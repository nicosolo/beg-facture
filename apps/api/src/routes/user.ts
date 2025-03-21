import { Hono } from "hono"
import { odysUserRepository } from "../db/repositories/odys/user"
import type { User } from "@beg/types"

const app = new Hono().get("/", async (c) => {
    const users = await odysUserRepository.getAll()

    return c.json<User[]>(users, 200)
})

export const userRoutes = app
