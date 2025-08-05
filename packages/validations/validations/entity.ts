import { z } from "zod"
import { nullableDateSchema } from "./base"

// Client schema
export const clientSchema = z.object({
    id: z.number(),
    name: z.string(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

export type ClientSchema = z.infer<typeof clientSchema>

// Region schema
export const regionSchema = z.object({
    id: z.number(),
    name: z.string(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

export type RegionSchema = z.infer<typeof regionSchema>

// Company schema
export const companySchema = z.object({
    id: z.number(),
    name: z.string(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

export type CompanySchema = z.infer<typeof companySchema>

// Project Type schema
export const projectTypeSchema = z.object({
    id: z.number(),
    name: z.string(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

// Project Type creation schema
export const projectTypeCreateSchema = z.object({
    name: z.string().min(1),
})

// Project Type update schema
export const projectTypeUpdateSchema = z.object({
    name: z.string().min(1).optional(),
})

// Array response for getting all project types
export const projectTypesArraySchema = z.array(projectTypeSchema)

export type ProjectTypeSchema = z.infer<typeof projectTypeSchema>
export type ProjectTypeCreateInput = z.infer<typeof projectTypeCreateSchema>
export type ProjectTypeUpdateInput = z.infer<typeof projectTypeUpdateSchema>

// Engineer schema
export const engineerSchema = z.object({
    id: z.number(),
    name: z.string(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

export type EngineerSchema = z.infer<typeof engineerSchema>
