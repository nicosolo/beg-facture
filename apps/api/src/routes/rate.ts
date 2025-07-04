import { Hono } from "hono"
import { rateClassSchema } from "@beg/validations"
import { rateRepository } from "../db/repositories/rate.repository"
import { z } from "zod"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"

const rateClassesArraySchema = z.array(rateClassSchema)

export const rateRoutes = new Hono()
    .use("/*", authMiddleware)
    .get(
        "/",
        responseValidator({
            200: rateClassesArraySchema,
        }),
        async (c) => {
            const rates = await rateRepository.findAll()
            return c.render(rates, 200)
        }
    )
    .get(
        "/:class/:year",
        responseValidator({
            200: rateClassSchema,
        }),
        async (c) => {
            const classType = c.req.param("class")
            const year = parseInt(c.req.param("year"))

            if (isNaN(year)) {
                return c.json({ error: "Invalid year" }, 400)
            }

            // Validate class parameter
            const classValidation = z
                .enum(["A", "B", "C", "D", "E", "F", "G", "R", "Z"])
                .safeParse(classType)
            if (!classValidation.success) {
                return c.json({ error: "Invalid class type" }, 400)
            }

            const rate = await rateRepository.findByClassAndYear(classValidation.data, year)
            if (!rate) {
                return c.json({ error: "Rate not found" }, 404)
            }

            return c.render(rate, 200)
        }
    )
