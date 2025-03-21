import { Hono } from "hono"
import { statusRoutes } from "./routes/status"
import { userRoutes } from "./routes/user"
import { activityRoutes } from "./routes/activity"
import { projectRoutes } from "./routes/project"
import { rateRoutes } from "./routes/rate"
import { taskRoutes } from "./routes/task"
import { clientRoutes } from "./routes/client"

const app = new Hono()
    .route("/user", userRoutes)
    .route("/status", statusRoutes)
    .route("/activity", activityRoutes)
    .route("/project", projectRoutes)
    .route("/rate", rateRoutes)
    .route("/task", taskRoutes)
    .route("/client", clientRoutes)

export type AppType = typeof app
// export const client = hc<AppType>("http://localhost:3000/api")
// const res = await client.user.$get()
// console.log((await res.json())[0].firstName)
export default {
    port: 3000,
    fetch: app.fetch,
}
