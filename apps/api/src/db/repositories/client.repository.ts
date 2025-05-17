import { eq, sql } from "drizzle-orm"
import { db } from "../index"
import { clients } from "../schema"
import type { Pagination } from "@beg/validations"

export const clientRepository = {
    findAll: async (pagination?: Pagination) => {
        const { page = 1, limit = 10 } = pagination || {}
        const offset = (page - 1) * limit

        // Query with pagination
        const data = await db
            .select({
                id: clients.id,
                name: clients.name,
                createdAt: clients.createdAt,
                updatedAt: clients.updatedAt,
            })
            .from(clients)
            .limit(limit)
            .offset(offset)

        // Count total
        const [{ count }] = await db.select({ count: sql<number>`count(*)` }).from(clients)

        const totalPages = Math.ceil(count / limit)

        return {
            data,
            total: count,
            page,
            limit,
            totalPages,
        }
    },

    findById: async (id: number) => {
        const results = await db
            .select({
                id: clients.id,
                name: clients.name,
                createdAt: clients.createdAt,
                updatedAt: clients.updatedAt,
            })
            .from(clients)
            .where(eq(clients.id, id))
        return results[0] || null
    },
}
