import { z } from "zod"
import { paginationSchema } from "./pagination"

// Base user group schema
export const userGroupSchema = z.object({
    id: z.number(),
    name: z.string(),
})

// Create schema
export const userGroupCreateSchema = z.object({
    name: z.string().min(1, "Name is required"),
})

// Update schema
export const userGroupUpdateSchema = z.object({
    name: z.string().min(1).optional(),
})

// Filter schema with pagination
export const userGroupFilterSchema = z
    .object({
        name: z.string().optional(),
        sortBy: z.string().optional(),
        sortOrder: z.enum(["asc", "desc"]).optional(),
    })
    .merge(paginationSchema)

// Response schemas
export const userGroupResponseSchema = userGroupSchema

// TypeScript types
export type UserGroup = z.infer<typeof userGroupSchema>
export type UserGroupCreateInput = z.infer<typeof userGroupCreateSchema>
export type UserGroupUpdateInput = z.infer<typeof userGroupUpdateSchema>
export type UserGroupResponse = z.infer<typeof userGroupResponseSchema>
export type UserGroupFilter = z.infer<typeof userGroupFilterSchema>
export type UserGroupFilterInput = z.input<typeof userGroupFilterSchema>
