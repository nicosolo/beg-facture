import { z } from "zod"
import { paginationSchema, createPageResponseSchema } from "./pagination"
import { booleanSchema, dateSchema, timestampsSchema } from "./base"

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
export const projectResponseSchema = z
    .object({
        id: z.number(),
        projectNumber: z.string(),
        name: z.string(),
        startDate: dateSchema,
        remark: z.string().nullable(),
        printFlag: z.boolean().nullable(),
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
        totalDuration: z.number().nullable(),
        unBilledDuration: z.number().nullable(),
        unBilledDisbursementDuration: z.number().nullable(),
        firstActivityDate: z.coerce.date().nullable(),
        lastActivityDate: z.coerce.date().nullable(),
        ended: z.boolean().nullable(),
    })
    .merge(timestampsSchema)

export type ProjectResponse = z.infer<typeof projectResponseSchema>

export const projectListResponse = createPageResponseSchema(projectResponseSchema)

export type ProjectListResponse = z.infer<typeof projectListResponse>

export type ProjectAccessLevel = z.infer<typeof projectAccessLevelSchema>

// Project create schema
export const projectCreateSchema = z.object({
    projectNumber: z.string().min(1),
    name: z.string().min(1),
    startDate: dateSchema,
    typeId: z.number().positive(),
    locationId: z.number().positive().optional(),
    clientId: z.number().positive().optional(),
    engineerId: z.number().positive().optional(),
    companyId: z.number().positive().optional(),
    projectManagerId: z.number().positive().optional(),
    remark: z.string().optional(),
    printFlag: z.boolean().optional().default(false),
    ended: z.boolean().optional().default(false),
    archived: z.boolean().optional().default(false),
})

// Project update schema - all fields optional
export const projectUpdateSchema = projectCreateSchema.partial()

export type ProjectCreateInput = z.infer<typeof projectCreateSchema>
export type ProjectUpdateInput = z.infer<typeof projectUpdateSchema>

export const projectTypeCreateSchema = z.object({
    name: z.string().min(1),
})
// Project Type schema
export const projectTypeSchema = z
    .object({
        id: z.number(),
        name: z.string(),
    })
    .merge(timestampsSchema)

// Project Type update schema
export const projectTypeUpdateSchema = z.object({
    name: z.string().min(1).optional(),
})

// Array response for getting all project types
export const projectTypesArraySchema = z.array(projectTypeSchema)

export type ProjectTypeSchema = z.infer<typeof projectTypeSchema>
export type ProjectTypeCreateInput = z.infer<typeof projectTypeCreateSchema>
export type ProjectTypeUpdateInput = z.infer<typeof projectTypeUpdateSchema>
