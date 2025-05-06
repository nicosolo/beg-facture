import type { Context, MiddlewareHandler, Next } from "hono"
import { verifyToken } from "./auth"
import { userRepository } from "../db/repositories/user.repository"

export const authMiddleware: MiddlewareHandler = async (c: Context, next: Next) => {
    const authHeader = c.req.header("Authorization")

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return c.json({ error: "Unauthorized - Missing or invalid token format" }, 401)
    }

    const token = authHeader.split(" ")[1]
    const payload = verifyToken(token)

    if (!payload) {
        return c.json({ error: "Unauthorized - Invalid token" }, 401)
    }

    // Get user from database to ensure they still exist
    const user = await userRepository.findById(payload.id)

    if (!user) {
        return c.json({ error: "Unauthorized - User not found" }, 401)
    }

    // Add user data to the request context
    c.set("user", {
        id: user.id,
        email: user.email,
        role: user.role,
        firstName: user.firstName,
        lastName: user.lastName,
    })

    await next()
}
