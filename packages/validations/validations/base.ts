import { z } from "zod"

// Base schemas for entities
export const dateSchema = z.coerce.date()
export const nullableDateSchema = dateSchema.nullable()
export const booleanSchema = z.union([
    z.boolean(),
    z.string().transform((val) => val === "true"),
    z.literal("").transform(() => false),
])
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

export const successSchema = z.object({
    success: z.boolean(),
})

export type SuccessResponse = z.infer<typeof successSchema>

export const messageSchema = z.object({
    message: z.string(),
})

export type MessageResponse = z.infer<typeof messageSchema>

// Timestamps schema for entities
export const timestampsSchema = z.object({
    createdAt: dateSchema,
    updatedAt: dateSchema,
})

export type TimestampsSchema = z.infer<typeof timestampsSchema>
