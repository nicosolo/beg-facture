import { Hono } from "hono"
const app = new Hono()

app.get("/", async (c) => {
    return c.json({ data: [], error: "Failed to fetch users" }, 200)
})

export const statusRoutes = app
