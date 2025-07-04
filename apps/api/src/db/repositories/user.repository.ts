import { eq } from "drizzle-orm"
import { db } from "../index"
import { users } from "../schema"
import type { UserResponse } from "@beg/validations"

export const userRepository = {
    findByEmail: async (email: string) => {
        const results = await db.select().from(users).where(eq(users.email, email))
        return results[0] || null
    },

    findById: async (id: number) => {
        const results = await db
            .select({
                id: users.id,
                email: users.email,
                firstName: users.firstName,
                lastName: users.lastName,
                initials: users.initials,
                role: users.role,
                archived: users.archived,
                createdAt: users.createdAt,
                updatedAt: users.updatedAt,
            })
            .from(users)
            .where(eq(users.id, id))
        return results[0] || null
    },

    findAll: async (): Promise<UserResponse[]> => {
        return await db
            .select({
                id: users.id,
                email: users.email,
                firstName: users.firstName,
                lastName: users.lastName,
                initials: users.initials,
                role: users.role,
                archived: users.archived,
                createdAt: users.createdAt,
                updatedAt: users.updatedAt,
            })
            .from(users)
    },
}
