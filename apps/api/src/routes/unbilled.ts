import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { z } from "zod"
import {
    UnbilledActivitiesResponseSchema,
    type UnbilledActivitiesResponse,
    type RateItem,
} from "@beg/validations"
import { activityRepository } from "../db/repositories/activity.repository"
import { projectRepository } from "../db/repositories/project.repository"
import { rateRepository } from "../db/repositories/rate.repository"
import { authMiddleware } from "../tools/auth-middleware"
import { responseValidator } from "../tools/response-validator"
import type { Variables } from "../types/global"
import { userRepository } from "@src/db/repositories/user.repository"

const app = new Hono<{ Variables: Variables }>()

// Get unbilled activities with calculations for a project
app.get(
    "/project/:projectId",
    authMiddleware,
    zValidator(
        "param",
        z.object({
            projectId: z.string().transform((val) => parseInt(val, 10)),
        })
    ),

    responseValidator({ 200: UnbilledActivitiesResponseSchema }),
    async (c) => {
        const { projectId } = c.req.valid("param")
        const user = c.get("user")

        // Parse dates if provided

        // Get project to verify access and get start date
        const project = await projectRepository.findById(projectId, user)
        if (!project) {
            return c.json({ error: "Project not found" }, 404)
        }

        const activities = await activityRepository.findAll(user, {
            projectId,
            sortBy: "date",
            sortOrder: "asc",
            page: 1,
            limit: 10000,
            includeBilled: false,
            includeDisbursement: false,
            includeUnbilled: true,
        })

        // Filter to only unbilled activities
        const unbilledActivities = activities.data.filter((a) => !a.billed)
        const allUsers = await userRepository.findAllDetails()
        const userMap = new Map<number, (typeof allUsers)[0]>(allUsers.map((u) => [u.id, u]))
        // Calculate totals by rate class
        const rateClassTotals = new Map<string, RateItem>()
        let totalKilometers = 0
        let totalExpenses = 0
        let totalDisbursements = 0

        const allYears = [
            ...new Set<number>(unbilledActivities.map((a) => new Date(a.date).getFullYear())),
        ]
        const rateClasses = await rateRepository.findByYears(allYears)
        const rateClassesMaps = new Map<string, number>()
        for (const rate of rateClasses) {
            rateClassesMaps.set(`${rate.class}-${rate.year}`, rate.amount)
        }

        // Process activities
        for (const activity of unbilledActivities) {
            // Get user's rate class for this activity type
            let rateClass = "" // Default
            let hourlyRate = 0
            const activitiesRates = activity.user?.id
                ? userMap.get(activity.user?.id)?.activityRates
                : null
            if (activitiesRates) {
                const userClass = activitiesRates.find(
                    (rate) => rate.activityId === activity.activityType?.id
                )
                if (userClass) {
                    rateClass = userClass.class
                    const year = new Date(activity.date).getFullYear()
                    hourlyRate = rateClassesMaps.get(`${rateClass}-${year}`) || 0
                }
            }

            // Initialize rate class totals if not exists
            if (!rateClassTotals.has(rateClass)) {
                rateClassTotals.set(rateClass, {
                    rateClass,
                    base: 0,
                    adjusted: 0,
                    hourlyRate,
                    amount: 0,
                })
            }

            const classTotals = rateClassTotals.get(rateClass)!

            // Add duration to the rate class (duration is in minutes)
            if (activity.activityType?.billable && !activity.disbursement) {
                classTotals.base += activity.duration
                classTotals.adjusted += activity.duration
                classTotals.hourlyRate = hourlyRate // Update rate
            }

            // Sum up kilometers and expenses
            totalKilometers += activity.kilometers || 0
            totalExpenses += activity.expenses || 0

            if (activity.disbursement) {
                totalDisbursements += activity.expenses || 0
            }
        }

        // Calculate amounts for each rate class
        const rates = Array.from(rateClassTotals.values())
        rates.forEach((rate) => {
            rate.amount = rate.adjusted * rate.hourlyRate
        })

        // Calculate invoice totals
        const feesBase = rates.reduce((sum, rate) => sum + rate.base, 0)
        const feesAdjusted = rates.reduce((sum, rate) => sum + rate.adjusted, 0)
        const feesTotal = rates.reduce((sum, rate) => sum + rate.amount, 0)
        const feesFinalTotal = feesTotal // Can be adjusted with multiplication factor

        const expensesTravelRate = 0.65 // Default travel rate
        const expensesTravelAmount = totalKilometers * expensesTravelRate
        const expensesOtherAmount = totalExpenses
        const expensesThirdPartyAmount = totalDisbursements
        const expensesTotal = expensesTravelAmount + expensesOtherAmount
        const expensesTotalExpenses = expensesTotal + expensesThirdPartyAmount

        const totalHT = feesFinalTotal + expensesTotalExpenses
        const vatRate = 8.0 // Default VAT rate
        const vatAmount = totalHT * (vatRate / 100)
        const totalTTC = totalHT + vatAmount

        // Calculate period from activities
        let periodStartDate: Date | null = null
        let periodEndDate: Date | null = null

        if (unbilledActivities.length > 0) {
            const dates = unbilledActivities.map((a) => new Date(a.date).getTime())
            periodStartDate = new Date(Math.min(...dates))
            periodEndDate = new Date(Math.max(...dates))
        }

        // Get activity IDs for marking as billed later
        const activityIds = unbilledActivities.map((a) => a.id)

        const response: UnbilledActivitiesResponse = {
            activities: unbilledActivities,
            rates,
            totalKilometers,
            totalExpenses,
            totalDisbursements,
            activityIds,
            // Pre-calculated invoice totals
            feesBase,
            feesAdjusted,
            feesTotal,
            feesFinalTotal,
            expensesTravelAmount,
            expensesOtherAmount,
            expensesThirdPartyAmount,
            expensesTotal,
            expensesTotalExpenses,
            totalHT,
            vatRate,
            vatAmount,
            totalTTC,
            periodStart: periodStartDate,
            periodEnd: periodEndDate,
        }

        return c.json(response)
    }
)

export default app
