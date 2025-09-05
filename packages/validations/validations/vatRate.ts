import { z } from "zod"
import { timestampsSchema } from "./base"

// VAT rate create schema
export const vatRateCreateSchema = z.object({
    year: z.number().int().min(2000).max(2100),
    rate: z.number().min(0).max(100), // Rate as percentage (0-100)
})

export type VatRateCreateInput = z.infer<typeof vatRateCreateSchema>

// VAT rate update schema
export const vatRateUpdateSchema = vatRateCreateSchema.partial()

export type VatRateUpdateInput = z.infer<typeof vatRateUpdateSchema>

// VAT rate response schema
export const vatRateSchema = z
    .object({
        id: z.number(),
        year: z.number(),
        rate: z.number(),
    })
    .merge(timestampsSchema)

export type VatRate = z.infer<typeof vatRateSchema>


// List response (simple array, no pagination)
export const vatRateListResponse = z.array(vatRateSchema)

export type VatRateListResponse = z.infer<typeof vatRateListResponse>