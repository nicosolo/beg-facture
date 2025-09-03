import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    projectFilterSchema,
    projectListResponse,
    projectResponseSchema,
    projectCreateSchema,
    projectUpdateSchema,
    type ProjectListResponse,
    type ProjectResponse,
    type ProjectCreateInput,
    type ProjectUpdateInput,
} from "@beg/validations"
import { projectRepository } from "../db/repositories/project.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"
import { throwNotFound } from "@src/tools/error-handler"

export const projectRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)
    .get(
        "/",
        zValidator("query", projectFilterSchema),
        responseValidator({
            200: projectListResponse,
        }),
        async (c) => {
            const filter = c.req.valid("query")
            const user = c.get("user")
            const result = await projectRepository.findAll(user, filter)
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
                throw throwNotFound("Project not found")
            }

            const user = c.get("user")

            const project = await projectRepository.findById(id, user)
            if (!project) {
                throw throwNotFound("Project not found")
            }

            return c.render(project as ProjectResponse, 200)
        }
    )
    .post(
        "/",
        zValidator("json", projectCreateSchema),
        responseValidator({
            201: projectResponseSchema,
        }),
        async (c) => {
            const data = c.req.valid("json")
            const user = c.get("user")

            try {
                const project = await projectRepository.create(data, user)
                return c.render(project as ProjectResponse, 201)
            } catch (error: any) {
                if (error.message === "Project number already exists") {
                    return c.json({ error: error.message }, 409)
                }
                return c.json({ error: "Failed to create project" }, 500)
            }
        }
    )
    .put(
        "/:id",
        zValidator("json", projectUpdateSchema),
        responseValidator({
            200: projectResponseSchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                return c.json({ error: "Invalid ID" }, 400)
            }

            const data = c.req.valid("json")
            const user = c.get("user")

            const project = await projectRepository.update(id, data, user)
            return c.render(project as ProjectResponse, 200)
        }
    )
