import { z } from "zod"
import { createPageResponseSchema, paginationSchema } from "./pagination"
import { booleanSchema, classSchema, dateSchema, timestampsSchema } from "./base"

// Base activity filter schema without pagination
const activityBaseFilterSchema = z.object({
    projectId: z.coerce.number().optional(),
    userId: z.coerce.number().optional(),
    fromDate: z.coerce.date().optional(),
    toDate: z.coerce.date().optional(),
    sortBy: z
        .enum(["date", "duration", "kilometers", "expenses", "rate"])
        .optional()
        .default("date"),
    sortOrder: z.enum(["asc", "desc"]).default("asc").optional(),
    includeBilled: booleanSchema.default(false).optional(),
    includeDisbursement: booleanSchema.default(false).optional(),
    includeUnbilled: booleanSchema.default(false).optional(),
    activityTypeId: z.coerce.number().optional(),
    invoiceId: z.coerce.number().optional(),
})

// Activity filter schema for listing (includes pagination)
export const activityFilterSchema = activityBaseFilterSchema.merge(paginationSchema)

export type ActivityFilter = z.infer<typeof activityFilterSchema>

// Activity export filter schema (extends base filter with export-specific options)
export const activityExportFilterSchema = activityBaseFilterSchema.extend({
    perUser: booleanSchema.default(false).optional(),
})

export type ActivityExportFilter = z.infer<typeof activityExportFilterSchema>

export const activityCreateSchema = z.object({
    projectId: z.number(),
    activityTypeId: z.number(),
    date: dateSchema,
    duration: z.number(),
    kilometers: z.number(),
    expenses: z.number(),
    description: z.string(),
    billed: z.boolean(),
    userId: z.number().optional(),
})

export type ActivityCreateInput = z.infer<typeof activityCreateSchema>

export const activityUpdateSchema = activityCreateSchema.partial()

export type ActivityUpdateInput = z.infer<typeof activityUpdateSchema>

// Bulk update schema
export const activityBulkUpdateSchema = z.object({
    ids: z.array(z.number()).min(1),
    updates: z.object({
        billed: z.boolean().optional(),
        disbursement: z.boolean().optional(),
    }),
})

export type ActivityBulkUpdateInput = z.infer<typeof activityBulkUpdateSchema>

// Response for bulk operations
export const activityBulkUpdateResponseSchema = z.object({
    updated: z.number(),
    ids: z.array(z.number()),
})

export type ActivityBulkUpdateResponse = z.infer<typeof activityBulkUpdateResponseSchema>

// Activity response schema with nested objects
export const activityResponseSchema = z
    .object({
        id: z.number(),
        date: dateSchema,
        duration: z.number(),
        kilometers: z.number(),
        expenses: z.number(),
        rate: z.number(),
        rateClass: classSchema.nullable(),
        description: z.string().nullable(),
        billed: z.boolean(),
        disbursement: z.boolean().optional(),
        user: z
            .object({
                id: z.number(),
                firstName: z.string(),
                lastName: z.string(),
                initials: z.string(),
            })
            .nullable(),
        project: z
            .object({
                id: z.number(),
                name: z.string(),
                projectNumber: z.string(),
            })
            .nullable(),
        activityType: z
            .object({
                id: z.number(),
                name: z.string(),
                code: z.string(),
                billable: z.boolean(),
            })
            .nullable(),
    })
    .merge(timestampsSchema)

export type ActivityResponse = z.infer<typeof activityResponseSchema>

export const activityListResponse = createPageResponseSchema(activityResponseSchema).extend({
    totals: z
        .object({
            duration: z.number(),
            kilometers: z.number(),
            expenses: z.number(),
        })
        .optional(),
})

export type ActivityListResponse = z.infer<typeof activityListResponse>
