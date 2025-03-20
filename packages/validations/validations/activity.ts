import { z } from "zod"

// Create a schema that parses query string values
export const activityFilterSchema = z.object({
    projectId: z.string().transform((val) => parseInt(val)),
    userId: z
        .string()
        .transform((val) => parseInt(val))
        .optional(),
    taskId: z
        .string()
        .transform((val) => parseInt(val))
        .optional(),

    startDate: z
        .string()
        .transform((val) => new Date(val))
        .optional(),
    endDate: z
        .string()
        .transform((val) => new Date(val))
        .optional(),
    validationStatus: z.string().optional(),
    isTemplate: z
        .string()
        .transform((val) => val.toLowerCase() === "true")
        .optional(),
})

export type ActivityFilter = z.infer<typeof activityFilterSchema>
