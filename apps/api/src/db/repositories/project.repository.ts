import { eq, sql } from "drizzle-orm"
import { db } from "../index"
import { projects, clients, companies, engineers, locations, projectTypes, users } from "../schema"
import type { Pagination, ProjectListResponse, ProjectResponse } from "@beg/validations"

export const projectRepository = {
    findAll: async (pagination?: Pagination): Promise<ProjectListResponse> => {
        const { page = 1, limit = 10 } = pagination || {}
        const offset = (page - 1) * limit

        // Query with pagination
        const data = await db
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
            .limit(limit)
            .offset(offset)

        // Count total
        const [{ count }] = await db.select({ count: sql<number>`count(*)` }).from(projects)

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
