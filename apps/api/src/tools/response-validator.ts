import type { TypedResponse } from "hono"
import { createMiddleware } from "hono/factory"
import { HTTPException } from "hono/http-exception"
import type { StatusCode } from "hono/utils/http-status"
import { ZodSchema } from "zod"

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
                        throw new HTTPException(500, {
                            res:
                                process.env.NODE_ENV === "development"
                                    ? c.json(
                                          {
                                              message: "Validation response error",
                                              error: result.error.flatten(),
                                          },
                                          500
                                      )
                                    : c.json({ message: "Validation response error" }, 500),
                        })
                    }
                    return c.json(result.data)
                }
            }
            return c.json({ message: "Invalid!" }, 500)
        })
        await next()
    })
