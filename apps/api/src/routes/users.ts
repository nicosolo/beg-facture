import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { mysqlDb } from "../db/mysql"
import { mysqlUsers } from "../db/schema"
import type { BaseUser } from "@beg/types"
const app = new Hono()

// Get all users
app.get("/", async (c) => {
    try {
        const users = await mysqlDb.select().from(mysqlUsers)
    } catch (error) {
        return c.json({ data: [], error: "Failed to fetch users" }, 500)
    }
})

// Create user with validation
app.post("/", zValidator("json", userSchema), async (c) => {})

export const userRoutes = app
