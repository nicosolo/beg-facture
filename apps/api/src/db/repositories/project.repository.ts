import { eq, sql, like, and, or, gte, lte, asc, desc, inArray, lt, gt, ne } from "drizzle-orm"
import { db } from "../index"
import {
    projects,
    clients,
    companies,
    engineers,
    locations,
    projectTypes,
    users,
    projectAccess,
    projectManagers,
} from "../schema"
import {
    type ProjectFilter,
    type ProjectListResponse,
    type ProjectResponse,
    type ProjectCreateInput,
    type ProjectUpdateInput,
    ErrorCode,
} from "@beg/validations"
import type { Variables } from "@src/types/global"
import { ApiException, throwDuplicateEntry, throwForbidden } from "@src/tools/error-handler"
import { STATUS_CODES } from "http"
import { hasRole } from "@src/tools/role-middleware"

export const projectRepository = {
    findAll: async (
        user: Variables["user"],
        filters?: ProjectFilter
    ): Promise<ProjectListResponse> => {
        const {
            page = 1,
            limit = 10,
            name,
            includeArchived = false,
            referentUserId,
            fromDate,
            toDate,
            sortBy = "name",
            sortOrder = "asc",
            hasUnbilledTime = undefined,
            includeEnded = false,
        } = filters || {}
        const offset = (page - 1) * limit

        // Build where conditions
        const whereConditions = []

        // Name filter (case-insensitive search)
        if (name && name.trim()) {
            whereConditions.push(
                or(
                    like(projects.name, `%${name.split(" ").join("%")}%`),
                    like(projects.projectNumber, `${name.split(" ").join("%")}%`)
                )
            )
        }

        // Referent user filter (project manager)
        // Note: This will be handled in the join below
        const filterByProjectManager = referentUserId !== undefined

        // Date filters - filter by project start date
        if (fromDate) {
            whereConditions.push(gte(projects.startDate, fromDate))
        }
        if (toDate) {
            whereConditions.push(lte(projects.startDate, toDate))
        }

        // Ended filter
        if (!includeArchived) {
            whereConditions.push(eq(projects.archived, false))
        }

        if (!includeEnded) {
            whereConditions.push(eq(projects.ended, false))
        }
        if (hasUnbilledTime === true) {
            whereConditions.push(gt(projects.unBilledDuration, 0))
        }

        // Note: archived filter is not implemented as projects table doesn't have archived field
        // This appears to be a legacy filter from the old system

        // Apply sorting
        const sortColumn = (() => {
            switch (sortBy) {
                case "name":
                    return projects.name
                case "unBilledDuration":
                    // For unbilled duration, we'll sort by project name as fallback
                    // since calculating unbilled duration requires complex aggregation
                    return projects.unBilledDuration
                case "firstActivityDate":
                    // Sort by project start date as approximation for first activity
                    return projects.firstActivityDate
                case "lastActivityDate":
                    // Sort by project updated date as approximation for last activity
                    return projects.lastActivityDate
                default:
                    return projects.name
            }
        })()

        // Create custom sort order to prioritize projectNumber matches when searching by name
        const sortExpressions = []

        // If searching by name, add priority sort for projectNumber matches
        if (name && name.trim()) {
            const trimmedSearch = name.trim()
            const projectNumberPattern = `${trimmedSearch}%`
            const searchTokens = trimmedSearch.split(/\s+/).join("%")
            const projectNamePattern = `%${searchTokens}%`
            sortExpressions.push(
                sql`CASE
                        WHEN ${projects.projectNumber} LIKE ${projectNumberPattern} THEN 0
                        WHEN ${projects.name} LIKE ${projectNamePattern} THEN 1
                        ELSE 2
                    END`
            )
        }

        // Add the main sort column
        const sortDirection = sortOrder === "desc" ? desc(sortColumn) : asc(sortColumn)
        sortExpressions.push(sortDirection)

        // Build the main query with a subquery to filter by project manager if needed
        let baseQuery = db
            .select({
                id: projects.id,
                projectNumber: projects.projectNumber,
                subProjectName: projects.subProjectName,
                name: projects.name,
                startDate: projects.startDate,
                remark: projects.remark,
                invoicingAddress: projects.invoicingAddress,
                printFlag: projects.printFlag,
                latitude: projects.latitude,
                longitude: projects.longitude,
                archived: projects.archived,
                createdAt: projects.createdAt,
                updatedAt: projects.updatedAt,
                firstActivityDate: projects.firstActivityDate,
                lastActivityDate: projects.lastActivityDate,
                totalDuration: projects.totalDuration,
                unBilledDuration: projects.unBilledDuration,
                unBilledDisbursementDuration: projects.unBilledDisbursementDuration,
                ended: projects.ended,
                location: {
                    id: locations.id,
                    name: locations.name,
                    country: locations.country,
                    canton: locations.canton,
                    region: locations.region,
                    address: locations.address,
                },
                client: {
                    id: clients.id,
                    name: clients.name,
                },
                engineer: {
                    id: engineers.id,
                    name: engineers.name,
                },
                company: {
                    id: companies.id,
                    name: companies.name,
                },
                type: {
                    id: projectTypes.id,
                    name: projectTypes.name,
                },
            })
            .from(projects)
            .leftJoin(locations, eq(projects.locationId, locations.id))
            .leftJoin(clients, eq(projects.clientId, clients.id))
            .leftJoin(engineers, eq(projects.engineerId, engineers.id))
            .leftJoin(companies, eq(projects.companyId, companies.id))
            .innerJoin(projectTypes, eq(projects.typeId, projectTypes.id))

        // Add project manager filter if specified
        if (filterByProjectManager && referentUserId) {
            baseQuery = baseQuery.innerJoin(
                projectManagers,
                and(
                    eq(projectManagers.projectId, projects.id),
                    eq(projectManagers.userId, referentUserId)
                )
            )
        }

        // Disable access control for now
        // if (user.role !== "admin") {
        //     baseQuery = baseQuery.innerJoin(
        //         projectAccess,
        //         and(eq(projects.id, projectAccess.projectId), eq(projectAccess.userId, user.id))
        //     )
        // }

        // Execute query with conditional where clause
        const rawData =
            whereConditions.length > 0
                ? await baseQuery
                      .where(and(...whereConditions))
                      .orderBy(...sortExpressions)
                      .limit(limit)
                      .offset(offset)
                      .execute()
                : await baseQuery
                      .orderBy(...sortExpressions)
                      .limit(limit)
                      .offset(offset)
                      .execute()

        // Get all unique project IDs
        const projectIds = rawData.map((p) => p.id)

        // Fetch all project managers for these projects in one query
        const allProjectManagers =
            projectIds.length > 0
                ? await db
                      .select({
                          projectId: projectManagers.projectId,
                          id: users.id,
                          firstName: users.firstName,
                          lastName: users.lastName,
                          initials: users.initials,
                      })
                      .from(projectManagers)
                      .innerJoin(users, eq(projectManagers.userId, users.id))
                      .where(inArray(projectManagers.projectId, projectIds))
                      .execute()
                : []

        // Group managers by project ID
        const managersMapByProject = new Map<number, any[]>()
        allProjectManagers.forEach((pm) => {
            if (!managersMapByProject.has(pm.projectId)) {
                managersMapByProject.set(pm.projectId, [])
            }
            managersMapByProject.get(pm.projectId)!.push({
                id: pm.id,
                firstName: pm.firstName,
                lastName: pm.lastName,
                initials: pm.initials,
            })
        })

        // Attach project managers to each project
        const data = rawData.map((project) => ({
            ...project,
            projectManagers: managersMapByProject.get(project.id) || [],
        }))

        // Count total with same filters (excluding pagination)
        const countQuery = db.select({ count: sql<number>`count(*)` }).from(projects)

        // Disable access control for now
        // if (user.role !== "admin") {
        //     countQuery.innerJoin(
        //         projectAccess,
        //         and(eq(projects.id, projectAccess.projectId), eq(projectAccess.userId, user.id))
        //     )
        // }

        const [{ count }] = await (
            whereConditions.length > 0 ? countQuery.where(and(...whereConditions)) : countQuery
        ).execute()

        const totalPages = Math.ceil(count / limit)

        return {
            data,
            total: count,
            page,
            limit,
            totalPages,
        }
    },

    findById: async (id: number, user: Variables["user"]): Promise<ProjectResponse | null> => {
        const query = db
            .select({
                id: projects.id,
                projectNumber: projects.projectNumber,
                subProjectName: projects.subProjectName,
                name: projects.name,
                startDate: projects.startDate,
                remark: projects.remark,
                invoicingAddress: projects.invoicingAddress,
                printFlag: projects.printFlag,
                latitude: projects.latitude,
                longitude: projects.longitude,
                archived: projects.archived,
                createdAt: projects.createdAt,
                updatedAt: projects.updatedAt,
                firstActivityDate: projects.firstActivityDate,
                lastActivityDate: projects.lastActivityDate,
                totalDuration: projects.totalDuration,
                unBilledDuration: projects.unBilledDuration,
                unBilledDisbursementDuration: projects.unBilledDisbursementDuration,
                ended: projects.ended,
                location: {
                    id: locations.id,
                    name: locations.name,
                    country: locations.country,
                    canton: locations.canton,
                    region: locations.region,
                    address: locations.address,
                },
                client: {
                    id: clients.id,
                    name: clients.name,
                },
                engineer: {
                    id: engineers.id,
                    name: engineers.name,
                },
                company: {
                    id: companies.id,
                    name: companies.name,
                },
                type: {
                    id: projectTypes.id,
                    name: projectTypes.name,
                },
            })
            .from(projects)
            .leftJoin(locations, eq(projects.locationId, locations.id))
            .leftJoin(clients, eq(projects.clientId, clients.id))
            .leftJoin(engineers, eq(projects.engineerId, engineers.id))
            .leftJoin(companies, eq(projects.companyId, companies.id))
            .innerJoin(projectTypes, eq(projects.typeId, projectTypes.id))

        // Disable access control for now
        // if (user.role !== "admin") {
        //     query.innerJoin(
        //         projectAccess,
        //         and(eq(projects.id, projectAccess.projectId), eq(projectAccess.userId, user.id))
        //     )
        // }

        const results = await query.where(and(eq(projects.id, id))).execute()
        if (!results[0]) return null

        const project = results[0]

        // Fetch project managers using junction table
        const managers = await db
            .select({
                id: users.id,
                firstName: users.firstName,
                lastName: users.lastName,
                initials: users.initials,
            })
            .from(projectManagers)
            .innerJoin(users, eq(projectManagers.userId, users.id))
            .where(eq(projectManagers.projectId, id))
            .execute()

        return {
            ...project,
            projectManagers: managers,
        } as ProjectResponse
    },

    create: async (data: ProjectCreateInput, user: Variables["user"]): Promise<ProjectResponse> => {
        // Only admins can create projects
        if (!hasRole(user.role, "admin")) {
            throw throwForbidden("Only administrators can create new projects")
        }

        // Handle parent project data copying if parentProjectId is provided
        let parentProjectData = null
        if (data.parentProjectId) {
            const [parent] = await db
                .select()
                .from(projects)
                .where(eq(projects.id, data.parentProjectId))
                .execute()

            if (!parent) {
                throw new Error("Parent project not found")
            }
            parentProjectData = parent
        }

        // Check for duplicate project number + subProjectName combination
        const whereConditions = [eq(projects.projectNumber, data.projectNumber)]
        if (data.subProjectName) {
            whereConditions.push(eq(projects.subProjectName, data.subProjectName))
        } else {
            // If no subProjectName, check if main project exists
            const existing = await db
                .select({ id: projects.id })
                .from(projects)
                .where(
                    and(
                        eq(projects.projectNumber, data.projectNumber),
                        sql`${projects.subProjectName} IS NULL`
                    )
                )
                .execute()

            if (existing.length > 0) {
                throw new Error("Project number already exists")
            }
        }

        if (data.subProjectName) {
            const existing = await db
                .select({ id: projects.id })
                .from(projects)
                .where(and(...whereConditions))
                .execute()

            if (existing.length > 0) {
                throw new Error("Sub-project with this name already exists for this project number")
            }
        }

        // Get project managers from data or parent project
        let managerUserIds: number[] = []
        if (data.projectManagers && data.projectManagers.length > 0) {
            managerUserIds = data.projectManagers
        } else if (parentProjectData) {
            // Fetch parent project managers
            const parentManagers = await db
                .select({ userId: projectManagers.userId })
                .from(projectManagers)
                .where(eq(projectManagers.projectId, parentProjectData.id))
                .execute()
            managerUserIds = parentManagers.map((pm) => pm.userId)
        }

        // Insert the new project, using parent data if provided
        const projectData = parentProjectData
            ? {
                  projectNumber: parentProjectData.projectNumber,
                  subProjectName: data.subProjectName || null,
                  name: data.name,
                  startDate: data.startDate || parentProjectData.startDate,
                  typeId: data.typeId || parentProjectData.typeId,
                  locationId: data.locationId || parentProjectData.locationId,
                  clientId: data.clientId || parentProjectData.clientId,
                  engineerId: data.engineerId || parentProjectData.engineerId,
                  companyId: data.companyId || parentProjectData.companyId,
                  remark: data.remark || parentProjectData.remark,
                  printFlag: data.printFlag ?? parentProjectData.printFlag,
                  ended: data.ended ?? parentProjectData.ended,
                  archived: data.archived ?? parentProjectData.archived,
                  invoicingAddress: data.invoicingAddress || parentProjectData.invoicingAddress,
                  latitude:
                      data.latitude !== undefined
                          ? data.latitude
                          : (parentProjectData.latitude ?? null),
                  longitude:
                      data.longitude !== undefined
                          ? data.longitude
                          : (parentProjectData.longitude ?? null),
                  createdAt: new Date(),
                  updatedAt: new Date(),
              }
            : {
                  projectNumber: data.projectNumber,
                  subProjectName: data.subProjectName || null,
                  name: data.name,
                  startDate: data.startDate,
                  typeId: data.typeId,
                  locationId: data.locationId || null,
                  clientId: data.clientId || null,
                  engineerId: data.engineerId || null,
                  companyId: data.companyId || null,
                  remark: data.remark || null,
                  printFlag: data.printFlag || false,
                  ended: data.ended || false,
                  archived: data.archived || false,
                  latitude: data.latitude ?? null,
                  longitude: data.longitude ?? null,
                  createdAt: new Date(),
                  updatedAt: new Date(),
              }

        const [newProject] = await db
            .insert(projects)
            .values(projectData)
            .returning({ id: projects.id })
            .execute()

        // Insert project managers into junction table
        if (managerUserIds.length > 0) {
            const managersToInsert = managerUserIds.map((userId) => ({
                projectId: newProject.id,
                userId,
                createdAt: new Date(),
                updatedAt: new Date(),
            }))
            await db.insert(projectManagers).values(managersToInsert).execute()
        }

        // If not admin, grant write access to the creator
        if (!hasRole(user.role, "admin") && newProject) {
            await db
                .insert(projectAccess)
                .values({
                    projectId: newProject.id,
                    userId: user.id,
                    accessLevel: "write",
                })
                .execute()
        }

        // Return the created project with all relations
        const created = await projectRepository.findById(newProject.id, user)
        if (!created) {
            throw new Error("Failed to retrieve created project")
        }

        return created
    },

    update: async (
        id: number,
        data: ProjectUpdateInput,
        user: Variables["user"]
    ): Promise<ProjectResponse> => {
        const isAdmin = hasRole(user.role, "admin")

        // Check if user is a project manager of this project
        const isProjectManager = await db
            .select({ userId: projectManagers.userId })
            .from(projectManagers)
            .where(and(eq(projectManagers.projectId, id), eq(projectManagers.userId, user.id)))
            .execute()

        const userIsProjectManager = isProjectManager.length > 0

        // If user is not admin and not a project manager, deny all updates
        if (!isAdmin && !userIsProjectManager) {
            throw throwForbidden("You do not have permission to update this project")
        }

        // If user is a project manager (but not admin), only allow updating projectManagers field
        if (!isAdmin && userIsProjectManager) {
            // Check if user is trying to update fields other than projectManagers
            const { projectManagers: _, ...otherFields } = data
            const hasOtherFields = Object.keys(otherFields).length > 0

            if (hasOtherFields) {
                throw throwForbidden(
                    "Project managers can only add or remove other project managers"
                )
            }
        }

        // Build update object, filtering out undefined values (excluding projectManagers)
        const updateData: any = {}
        if (data.projectNumber !== undefined) updateData.projectNumber = data.projectNumber
        if (data.subProjectName !== undefined)
            updateData.subProjectName = data.subProjectName || null
        if (data.name !== undefined) updateData.name = data.name
        if (data.startDate !== undefined) updateData.startDate = data.startDate
        if (data.typeId !== undefined) updateData.typeId = data.typeId
        if (data.locationId !== undefined) updateData.locationId = data.locationId || null
        if (data.clientId !== undefined) updateData.clientId = data.clientId || null
        if (data.engineerId !== undefined) updateData.engineerId = data.engineerId || null
        if (data.companyId !== undefined) updateData.companyId = data.companyId || null
        if (data.remark !== undefined) updateData.remark = data.remark || null
        if (data.printFlag !== undefined) updateData.printFlag = data.printFlag
        if (data.invoicingAddress !== undefined) updateData.invoicingAddress = data.invoicingAddress
        if (data.ended !== undefined) updateData.ended = data.ended
        if (data.archived !== undefined) updateData.archived = data.archived
        if (data.latitude !== undefined) updateData.latitude = data.latitude
        if (data.longitude !== undefined) updateData.longitude = data.longitude
        console.log(data, updateData)

        // Update the project
        await db
            .update(projects)
            .set({
                ...updateData,
                updatedAt: new Date(),
            })
            .where(eq(projects.id, id))
            .execute()

        // Update project managers if provided
        if (data.projectManagers !== undefined) {
            // Delete existing project managers
            await db.delete(projectManagers).where(eq(projectManagers.projectId, id)).execute()

            // Insert new project managers
            if (data.projectManagers.length > 0) {
                const managersToInsert = data.projectManagers.map((userId) => ({
                    projectId: id,
                    userId,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                }))
                await db.insert(projectManagers).values(managersToInsert).execute()
            }
        }

        // Return the updated project
        const updated = await projectRepository.findById(id, user)
        if (!updated) {
            throw new Error("Project not found")
        }

        return updated
    },

    findMainProjects: async (user: Variables["user"]): Promise<ProjectListResponse> => {
        // Get main projects (projects without subProjectName)
        const query = db
            .select({
                id: projects.id,
                projectNumber: projects.projectNumber,
                subProjectName: projects.subProjectName,
                name: projects.name,
                startDate: projects.startDate,
                remark: projects.remark,
                invoicingAddress: projects.invoicingAddress,
                printFlag: projects.printFlag,
                latitude: projects.latitude,
                longitude: projects.longitude,
                archived: projects.archived,
                createdAt: projects.createdAt,
                updatedAt: projects.updatedAt,
                firstActivityDate: projects.firstActivityDate,
                lastActivityDate: projects.lastActivityDate,
                totalDuration: projects.totalDuration,
                unBilledDuration: projects.unBilledDuration,
                unBilledDisbursementDuration: projects.unBilledDisbursementDuration,
                ended: projects.ended,
                location: {
                    id: locations.id,
                    name: locations.name,
                    country: locations.country,
                    canton: locations.canton,
                    region: locations.region,
                    address: locations.address,
                },
                client: {
                    id: clients.id,
                    name: clients.name,
                },
                engineer: {
                    id: engineers.id,
                    name: engineers.name,
                },
                company: {
                    id: companies.id,
                    name: companies.name,
                },
                type: {
                    id: projectTypes.id,
                    name: projectTypes.name,
                },
            })
            .from(projects)
            .leftJoin(locations, eq(projects.locationId, locations.id))
            .leftJoin(clients, eq(projects.clientId, clients.id))
            .leftJoin(engineers, eq(projects.engineerId, engineers.id))
            .leftJoin(companies, eq(projects.companyId, companies.id))
            .innerJoin(projectTypes, eq(projects.typeId, projectTypes.id))

        // Disable access control for now
        // if (user.role !== "admin") {
        //     query.innerJoin(
        //         projectAccess,
        //         and(eq(projects.id, projectAccess.projectId), eq(projectAccess.userId, user.id))
        //     )
        // }

        const rawData = await query
            .where(sql`${projects.subProjectName} IS NULL`)
            .orderBy(asc(projects.name))
            .execute()

        // Get all unique project IDs
        const projectIds = rawData.map((p) => p.id)

        // Fetch all project managers for these projects in one query
        const allProjectManagers =
            projectIds.length > 0
                ? await db
                      .select({
                          projectId: projectManagers.projectId,
                          id: users.id,
                          firstName: users.firstName,
                          lastName: users.lastName,
                          initials: users.initials,
                      })
                      .from(projectManagers)
                      .innerJoin(users, eq(projectManagers.userId, users.id))
                      .where(inArray(projectManagers.projectId, projectIds))
                      .execute()
                : []

        // Group managers by project ID
        const managersMapByProject = new Map<number, any[]>()
        allProjectManagers.forEach((pm) => {
            if (!managersMapByProject.has(pm.projectId)) {
                managersMapByProject.set(pm.projectId, [])
            }
            managersMapByProject.get(pm.projectId)!.push({
                id: pm.id,
                firstName: pm.firstName,
                lastName: pm.lastName,
                initials: pm.initials,
            })
        })

        // Attach project managers to each project
        const data = rawData.map((project) => ({
            ...project,
            projectManagers: managersMapByProject.get(project.id) || [],
        }))

        return {
            data,
            total: data.length,
            page: 1,
            limit: 1000,
            totalPages: 1,
        }
    },
}
