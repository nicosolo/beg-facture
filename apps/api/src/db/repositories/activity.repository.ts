import { and, eq, sql, desc, asc, gte, lte, or } from "drizzle-orm"
import { db } from "../index"
import { activities, activityTypes, projects, users, projectUsers } from "../schema"
import type { ActivityFilter } from "@beg/validations"
import type { Variables } from "@src/types/global"
import { hasRole } from "@src/tools/role-middleware"

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
        .innerJoin(activityTypes, eq(activities.activityTypeId, activityTypes.id))
        .where(
            and(
                eq(activities.billed, false),
                eq(activities.projectId, projectId),
                eq(activityTypes.billable, true)
            )
        )

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
            totalDuration: totalDuration || 0,
            unBilledDuration: unbilledDuration || 0,
            unBilledDisbursementDuration: unbilledDisbursementDuration || 0,
            updatedAt: new Date(),
        })
        .where(eq(projects.id, projectId))
}

const selectFields = (user: Variables["user"]) => ({
    id: activities.id,
    date: activities.date,
    duration: activities.duration,
    kilometers: activities.kilometers,
    expenses: activities.expenses,
    rate: activities.rate,
    rateClass: activities.rateClass,
    description: activities.description,
    billed: activities.billed,
    ...(hasRole(user.role, "admin") ? { disbursement: activities.disbursement } : {}),
    createdAt: activities.createdAt,
    updatedAt: activities.updatedAt,
    invoiceId: activities.invoiceId,
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

const createBaseQuery = (user: Variables["user"]) =>
    db
        .select(selectFields(user))
        .from(activities)
        .leftJoin(users, eq(activities.userId, users.id))
        .leftJoin(projects, eq(activities.projectId, projects.id))
        .leftJoin(activityTypes, eq(activities.activityTypeId, activityTypes.id))

const buildFilterComponents = (filter: ActivityFilter) => {
    const {
        userId,
        projectId,
        fromDate,
        toDate,
        sortBy = "date",
        sortOrder = "asc",
        includeBilled = false,
        includeDisbursement = false,
        includeUnbilled = false,
        activityTypeId,
        invoiceId,
    } = filter

    const whereConditions: any[] = []
    if (userId) whereConditions.push(eq(activities.userId, userId))
    if (projectId) whereConditions.push(eq(activities.projectId, projectId))
    if (fromDate) whereConditions.push(gte(activities.date, fromDate))
    if (toDate) whereConditions.push(lte(activities.date, toDate))
    if (activityTypeId) whereConditions.push(eq(activities.activityTypeId, activityTypeId))

    const billingConditions = []
    if (includeBilled) billingConditions.push(eq(activities.billed, true))
    if (includeUnbilled) billingConditions.push(eq(activities.billed, false))
    if (includeDisbursement) billingConditions.push(eq(activities.disbursement, true))

    if (billingConditions.length > 0) {
        whereConditions.push(or(...billingConditions))
    }

    if (invoiceId) {
        whereConditions.splice(0, whereConditions.length, eq(activities.invoiceId, invoiceId))
    }

    const sortColumn = (() => {
        switch (sortBy) {
            case "date":
                return activities.date
            case "duration":
                return activities.duration
            case "kilometers":
                return activities.kilometers
            case "expenses":
                return activities.expenses
            case "rate":
                return activities.rate
            default:
                return activities.date
        }
    })()

    const sortDirection = sortOrder === "desc" ? desc(sortColumn) : asc(sortColumn)
    const secondarySort = sortOrder === "desc" ? desc(activities.id) : asc(activities.id)

    return {
        whereConditions,
        sortDirection,
        secondarySort,
    }
}

export const activityRepository = {
    findAll: async (user: Variables["user"], filter: ActivityFilter) => {
        const { page = 1, limit = 10 } = filter
        const offset = (page - 1) * limit
        const { whereConditions, sortDirection, secondarySort } = buildFilterComponents(filter)

        // Query with conditions
        const baseQuery = createBaseQuery(user)

        // Disable access control for now
        // if (user.role !== "admin") {
        //     baseQuery.innerJoin(
        //         projectUsers,
        //         and(eq(projects.id, projectUsers.projectId), eq(projectUsers.userId, user.id))
        //     )
        // }
        const dataQuery =
            whereConditions.length > 0
                ? baseQuery
                      .where(and(...whereConditions))
                      .orderBy(sortDirection, secondarySort)
                      .limit(limit)
                      .offset(offset)
                : baseQuery.orderBy(sortDirection, secondarySort).limit(limit).offset(offset)

        const data = await dataQuery

        // Count total with same filters and access control
        const countQuery = db
            .select({ count: sql<number>`count(*)` })
            .from(activities)
            .leftJoin(projects, eq(activities.projectId, projects.id))

        // Disable access control for now
        // if (user.role !== "admin") {
        //     countQuery.innerJoin(
        //         projectUsers,
        //         and(eq(projects.id, projectUsers.projectId), eq(projectUsers.userId, user.id))
        //     )
        // }

        const [{ count }] = await (whereConditions.length > 0
            ? countQuery.where(and(...whereConditions))
            : countQuery)
        const totalPages = Math.ceil(count / limit)

        // Calculate totals for all filtered activities (without pagination)
        const totalsQuery = db
            .select({
                totalDuration: sql<number>`COALESCE(SUM(${activities.duration}), 0)`,
                totalKilometers: sql<number>`COALESCE(SUM(${activities.kilometers}), 0)`,
                totalExpenses: sql<number>`COALESCE(SUM(${activities.expenses}), 0)`,
            })
            .from(activities)
            .leftJoin(projects, eq(activities.projectId, projects.id))

        // Disable access control for now
        // if (user.role !== "admin") {
        //     totalsQuery.innerJoin(
        //         projectUsers,
        //         and(eq(projects.id, projectUsers.projectId), eq(projectUsers.userId, user.id))
        //     )
        // }

        const [totalsResult] = await (whereConditions.length > 0
            ? totalsQuery.where(and(...whereConditions))
            : totalsQuery)

        const totals = {
            duration: Number(totalsResult.totalDuration),
            kilometers: Number(totalsResult.totalKilometers),
            expenses: Number(totalsResult.totalExpenses),
        }

        return {
            data,
            total: count,
            page,
            limit,
            totalPages,
            totals,
        }
    },

    findAllForExport: async (user: Variables["user"], filter: ActivityFilter) => {
        const { whereConditions, sortDirection, secondarySort } = buildFilterComponents(filter)
        const baseQuery = createBaseQuery(user)

        const dataQuery =
            whereConditions.length > 0
                ? baseQuery.where(and(...whereConditions)).orderBy(sortDirection, secondarySort)
                : baseQuery.orderBy(sortDirection, secondarySort)

        return await dataQuery
    },

    findById: async (id: number, user: Variables["user"]) => {
        const query = db
            .select({
                id: activities.id,
                date: activities.date,
                duration: activities.duration,
                kilometers: activities.kilometers,
                expenses: activities.expenses,
                rate: activities.rate,
                rateClass: activities.rateClass,
                description: activities.description,
                billed: activities.billed,
                ...(hasRole(user.role, "admin") ? { disbursement: activities.disbursement } : {}),
                createdAt: activities.createdAt,
                updatedAt: activities.updatedAt,
                invoiceId: activities.invoiceId,
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

        // Disable access control for now
        // if (user.role !== "admin") {
        //     query.innerJoin(
        //         projectUsers,
        //         and(eq(projects.id, projectUsers.projectId), eq(projectUsers.userId, user.id))
        //     )
        // }

        const result = await query.where(eq(activities.id, id))

        return result[0] || null
    },

    create: async (data: typeof activities.$inferInsert) => {
        const [newActivity] = await db.insert(activities).values(data).returning()

        // Update project dates after creating activity
        await updateProjectActivityDates(data.projectId)

        // Return the created activity with relations
        // Note: For create, we assume the user has access since they're creating it
        // The access check will be enforced when reading
        return activityRepository.findById(newActivity.id, {
            id: 0,
            role: "admin",
        } as Variables["user"])
    },

    update: async (id: number, data: Partial<typeof activities.$inferInsert>) => {
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

        // For update, use admin access to bypass filtering since we already checked access
        return activityRepository.findById(id, { id: 0, role: "admin" } as Variables["user"])
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

    bulkUpdate: async (ids: number[], updates: { billed?: boolean; disbursement?: boolean }) => {
        if (ids.length === 0) {
            return 0
        }

        // Perform the bulk update
        await db
            .update(activities)
            .set({
                ...updates,
                updatedAt: new Date(),
            })
            .where(
                sql`${activities.id} IN (${sql.join(
                    ids.map((id) => sql`${id}`),
                    sql`, `
                )})`
            )

        // Get all affected project IDs
        const affectedProjects = await db
            .select({ projectId: activities.projectId })
            .from(activities)
            .where(
                sql`${activities.id} IN (${sql.join(
                    ids.map((id) => sql`${id}`),
                    sql`, `
                )})`
            )
            .groupBy(activities.projectId)

        // Update project dates for all affected projects
        for (const project of affectedProjects) {
            await updateProjectActivityDates(project.projectId)
        }

        return ids.length
    },
}
