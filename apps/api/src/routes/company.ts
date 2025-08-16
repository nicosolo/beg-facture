import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { 
    companyFilterSchema, 
    companySchema, 
    companyCreateSchema,
    companyUpdateSchema,
    createPageResponseSchema 
} from "@beg/validations"
import { companyRepository } from "../db/repositories/company.repository"
import { authMiddleware, adminOnlyMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"
import { createApiError, ErrorCode } from "@beg/validations"

const companyResponseArraySchema = createPageResponseSchema(companySchema)

export const companyRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)
    .get(
        "/",
        zValidator("query", companyFilterSchema),
        responseValidator({
            200: companyResponseArraySchema,
        }),
        async (c) => {
            const filter = c.req.valid("query")
            const result = await companyRepository.findAll(filter)
            return c.render(result, 200)
        }
    )

    .get(
        "/:id",
        responseValidator({
            200: companySchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                throw createApiError(ErrorCode.BAD_REQUEST, "Invalid ID")
            }

            const company = await companyRepository.findById(id)
            if (!company) {
                throw createApiError(ErrorCode.NOT_FOUND, "Company not found")
            }

            return c.render(company, 200)
        }
    )

    .post(
        "/",
        adminOnlyMiddleware,
        zValidator("json", companyCreateSchema),
        responseValidator({
            201: companySchema,
        }),
        async (c) => {
            const data = c.req.valid("json")
            const company = await companyRepository.create(data)
            return c.render(company, 201)
        }
    )

    .put(
        "/:id",
        adminOnlyMiddleware,
        zValidator("json", companyUpdateSchema),
        responseValidator({
            200: companySchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                throw createApiError(ErrorCode.BAD_REQUEST, "Invalid ID")
            }

            const data = c.req.valid("json")
            const company = await companyRepository.update(id, data)
            if (!company) {
                throw createApiError(ErrorCode.NOT_FOUND, "Company not found")
            }

            return c.render(company, 200)
        }
    )

    .delete(
        "/:id",
        adminOnlyMiddleware,
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                throw createApiError(ErrorCode.BAD_REQUEST, "Invalid ID")
            }

            // Check if company exists
            const company = await companyRepository.findById(id)
            if (!company) {
                throw createApiError(ErrorCode.NOT_FOUND, "Company not found")
            }

            // Check if company has projects
            const hasProjects = await companyRepository.hasProjects(id)
            
            if (hasProjects) {
                throw createApiError(
                    ErrorCode.CONSTRAINT_VIOLATION,
                    "Cannot delete company with existing projects"
                )
            }

            await companyRepository.delete(id)
            return c.json({ success: true }, 200)
        }
    )