import { and, eq, sql, desc, asc } from "drizzle-orm"
import { db } from "../index"
import { activities, activityTypes, projects, users } from "../schema"
import type { ActivityFilter, ActivityCreateInput, ActivityUpdateInput } from "@beg/validations"

// Helper function to update project dates and duration
export async function updateProjectActivityDates(projectId: number) {
    // Get the earliest and latest activity dates, and sum of durations for this project
    const result = await db
        .select({
            firstDate: sql<number>`MIN(${activities.date})`,
            lastDate: sql<number>`MAX(${activities.date})`,
            totalDuration: sql<number>`COALESCE(SUM(${activities.duration}), 0)`,
        })
        .from(activities)
        .where(eq(activities.projectId, projectId))

    const { firstDate, lastDate, totalDuration } = result[0]

    const resultUnbilled = await db
        .select({
            unbilledDuration: sql<number>`COALESCE(SUM(${activities.duration}), 0)`,
        })
        .from(activities)
        .where(and(eq(activities.billed, false), eq(activities.projectId, projectId)))

    const { unbilledDuration } = resultUnbilled[0]

    const resultUnbilledDisbursement = await db
        .select({
            unbilledDisbursementDuration: sql<number>`COALESCE(SUM(${activities.duration}), 0)`,
        })
        .from(activities)
        .where(and(eq(activities.disbursement, true), eq(activities.projectId, projectId)))

    const { unbilledDisbursementDuration } = resultUnbilledDisbursement[0]

    // Update the project with the calculated values
    await db
        .update(projects)
        .set({
            firstActivityDate: firstDate ? new Date(firstDate * 1000) : null,
            lastActivityDate: lastDate ? new Date(lastDate * 1000) : null,
            totalDuration: Math.round(totalDuration || 0),
            unBilledDuration: Math.round(unbilledDuration || 0),
            unBilledDisbursementDuration: Math.round(unbilledDisbursementDuration || 0),
            updatedAt: new Date(),
        })
        .where(eq(projects.id, projectId))
}

export const activityRepository = {
    findAll: async (filter: ActivityFilter) => {
        const { page = 1, limit = 10, userId, projectId, startDate, endDate } = filter
        const offset = (page - 1) * limit

        // Build where conditions
        const whereConditions = []
        if (userId) whereConditions.push(eq(activities.userId, userId))
        if (projectId) whereConditions.push(eq(activities.projectId, projectId))
        if (startDate) whereConditions.push(sql`${activities.date} >= ${startDate}`)
        if (endDate) whereConditions.push(sql`${activities.date} <= ${endDate}`)

        // Query with conditions
        const query = db
            .select({
                id: activities.id,
                date: activities.date,
                duration: activities.duration,
                kilometers: activities.kilometers,
                expenses: activities.expenses,
                rate: activities.rate,
                description: activities.description,
                billed: activities.billed,
                disbursement: activities.disbursement,
                createdAt: activities.createdAt,
                updatedAt: activities.updatedAt,
                user: {
                    id: users.id,
                    firstName: users.firstName,
                    lastName: users.lastName,
                    initials: users.initials,
                },
                project: {
                    id: projects.id,
                    name: projects.name,
                    projectNumber: projects.projectNumber,
                },
                activityType: {
                    id: activityTypes.id,
                    name: activityTypes.name,
                    code: activityTypes.code,
                    billable: activityTypes.billable,
                },
            })
            .from(activities)
            .leftJoin(users, eq(activities.userId, users.id))
            .leftJoin(projects, eq(activities.projectId, projects.id))
            .leftJoin(activityTypes, eq(activities.activityTypeId, activityTypes.id))
            .where(whereConditions.length ? and(...whereConditions) : undefined)
            .limit(limit)
            .offset(offset)

        const data = await query

        // Count total
        const countQuery = db
            .select({ count: sql<number>`count(*)` })
            .from(activities)
            .where(whereConditions.length ? and(...whereConditions) : undefined)

        const [{ count }] = await countQuery
        const totalPages = Math.ceil(count / limit)

        return {
            data,
            total: count,
            page,
            limit,
            totalPages,
        }
    },

    findById: async (id: number) => {
        const result = await db
            .select({
                id: activities.id,
                date: activities.date,
                duration: activities.duration,
                kilometers: activities.kilometers,
                expenses: activities.expenses,
                rate: activities.rate,
                description: activities.description,
                billed: activities.billed,
                disbursement: activities.disbursement,
                createdAt: activities.createdAt,
                updatedAt: activities.updatedAt,
                user: {
                    id: users.id,
                    firstName: users.firstName,
                    lastName: users.lastName,
                    initials: users.initials,
                },
                project: {
                    id: projects.id,
                    name: projects.name,
                    projectNumber: projects.projectNumber,
                },
                activityType: {
                    id: activityTypes.id,
                    name: activityTypes.name,
                    code: activityTypes.code,
                    billable: activityTypes.billable,
                },
            })
            .from(activities)
            .leftJoin(users, eq(activities.userId, users.id))
            .leftJoin(projects, eq(activities.projectId, projects.id))
            .leftJoin(activityTypes, eq(activities.activityTypeId, activityTypes.id))
            .where(eq(activities.id, id))

        return result[0] || null
    },

    create: async (data: typeof activities.$inferInsert) => {
        const [newActivity] = await db.insert(activities).values(data).returning()

        // Update project dates after creating activity
        await updateProjectActivityDates(data.projectId)

        // Return the created activity with relations
        return activityRepository.findById(newActivity.id)
    },

    update: async (id: number, data: ActivityUpdateInput) => {
        // Get the old project ID before updating
        const [oldActivity] = await db
            .select({ projectId: activities.projectId })
            .from(activities)
            .where(eq(activities.id, id))

        if (!oldActivity) {
            return null
        }

        const [updatedActivity] = await db
            .update(activities)
            .set({
                ...data,
                updatedAt: new Date(),
            })
            .where(eq(activities.id, id))
            .returning()

        if (updatedActivity) {
            // Update project dates after updating activity
            await updateProjectActivityDates(updatedActivity.projectId)

            // If the project was changed, update the old project too
            if (data.projectId && data.projectId !== oldActivity.projectId) {
                await updateProjectActivityDates(oldActivity.projectId)
            }
        }

        return activityRepository.findById(id)
    },

    delete: async (id: number) => {
        // Get the activity to know which project to update
        const [activityToDelete] = await db
            .select({ projectId: activities.projectId })
            .from(activities)
            .where(eq(activities.id, id))

        if (!activityToDelete) {
            return false
        }

        // Delete the activity
        await db.delete(activities).where(eq(activities.id, id))

        // Update project dates after deleting activity
        await updateProjectActivityDates(activityToDelete.projectId)

        return true
    },
}
