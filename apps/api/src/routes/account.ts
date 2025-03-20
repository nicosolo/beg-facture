import { Hono } from "hono"
import { odysActivityRepository } from "../db/repositories/odys/activity"

const api = new Hono()

api.get("/account", async (c) => {
    const accounts = await odysActivityRepository.getAll()
    return c.json(accounts)
})

export const accountRoutes = api
