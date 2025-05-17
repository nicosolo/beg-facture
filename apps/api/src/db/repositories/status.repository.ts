import { db } from "../index"
import { sql } from "drizzle-orm"

export const statusRepository = {
    getStatus: async () => {
        try {
            // Simple query to check if database is connected
            await db.run(sql`SELECT 1`)
            return { status: "ok", database: "connected" }
        } catch (error) {
            return { status: "error", database: "disconnected", error: String(error) }
        }
    },
}
