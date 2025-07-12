import { z } from "zod"

// Base schemas for entities
export const dateSchema = z.coerce.date()
export const nullableDateSchema = dateSchema.nullable()

export type DateSchema = z.infer<typeof dateSchema>
export type NullableDateSchema = z.infer<typeof nullableDateSchema>
// ID parameter schema
export const idParamSchema = z.object({
    id: z.coerce.number().int().positive(),
})

export type IdParamSchema = z.infer<typeof idParamSchema>

// Class type
export const classSchema = z.enum(["A", "B", "C", "D", "E", "F", "G", "R", "Z"])

export type ClassSchema = z.infer<typeof classSchema>
