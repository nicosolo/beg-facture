import { drizzle } from "drizzle-orm/bun-sqlite"
import { Database } from "bun:sqlite"
import * as schema from "./schema"
import { DATABASE_FILE_PATH } from "@src/config"

const sqlite = new Database(DATABASE_FILE_PATH!, { create: true })
export const db = drizzle(sqlite, { schema })
