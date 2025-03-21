import { Hono } from "hono"
import { odysTaskRepository } from "../db/repositories/odys/task"
import type { Task } from "@beg/types"

const api = new Hono().get("/", async (c) => {
    const tasks = await odysTaskRepository.getAll()
    return c.json<Task[]>(tasks)
})

export const taskRoutes = api
