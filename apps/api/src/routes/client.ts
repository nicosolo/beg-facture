import { Hono } from "hono"
import { odysClientRepository } from "../db/repositories/odys/client"
import { zValidator } from "@hono/zod-validator"
import { clientFilterSchema, type ClientFilter } from "@beg/validations"
import { type Page } from "@beg/types"
import type { Client } from "@beg/types"

const api = new Hono().get("/", zValidator("query", clientFilterSchema), async (c) => {
    const filter = c.req.valid("query")
    const clients = await odysClientRepository.filter(filter)
    return c.json<Page<Client>>(clients)
})

export const clientRoutes = api
