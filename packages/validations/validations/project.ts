import { z } from "zod"
import { paginationSchema } from "./pagination"

// Update schema to match activity filter schema pattern
export const projectFilterSchema = z
    .object({
        accountId: z
            .string()
            .transform((val) => parseInt(val))
            .optional(),
        name: z.string().optional(),
        archived: z
            .string()
            .transform((val) => val.toLowerCase() === "true")
            .optional()
            .default("false"),
        referentUserId: z
            .string()
            .transform((val) => parseInt(val))
            .optional(),
        fromDate: z
            .string()
            .transform((val) => new Date(val))
            .optional(),
        toDate: z
            .string()
            .transform((val) => new Date(val))
            .optional(),
    })
    .merge(paginationSchema)

export type ProjectFilter = z.infer<typeof projectFilterSchema>
