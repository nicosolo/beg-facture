import type { Config } from "drizzle-kit"
import { DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_DATABASE } from "./src/config"

export default {
    schema: "./src/db/schema.ts",
    out: "./drizzle",
    migrations: {},
    dialect: "mysql",
    dbCredentials: {
        host: DB_HOST,
        port: Number(DB_PORT),
        user: DB_USER,
        password: DB_PASSWORD,
        database: DB_DATABASE,
    },
    verbose: true,
    strict: true,
} satisfies Config
