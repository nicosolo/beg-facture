import { z } from "zod"
import { paginationSchema, createPageResponseSchema } from "./pagination"
import { dateSchema, nullableDateSchema } from "./base"

// Update schema to match activity filter schema pattern
export const projectFilterSchema = z
    .object({
        name: z.string().optional(),
        archived: z.coerce.boolean().optional().default(false),
        referentUserId: z.coerce.number().optional(),
        fromDate: z.coerce.date().optional(),
        toDate: z.coerce.date().optional(),
        sortBy: z
            .enum(["name", "unBilledDuration", "firstActivityDate", "lastActivityDate"])
            .optional()
            .default("name"),
        sortOrder: z.enum(["asc", "desc"]).optional().default("asc"),
        hasUnbilledTime: z.coerce.boolean().optional().default(true),
    })
    .merge(paginationSchema)

export type ProjectFilter = z.infer<typeof projectFilterSchema>
export type ProjectFilterInput = z.input<typeof projectFilterSchema>

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
