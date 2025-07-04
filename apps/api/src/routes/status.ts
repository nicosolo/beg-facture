import { Hono } from "hono"
import { statusRepository } from "../db/repositories/status.repository"
import { z } from "zod"
import { responseValidator } from "@src/tools/response-validator"

// Create a schema for the status response
const statusResponseSchema = z.object({
    status: z.enum(["ok", "error"]),
    database: z.enum(["connected", "disconnected"]),
    error: z.string().optional(),
})

export const statusRoutes = new Hono().get(
    "/",
    responseValidator({
        200: statusResponseSchema,
    }),
    async (c) => {
        const status = await statusRepository.getStatus()
        return c.render(status, 200)
    }
)
