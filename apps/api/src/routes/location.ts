import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    locationSchema,
    locationCreateSchema,
    locationUpdateSchema,
    locationFilterSchema,
    createPageResponseSchema,
    idParamSchema,
    successSchema,
} from "@beg/validations"
import { locationRepository } from "../db/repositories/location.repository"
import { authMiddleware } from "../tools/auth-middleware"
import { roleMiddleware } from "../tools/role-middleware"
import { responseValidator } from "../tools/response-validator"
import { z } from "zod"
import type { Variables } from "@src/types/global"

const locationResponseArraySchema = createPageResponseSchema(locationSchema)

export const locationRoutes = new Hono<{ Variables: Variables }>()
    // Get all locations (no auth required)
    .get(
        "/",
        zValidator("query", locationFilterSchema),
        responseValidator({
            200: locationResponseArraySchema,
        }),
        async (c) => {
            const filter = c.req.valid("query")
            const result = await locationRepository.findAll(filter)
            console.log(result)
            return c.render(result, 200)
        }
    )

    // Get location by ID (no auth required)
    .get(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: locationSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const location = await locationRepository.findById(id)
            if (!location) {
                return c.json({ error: "Location not found" }, 404)
            }
            return c.render(location, 200)
        }
    )

    // Create location (admin only)
    .post(
        "/",
        authMiddleware,
        roleMiddleware("admin"),
        zValidator("json", locationCreateSchema),
        responseValidator({
            201: locationSchema,
        }),
        async (c) => {
            const locationData = c.req.valid("json")
            const newLocation = await locationRepository.create(locationData)
            return c.render(newLocation, 201)
        }
    )

    // Update location (admin only)
    .put(
        "/:id",
        authMiddleware,
        roleMiddleware("admin"),
        zValidator("param", idParamSchema),
        zValidator("json", locationUpdateSchema),
        responseValidator({
            200: locationSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const locationData = c.req.valid("json")

            // Check if location exists
            const existingLocation = await locationRepository.findById(id)
            if (!existingLocation) {
                return c.json({ error: "Location not found" }, 404)
            }

            const updatedLocation = await locationRepository.update(id, locationData)
            if (!updatedLocation) {
                return c.json({ error: "Failed to update location" }, 500)
            }

            return c.render(updatedLocation, 200)
        }
    )

    // Delete location (admin only)
    .delete(
        "/:id",
        authMiddleware,
        roleMiddleware("admin"),
        zValidator("param", idParamSchema),
        responseValidator({
            204: successSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")

            // Check if location exists
            const existingLocation = await locationRepository.findById(id)
            if (!existingLocation) {
                return c.json({ error: "Location not found" }, 404)
            }

            const deleted = await locationRepository.delete(id)
            if (!deleted) {
                return c.json({ error: "Failed to delete location" }, 500)
            }

            return c.render({ success: true }, 204)
        }
    )
