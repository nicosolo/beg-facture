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

// Location schema
export const locationSchema = z.object({
    id: z.number(),
    name: z.string(),
    regionId: z.number(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

export type LocationSchema = z.infer<typeof locationSchema>

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

export type ProjectTypeSchema = z.infer<typeof projectTypeSchema>

// Engineer schema
export const engineerSchema = z.object({
    id: z.number(),
    name: z.string(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

export type EngineerSchema = z.infer<typeof engineerSchema>

// Class type
export const classSchema = z.enum(["A", "B", "C", "D", "E", "F", "G", "R", "Z"])

export type ClassSchema = z.infer<typeof classSchema>

// Rate Class schema
export const rateClassSchema = z.object({
    id: z.number(),
    class: classSchema,
    year: z.number(),
    amount: z.number(),
})

export type RateClassSchema = z.infer<typeof rateClassSchema>
