import { drizzle } from "drizzle-orm/bun-sqlite"
import { Database } from "bun:sqlite"
import * as schema from "./schema"
import { DB_FILE_PATH } from "@src/config"

// Create SQLite database connection
const sqlite = new Database(DB_FILE_PATH)

export const db = drizzle(sqlite, { schema })
