import { z } from "zod"

// Create a schema that parses query string values
export const userFilterSchema = z.object({
    active: z
        .string()
        .transform(
            (val) => val.toString().toLowerCase() === "true" || val.toString().toLowerCase() === "1"
        )
        .optional(),
})

export type UserFilter = z.infer<typeof userFilterSchema>
export type UserFilterInput = z.input<typeof userFilterSchema>

export function convertUserFilterToInput(filter: UserFilter): UserFilterInput {
    return {
        active: filter.active?.toString(),
    }
}
