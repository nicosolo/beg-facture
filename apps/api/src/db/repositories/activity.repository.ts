import { and, eq, sql } from "drizzle-orm"
import { db } from "../index"
import { activities, activityTypes, projects, users } from "../schema"
import type { ActivityFilter } from "@beg/validations"

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
}
