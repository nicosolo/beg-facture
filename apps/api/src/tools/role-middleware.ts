import type { Context, MiddlewareHandler, Next } from "hono"
import type { UserRole } from "@beg/validations"

export const roleMiddleware = (requiredRole: UserRole): MiddlewareHandler => {
    return async (c: Context, next: Next) => {
        // Get the user from the context (added by authMiddleware)
        const user = c.get("user")

        if (!user) {
            return c.json({ error: "Unauthorized - Authentication required" }, 401)
        }

        // Check if the user has the required role
        if (user.role !== requiredRole) {
            return c.json({ error: `Forbidden - ${requiredRole} role required` }, 403)
        }

        await next()
    }
}
