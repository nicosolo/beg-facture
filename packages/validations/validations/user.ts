import { z } from "zod"
import { timestampsSchema } from "./base"
import { activityRateUserSchema } from "./activityRateUser"
import { booleanSchema } from "./base"
// Create a schema that parses query string values
export const userFilterSchema = z.object({
    active: booleanSchema.optional(),
})

export const userRoleSchema = z.enum(["admin", "user"])

// Login schema for authentication
export const loginSchema = z.object({
    email: z.string().min(2),
    password: z.string().min(2),
})

// User creation schema
export const userCreateSchema = z.object({
    email: z.string().email(),
    firstName: z.string().min(1),
    lastName: z.string().min(1),
    initials: z.string().min(1),
    password: z.string().min(6),
    role: z.enum(["admin", "user"]).default("user"),
    archived: z.boolean().default(false),
    activityRates: z.array(activityRateUserSchema).optional(),
})

// User update schema (makes most fields optional except id)
export const userUpdateSchema = z.object({
    email: z.string().email().optional(),
    firstName: z.string().min(1).optional(),
    lastName: z.string().min(1).optional(),
    initials: z.string().min(1).optional(),
    password: z.string().min(6).optional().nullable(),
    role: z.enum(["admin", "user"]).optional(),
    archived: z.boolean().optional(),
    activityRates: z.array(activityRateUserSchema).optional(),
})

export type LoginInput = z.infer<typeof loginSchema>
export type UserFilter = z.infer<typeof userFilterSchema>
export type UserFilterInput = z.input<typeof userFilterSchema>
export type UserCreateInput = z.infer<typeof userCreateSchema>
export type UserUpdateInput = z.infer<typeof userUpdateSchema>

export function convertUserFilterToInput(filter: UserFilter): UserFilterInput {
    return {
        active: filter.active,
    }
}

export const userResponseSchema = z
    .object({
        id: z.coerce.number(),
        email: z.string().email(),
        firstName: z.string(),
        lastName: z.string(),
        initials: z.string(),
        role: z.enum(["admin", "user"]),
        archived: z.boolean(),
    })
    .merge(timestampsSchema)

// Define login response schema
export const loginResponseSchema = z.object({
    token: z.string(),
    user: userResponseSchema,
})

export const userDetailResponseSchema = z
    .object({
        id: z.coerce.number(),
        email: z.string().email(),
        firstName: z.string(),
        lastName: z.string(),
        initials: z.string(),
        role: z.enum(["admin", "user"]),
        archived: z.boolean(),
        activityRates: z.array(activityRateUserSchema).nullable(),
    })
    .merge(timestampsSchema)

export type UserResponse = z.infer<typeof userResponseSchema>
export type UserDetailResponse = z.infer<typeof userDetailResponseSchema>
export type UserRole = z.infer<typeof userRoleSchema>
