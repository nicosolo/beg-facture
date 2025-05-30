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
    activities,
} from "../schema"
import type {
    Pagination,
    ProjectFilter,
    ProjectListResponse,
    ProjectResponse,
} from "@beg/validations"

export const projectRepository = {
    findAll: async (filters?: ProjectFilter): Promise<ProjectListResponse> => {
        const {
            page = 1,
            limit = 10,
            name,
            archived = false,
            referentUserId,
            fromDate,
            toDate,
            sortBy = "name",
            sortOrder = "asc",
            hasUnbilledTime = true,
        } = filters || {}
        const offset = (page - 1) * limit

        // Build where conditions
        const whereConditions = []

        // Name filter (case-insensitive search)
        if (name && name.trim()) {
            whereConditions.push(
                or(
                    like(projects.name, `%${name.trim()}%`),
                    like(projects.projectNumber, `${name.trim()}%`)
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

        // Handle hasUnbilledTime filter by getting project IDs first
        if (hasUnbilledTime !== undefined) {
            const unbilledProjects = await db
                .selectDistinct({ projectId: activities.projectId })
                .from(activities)
                .where(eq(activities.billed, false))

            const projectIdsWithUnbilledTime = unbilledProjects.map((p) => p.projectId)

            if (hasUnbilledTime) {
                // Only include projects that have unbilled activities
                if (projectIdsWithUnbilledTime.length > 0) {
                    whereConditions.push(inArray(projects.id, projectIdsWithUnbilledTime))
                } else {
                    // No projects have unbilled time, return empty result
                    whereConditions.push(eq(projects.id, -1)) // Impossible condition
                }
            } else {
                // Only include projects that have no unbilled activities
                if (projectIdsWithUnbilledTime.length > 0) {
                    whereConditions.push(
                        sql`${projects.id} NOT IN (${projectIdsWithUnbilledTime.join(",")})`
                    )
                }
                // If no projects have unbilled time, include all projects (no additional filter needed)
            }
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
                    return projects.name
                case "firstActivityDate":
                    // Sort by project start date as approximation for first activity
                    return projects.startDate
                case "lastActivityDate":
                    // Sort by project updated date as approximation for last activity
                    return projects.updatedAt
                default:
                    return projects.name
            }
        })()

        const sortDirection = sortOrder === "desc" ? desc(sortColumn) : asc(sortColumn)

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

        // Execute query with conditional where clause
        const data = await (
            whereConditions.length > 0
                ? baseQuery
                      .where(and(...whereConditions))
                      .orderBy(sortDirection)
                      .limit(limit)
                      .offset(offset)
                : baseQuery.orderBy(sortDirection).limit(limit).offset(offset)
        ).execute()

        // Count total with same filters (excluding pagination)
        const countQuery = db.select({ count: sql<number>`count(*)` }).from(projects)

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

    findById: async (id: number): Promise<ProjectResponse | null> => {
        const results = await db
            .select({
                id: projects.id,
                projectNumber: projects.projectNumber,
                name: projects.name,
                startDate: projects.startDate,
                remark: projects.remark,
                printFlag: projects.printFlag,
                createdAt: projects.createdAt,
                updatedAt: projects.updatedAt,
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
            .where(eq(projects.id, id))

        if (!results[0]) return null

        return results[0]
    },
}
