import { Hono } from "hono"
import { exportMdbToJson } from "@src/tools/mdb-export"
import { runImport } from "@src/db/import"
import { existsSync } from "fs"
import path from "path"
import { adminOnlyMiddleware, authMiddleware } from "@src/tools/auth-middleware"
import { MS_ACCESS_DB_PATH } from "@src/config"

const importRoutes = new Hono()

// Admin-only route to import data from MS Access database
importRoutes.post("/", authMiddleware, adminOnlyMiddleware, async (c) => {
    try {
        // Get MDB path from environment variable
        const mdbPath = MS_ACCESS_DB_PATH

        if (!mdbPath) {
            return c.json(
                {
                    error: "MS_ACCESS_DB_PATH environment variable not set",
                },
                400
            )
        }

        // Check if MDB file exists
        if (!existsSync(mdbPath)) {
            return c.json(
                {
                    error: `MDB file not found at path: ${mdbPath}`,
                },
                404
            )
        }

        // Use /tmp directory for temporary JSON files
        const tempExportDir = path.join("/tmp", `mdb-export-${Date.now()}`)

        console.log(`Starting import process from ${mdbPath}`)

        // Step 1: Export MDB to JSON files
        console.log("Step 1: Exporting MDB to JSON...")
        await exportMdbToJson(mdbPath, tempExportDir)

        // Step 2: Import JSON files to database
        console.log("Step 2: Importing JSON to database...")
        await runImport(tempExportDir)

        // Step 3: Clean up temporary files
        console.log("Step 3: Cleaning up temporary files...")
        const { rm } = await import("fs/promises")
        await rm(tempExportDir, { recursive: true, force: true })

        return c.json({
            success: true,
            message: "Database import completed successfully",
            mdbPath,
            tempDir: tempExportDir,
        })
    } catch (error) {
        console.error("Import failed:", error)
        return c.json(
            {
                error: "Import failed",
                details: error instanceof Error ? error.message : String(error),
            },
            500
        )
    }
})

// Status endpoint to check if import is available
importRoutes.get("/status", authMiddleware, adminOnlyMiddleware, async (c) => {
    const mdbPath = MS_ACCESS_DB_PATH
    console.log(mdbPath)
    return c.json({
        available: !!mdbPath,
        mdbPath: mdbPath || null,
        mdbExists: mdbPath ? existsSync(mdbPath) : false,
        mdbToolsAvailable: true, // Assuming mdb-tools is installed in container
    })
})

export { importRoutes }
