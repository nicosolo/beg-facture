import { z } from "zod"
import { paginationSchema } from "./pagination"
import { nullableDateSchema } from "./base"

// Create a schema for client filtering with pagination
export const clientFilterSchema = z
    .object({
        name: z.string().optional(),
        city: z.string().optional(),
        postalCode: z.string().optional(),
        iban: z.string().optional(),
        address: z.string().optional(),
    })
    .merge(paginationSchema)

export type ClientFilter = z.infer<typeof clientFilterSchema>
export type ClientFilterInput = z.input<typeof clientFilterSchema>
