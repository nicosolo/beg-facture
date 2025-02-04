import {
    mysqlTable,
    timestamp as mysqlTimestamp,
    text as mysqlText,
    int,
} from "drizzle-orm/mysql-core"
import { sqliteTable, text as sqliteText, int as sqliteInt } from "drizzle-orm/sqlite-core"

// MySQL schema
export const mysqlUsers = mysqlTable("users", {
    id: int("id").primaryKey().autoincrement(),
    email: mysqlText("email").notNull(),
    name: mysqlText("name").notNull(),
    createdAt: mysqlTimestamp("created_at").defaultNow(),
})

export const mysqlPosts = mysqlTable("posts", {
    id: int("id").primaryKey().autoincrement(),
    title: mysqlText("title").notNull(),
    content: mysqlText("content").notNull(),
    authorId: int("author_id").notNull(),
    createdAt: mysqlTimestamp("created_at").defaultNow(),
})

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
