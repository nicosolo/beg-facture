import { Hono } from "hono"

import { zValidator } from "@hono/zod-validator"
import { activityFilterSchema, type ActivityFilter } from "@beg/validations"
import type { Activity, Page } from "@beg/types"

const api = new Hono().get("/", zValidator("query", activityFilterSchema), async (c) => {
    const filter = c.req.valid("query")
    return c.json<Page<Activity>>({
        data: [],
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 1,
    })
})

export const activityRoutes = api
