import { Hono } from "hono"

import { zValidator } from "@hono/zod-validator"
import {
    activityFilterSchema,
    activityResponseSchema,
    activityCreateSchema,
    activityUpdateSchema,
    idParamSchema,
    createPageResponseSchema,
} from "@beg/validations"
import { activityRepository } from "../db/repositories/activity.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import { throwNotFound } from "@src/tools/error-handler"
import type { Variables } from "@src/types/global"

const activityResponseArraySchema = createPageResponseSchema(activityResponseSchema)

export const activityRoutes = new Hono<{ Variables: Variables }>()
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

    // Create new activity
    .post(
        "/",
        zValidator("json", activityCreateSchema),
        responseValidator({
            201: activityResponseSchema,
        }),
        async (c) => {
            const activityData = c.req.valid("json")
            const user = c.get("user")

            // Add the current user's ID to the activity data
            const newActivity = await activityRepository.create({
                ...activityData,
                userId: user.id,
                kilometers: 0,
                expenses: 0,
                rate: 0,
                disbursement: false,
                billed: false,
                description: "",
                createdAt: new Date(),
                updatedAt: new Date(),
            })

            if (!newActivity) {
                return c.json({ error: "Failed to create activity" }, 500)
            }

            return c.render(newActivity, 201)
        }
    )

    // Update activity
    .put(
        "/:id",
        zValidator("param", idParamSchema),
        zValidator("json", activityUpdateSchema),
        responseValidator({
            200: activityResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const activityData = c.req.valid("json")

            const updatedActivity = await activityRepository.update(id, activityData)

            if (!updatedActivity) {
                throwNotFound("Activity")
            }

            return c.render(updatedActivity, 200)
        }
    )

    // Delete activity
    .delete("/:id", zValidator("param", idParamSchema), async (c) => {
        const { id } = c.req.valid("param")

        const deleted = await activityRepository.delete(id)

        if (!deleted) {
            throwNotFound("Activity")
        }

        return c.json({ message: "Activity deleted successfully" }, 200)
    })
