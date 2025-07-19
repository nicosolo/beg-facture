import type { TypedResponse } from "hono"
import { createMiddleware } from "hono/factory"
import { HTTPException } from "hono/http-exception"
import type { StatusCode } from "hono/utils/http-status"
import { ZodSchema } from "zod"
import { throwResponseValidationError, throwValidationError } from "./error-handler"

declare module "hono" {
    interface ContextRenderer {
        (data: any, status: StatusCode): TypedResponse
    }
}

type Params = Partial<Record<StatusCode, ZodSchema>>

export const responseValidator = (params: Params) =>
    createMiddleware(async (c, next) => {
        c.setRenderer((data, status) => {
            for (const [code, schema] of Object.entries(params)) {
                if (status.toString() === code) {
                    const result = schema.safeParse(data)

                    if (!result.success) {
                        const fieldErrors = result.error.flatten().fieldErrors
                        const errors = Object.keys(fieldErrors).flatMap((key) => {
                            const keyErrors = fieldErrors[key as keyof typeof fieldErrors]
                            if (!keyErrors) return []
                            return keyErrors.map((error: string) => ({
                                field: key,
                                message: error,
                                code: undefined,
                            }))
                        })
                        throwResponseValidationError("Validation response error", errors)
                    }
                    return c.json(result.data)
                }
            }
            return c.json({ message: "Invalid!" }, 500)
        })
        await next()
    })
