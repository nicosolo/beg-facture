import { z } from "zod"
import { nullableDateSchema } from "./base"

// Create a schema that parses query string values
export const userFilterSchema = z.object({
    active: z
        .string()
        .transform(
            (val) => val.toString().toLowerCase() === "true" || val.toString().toLowerCase() === "1"
        )
        .optional(),
})

// Login schema for authentication
export const loginSchema = z.object({
    email: z.string().email(),
    password: z.string().min(3),
})

export type LoginInput = z.infer<typeof loginSchema>
export type UserFilter = z.infer<typeof userFilterSchema>
export type UserFilterInput = z.input<typeof userFilterSchema>

export function convertUserFilterToInput(filter: UserFilter): UserFilterInput {
    return {
        active: filter.active?.toString(),
    }
}

export const userResponseSchema = z.object({
    id: z.number(),
    email: z.string().email(),
    firstName: z.string(),
    lastName: z.string(),
    initials: z.string(),
    role: z.enum(["admin", "user"]),
    archived: z.boolean(),
    createdAt: nullableDateSchema,
    updatedAt: nullableDateSchema,
})

export type UserResponse = z.infer<typeof userResponseSchema>
