import { sql } from "drizzle-orm"
import { integer } from "drizzle-orm/sqlite-core"

export const timestamps = {
    updatedAt: integer("updatedAt", { mode: "timestamp" })
        .default(sql`CURRENT_TIMESTAMP`)
        .$onUpdate(() => new Date()),
    createdAt: integer("createdAt", { mode: "timestamp" }).default(sql`CURRENT_TIMESTAMP`),
}
