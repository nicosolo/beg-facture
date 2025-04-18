import { Hono } from "hono"
import type { RateClass } from "@beg/types"

const api = new Hono().get("/", async (c) => {
    return c.json<RateClass[]>([])
})

export const rateRoutes = api
