import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    loginSchema,
    userResponseSchema,
    userCreateSchema,
    userUpdateSchema,
    idParamSchema,
    type UserResponse,
} from "@beg/validations"
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
            return c.render(users as UserResponse[], 200)
        }
    )

    // Get user by ID
    .get(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: userResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const user = await userRepository.findById(id)

            if (!user) {
                return c.json({ error: "User not found" }, 404)
            }

            return c.render(user, 200)
        }
    )

    // Create new user
    .post(
        "/",
        zValidator("json", userCreateSchema),
        responseValidator({
            201: userResponseSchema,
        }),
        async (c) => {
            const userData = c.req.valid("json")

            // Check if user with this email already exists
            const existingUser = await userRepository.findByEmail(userData.email)
            if (existingUser) {
                return c.json({ error: "User with this email already exists" }, 400)
            }

            const newUser = await userRepository.create(userData)
            return c.render(newUser, 201)
        }
    )

    // Update user
    .put(
        "/:id",
        zValidator("param", idParamSchema),
        zValidator("json", userUpdateSchema),
        responseValidator({
            200: userResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const userData = c.req.valid("json")

            // Check if user exists
            const existingUser = await userRepository.findById(id)
            if (!existingUser) {
                return c.json({ error: "User not found" }, 404)
            }

            // Check if email is being changed and if it's already taken
            if (userData.email && userData.email !== existingUser.email) {
                const emailExists = await userRepository.findByEmail(userData.email)
                if (emailExists) {
                    return c.json({ error: "Email already taken" }, 400)
                }
            }

            const updatedUser = await userRepository.update(id, userData)
            return c.render(updatedUser, 200)
        }
    )
