import { drizzle } from "drizzle-orm/mysql2"
import mysql from "mysql2/promise"
import * as schema from "./schema"
import { DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_DATABASE } from "@src/config"

const poolConnection = mysql.createPool({
    host: DB_HOST,
    port: Number(DB_PORT),
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_DATABASE,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
})

export const db = drizzle(poolConnection, { schema, mode: "default" })
