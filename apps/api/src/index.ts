import { Hono } from "hono"
import { statusRoutes } from "@src/routes/status"
import { userRoutes } from "@src/routes/user"
import { activityRoutes } from "@src/routes/activity"
import { activityTypeRoutes } from "@src/routes/activityType"
import { projectRoutes } from "@src/routes/project"
import { projectTypeRoutes } from "@src/routes/projectType"
import { rateRoutes } from "@src/routes/rate"
import { clientRoutes } from "@src/routes/client"
import { invoiceRoutes } from "@src/routes/invoice"
import { runMigrations } from "@src/db/migrate"
import { PORT, DB_FILE_PATH } from "@src/config"
import { mkdir } from "node:fs/promises"
import { dirname } from "node:path"
import { existsSync } from "node:fs"
import { errorHandler } from "@src/tools/error-handler"

// Ensure SQLite database directory exists
const dbDir = dirname(DB_FILE_PATH)
if (!existsSync(dbDir)) {
    await mkdir(dbDir, { recursive: true })
    console.log(`Created database directory: ${dbDir}`)
}

// Run database migrations
await runMigrations()

const app = new Hono()
    .onError(errorHandler)
    .route("/user", userRoutes)
    .route("/status", statusRoutes)
    .route("/activity", activityRoutes)
    .route("/activity-type", activityTypeRoutes)
    .route("/project", projectRoutes)
    .route("/project-type", projectTypeRoutes)
    .route("/rate", rateRoutes)
    .route("/client", clientRoutes)
    .route("/invoice", invoiceRoutes)

export type ApiRoutes = typeof app

// const res = await client.user.$get()
// console.log((await res.json())[0].firstName)
export default {
    port: PORT,
    fetch: app.fetch,
}
