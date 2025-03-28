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
        sortBy: z
            .enum(["name", "unBilledDuration", "firstActivityDate", "lastActivityDate"])
            .optional()
            .default("name"),
        sortOrder: z.enum(["asc", "desc"]).optional().default("asc"),
        hasUnbilledTime: z
            .string()
            .transform((val) => val.toLowerCase() === "true")
            .optional()
            .default("true"),
    })
    .merge(paginationSchema)

export type ProjectFilter = z.infer<typeof projectFilterSchema>
export type ProjectFilterInput = z.input<typeof projectFilterSchema>

export function convertProjectFilterToInput(filter: ProjectFilter): ProjectFilterInput {
    return {
        ...filter,
        page: filter.page?.toString(),
        limit: filter.limit?.toString(),
        accountId: filter.accountId?.toString(),
        archived: filter.archived?.toString(),
        referentUserId: filter.referentUserId?.toString(),
        fromDate: filter.fromDate?.toISOString(),
        toDate: filter.toDate?.toISOString(),
        hasUnbilledTime: filter.hasUnbilledTime?.toString(),
    }
}
