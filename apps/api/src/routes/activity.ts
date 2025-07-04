import { Hono } from "hono"

import { zValidator } from "@hono/zod-validator"
import {
    activityFilterSchema,
    activityResponseSchema,
    createPageResponseSchema,
} from "@beg/validations"
import { activityRepository } from "../db/repositories/activity.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"

const activityResponseArraySchema = createPageResponseSchema(activityResponseSchema)

export const activityRoutes = new Hono()
    .use("/*", authMiddleware)
    .get(
        "/",
        zValidator("query", activityFilterSchema),
        responseValidator({
            200: activityResponseArraySchema,
        }),
        async (c) => {
            const filter = c.req.valid("query")
            const result = await activityRepository.findAll(filter)
            return c.render(result, 200)
        }
    )
    .get(
        "/:id",
        responseValidator({
            200: activityResponseSchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                return c.json({ error: "Invalid ID" }, 400)
            }

            const activity = await activityRepository.findById(id)
            if (!activity) {
                return c.json({ error: "Activity not found" }, 404)
            }

            return c.render(activity, 200)
        }
    )
