import { z } from "zod"
import { paginationSchema } from "./pagination"
import { nullableDateSchema } from "./base"

// Create a schema for client filtering with pagination
export const activityRateUserSchema = z.object({
    activityId: z.coerce.number(),
    class: z.string(),
})

export type ActivityRateUserFilter = z.infer<typeof activityRateUserSchema>
export type ActivityRateUserFilterInput = z.input<typeof activityRateUserSchema>
