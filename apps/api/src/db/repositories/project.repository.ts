import { eq, sql, like, and, or, gte, lte, asc, desc, inArray, lt, gt } from "drizzle-orm"
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
} from "../schema"
import type {
    ProjectFilter,
    ProjectListResponse,
    ProjectResponse,
    ProjectCreateInput,
    ProjectUpdateInput,
} from "@beg/validations"
import type { Variables } from "@src/types/global"

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
        if (referentUserId) {
            whereConditions.push(eq(projects.projectManagerId, referentUserId))
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
            const searchPattern = `${name.trim()}%`
            sortExpressions.push(
                sql`CASE WHEN ${projects.projectNumber} LIKE ${searchPattern} THEN 0 ELSE 1 END`
            )
        }

        // Add the main sort column
        const sortDirection = sortOrder === "desc" ? desc(sortColumn) : asc(sortColumn)
        sortExpressions.push(sortDirection)

        // Build the main query in a single chain
        const baseQuery = db
            .select({
                id: projects.id,
                projectNumber: projects.projectNumber,
                name: projects.name,
                startDate: projects.startDate,
                remark: projects.remark,
                printFlag: projects.printFlag,
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
                projectManager: {
                    id: users.id,
                    firstName: users.firstName,
                    lastName: users.lastName,
                    initials: users.initials,
                },
            })
            .from(projects)

            .leftJoin(locations, eq(projects.locationId, locations.id))
            .leftJoin(clients, eq(projects.clientId, clients.id))
            .leftJoin(engineers, eq(projects.engineerId, engineers.id))
            .leftJoin(companies, eq(projects.companyId, companies.id))
            .innerJoin(projectTypes, eq(projects.typeId, projectTypes.id))
            .leftJoin(users, eq(projects.projectManagerId, users.id))

        if (user.role !== "admin") {
            baseQuery.innerJoin(
                projectAccess,
                and(eq(projects.id, projectAccess.projectId), eq(projectAccess.userId, user.id))
            )
        }
        // Execute query with conditional where clause
        const data =
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

        // Count total with same filters (excluding pagination)
        const countQuery = db.select({ count: sql<number>`count(*)` }).from(projects)

        if (user.role !== "admin") {
            countQuery.innerJoin(
                projectAccess,
                and(eq(projects.id, projectAccess.projectId), eq(projectAccess.userId, user.id))
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
        const query = db
            .select({
                id: projects.id,
                projectNumber: projects.projectNumber,
                name: projects.name,
                startDate: projects.startDate,
                remark: projects.remark,
                printFlag: projects.printFlag,
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
                projectManager: {
                    id: users.id,
                    firstName: users.firstName,
                    lastName: users.lastName,
                    initials: users.initials,
                },
            })
            .from(projects)
            .leftJoin(locations, eq(projects.locationId, locations.id))
            .leftJoin(clients, eq(projects.clientId, clients.id))
            .leftJoin(engineers, eq(projects.engineerId, engineers.id))
            .leftJoin(companies, eq(projects.companyId, companies.id))
            .innerJoin(projectTypes, eq(projects.typeId, projectTypes.id))
            .leftJoin(users, eq(projects.projectManagerId, users.id))

        if (user.role !== "admin") {
            query.innerJoin(
                projectAccess,
                and(eq(projects.id, projectAccess.projectId), eq(projectAccess.userId, user.id))
            )
        }

        const results = await query.where(and(eq(projects.id, id))).execute()
        if (!results[0]) return null

        return results[0] as ProjectResponse
    },

    create: async (data: ProjectCreateInput, user: Variables["user"]): Promise<ProjectResponse> => {
        // Check if project number already exists
        const existing = await db
            .select({ id: projects.id })
            .from(projects)
            .where(eq(projects.projectNumber, data.projectNumber))
            .execute()

        if (existing.length > 0) {
            throw new Error("Project number already exists")
        }

        // Insert the new project
        const [newProject] = await db
            .insert(projects)
            .values({
                projectNumber: data.projectNumber,
                name: data.name,
                startDate: data.startDate,
                typeId: data.typeId,
                locationId: data.locationId || null,
                clientId: data.clientId || null,
                engineerId: data.engineerId || null,
                companyId: data.companyId || null,
                projectManagerId: data.projectManagerId || null,
                remark: data.remark || null,
                printFlag: data.printFlag || false,
                ended: data.ended || false,
                archived: data.archived || false,
            })
            .returning({ id: projects.id })
            .execute()

        // If not admin, grant write access to the creator
        if (user.role !== "admin" && newProject) {
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
        // Check if user has write access
        if (user.role !== "admin") {
            const access = await db
                .select({ accessLevel: projectAccess.accessLevel })
                .from(projectAccess)
                .where(
                    and(
                        eq(projectAccess.projectId, id),
                        eq(projectAccess.userId, user.id),
                        eq(projectAccess.accessLevel, "write")
                    )
                )
                .execute()

            if (access.length === 0) {
                throw new Error("Insufficient permissions to update this project")
            }
        }

        // If updating project number, check uniqueness
        if (data.projectNumber) {
            const existing = await db
                .select({ id: projects.id })
                .from(projects)
                .where(
                    and(
                        eq(projects.projectNumber, data.projectNumber),
                        sql`${projects.id} != ${id}`
                    )
                )
                .execute()

            if (existing.length > 0) {
                throw new Error("Project number already exists")
            }
        }

        // Build update object, filtering out undefined values
        const updateData: any = {}
        if (data.projectNumber !== undefined) updateData.projectNumber = data.projectNumber
        if (data.name !== undefined) updateData.name = data.name
        if (data.startDate !== undefined) updateData.startDate = data.startDate
        if (data.typeId !== undefined) updateData.typeId = data.typeId
        if (data.locationId !== undefined) updateData.locationId = data.locationId || null
        if (data.clientId !== undefined) updateData.clientId = data.clientId || null
        if (data.engineerId !== undefined) updateData.engineerId = data.engineerId || null
        if (data.companyId !== undefined) updateData.companyId = data.companyId || null
        if (data.projectManagerId !== undefined)
            updateData.projectManagerId = data.projectManagerId || null
        if (data.remark !== undefined) updateData.remark = data.remark || null
        if (data.printFlag !== undefined) updateData.printFlag = data.printFlag
        if (data.ended !== undefined) updateData.ended = data.ended
        if (data.archived !== undefined) updateData.archived = data.archived

        // Update the project
        await db
            .update(projects)
            .set({
                ...updateData,
                updatedAt: new Date(),
            })
            .where(eq(projects.id, id))
            .execute()

        // Return the updated project
        const updated = await projectRepository.findById(id, user)
        if (!updated) {
            throw new Error("Project not found")
        }

        return updated
    },
}
