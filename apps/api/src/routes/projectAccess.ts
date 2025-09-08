import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    projectAccessCreateSchema,
    projectAccessUpdateSchema,
    projectAccessResponseSchema,
    projectAccessListResponseSchema,
    idParamSchema,
} from "@beg/validations"
import { projectAccessRepository } from "../db/repositories/projectAccess.repository"
import { authMiddleware } from "../tools/auth-middleware"
import { roleMiddleware } from "../tools/role-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"
import { z } from "zod"

const projectIdParamSchema = z.object({
    projectId: z.coerce.number().int().positive(),
})

export const projectAccessRoutes = new Hono<{ Variables: Variables }>()
    // All routes require authentication and admin role
    .use("*", authMiddleware)
    .use("*", roleMiddleware("admin"))
    // Get all project access for a specific project
    .get(
        "/project/:projectId",
        zValidator("param", projectIdParamSchema),
        responseValidator({
            200: projectAccessListResponseSchema,
            404: z.object({ error: z.string() }),
        }),
        async (c) => {
            const { projectId } = c.req.valid("param")

            try {
                const accesses = await projectAccessRepository.findByProjectId(projectId)
                return c.json(accesses, 200)
            } catch (error) {
                console.error("Error fetching project accesses:", error)
                return c.json({ error: "Failed to fetch project accesses" }, 500)
            }
        }
    )
    // Get all project access for a specific user
    .get(
        "/user/:userId",
        zValidator("param", z.object({ userId: z.coerce.number().int().positive() })),
        responseValidator({
            200: projectAccessListResponseSchema,
            404: z.object({ error: z.string() }),
        }),
        async (c) => {
            const { userId } = c.req.valid("param")

            try {
                const accesses = await projectAccessRepository.findByUserId(userId)
                return c.json(accesses, 200)
            } catch (error) {
                console.error("Error fetching user project accesses:", error)
                return c.json({ error: "Failed to fetch user project accesses" }, 500)
            }
        }
    )
    // Get a specific project access by ID
    .get(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: projectAccessResponseSchema,
            404: z.object({ error: z.string() }),
        }),
        async (c) => {
            const { id } = c.req.valid("param")

            try {
                const access = await projectAccessRepository.findById(id)
                if (!access) {
                    return c.json({ error: "Project access not found" }, 404)
                }
                return c.json(access, 200)
            } catch (error) {
                console.error("Error fetching project access:", error)
                return c.json({ error: "Failed to fetch project access" }, 500)
            }
        }
    )
    // Create or update project access (upsert)
    .post(
        "/",
        zValidator("json", projectAccessCreateSchema),
        responseValidator({
            200: projectAccessResponseSchema,
            201: projectAccessResponseSchema,
            400: z.object({ error: z.string() }),
        }),
        async (c) => {
            const data = c.req.valid("json")

            try {
                const access = await projectAccessRepository.upsert(data)
                const fullAccess = await projectAccessRepository.findById(access.id)
                return c.json(fullAccess!, 201)
            } catch (error) {
                console.error("Error creating project access:", error)
                return c.json({ error: "Failed to create project access" }, 500)
            }
        }
    )
    // Update project access
    .put(
        "/:id",
        zValidator("param", idParamSchema),
        zValidator("json", projectAccessUpdateSchema),
        responseValidator({
            200: projectAccessResponseSchema,
            404: z.object({ error: z.string() }),
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const data = c.req.valid("json")

            try {
                const access = await projectAccessRepository.update(id, data)
                if (!access) {
                    return c.json({ error: "Project access not found" }, 404)
                }
                const fullAccess = await projectAccessRepository.findById(access.id)
                return c.json(fullAccess!, 200)
            } catch (error) {
                console.error("Error updating project access:", error)
                return c.json({ error: "Failed to update project access" }, 500)
            }
        }
    )
    // Delete project access
    .delete(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: z.object({ message: z.string() }),
            404: z.object({ error: z.string() }),
        }),
        async (c) => {
            const { id } = c.req.valid("param")

            try {
                const access = await projectAccessRepository.delete(id)
                if (!access) {
                    return c.json({ error: "Project access not found" }, 404)
                }
                return c.json({ message: "Project access deleted successfully" }, 200)
            } catch (error) {
                console.error("Error deleting project access:", error)
                return c.json({ error: "Failed to delete project access" }, 500)
            }
        }
    )
    // Delete project access by user and project
    .delete(
        "/user/:userId/project/:projectId",
        zValidator(
            "param",
            z.object({
                userId: z.coerce.number().int().positive(),
                projectId: z.coerce.number().int().positive(),
            })
        ),
        responseValidator({
            200: z.object({ message: z.string() }),
            404: z.object({ error: z.string() }),
        }),
        async (c) => {
            const { userId, projectId } = c.req.valid("param")

            try {
                const access = await projectAccessRepository.deleteByUserAndProject(userId, projectId)
                if (!access) {
                    return c.json({ error: "Project access not found" }, 404)
                }
                return c.json({ message: "Project access deleted successfully" }, 200)
            } catch (error) {
                console.error("Error deleting project access:", error)
                return c.json({ error: "Failed to delete project access" }, 500)
            }
        }
    )