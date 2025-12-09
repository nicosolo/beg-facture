import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    userGroupFilterSchema,
    userGroupResponseSchema,
    userGroupCreateSchema,
    userGroupUpdateSchema,
    createPageResponseSchema,
} from "@beg/validations"
import { userGroupRepository } from "../db/repositories/userGroup.repository"
import { authMiddleware, adminOnlyMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import type { Variables } from "@src/types/global"
import { ErrorCode } from "@beg/validations"
import { ApiException } from "@src/tools/error-handler"

const userGroupResponseArraySchema = createPageResponseSchema(userGroupResponseSchema)

export const userGroupRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)
    .get(
        "/",
        zValidator("query", userGroupFilterSchema),
        responseValidator({
            200: userGroupResponseArraySchema,
        }),
        async (c) => {
            const filter = c.req.valid("query")
            const result = await userGroupRepository.findAll(filter)
            return c.render(result, 200)
        }
    )

    .get(
        "/:id",
        responseValidator({
            200: userGroupResponseSchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                throw new ApiException(400, ErrorCode.BAD_REQUEST, "Invalid ID")
            }

            const group = await userGroupRepository.findById(id)
            if (!group) {
                throw new ApiException(404, ErrorCode.NOT_FOUND, "User group not found")
            }

            return c.render(group, 200)
        }
    )

    .post(
        "/",
        adminOnlyMiddleware,
        zValidator("json", userGroupCreateSchema),
        responseValidator({
            201: userGroupResponseSchema,
        }),
        async (c) => {
            const data = c.req.valid("json")

            // Check for duplicate name
            const existing = await userGroupRepository.findByName(data.name)
            if (existing) {
                throw new ApiException(
                    409,
                    ErrorCode.ALREADY_EXISTS,
                    "A group with this name already exists"
                )
            }

            const group = await userGroupRepository.create(data)
            return c.render(group, 201)
        }
    )

    .put(
        "/:id",
        adminOnlyMiddleware,
        zValidator("json", userGroupUpdateSchema),
        responseValidator({
            200: userGroupResponseSchema,
        }),
        async (c) => {
            const id = parseInt(c.req.param("id"))
            if (isNaN(id)) {
                throw new ApiException(400, ErrorCode.BAD_REQUEST, "Invalid ID")
            }

            const data = c.req.valid("json")

            // Check if group exists
            const existing = await userGroupRepository.findById(id)
            if (!existing) {
                throw new ApiException(404, ErrorCode.NOT_FOUND, "User group not found")
            }

            // Check for duplicate name if name is being changed
            if (data.name && data.name !== existing.name) {
                const duplicate = await userGroupRepository.findByName(data.name)
                if (duplicate) {
                    throw new ApiException(
                        409,
                        ErrorCode.ALREADY_EXISTS,
                        "A group with this name already exists"
                    )
                }
            }

            const group = await userGroupRepository.update(id, data)
            if (!group) {
                throw new ApiException(404, ErrorCode.NOT_FOUND, "User group not found")
            }

            return c.render(group, 200)
        }
    )

    .delete("/:id", adminOnlyMiddleware, async (c) => {
        const id = parseInt(c.req.param("id"))
        if (isNaN(id)) {
            throw new ApiException(400, ErrorCode.BAD_REQUEST, "Invalid ID")
        }

        // Check if group exists
        const group = await userGroupRepository.findById(id)
        if (!group) {
            throw new ApiException(404, ErrorCode.NOT_FOUND, "User group not found")
        }

        await userGroupRepository.delete(id)
        return c.json({ success: true }, 200)
    })
