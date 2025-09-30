import { z } from "zod"
import { paginationSchema, createPageResponseSchema } from "./pagination"
import { booleanSchema, dateSchema, nullableTimestampsSchema, timestampsSchema } from "./base"
import type { projectAccessLevelSchema } from "./projectAccess"

// Moved to projectAccess.ts
// export const projectAccessLevelSchema = z.enum(["read", "write"])
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
        subProjectName: z.string().nullable(),
        name: z.string(),
        startDate: dateSchema,
        remark: z.string().nullable(),
        invoicingAddress: z.string().nullable(),
        printFlag: z.boolean().nullable(),
        latitude: z.number().nullable(),
        longitude: z.number().nullable(),
        location: z
            .object({
                id: z.number(),
                name: z.string(),
                country: z.string().nullable(),
                canton: z.string().nullable(),
                region: z.string().nullable(),
                address: z.string().nullable(),
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
    .merge(nullableTimestampsSchema)

export type ProjectResponse = z.infer<typeof projectResponseSchema>

export const projectListResponse = createPageResponseSchema(projectResponseSchema)

export type ProjectListResponse = z.infer<typeof projectListResponse>

// Project create schema
export const projectCreateSchema = z.object({
    projectNumber: z.string().min(1),
    subProjectName: z.string().optional(),
    parentProjectId: z.number().positive().optional().nullable(),
    name: z.string().min(1),
    startDate: dateSchema,
    typeId: z.number().positive(),
    locationId: z.number().positive().optional().nullable(),
    clientId: z.number().positive().optional(),
    engineerId: z.number().positive().optional().nullable(),
    companyId: z.number().positive().optional().nullable(),
    projectManagerId: z.number().positive().optional().nullable(),
    remark: z.string().optional(),
    invoicingAddress: z.string().optional(),
    printFlag: z.boolean().optional().default(false),
    ended: z.boolean().optional().default(false),
    archived: z.boolean().optional().default(false),
    latitude: z.number().optional().nullable(),
    longitude: z.number().optional().nullable(),
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

// Project create schema
export const projectFolderRoutes = z.object({
    projectNumber: z.string().min(1),
})

export type ProjectTypeSchema = z.infer<typeof projectTypeSchema>
export type ProjectTypeCreateInput = z.infer<typeof projectTypeCreateSchema>
export type ProjectTypeUpdateInput = z.infer<typeof projectTypeUpdateSchema>
