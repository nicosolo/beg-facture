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
            .optional()
            .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
        endDate: z
            .string()
            .optional()
            .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
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
        startDate:
            filter.startDate instanceof Date ? filter.startDate.toISOString() : filter.startDate,
        endDate: filter.endDate instanceof Date ? filter.endDate.toISOString() : filter.endDate,
        validationStatus: filter.validationStatus,
        isTemplate: filter.isTemplate?.toString(),
        page: filter.page?.toString(),
        limit: filter.limit?.toString(),
    }
}
