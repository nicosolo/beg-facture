import { ref } from "vue"
import { useActivityAPI } from "./useFetchActivity"
import type { ActivityResponse } from "@beg/validations"

interface UnbilledActivitiesParams {
    projectId: number
    periodStart?: Date
    periodEnd?: Date
}

interface RateItem {
    rateClass: string
    base: number
    adjusted: number
    hourlyRate: number
    amount: number
}

interface UnbilledActivitiesResponse {
    activities: ActivityResponse[]
    rates: RateItem[]
    totalKilometers: number
    totalExpenses: number
    totalDisbursements: number
    activityIds: number[]
}

export function useFetchUnbilledActivities() {
    const loading = ref(false)
    const error = ref<Error | null>(null)
    const data = ref<UnbilledActivitiesResponse | null>(null)
    const { get } = useActivityAPI()
    const fetch = async (params: UnbilledActivitiesParams) => {
        loading.value = true
        error.value = null

        try {
            // Use the existing activity API composable

            // Build query params for activity endpoint
            const queryParams = {
                projectId: params.projectId,
                includeUnbilled: true,
                limit: 10000, // Large limit to get all activities
                sortBy: "date" as const,
                sortOrder: "asc" as const,
                fromDate: params.periodStart,
                toDate: params.periodEnd,
            }

            // Fetch activities using existing composable
            const response = await get({ query: queryParams })

            // Process activities on client side
            const activities = response.data || []

            // Calculate totals by rate class
            const rateClassTotals = new Map<string, RateItem>()
            let totalKilometers = 0
            let totalExpenses = 0
            let totalDisbursements = 0

            for (const activity of activities) {
                // Skip billed activities
                if (activity.billed) continue

                // Get rate class from user rate (assuming it's stored as a number 0=A, 1=B, etc.)
                const rateClass = String.fromCharCode(65 + (activity.rate || 0))

                if (!rateClassTotals.has(rateClass)) {
                    rateClassTotals.set(rateClass, {
                        rateClass,
                        base: 0,
                        adjusted: 0,
                        hourlyRate: 0,
                        amount: 0,
                    })
                }

                const classTotals = rateClassTotals.get(rateClass)!

                // Add duration to the rate class (duration is in minutes)
                if (activity.activityType?.billable && !activity.disbursement) {
                    classTotals.base += activity.duration
                    classTotals.adjusted += activity.duration
                }

                // Sum up kilometers and expenses
                totalKilometers += activity.kilometers || 0
                totalExpenses += activity.expenses || 0

                if (activity.disbursement) {
                    totalDisbursements += activity.expenses || 0
                }
            }

            // Convert rate class totals to array
            const rates = Array.from(rateClassTotals.values())

            // Get activity IDs for marking as billed later
            const activityIds = activities
                .filter((a: ActivityResponse) => !a.billed)
                .map((a: ActivityResponse) => a.id)

            data.value = {
                activities: activities.filter((a: ActivityResponse) => !a.billed),
                rates,
                totalKilometers,
                totalExpenses,
                totalDisbursements,
                activityIds,
            }

            return data.value
        } catch (err) {
            error.value = err instanceof Error ? err : new Error(String(err))
            throw err
        } finally {
            loading.value = false
        }
    }

    return {
        fetch,
        loading,
        error,
        data,
    }
}
