import { Hono } from "hono"
import { statusRepository } from "../db/repositories/status.repository"
import { z } from "zod"

// Create a schema for the status response
const statusResponseSchema = z.object({
    status: z.enum(["ok", "error"]),
    database: z.enum(["connected", "disconnected"]),
    error: z.string().optional(),
})

export const statusRoutes = new Hono().get("/", async (c) => {
    const status = await statusRepository.getStatus()

    // Validate the response before sending
    const validatedResponse = statusResponseSchema.safeParse(status)
    if (!validatedResponse.success) {
        console.error("Response validation failed:", validatedResponse.error)
        return c.json({ status: "error", message: "Internal server error" }, 500)
    }

    return c.json(validatedResponse.data)
})
