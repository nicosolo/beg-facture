import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { loginSchema } from "@beg/validations"
import { userRepository } from "../db/repositories/user.repository"
import { comparePassword, generateToken } from "../tools/auth"
import { authMiddleware } from "../tools/auth-middleware"

// Create the app and apply auth middleware to routes that need it
export const userRoutes = new Hono()
    .post("/login", zValidator("json", loginSchema), async (c) => {
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
    .use("/*", authMiddleware)

    // Get all users (protected and requires admin role)
    .get("/", async (c) => {
        const users = await userRepository.findAll()
        return c.json(users, 200)
    })
