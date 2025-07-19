import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    projectTypeSchema,
    projectTypeCreateSchema,
    projectTypeUpdateSchema,
    projectTypesArraySchema,
    idParamSchema,
    type ProjectTypeSchema,
} from "@beg/validations"
import { projectTypeRepository } from "../db/repositories/projectType.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"

export const projectTypeRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)

    // Get all project types
    .get(
        "/",
        responseValidator({
            200: projectTypesArraySchema,
        }),
        async (c) => {
            const projectTypes = await projectTypeRepository.findAll()
            return c.render(projectTypes as ProjectTypeSchema[], 200)
        }
    )

    // Get project type by ID
    .get(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: projectTypeSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const projectType = await projectTypeRepository.findById(id)

            if (!projectType) {
                return c.json({ error: "Project type not found" }, 404)
            }

            return c.render(projectType, 200)
        }
    )

    // Create new project type
    .post(
        "/",
        zValidator("json", projectTypeCreateSchema),
        responseValidator({
            201: projectTypeSchema,
        }),
        async (c) => {
            const projectTypeData = c.req.valid("json")

            // Check if project type with this name already exists
            const existingProjectType = await projectTypeRepository.findByName(projectTypeData.name)
            if (existingProjectType) {
                return c.json({ error: "Project type with this name already exists" }, 400)
            }

            const newProjectType = await projectTypeRepository.create(projectTypeData)
            return c.render(newProjectType, 201)
        }
    )

    // Update project type
    .put(
        "/:id",
        zValidator("param", idParamSchema),
        zValidator("json", projectTypeUpdateSchema),
        responseValidator({
            200: projectTypeSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const projectTypeData = c.req.valid("json")

            // Check if project type exists
            const existingProjectType = await projectTypeRepository.findById(id)
            if (!existingProjectType) {
                return c.json({ error: "Project type not found" }, 404)
            }

            // Check if name is being changed and if it already exists
            if (projectTypeData.name) {
                const conflictingProjectType = await projectTypeRepository.findByName(
                    projectTypeData.name
                )
                if (conflictingProjectType && conflictingProjectType.id !== id) {
                    return c.json({ error: "Project type with this name already exists" }, 400)
                }
            }

            const updatedProjectType = await projectTypeRepository.update(id, projectTypeData)
            return c.render(updatedProjectType, 200)
        }
    )

    // Delete project type
    .delete("/:id", zValidator("param", idParamSchema), async (c) => {
        const { id } = c.req.valid("param")

        // Check if project type exists
        const existingProjectType = await projectTypeRepository.findById(id)
        if (!existingProjectType) {
            return c.json({ error: "Project type not found" }, 404)
        }

        await projectTypeRepository.delete(id)
        return c.json({ message: "Project type deleted successfully" }, 200)
    })
