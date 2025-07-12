import { z } from "zod"

// Create a schema for client filtering with pagination
export const activityRateUserSchema = z.object({
    activityId: z.coerce.number(),
    class: z.string(),
})

export type ActivityRateUser = z.infer<typeof activityRateUserSchema>
export type ActivityRateUserInput = z.input<typeof activityRateUserSchema>
