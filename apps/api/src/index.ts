import { Hono } from "hono"
import { statusRoutes } from "./routes/status"
import { userRoutes } from "./routes/users"
import { activityRoutes } from "./routes/activity"
const app = new Hono()

app.route("/api/users", userRoutes)
// app.route("/api/posts", postRoutes)
app.route("/api/status", statusRoutes)
app.route("/api/activity", activityRoutes)
export default {
    port: 3000,
    fetch: app.fetch,
}
