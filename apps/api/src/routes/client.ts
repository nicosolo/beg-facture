import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { clientFilterSchema, type ClientFilter } from "@beg/validations"
import { type Page } from "@beg/types"
import type { Client } from "@beg/types"

const api = new Hono().get("/", zValidator("query", clientFilterSchema), async (c) => {
    const filter = c.req.valid("query")
    return c.json<Page<Client>>({
        data: [],
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 1,
    })
})

export const clientRoutes = api
