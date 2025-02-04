import { drizzle } from "drizzle-orm/better-sqlite3";
import Database from "better-sqlite3";
import * as schema from "./schema";

// Store SQLite database in the persistent volume
const sqlite = new Database("/app/api/data/sqlite.db");
export const sqliteDb = drizzle(sqlite, { schema });
