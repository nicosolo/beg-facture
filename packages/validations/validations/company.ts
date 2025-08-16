import { z } from "zod"
import { paginationSchema } from "./pagination"
import { timestampsSchema } from "./base"

// Base company schema
export const companySchema = z
    .object({
        id: z.number(),
        name: z.string(),
    })
    .merge(timestampsSchema)

// Create schema (without id and timestamps)
export const companyCreateSchema = z.object({
    name: z.string().min(1, "Name is required"),
})

// Update schema (partial of create)
export const companyUpdateSchema = companyCreateSchema.partial()

// Create a schema for company filtering with pagination
export const companyFilterSchema = z
    .object({
        name: z.string().optional(),
        sortBy: z.enum(["name", "createdAt"]).optional(),
        sortOrder: z.enum(["asc", "desc"]).optional(),
    })
    .merge(paginationSchema)

// Response schemas
export const companyResponseSchema = companySchema

// TypeScript types
export type Company = z.infer<typeof companySchema>
export type CompanyCreateInput = z.infer<typeof companyCreateSchema>
export type CompanyUpdateInput = z.infer<typeof companyUpdateSchema>
export type CompanyResponse = z.infer<typeof companyResponseSchema>
export type CompanyFilter = z.infer<typeof companyFilterSchema>
export type CompanyFilterInput = z.input<typeof companyFilterSchema>
