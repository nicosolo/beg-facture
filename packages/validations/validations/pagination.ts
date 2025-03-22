import { z } from "zod"

/**
 * Pagination parameters schema
 */
export const paginationSchema = z.object({
    page: z
        .string()
        .transform((val) => parseInt(val))
        .optional()
        .default("1"),
    limit: z
        .string()
        .transform((val) => parseInt(val))
        .optional()
        .default("20"),
})

export type PaginationParams = z.infer<typeof paginationSchema>
export type PaginationParamsInput = z.input<typeof paginationSchema>
