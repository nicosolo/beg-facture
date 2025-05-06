import { timestamp } from "drizzle-orm/mysql-core"
import { sql } from "drizzle-orm"

export const timestamps = {
    updatedAt: timestamp("updatedAt")
        .default(sql`CURRENT_TIMESTAMP`)
        .$onUpdate(() => sql`CURRENT_TIMESTAMP`),
    createdAt: timestamp("createdAt").default(sql`CURRENT_TIMESTAMP`),
}
