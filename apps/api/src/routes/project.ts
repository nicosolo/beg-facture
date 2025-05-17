import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    ProjectListResponse,
    projectFilterSchema,
    projectResponseSchema,
    createPageResponseSchema,
} from "@beg/validations"
import { projectRepository } from "../db/repositories/project.repository"
import { authMiddleware } from "@src/tools/auth-middleware"

const projectResponseArraySchema = createPageResponseSchema(projectResponseSchema)

export const projectRoutes = new Hono()
    .use("/*", authMiddleware)
    .get("/", zValidator("query", projectFilterSchema), async (c) => {
        const filter = c.req.valid("query")

        const result = await projectRepository.findAll(filter)

        return c.json(result)
    })

    .get("/:id", async (c) => {
        const id = parseInt(c.req.param("id"))
        if (isNaN(id)) {
            return c.json({ error: "Invalid ID" }, 400)
        }

        const project = await projectRepository.findById(id)
        if (!project) {
            return c.json({ error: "Project not found" }, 404)
        }

        // Validate the response before sending
        const validatedResponse = projectResponseSchema.safeParse(project)
        if (!validatedResponse.success) {
            console.error("Response validation failed:", validatedResponse.error)
            return c.json({ error: "Internal server error" }, 500)
        }

        return c.json(validatedResponse.data)
    })
