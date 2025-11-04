import { z } from "zod"
import { timestampsSchema } from "./base"

// Role enum for project users
export const projectUserRoleSchema = z.enum(["manager", "member"])

export type ProjectUserRole = z.infer<typeof projectUserRoleSchema>
