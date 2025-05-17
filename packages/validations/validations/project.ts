import { z } from "zod"
import { paginationSchema, createPageResponseSchema } from "./pagination"
import { dateSchema, nullableDateSchema } from "./base"

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

// Project response schema with nested objects
export const projectResponseSchema = z.object({
    id: z.number(),
    projectNumber: z.string(),
    name: z.string(),
    startDate: dateSchema,
    remark: z.string().nullable(),
    printFlag: z.boolean().nullable(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
    location: z
        .object({
            id: z.number(),
            name: z.string(),
        })
        .nullable(),
    client: z
        .object({
            id: z.number(),
            name: z.string(),
        })
        .nullable(),
    engineer: z
        .object({
            id: z.number(),
            name: z.string(),
        })
        .nullable(),
    company: z
        .object({
            id: z.number(),
            name: z.string(),
        })
        .nullable(),
    type: z.object({
        id: z.number(),
        name: z.string(),
    }),
    projectManager: z
        .object({
            id: z.number(),
            firstName: z.string(),
            lastName: z.string(),
            initials: z.string(),
        })
        .nullable(),
})

export type ProjectResponse = z.infer<typeof projectResponseSchema>

export const projectListResponse = createPageResponseSchema(projectResponseSchema)

export type ProjectListResponse = z.infer<typeof projectListResponse>
