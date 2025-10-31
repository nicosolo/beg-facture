import { z } from "zod"
import { booleanSchema, dateSchema } from "./base"

// Filter schema for project map (same as projectBaseFilterSchema but separate)
export const projectMapFilterSchema = z.object({
    name: z.string().optional(),
    referentUserId: z.coerce.number().optional(),
    fromDate: z.coerce.date().optional(),
    toDate: z.coerce.date().optional(),
})

export type ProjectMapFilter = z.infer<typeof projectMapFilterSchema>
export type ProjectMapFilterInput = z.input<typeof projectMapFilterSchema>

// Lightweight project map item schema for map markers
export const projectMapItemResponseSchema = z.object({
    id: z.number(),
    projectNumber: z.string(),
    name: z.string(),
    latitude: z.number(),
    longitude: z.number(),
    clientName: z.string().nullable(),
    locationName: z.string().nullable(),
    lastActivityDate: dateSchema.nullable(),
})

// Array response for map endpoint
export const projectMapArrayResponseSchema = z.array(projectMapItemResponseSchema)

// TypeScript types
export type ProjectMapItemResponse = z.infer<typeof projectMapItemResponseSchema>
export type ProjectMapArrayResponse = z.infer<typeof projectMapArrayResponseSchema>
