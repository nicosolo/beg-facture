import { and, eq } from "drizzle-orm"
import { db } from "../index"
import { rateClasses } from "../schema"
import type { Class } from "@beg/types"

export const rateRepository = {
    findAll: async () => {
        return await db
            .select({
                id: rateClasses.id,
                class: rateClasses.class,
                year: rateClasses.year,
                amount: rateClasses.amount,
            })
            .from(rateClasses)
    },

    findByClassAndYear: async (classType: Class, year: number) => {
        const results = await db
            .select({
                id: rateClasses.id,
                class: rateClasses.class,
                year: rateClasses.year,
                amount: rateClasses.amount,
            })
            .from(rateClasses)
            .where(and(eq(rateClasses.class, classType), eq(rateClasses.year, year)))
        return results[0] || null
    },
}
