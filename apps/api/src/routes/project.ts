import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    projectFilterSchema,
    projectListResponse,
    projectResponseSchema,
    type ProjectListResponse,
    type ProjectResponse,
} from "@beg/validations"
import { projectRepository } from "../db/repositories/project.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"

export const projectRoutes = new Hono()
    .use("/*", authMiddleware)
    .get(
        "/",
        zValidator("query", projectFilterSchema),
        responseValidator({
            200: projectListResponse,
        }),
        async (c) => {
            const filter = c.req.valid("query")

            const result = await projectRepository.findAll(filter)

            return c.render(result as ProjectListResponse, 200)
        }
    )

    .get(
        "/:id",
        responseValidator({
            200: projectResponseSchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                return c.json({ error: "Invalid ID" }, 400)
            }

            const project = await projectRepository.findById(id)
            if (!project) {
                return c.json({ error: "Project not found" }, 404)
            }

            return c.render(project as ProjectResponse, 200)
        }
    )
