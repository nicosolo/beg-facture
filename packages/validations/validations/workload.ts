import { z } from "zod"

// Base workload schema
export const workloadSchema = z.object({
    id: z.number(),
    userId: z.number(),
    year: z.number().min(1900).max(2100),
    month: z.number().min(1).max(12),
    workload: z.number().min(0).max(100),
    createdAt: z.date(),
    updatedAt: z.date(),
})

// Create workload schema
export const workloadCreateSchema = z.object({
    userId: z.number(),
    year: z.number().min(1900).max(2100),
    month: z.number().min(1).max(12),
    workload: z.number().min(0).max(100),
})

// Update workload schema
export const workloadUpdateSchema = z.object({
    userId: z.number().optional(),
    year: z.number().min(1900).max(2100).optional(),
    month: z.number().min(1).max(12).optional(),
    workload: z.number().min(0).max(100).optional(),
})

// Filter schema
export const workloadFilterSchema = z.object({
    userId: z.coerce.number().optional(),
    year: z.coerce.number().optional(),
    month: z.coerce.number().optional(),
})

// Response schemas
export const workloadResponseSchema = workloadSchema
export const workloadArrayResponseSchema = z.array(workloadSchema)

// Types
export type Workload = z.infer<typeof workloadSchema>
export type WorkloadCreate = z.infer<typeof workloadCreateSchema>
export type WorkloadUpdate = z.infer<typeof workloadUpdateSchema>
export type WorkloadFilter = z.infer<typeof workloadFilterSchema>
export type WorkloadResponse = Workload
export type WorkloadArrayResponse = Workload[]
