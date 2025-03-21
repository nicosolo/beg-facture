import { Hono } from "hono"
import { odysProjectRepository } from "../db/repositories/odys/project"
import { zValidator } from "@hono/zod-validator"
import { projectFilterSchema, type ProjectFilter } from "@beg/validations"
import type { Project, Page } from "@beg/types"

const api = new Hono().get("/", zValidator("query", projectFilterSchema), async (c) => {
    const filter = c.req.valid("query")
    const result = await odysProjectRepository.filter(filter)
    return c.json<Page<Project>>(result)
})

export const projectRoutes = api
