import { eq, sql, and } from "drizzle-orm"
import { db } from "../index"
import { monthlyHours } from "../schema"
import type { MonthlyHoursFilter, MonthlyHoursCreateInput, MonthlyHoursUpdateInput } from "@beg/validations"

export const monthlyHoursRepository = {
    findAll: async (filter: MonthlyHoursFilter) => {
        const { page = 1, limit = 100, year, month, sortBy = "year", sortOrder = "desc" } = filter
        const offset = (page - 1) * limit

        // Build conditions
        const conditions = []
        if (year) {
            conditions.push(eq(monthlyHours.year, year))
        }
        if (month) {
            conditions.push(eq(monthlyHours.month, month))
        }

        // Query with pagination and filters
        const query = db
            .select({
                id: monthlyHours.id,
                year: monthlyHours.year,
                month: monthlyHours.month,
                amountOfHours: monthlyHours.amountOfHours,
                createdAt: monthlyHours.createdAt,
                updatedAt: monthlyHours.updatedAt,
            })
            .from(monthlyHours)

        if (conditions.length > 0) {
            query.where(and(...conditions))
        }

        // Apply sorting
        if (sortBy === "year") {
            if (sortOrder === "desc") {
                query.orderBy(sql`${monthlyHours.year} DESC, ${monthlyHours.month} DESC`)
            } else {
                query.orderBy(sql`${monthlyHours.year} ASC, ${monthlyHours.month} ASC`)
            }
        } else if (sortBy === "month") {
            query.orderBy(
                sortOrder === "desc" ? sql`${monthlyHours.month} DESC` : monthlyHours.month
            )
        } else if (sortBy === "amountOfHours") {
            query.orderBy(
                sortOrder === "desc" ? sql`${monthlyHours.amountOfHours} DESC` : monthlyHours.amountOfHours
            )
        } else if (sortBy === "createdAt") {
            query.orderBy(
                sortOrder === "desc" ? sql`${monthlyHours.createdAt} DESC` : monthlyHours.createdAt
            )
        }

        const data = await query.limit(limit).offset(offset)

        // Count total with same conditions
        const countQuery = db.select({ count: sql<number>`count(*)` }).from(monthlyHours)
        if (conditions.length > 0) {
            countQuery.where(and(...conditions))
        }
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
        const results = await db
            .select({
                id: monthlyHours.id,
                year: monthlyHours.year,
                month: monthlyHours.month,
                amountOfHours: monthlyHours.amountOfHours,
                createdAt: monthlyHours.createdAt,
                updatedAt: monthlyHours.updatedAt,
            })
            .from(monthlyHours)
            .where(eq(monthlyHours.id, id))
        return results[0] || null
    },

    findByYearMonth: async (year: number, month: number) => {
        const results = await db
            .select({
                id: monthlyHours.id,
                year: monthlyHours.year,
                month: monthlyHours.month,
                amountOfHours: monthlyHours.amountOfHours,
                createdAt: monthlyHours.createdAt,
                updatedAt: monthlyHours.updatedAt,
            })
            .from(monthlyHours)
            .where(and(eq(monthlyHours.year, year), eq(monthlyHours.month, month)))
        return results[0] || null
    },

    create: async (data: MonthlyHoursCreateInput) => {
        const result = await db
            .insert(monthlyHours)
            .values({
                year: data.year,
                month: data.month,
                amountOfHours: data.amountOfHours,
                createdAt: new Date(),
                updatedAt: new Date(),
            })
            .returning({
                id: monthlyHours.id,
                year: monthlyHours.year,
                month: monthlyHours.month,
                amountOfHours: monthlyHours.amountOfHours,
                createdAt: monthlyHours.createdAt,
                updatedAt: monthlyHours.updatedAt,
            })
        return result[0]
    },

    update: async (id: number, data: MonthlyHoursUpdateInput) => {
        const result = await db
            .update(monthlyHours)
            .set({
                ...(data.year !== undefined && { year: data.year }),
                ...(data.month !== undefined && { month: data.month }),
                ...(data.amountOfHours !== undefined && { amountOfHours: data.amountOfHours }),
                updatedAt: new Date(),
            })
            .where(eq(monthlyHours.id, id))
            .returning({
                id: monthlyHours.id,
                year: monthlyHours.year,
                month: monthlyHours.month,
                amountOfHours: monthlyHours.amountOfHours,
                createdAt: monthlyHours.createdAt,
                updatedAt: monthlyHours.updatedAt,
            })
        return result[0] || null
    },

    delete: async (id: number) => {
        await db.delete(monthlyHours).where(eq(monthlyHours.id, id))
    },

    upsert: async (data: MonthlyHoursCreateInput) => {
        // Check if record exists
        const existing = await monthlyHoursRepository.findByYearMonth(data.year, data.month)

        if (existing) {
            // Update existing record
            return await monthlyHoursRepository.update(existing.id, {
                amountOfHours: data.amountOfHours,
            })
        } else {
            // Create new record
            return await monthlyHoursRepository.create(data)
        }
    },
}