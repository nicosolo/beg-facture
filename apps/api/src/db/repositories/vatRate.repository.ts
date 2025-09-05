import { db } from "../index"
import { vatRates } from "../schema"
import { eq, desc } from "drizzle-orm"
import type { VatRateCreateInput, VatRateUpdateInput } from "@beg/validations"

export const vatRateRepository = {
    async findAll() {
        // Always return all records sorted by year descending
        const data = await db.select().from(vatRates).orderBy(desc(vatRates.year))

        return data
    },

    async findById(id: number) {
        const result = await db.select().from(vatRates).where(eq(vatRates.id, id)).limit(1)

        return result[0] || null
    },

    async findByYear(year: number) {
        const result = await db.select().from(vatRates).where(eq(vatRates.year, year)).limit(1)

        return result[0] || null
    },

    async create(data: VatRateCreateInput) {
        const result = await db
            .insert(vatRates)
            .values({ ...data, createdAt: new Date(), updatedAt: new Date() })
            .returning()

        return result[0]
    },

    async update(id: number, data: VatRateUpdateInput) {
        const result = await db
            .update(vatRates)
            .set({ ...data, updatedAt: new Date() })
            .where(eq(vatRates.id, id))
            .returning()

        return result[0] || null
    },

    async delete(id: number) {
        await db.delete(vatRates).where(eq(vatRates.id, id))
    },
}
