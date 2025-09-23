import { z } from "zod"
import { paginationSchema } from "./pagination"
import { timestampsSchema } from "./base"

// Base monthly hours schema
export const monthlyHoursSchema = z
    .object({
        id: z.number(),
        year: z.number().min(2000).max(2100),
        month: z.number().min(1).max(12),
        amountOfHours: z.number().positive(),
    })
    .merge(timestampsSchema)

// Create schema (without id and timestamps)
export const monthlyHoursCreateSchema = z.object({
    year: z.number().min(2000, "Year must be 2000 or later").max(2100, "Year must be before 2100"),
    month: z
        .number()
        .min(1, "Month must be between 1 and 12")
        .max(12, "Month must be between 1 and 12"),
    amountOfHours: z.number().positive("Hours must be positive"),
})

// Update schema (partial of create)
export const monthlyHoursUpdateSchema = monthlyHoursCreateSchema.partial()

// Create a schema for monthly hours filtering with pagination
export const monthlyHoursFilterSchema = z
    .object({
        year: z.coerce.number().optional(),
        month: z.coerce.number().min(1).max(12).optional(),
        sortBy: z.enum(["year", "month", "amountOfHours", "createdAt"]).optional(),
        sortOrder: z.enum(["asc", "desc"]).optional(),
    })
    .merge(paginationSchema)

// Response schemas
export const monthlyHoursResponseSchema = monthlyHoursSchema

// TypeScript types
export type MonthlyHours = z.infer<typeof monthlyHoursSchema>
export type MonthlyHoursCreateInput = z.infer<typeof monthlyHoursCreateSchema>
export type MonthlyHoursUpdateInput = z.infer<typeof monthlyHoursUpdateSchema>
export type MonthlyHoursResponse = z.infer<typeof monthlyHoursResponseSchema>
export type MonthlyHoursFilter = z.infer<typeof monthlyHoursFilterSchema>
export type MonthlyHoursFilterInput = z.input<typeof monthlyHoursFilterSchema>
