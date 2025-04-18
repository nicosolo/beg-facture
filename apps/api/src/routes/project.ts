import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { projectFilterSchema } from "@beg/validations"
import type { Project, Page } from "@beg/types"

const api = new Hono().get("/", zValidator("query", projectFilterSchema), async (c) => {
    const filter = c.req.valid("query")
    return c.json<Page<Project>>({
        data: [],
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 1,
    })
})

export const projectRoutes = api
