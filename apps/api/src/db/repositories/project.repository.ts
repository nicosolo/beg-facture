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
    projectUsers,
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
import { hasRole } from "@src/tools/role-middleware"

export const projectRepository = {
    // Check if a user is a manager of a specific project
    isProjectManager: async (projectId: number, userId: number): Promise<boolean> => {
        const result = await db
            .select({ userId: projectUsers.userId })
            .from(projectUsers)
            .where(
                and(
                    eq(projectUsers.projectId, projectId),
                    eq(projectUsers.userId, userId),
                    eq(projectUsers.role, "manager")
                )
            )
            .execute()

        return result.length > 0
    },

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
            includeDraft = false,
        } = filters || {}
        const offset = (page - 1) * limit

        // Build where conditions
        const whereConditions = []

        // Draft filter - exclude drafts by default (only show when includeDraft is true)
        if (includeDraft) {
            whereConditions.push(
                sql`${projects.projectNumber} IS NULL OR ${projects.projectNumber} = ''`
            )
        }

        // Name filter (case-insensitive search)
        if (name && name.trim()) {
            whereConditions.push(
                or(
                    like(projects.name, `%${name.split(" ").join("%")}%`),
                    like(projects.projectNumber, `${name.split(" ").join("%")}%`)
                )
            )
        }

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
                offerAmount: projects.offerAmount,
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

        // Add project manager filter and/or access control
        const hasManagerFilter = referentUserId !== undefined && referentUserId
        const needsAccessControl = !hasRole(user.role, "admin")

        if (hasManagerFilter && needsAccessControl) {
            // Non-admin with manager filter: show projects managed by referentUserId that user has access to
            // Use join with EXISTS subquery to check both conditions
            baseQuery = baseQuery.innerJoin(
                projectUsers,
                and(
                    eq(projects.id, projectUsers.projectId),
                    eq(projectUsers.userId, user.id),
                    // Project must be managed by referentUserId
                    sql`EXISTS (
                        SELECT 1 FROM ${projectUsers} pu2
                        WHERE pu2.projectId = ${projects.id}
                        AND pu2.userId = ${referentUserId}
                        AND pu2.role = 'manager'
                    )`
                )
            )
        } else if (hasManagerFilter) {
            // Admin with manager filter: show all projects managed by referentUserId
            baseQuery = baseQuery.innerJoin(
                projectUsers,
                and(
                    eq(projectUsers.projectId, projects.id),
                    eq(projectUsers.userId, referentUserId),
                    eq(projectUsers.role, "manager")
                )
            )
        } else if (needsAccessControl) {
            // Non-admin without manager filter: show all projects user has access to
            baseQuery = baseQuery.innerJoin(
                projectUsers,
                and(eq(projects.id, projectUsers.projectId), eq(projectUsers.userId, user.id))
            )
        }

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

        // Fetch all project users (managers and members) for these projects in one query
        const allProjectUsers =
            projectIds.length > 0
                ? await db
                      .select({
                          projectId: projectUsers.projectId,
                          id: users.id,
                          firstName: users.firstName,
                          lastName: users.lastName,
                          initials: users.initials,
                          role: projectUsers.role,
                      })
                      .from(projectUsers)
                      .innerJoin(users, eq(projectUsers.userId, users.id))
                      .where(inArray(projectUsers.projectId, projectIds))
                      .execute()
                : []

        const { managersMap, membersMap } = allProjectUsers.reduce(
            (acc, pu) => {
                const userInfo = {
                    id: pu.id,
                    firstName: pu.firstName,
                    lastName: pu.lastName,
                    initials: pu.initials,
                }

                if (pu.role === "manager") {
                    if (!acc.managersMap.has(pu.projectId)) {
                        acc.managersMap.set(pu.projectId, [])
                    }
                    acc.managersMap.get(pu.projectId)!.push(userInfo)
                } else if (pu.role === "member") {
                    if (!acc.membersMap.has(pu.projectId)) {
                        acc.membersMap.set(pu.projectId, [])
                    }
                    acc.membersMap.get(pu.projectId)!.push(userInfo)
                }

                return acc
            },
            {
                managersMap: new Map<number, any[]>(),
                membersMap: new Map<number, any[]>(),
            }
        )

        // Attach project managers and members to each project
        const data = rawData.map((project) => ({
            ...project,
            projectManagers: managersMap.get(project.id) || [],
            projectMembers: membersMap.get(project.id) || [],
            isDraft: !project.projectNumber || project.projectNumber.trim() === "",
        }))

        // Count total with same filters (excluding pagination)
        let countQuery = db
            .select({ count: sql<number>`count(DISTINCT ${projects.id})` })
            .from(projects)
            .innerJoin(projectTypes, eq(projects.typeId, projectTypes.id))

        // Apply same filters as main query
        if (hasManagerFilter && needsAccessControl) {
            // Non-admin with manager filter: count projects managed by referentUserId that user has access to
            countQuery = countQuery.innerJoin(
                projectUsers,
                and(
                    eq(projects.id, projectUsers.projectId),
                    eq(projectUsers.userId, user.id),
                    // Project must be managed by referentUserId
                    sql`EXISTS (
                        SELECT 1 FROM ${projectUsers} pu2
                        WHERE pu2.projectId = ${projects.id}
                        AND pu2.userId = ${referentUserId}
                        AND pu2.role = 'manager'
                    )`
                )
            )
        } else if (hasManagerFilter) {
            // Admin with manager filter
            countQuery = countQuery.innerJoin(
                projectUsers,
                and(
                    eq(projectUsers.projectId, projects.id),
                    eq(projectUsers.userId, referentUserId),
                    eq(projectUsers.role, "manager")
                )
            )
        } else if (needsAccessControl) {
            // Non-admin without manager filter
            countQuery = countQuery.innerJoin(
                projectUsers,
                and(eq(projects.id, projectUsers.projectId), eq(projectUsers.userId, user.id))
            )
        }

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
        let query = db
            .select({
                id: projects.id,
                projectNumber: projects.projectNumber,
                subProjectName: projects.subProjectName,
                name: projects.name,
                startDate: projects.startDate,
                remark: projects.remark,
                invoicingAddress: projects.invoicingAddress,
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
                offerAmount: projects.offerAmount,
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

        // Access control: non-admin users can only see projects they're associated with
        if (!hasRole(user.role, "admin")) {
            query = query.innerJoin(
                projectUsers,
                and(eq(projects.id, projectUsers.projectId), eq(projectUsers.userId, user.id))
            )
        }

        const results = await query.where(eq(projects.id, id)).execute()
        if (!results[0]) return null

        const project = results[0]

        // Fetch project users (managers and members) using junction table
        const projectUsersList = await db
            .select({
                id: users.id,
                firstName: users.firstName,
                lastName: users.lastName,
                initials: users.initials,
                role: projectUsers.role,
            })
            .from(projectUsers)
            .innerJoin(users, eq(projectUsers.userId, users.id))
            .where(eq(projectUsers.projectId, id))
            .execute()

        // Separate managers and members
        const managers = projectUsersList
            .filter((u) => u.role === "manager")
            .map((u) => ({
                id: u.id,
                firstName: u.firstName,
                lastName: u.lastName,
                initials: u.initials,
            }))

        const members = projectUsersList
            .filter((u) => u.role === "member")
            .map((u) => ({
                id: u.id,
                firstName: u.firstName,
                lastName: u.lastName,
                initials: u.initials,
            }))

        return {
            ...project,
            projectManagers: managers,
            projectMembers: members,
            isDraft: !project.projectNumber || project.projectNumber.trim() === "",
        } as ProjectResponse
    },

    create: async (data: ProjectCreateInput): Promise<number | null> => {
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
        // Skip check for draft projects (projectNumber is null or empty)
        if (data.projectNumber && data.projectNumber.trim() !== "") {
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
                    throw new Error(
                        "Sub-project with this name already exists for this project number"
                    )
                }
            }
        }

        // Get project managers and members from data or parent project
        let managerUserIds: number[] = []
        let memberUserIds: number[] = []

        if (data.projectManagers && data.projectManagers.length > 0) {
            managerUserIds = data.projectManagers
        } else if (parentProjectData) {
            // Fetch parent project managers
            const parentManagers = await db
                .select({ userId: projectUsers.userId })
                .from(projectUsers)
                .where(
                    and(
                        eq(projectUsers.projectId, parentProjectData.id),
                        eq(projectUsers.role, "manager")
                    )
                )
                .execute()
            managerUserIds = parentManagers.map((pm) => pm.userId)
        }

        if (data.projectMembers && data.projectMembers.length > 0) {
            memberUserIds = data.projectMembers
        } else if (parentProjectData) {
            // Fetch parent project members
            const parentMembers = await db
                .select({ userId: projectUsers.userId })
                .from(projectUsers)
                .where(
                    and(
                        eq(projectUsers.projectId, parentProjectData.id),
                        eq(projectUsers.role, "member")
                    )
                )
                .execute()
            memberUserIds = parentMembers.map((pm) => pm.userId)
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
                  ended: data.ended ?? parentProjectData.ended,
                  archived: data.archived ?? parentProjectData.archived,
                  invoicingAddress: data.invoicingAddress || parentProjectData.invoicingAddress,
                  offerAmount:
                      data.offerAmount !== undefined
                          ? data.offerAmount
                          : (parentProjectData.offerAmount ?? null),
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
                  ended: data.ended || false,
                  archived: data.archived || false,
                  invoicingAddress: data.invoicingAddress || null,
                  offerAmount: data.offerAmount ?? null,
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

        // Insert project users (managers and members) into junction table
        const projectUsersToInsert: Array<{
            projectId: number
            userId: number
            role: "manager" | "member"
            createdAt: Date
            updatedAt: Date
        }> = []

        // Add managers
        if (managerUserIds.length > 0) {
            managerUserIds.forEach((userId) => {
                projectUsersToInsert.push({
                    projectId: newProject.id,
                    userId,
                    role: "manager" as const,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                })
            })
        }

        // Add members
        if (memberUserIds.length > 0) {
            memberUserIds.forEach((userId) => {
                projectUsersToInsert.push({
                    projectId: newProject.id,
                    userId,
                    role: "member" as const,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                })
            })
        }

        // Insert all project users at once
        if (projectUsersToInsert.length > 0) {
            await db.insert(projectUsers).values(projectUsersToInsert).execute()
        }

        return newProject.id
    },

    update: async (id: number, data: ProjectUpdateInput): Promise<number | null> => {
        // Build update object, filtering out undefined values (excluding projectManagers and projectMembers)
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
        if (data.invoicingAddress !== undefined) updateData.invoicingAddress = data.invoicingAddress
        if (data.ended !== undefined) updateData.ended = data.ended
        if (data.archived !== undefined) updateData.archived = data.archived
        if (data.latitude !== undefined) updateData.latitude = data.latitude
        if (data.longitude !== undefined) updateData.longitude = data.longitude
        if (data.offerAmount !== undefined) updateData.offerAmount = data.offerAmount
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
            await db
                .delete(projectUsers)
                .where(and(eq(projectUsers.projectId, id), eq(projectUsers.role, "manager")))
                .execute()

            // Insert new project managers
            if (data.projectManagers.length > 0) {
                const managersToInsert = data.projectManagers.map((userId) => ({
                    projectId: id,
                    userId,
                    role: "manager" as const,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                }))
                await db.insert(projectUsers).values(managersToInsert).execute()
            }
        }

        // Update project members if provided
        if (data.projectMembers !== undefined) {
            // Delete existing project members
            await db
                .delete(projectUsers)
                .where(and(eq(projectUsers.projectId, id), eq(projectUsers.role, "member")))
                .execute()

            // Insert new project members
            if (data.projectMembers.length > 0) {
                const membersToInsert = data.projectMembers.map((userId) => ({
                    projectId: id,
                    userId,
                    role: "member" as const,
                    createdAt: new Date(),
                    updatedAt: new Date(),
                }))
                await db.insert(projectUsers).values(membersToInsert).execute()
            }
        }

        return id
    },
}
