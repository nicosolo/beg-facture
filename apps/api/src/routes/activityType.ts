import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    activityTypeCreateSchema,
    activityTypeUpdateSchema,
    activityTypeResponseSchema,
    activityTypesArrayResponseSchema,
    idParamSchema,
    type ActivityTypeResponse,
} from "@beg/validations"
import { activityTypeRepository } from "../db/repositories/activityType.repository"
import { authMiddleware } from "../tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"
import { roleMiddleware } from "@src/tools/role-middleware"

// Create the app and apply auth middleware to all routes
export const activityTypeRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)

    // Get all activity types
    .get(
        "/",
        responseValidator({
            200: activityTypesArrayResponseSchema,
        }),
        async (c) => {
            const activityTypes = await activityTypeRepository.findAll()
            return c.render(activityTypes as ActivityTypeResponse[], 200)
        }
    )

    // Get activity type by ID
    .get(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: activityTypeResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const activityType = await activityTypeRepository.findById(id)

            if (!activityType) {
                return c.json({ error: "Activity type not found" }, 404)
            }

            return c.render(activityType, 200)
        }
    )

    // Create new activity type
    .post(
        "/",
        roleMiddleware("admin"),
        zValidator("json", activityTypeCreateSchema),
        responseValidator({
            201: activityTypeResponseSchema,
        }),
        async (c) => {
            const activityTypeData = c.req.valid("json")

            // Check if activity type with this code already exists
            const existingActivityType = await activityTypeRepository.findByCode(
                activityTypeData.code
            )
            if (existingActivityType) {
                return c.json({ error: "Activity type with this code already exists" }, 400)
            }

            const newActivityType = await activityTypeRepository.create(activityTypeData)
            return c.render(newActivityType, 201)
        }
    )

    // Update activity type
    .put(
        "/:id",
        roleMiddleware("admin"),
        zValidator("param", idParamSchema),
        zValidator("json", activityTypeUpdateSchema),
        responseValidator({
            200: activityTypeResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const activityTypeData = c.req.valid("json")

            // Check if activity type exists
            const existingActivityType = await activityTypeRepository.findById(id)
            if (!existingActivityType) {
                return c.json({ error: "Activity type not found" }, 404)
            }

            // Check if code is being changed and if it's already taken
            if (activityTypeData.code && activityTypeData.code !== existingActivityType.code) {
                const codeExists = await activityTypeRepository.findByCode(activityTypeData.code)
                if (codeExists) {
                    return c.json({ error: "Activity type code already taken" }, 400)
                }
            }

            const updatedActivityType = await activityTypeRepository.update(id, activityTypeData)
            return c.render(updatedActivityType, 200)
        }
    )
