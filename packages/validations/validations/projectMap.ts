import { z } from "zod"
import { dateSchema } from "./base"

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
