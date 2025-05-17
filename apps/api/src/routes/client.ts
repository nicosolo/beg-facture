import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { clientFilterSchema, clientSchema, createPageResponseSchema } from "@beg/validations"
import { clientRepository } from "../db/repositories/client.repository"
import { authMiddleware } from "@src/tools/auth-middleware"

const clientResponseArraySchema = createPageResponseSchema(clientSchema)

export const clientRoutes = new Hono()
    .use("/*", authMiddleware)
    .get("/", zValidator("query", clientFilterSchema), async (c) => {
        const filter = c.req.valid("query")

        // Pass pagination parameters directly to the repository
        const result = await clientRepository.findAll(filter)

        // Validate the response before sending
        const validatedResponse = clientResponseArraySchema.safeParse(result)
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

        const client = await clientRepository.findById(id)
        if (!client) {
            return c.json({ error: "Client not found" }, 404)
        }

        // Validate the response before sending
        const validatedResponse = clientSchema.safeParse(client)
        if (!validatedResponse.success) {
            console.error("Response validation failed:", validatedResponse.error)
            return c.json({ error: "Internal server error" }, 500)
        }

        return c.json(validatedResponse.data)
    })
