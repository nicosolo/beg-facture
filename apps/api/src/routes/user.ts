import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { z } from "zod"
import type { User } from "@beg/types"
import { userRepository } from "../db/repositories/user.repository"
import { comparePassword, generateToken } from "../tools/auth"
import { authMiddleware } from "../tools/auth-middleware"

// Validation schemas
const loginSchema = z.object({
    email: z.string().email(),
    password: z.string().min(6),
})

// Create the app and apply auth middleware to routes that need it
const app = new Hono()

// Login endpoint (no auth required)
app.post("/login", zValidator("json", loginSchema), async (c) => {
    const { email, password } = c.req.valid("json")

    const user = await userRepository.findByEmail(email)
    if (!user) {
        return c.json({ error: "Invalid credentials" }, 401)
    }

    const passwordMatch = await comparePassword(password, user.password)
    if (!passwordMatch) {
        return c.json({ error: "Invalid credentials" }, 401)
    }

    // Generate JWT token
    const token = generateToken(user)

    return c.json(
        {
            token,
            user: {
                id: user.id,
                email: user.email,
                firstName: user.firstName,
                lastName: user.lastName,
                role: user.role,
            },
        },
        200
    )
})

// Protected routes - require authentication
app.use("/*", authMiddleware)

// Get all users (protected)
app.get("/", async (c) => {
    const users = await userRepository.findAll()

    // Remove passwords from response
    const safeUsers = users.map((user) => {
        const { password, ...safeUser } = user
        return safeUser
    })

    return c.json<Omit<User, "password">[]>(safeUsers, 200)
})

export const userRoutes = app
