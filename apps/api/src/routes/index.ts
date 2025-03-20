import { Hono } from "hono"

const api = new Hono()

api.get("/", async (c) => {
    return c.text("Hello world!")
})

export const indexRoutes = api
