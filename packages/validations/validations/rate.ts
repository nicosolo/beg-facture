import { classSchema } from "./base"
import { z } from "zod"

// Rate Class schema
export const rateClassFilterSchema = z.object({
    year: z.coerce.number().optional(),
})
// Rate Class schema
export const rateClassSchema = z.object({
    id: z.number(),
    class: classSchema,
    year: z.number(),
    amount: z.number(),
})

// Rate Class creation schema
export const rateClassCreateSchema = z.object({
    class: classSchema,
    year: z.number().min(1990).max(2100),
    amount: z.coerce.number().min(0),
})

// Rate Class update schema
export const rateClassUpdateSchema = z.object({
    class: classSchema.optional(),
    year: z.number().min(1990).max(2100).optional(),
    amount: z.coerce.number().min(0).optional(),
})

// Array response for getting all rate classes
export const rateClassesArraySchema = z.array(rateClassSchema)

export type RateClassSchema = z.infer<typeof rateClassSchema>
export type RateClassCreateInput = z.infer<typeof rateClassCreateSchema>
export type RateClassUpdateInput = z.infer<typeof rateClassUpdateSchema>
