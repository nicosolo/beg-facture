import { z } from "zod"
import { paginationSchema } from "./pagination"
import { timestampsSchema } from "./base"

// Base client schema
export const clientSchema = z
    .object({
        id: z.number(),
        name: z.string(),
    })
    .merge(timestampsSchema)

// Create schema (without id and timestamps)
export const clientCreateSchema = z.object({
    name: z.string().min(1, "Name is required"),
})

// Update schema (partial of create)
export const clientUpdateSchema = clientCreateSchema.partial()

// Create a schema for client filtering with pagination
export const clientFilterSchema = z
    .object({
        name: z.string().optional(),
        sortBy: z.string().optional(),
        sortOrder: z.enum(["asc", "desc"]).optional(),
    })
    .merge(paginationSchema)

// Response schemas
export const clientResponseSchema = clientSchema

// TypeScript types
export type Client = z.infer<typeof clientSchema>
export type ClientCreateInput = z.infer<typeof clientCreateSchema>
export type ClientUpdateInput = z.infer<typeof clientUpdateSchema>
export type ClientResponse = z.infer<typeof clientResponseSchema>
export type ClientFilter = z.infer<typeof clientFilterSchema>
export type ClientFilterInput = z.input<typeof clientFilterSchema>
