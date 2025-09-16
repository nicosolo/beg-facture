import { Hono } from "hono"
import { existsSync } from "fs"
import { adminOnlyMiddleware, authMiddleware } from "@src/tools/auth-middleware"
import { MS_ACCESS_DB_PATH } from "@src/config"
import { importMdbToSqlite } from "@src/scripts/import-mdb"

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

        // Use the imported function to handle the import
        const tempExportDir = await importMdbToSqlite()

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
