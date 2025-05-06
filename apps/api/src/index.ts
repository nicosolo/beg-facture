import { Hono } from "hono"
import { statusRoutes } from "@src/routes/status"
import { userRoutes } from "@src/routes/user"
import { activityRoutes } from "@src/routes/activity"
import { projectRoutes } from "@src/routes/project"
import { rateRoutes } from "@src/routes/rate"
import { clientRoutes } from "@src/routes/client"
import { runMigrations } from "@src/db/migrate"
import { PORT } from "@src/config"
import { authMiddleware } from "@src/tools/auth-middleware"

// Run database migrations
await runMigrations()

const app = new Hono()
// Route for authentication (not protected)
// public
app.route("/user", userRoutes)

// protected prefixes + routers
const protectedRoutes: [string, typeof userRoutes][] = [
    ["/status", statusRoutes],
    ["/activity", activityRoutes],
    ["/project", projectRoutes],
    ["/rate", rateRoutes],
    ["/client", clientRoutes],
]

for (const [prefix, router] of protectedRoutes) {
    app.use(`${prefix}/*`, authMiddleware)
    app.route(prefix, router)
}
export type AppType = typeof app
// export const client = hc<AppType>("http://localhost:3000/api")
// const res = await client.user.$get()
// console.log((await res.json())[0].firstName)
export default {
    port: PORT,
    fetch: app.fetch,
}
