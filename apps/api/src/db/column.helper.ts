import { integer } from "drizzle-orm/sqlite-core"
import { sql } from "drizzle-orm"

export const timestamps = {
    updatedAt: integer("updatedAt", { mode: "timestamp" })
        .default(sql`(strftime('%s', 'now'))`)
        .notNull(),
    createdAt: integer("createdAt", { mode: "timestamp" })
        .default(sql`(strftime('%s', 'now'))`)
        .notNull(),
}
