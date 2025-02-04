import { Hono } from "hono"
import { mysqlDb } from "../db/mysql"
import { mysqlPosts } from "../db/schema"

const app = new Hono()

app.get("/", async (c) => {
    const posts = await mysqlDb.select().from(mysqlPosts)
    return c.json(posts)
})

export const postRoutes = app
