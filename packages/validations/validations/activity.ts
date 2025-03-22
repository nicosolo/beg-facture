import { z } from "zod"
import { paginationSchema } from "./pagination"

// Create a schema that parses query string values
export const activityFilterSchema = z
    .object({
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
            .transform(
                (val) =>
                    val.toString().toLowerCase() === "true" || val.toString().toLowerCase() === "1"
            )
            .optional(),
    })
    .merge(paginationSchema)

export type ActivityFilter = z.infer<typeof activityFilterSchema>
export type ActivityFilterInput = z.input<typeof activityFilterSchema>

export function convertActivityFilterToInput(filter: ActivityFilter): ActivityFilterInput {
    return {
        projectId: filter.projectId?.toString(),
        userId: filter.userId?.toString(),
        taskId: filter.taskId?.toString(),
        startDate: filter.startDate?.toISOString(),
        endDate: filter.endDate?.toISOString(),
        validationStatus: filter.validationStatus,
        isTemplate: filter.isTemplate?.toString(),
        page: filter.page?.toString(),
        limit: filter.limit?.toString(),
    }
}
