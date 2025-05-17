import { Hono } from "hono"

import { zValidator } from "@hono/zod-validator"
import {
    activityFilterSchema,
    activityResponseSchema,
    createPageResponseSchema,
} from "@beg/validations"
import { activityRepository } from "../db/repositories/activity.repository"
import { authMiddleware } from "@src/tools/auth-middleware"

const activityResponseArraySchema = createPageResponseSchema(activityResponseSchema)

export const activityRoutes = new Hono()
    .use("/*", authMiddleware)
    .get("/", zValidator("query", activityFilterSchema), async (c) => {
        const filter = c.req.valid("query")
        const result = await activityRepository.findAll(filter)

        // Validate the response before sending
        const validatedResponse = activityResponseArraySchema.safeParse(result)
        if (!validatedResponse.success) {
            console.error("Response validation failed:", validatedResponse.error)
            return c.json({ error: "Internal server error" }, 500)
        }

        return c.json(validatedResponse.data)
    })
    .get("/:id", async (c) => {
        const id = parseInt(c.req.param("id"))
        if (isNaN(id)) {
            return c.json({ error: "Invalid ID" }, 400)
        }

        const activity = await activityRepository.findById(id)
        if (!activity) {
            return c.json({ error: "Activity not found" }, 404)
        }

        // Validate the response before sending
        const validatedResponse = activityResponseSchema.safeParse(activity)
        if (!validatedResponse.success) {
            console.error("Response validation failed:", validatedResponse.error)
            return c.json({ error: "Internal server error" }, 500)
        }

        return c.json(validatedResponse.data)
    })
