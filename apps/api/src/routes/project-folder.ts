import { Hono } from "hono"
import { authMiddleware } from "@src/tools/auth-middleware"
import { ProjectFolderCache } from "@src/tools/project-folder-finder"
import { z } from "zod"
import { zValidator } from "@hono/zod-validator"

const projectFolderRoutes = new Hono()

// Initialize cache with base directory from env or default
const baseProjectDir = process.env.PROJECT_BASE_DIR || "/app/projects"
const folderCache = new ProjectFolderCache(baseProjectDir)

// Search for project folder by project number
const searchSchema = z.object({
    projectNumber: z.string().regex(/^\d+$/, "Project number must be numeric"),
    all: z
        .string()
        .optional()
        .transform((val) => val === "true"),
})

projectFolderRoutes.get("/search", authMiddleware, zValidator("query", searchSchema), async (c) => {
    const { projectNumber, all } = c.req.valid("query")

    try {
        if (all) {
            const results = await folderCache.findAll(projectNumber)
            return c.json({
                projectNumber,
                count: results.length,
                results,
            })
        } else {
            const result = await folderCache.find(projectNumber)
            return c.json({
                projectNumber,
                found: !!result,
                result,
            })
        }
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

export { projectFolderRoutes }
