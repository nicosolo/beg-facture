import { z } from "zod"

// Base schemas for entities
export const dateSchema = z.date().or(z.string().transform((str) => new Date(str)))
export const nullableDateSchema = dateSchema.nullable()

export type DateSchema = z.infer<typeof dateSchema>
export type NullableDateSchema = z.infer<typeof nullableDateSchema>
