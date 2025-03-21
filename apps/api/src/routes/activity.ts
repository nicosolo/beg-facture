import { Hono } from "hono"
import { odysActivityRepository } from "../db/repositories/odys/activity"
import { zValidator } from "@hono/zod-validator"
import { activityFilterSchema, type ActivityFilter } from "@beg/validations"
import { type Page } from "@beg/types"
import type { Activity } from "@beg/types"

const api = new Hono().get("/", zValidator("query", activityFilterSchema), async (c) => {
    const filter = c.req.valid("query")
    const activities = await odysActivityRepository.getAll(filter)
    return c.json<Page<Activity>>(activities)
})

export const activityRoutes = api
