import { migrate } from "drizzle-orm/bun-sqlite/migrator"
import { db } from "./index"
import { mkdir } from "node:fs/promises"
import { resolve } from "node:path"
import { existsSync, mkdirSync, writeFileSync } from "node:fs"

export async function runMigrations() {
    await migrate(db, {
        migrationsFolder: resolve(process.cwd(), "drizzle"),
    })
    console.log("Migrations completed successfully")
}

// Run migrations if this file is executed directly
if (import.meta.path === Bun.main) {
    await runMigrations()
}
