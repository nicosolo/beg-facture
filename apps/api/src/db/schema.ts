import { sqliteTable, text as sqliteText, int as sqliteInt } from "drizzle-orm/sqlite-core"

// SQLite schema (for caching/local storage)
export const sqliteUsers = sqliteTable("users", {
    id: sqliteInt("id").primaryKey(),
    email: sqliteText("email").notNull(),
    name: sqliteText("name").notNull(),
    createdAt: sqliteInt("created_at", { mode: "timestamp" }).notNull(),
})

export const sqlitePosts = sqliteTable("posts", {
    id: sqliteInt("id").primaryKey(),
    title: sqliteText("title").notNull(),
    content: sqliteText("content").notNull(),
    authorId: sqliteInt("author_id").notNull(),
    createdAt: sqliteInt("created_at", { mode: "timestamp" }).notNull(),
})
