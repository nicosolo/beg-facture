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
import type { ProjectFilter, ProjectListResponse, ProjectResponse } from "@beg/validations"
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
            console.log(fromDate)
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
}
