import { Hono } from "hono"
import type { User } from "@beg/types"

const app = new Hono().get("/", async (c) => {
    return c.json<User[]>([], 200)
})

export const userRoutes = app
