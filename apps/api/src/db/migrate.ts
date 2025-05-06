import { migrate } from "drizzle-orm/mysql2/migrator"
import { db } from "./index"
import { resolve } from "node:path"

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
