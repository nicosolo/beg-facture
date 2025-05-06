import { eq } from "drizzle-orm"
import { db } from "../index"
import { users } from "../schema"

export const userRepository = {
    findByEmail: async (email: string) => {
        const results = await db.select().from(users).where(eq(users.email, email))
        return results[0] || null
    },

    findById: async (id: number) => {
        const results = await db.select().from(users).where(eq(users.id, id))
        return results[0] || null
    },

    findAll: async () => {
        return await db.select().from(users)
    },
}
