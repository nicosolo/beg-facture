import { Hono } from "hono"
import { odysActivityRepository } from "../db/repositories/odys/activity"
import type { ActivityFilter } from "@beg/types"
import { zValidator } from "@hono/zod-validator"
import { activityFilterSchema } from "@beg/validations"

const api = new Hono()

api.get("/", zValidator("query", activityFilterSchema), async (c) => {
    const filter = c.req.valid("query") as ActivityFilter
    const activities = await odysActivityRepository.getAll(filter)
    return c.json(activities)
})

export const activityRoutes = api
