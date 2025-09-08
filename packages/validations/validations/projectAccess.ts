import { z } from "zod"
import { timestampsSchema } from "./base"

export const projectAccessLevelSchema = z.enum(["read", "write"])

export type ProjectAccessLevel = z.infer<typeof projectAccessLevelSchema>

export const projectAccessCreateSchema = z.object({
    projectId: z.number().int().positive(),
    userId: z.number().int().positive(),
    accessLevel: projectAccessLevelSchema,
})

export const projectAccessUpdateSchema = z.object({
    accessLevel: projectAccessLevelSchema,
})

export const projectAccessResponseSchema = z
    .object({
        id: z.number(),
        projectId: z.number(),
        userId: z.number(),
        accessLevel: projectAccessLevelSchema,
        user: z
            .object({
                id: z.number(),
                name: z.string(),
                email: z.string(),
                role: z.string(),
            })
            .optional(),
        project: z
            .object({
                id: z.number(),
                name: z.string(),
                projectNumber: z.string(),
            })
            .optional(),
    })
    .merge(timestampsSchema)

export const projectAccessListResponseSchema = z.array(projectAccessResponseSchema)

export type ProjectAccessCreate = z.infer<typeof projectAccessCreateSchema>
export type ProjectAccessUpdate = z.infer<typeof projectAccessUpdateSchema>
export type ProjectAccessResponse = z.infer<typeof projectAccessResponseSchema>
export type ProjectAccessListResponse = z.infer<typeof projectAccessListResponseSchema>