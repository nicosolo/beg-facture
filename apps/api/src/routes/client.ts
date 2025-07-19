import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { clientFilterSchema, clientSchema, createPageResponseSchema } from "@beg/validations"
import { clientRepository } from "../db/repositories/client.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"

const clientResponseArraySchema = createPageResponseSchema(clientSchema)

export const clientRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)
    .get(
        "/",
        zValidator("query", clientFilterSchema),
        responseValidator({
            200: clientResponseArraySchema,
        }),
        async (c) => {
            const filter = c.req.valid("query")
            const result = await clientRepository.findAll(filter)
            return c.render(result, 200)
        }
    )

    .get(
        "/:id",
        responseValidator({
            200: clientSchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                return c.json({ error: "Invalid ID" }, 400)
            }

            const client = await clientRepository.findById(id)
            if (!client) {
                return c.json({ error: "Client not found" }, 404)
            }

            return c.render(client, 200)
        }
    )
