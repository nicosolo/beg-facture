import type { Config } from "drizzle-kit"
import { DATABASE_FILE_PATH } from "./src/config"

export default {
    schema: "./src/db/schema.ts",
    out: "./drizzle",
    migrations: {},
    dialect: "sqlite",
    dbCredentials: {
        url: DATABASE_FILE_PATH,
    },
    verbose: true,
    strict: true,
} satisfies Config
