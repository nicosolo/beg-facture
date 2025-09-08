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
} from "@beg/validations"
import { projectRepository } from "../db/repositories/project.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"
import { throwNotFound } from "@src/tools/error-handler"
import { findProjectFolderSingle } from "@src/tools/project-folder-finder"
import { PROJECT_BASE_DIR } from "@src/config"

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
        "/parent-projects",
        responseValidator({
            200: projectListResponse,
        }),
        async (c) => {
            const user = c.get("user")
            // Get projects without subProjectName (main projects only)
            const result = await projectRepository.findMainProjects(user)
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
    .get("/:id/folder", async (c) => {
        const id = parseInt(c.req.param("id"))
        if (isNaN(id)) {
            return c.json({ error: "Invalid project ID" }, 400)
        }

        const user = c.get("user")

        // First get the project to obtain its project number
        const project = await projectRepository.findById(id, user)
        if (!project) {
            return c.json({ error: "Project not found" }, 404)
        }

        try {
            // Search for folder using the project number
            const result = await findProjectFolderSingle(PROJECT_BASE_DIR, project.projectNumber)

            return c.json({
                projectId: id,
                projectNumber: project.projectNumber,
                found: !!result,
                folder: result,
            })
        } catch (error) {
            console.error("Project folder search error:", error)
            return c.json(
                {
                    error: "Failed to search for project folder",
                    details: error instanceof Error ? error.message : String(error),
                },
                500
            )
        }
    })
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
