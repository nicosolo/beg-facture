import { eq, sql, like, and } from "drizzle-orm"
import { db } from "../index"
import { userGroups } from "../schema"
import type { UserGroupFilter, UserGroupCreateInput, UserGroupUpdateInput } from "@beg/validations"

export const userGroupRepository = {
    findAll: async (filter: UserGroupFilter) => {
        const { page = 1, limit = 10, name, sortBy = "name", sortOrder = "asc" } = filter
        const offset = (page - 1) * limit

        // Build conditions
        const conditions = []
        if (name) {
            conditions.push(like(userGroups.name, `%${name}%`))
        }

        // Query groups
        const query = db
            .select({
                id: userGroups.id,
                name: userGroups.name,
                createdAt: userGroups.createdAt,
                updatedAt: userGroups.updatedAt,
            })
            .from(userGroups)

        if (conditions.length > 0) {
            query.where(and(...conditions))
        }

        // Apply sorting
        if (sortBy === "name") {
            query.orderBy(sortOrder === "desc" ? sql`${userGroups.name} DESC` : userGroups.name)
        } else if (sortBy === "createdAt") {
            query.orderBy(
                sortOrder === "desc" ? sql`${userGroups.createdAt} DESC` : userGroups.createdAt
            )
        }

        const data = await query.limit(limit).offset(offset)

        // Count total with same conditions
        const countQuery = db.select({ count: sql<number>`count(*)` }).from(userGroups)
        if (conditions.length > 0) {
            countQuery.where(and(...conditions))
        }
        const [{ count }] = await countQuery

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
                id: userGroups.id,
                name: userGroups.name,
                createdAt: userGroups.createdAt,
                updatedAt: userGroups.updatedAt,
            })
            .from(userGroups)
            .where(eq(userGroups.id, id))

        return results[0] || null
    },

    findByName: async (name: string) => {
        const results = await db
            .select({
                id: userGroups.id,
                name: userGroups.name,
            })
            .from(userGroups)
            .where(eq(userGroups.name, name))
        return results[0] || null
    },

    create: async (data: UserGroupCreateInput) => {
        const result = await db
            .insert(userGroups)
            .values({
                name: data.name,
                createdAt: new Date(),
                updatedAt: new Date(),
            })
            .returning({
                id: userGroups.id,
                name: userGroups.name,
                createdAt: userGroups.createdAt,
                updatedAt: userGroups.updatedAt,
            })

        return result[0]
    },

    update: async (id: number, data: UserGroupUpdateInput) => {
        const result = await db
            .update(userGroups)
            .set({
                name: data.name,
                updatedAt: new Date(),
            })
            .where(eq(userGroups.id, id))
            .returning({
                id: userGroups.id,
                name: userGroups.name,
                createdAt: userGroups.createdAt,
                updatedAt: userGroups.updatedAt,
            })

        return result[0] || null
    },

    delete: async (id: number) => {
        await db.delete(userGroups).where(eq(userGroups.id, id))
    },
}
