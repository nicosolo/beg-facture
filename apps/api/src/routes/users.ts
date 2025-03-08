import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { odysUserRepository } from "../db/repositories/odys/user"
const app = new Hono()

// Get all users
app.get("/", async (c) => {
    try {
        const users = await odysUserRepository.getAll()
        return c.json({ users })
    } catch (error) {
        console.error(error)
        return c.json({ data: [], error: "Failed to fetch users" }, 500)
    }
})

// Create user with validation
// app.post("/", zValidator("json", userSchema), async (c) => {})

export const userRoutes = app
