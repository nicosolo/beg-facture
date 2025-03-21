import { Hono } from "hono"

const app = new Hono().get("/", async (c) => {
    return c.json({ data: "OK" }, 200)
})

export const statusRoutes = app
