import { z } from "zod"
import { paginationSchema, createPageResponseSchema } from "./pagination"
import { booleanSchema, dateSchema, nullableDateSchema } from "./base"

export const projectAccessLevelSchema = z.enum(["read", "write"])
// Update schema to match activity filter schema pattern
export const projectFilterSchema = z
    .object({
        name: z.string().optional(),
        referentUserId: z.coerce.number().optional(),
        fromDate: z.coerce.date().optional(),
        toDate: z.coerce.date().optional(),
        sortBy: z
            .enum(["name", "unBilledDuration", "firstActivityDate", "lastActivityDate"])
            .optional()
            .default("name"),
        sortOrder: z.enum(["asc", "desc"]).optional().default("asc"),
        hasUnbilledTime: booleanSchema.optional().default(false),
        includeArchived: booleanSchema.optional().default(false),
        includeEnded: booleanSchema.optional().default(false),
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
    firstActivityDate: nullableDateSchema,
    lastActivityDate: nullableDateSchema,
    totalDuration: z.number().nullable(),
    unBilledDuration: z.number().nullable(),
    unBilledDisbursementDuration: z.number().nullable(),
    ended: z.boolean().nullable(),
})

export type ProjectResponse = z.infer<typeof projectResponseSchema>

export const projectListResponse = createPageResponseSchema(projectResponseSchema)

export type ProjectListResponse = z.infer<typeof projectListResponse>

export type ProjectAccessLevel = z.infer<typeof projectAccessLevelSchema>
