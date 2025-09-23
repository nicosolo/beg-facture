import { z } from "zod"
import { activityResponseSchema } from "./activity"
import { RateItemSchema } from "./invoice"
import { dateSchema } from "./base"
import { vatRateSchema } from "./vatRate"

// Response schema for unbilled activities
export const UnbilledActivitiesResponseSchema = z.object({
    activities: z.array(activityResponseSchema),
    rates: z.array(RateItemSchema),
    totalKilometers: z.number(),
    expensesTravelRate: z.number(),
    totalExpenses: z.number(),
    totalDisbursements: z.number(),
    activityIds: z.array(z.number()),
    periodStart: z.date().nullable(),
    periodEnd: z.date().nullable(),
})

// Schema for unbilled activities query parameters
export const unbilledQuerySchema = z.object({
    periodStart: dateSchema.optional(),
    periodEnd: dateSchema.optional(),
})

// Schema for unbilled activities params
export const unbilledParamsSchema = z.object({
    projectId: z.number(),
})

export type UnbilledActivitiesRequest = z.infer<typeof unbilledQuerySchema>
export type RateItem = z.infer<typeof RateItemSchema>
export type UnbilledActivitiesResponse = z.infer<typeof UnbilledActivitiesResponseSchema>
