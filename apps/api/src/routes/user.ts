import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { loginSchema, userResponseSchema, type UserResponse } from "@beg/validations"
import { userRepository } from "../db/repositories/user.repository"
import { comparePassword, generateToken } from "../tools/auth"
import { authMiddleware } from "../tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import { z } from "zod"

// Define login response schema
const loginResponseSchema = z.object({
    token: z.string(),
    user: z.object({
        id: z.number(),
        email: z.string().email(),
        firstName: z.string(),
        lastName: z.string(),
        role: z.enum(["admin", "user"]),
    }),
})

// Define users array response schema
const usersArrayResponseSchema = z.array(userResponseSchema)

// Create the app and apply auth middleware to routes that need it
export const userRoutes = new Hono()
    .post(
        "/login",
        zValidator("json", loginSchema),
        responseValidator({
            200: loginResponseSchema,
        }),
        async (c) => {
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

            return c.render(
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
        }
    )
    .use("/*", authMiddleware)

    // Get all users (protected and requires admin role)
    .get(
        "/",
        responseValidator({
            200: usersArrayResponseSchema,
        }),
        async (c) => {
            const users = await userRepository.findAll()
            console.log(users)
            return c.render(users as UserResponse[], 200)
        }
    )
