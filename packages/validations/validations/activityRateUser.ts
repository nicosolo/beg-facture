import { z } from "zod"
import { classSchema } from "./base"

// Create a schema for client filtering with pagination
export const activityRateUserSchema = z.object({
    activityId: z.coerce.number(),
    class: classSchema,
})

export type ActivityRateUser = z.infer<typeof activityRateUserSchema>
export type ActivityRateUserInput = z.input<typeof activityRateUserSchema>
