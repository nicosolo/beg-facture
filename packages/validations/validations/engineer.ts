import { z } from "zod"
import { paginationSchema } from "./pagination"
import { timestampsSchema } from "./base"

// Base engineer schema
export const engineerSchema = z.object({
    id: z.number(),
    name: z.string(),
}).merge(timestampsSchema)

// Create schema (without id and timestamps)
export const engineerCreateSchema = z.object({
    name: z.string().min(1, "Name is required"),
})

// Update schema (partial of create)
export const engineerUpdateSchema = engineerCreateSchema.partial()

// Create a schema for engineer filtering with pagination
export const engineerFilterSchema = z
    .object({
        name: z.string().optional(),
        sortBy: z.enum(["name", "createdAt"]).optional(),
        sortOrder: z.enum(["asc", "desc"]).optional(),
    })
    .merge(paginationSchema)

// Response schemas
export const engineerResponseSchema = engineerSchema

// TypeScript types
export type Engineer = z.infer<typeof engineerSchema>
export type EngineerCreateInput = z.infer<typeof engineerCreateSchema>
export type EngineerUpdateInput = z.infer<typeof engineerUpdateSchema>
export type EngineerResponse = z.infer<typeof engineerResponseSchema>
export type EngineerFilter = z.infer<typeof engineerFilterSchema>
export type EngineerFilterInput = z.input<typeof engineerFilterSchema>