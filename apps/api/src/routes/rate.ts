import { Hono } from "hono"
import { odysRateRepository } from "../db/repositories/odys/rate"
import type { Rate } from "@beg/types"

const api = new Hono().get("/", async (c) => {
    const rates = await odysRateRepository.getAll()
    return c.json<Rate[]>(rates)
})

export const rateRoutes = api
