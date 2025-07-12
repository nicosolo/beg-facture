import { z } from "zod"

/**
 * Pagination parameters schema
 */
export const paginationSchema = z.object({
    page: z.coerce.number().int().positive().optional().default(1),
    limit: z.coerce.number().int().positive().optional().default(20),
})

export const paginationResponseSchema = z.object({
    total: z.number(),
    page: z.number(),
    limit: z.number(),
    totalPages: z.number(),
})

export const createPageResponseSchema = <T extends z.ZodTypeAny>(schema: T) => {
    return z.object({
        data: z.array(schema),
        total: z.number(),
        page: z.number(),
        limit: z.number(),
        totalPages: z.number(),
    })
}

export type PaginationInput = z.input<typeof paginationSchema>
export type Pagination = z.infer<typeof paginationSchema>
export type PaginationResponse = z.infer<typeof paginationResponseSchema>
export type PageResponse<T> = {
    data: T[]
    total: number
    page: number
    limit: number
    totalPages: number
}
