import type { Config } from "drizzle-kit"
import { DB_FILE_PATH } from "./src/config"
import { existsSync, mkdirSync } from "node:fs"
import { dirname, resolve } from "node:path"

// Ensure database directory exists
const dbDir = dirname(resolve(DB_FILE_PATH))
if (!existsSync(dbDir)) {
    mkdirSync(dbDir, { recursive: true })
}

export default {
    schema: "./src/db/schema.ts",
    out: "./drizzle",
    migrations: {
        schema: "./src/db/schema.ts",
    },
    dialect: "sqlite",
    dbCredentials: {
        url: DB_FILE_PATH,
    },
    verbose: true,
    strict: true,
} satisfies Config
