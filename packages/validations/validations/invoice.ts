import { z } from "zod"
import { createPageResponseSchema, paginationSchema } from "./pagination"
import { dateSchema, timestampsSchema } from "./base"

// ============================================================================
// Enums and Constants
// ============================================================================

// Billing mode enum with keys
export const BILLING_MODE_KEYS = {
    ACCORDING_TO_DATA: "accordingToData",
    ACCORDING_TO_INVOICE: "accordingToInvoice",
    FIXED_PRICE: "fixedPrice",
} as const

export const BILLING_MODE_LABELS = {
    [BILLING_MODE_KEYS.ACCORDING_TO_DATA]: "selon données présentes",
    [BILLING_MODE_KEYS.ACCORDING_TO_INVOICE]: "selon facture annexée",
    [BILLING_MODE_KEYS.FIXED_PRICE]: "au forfait (voir notes)",
} as const

export const BillingModeEnum = z.enum([
    BILLING_MODE_KEYS.ACCORDING_TO_DATA,
    BILLING_MODE_KEYS.ACCORDING_TO_INVOICE,
    BILLING_MODE_KEYS.FIXED_PRICE,
])

export type BillingMode = z.infer<typeof BillingModeEnum>

// Invoice status enum
export const InvoiceStatusEnum = z.enum(["draft", "sent", "paid", "overdue", "cancelled"])
export type InvoiceStatus = z.infer<typeof InvoiceStatusEnum>

// ============================================================================
// Reusable schemas for arrays only (since they're separate tables)
// ============================================================================

// Fee item schema for rates array
export const RateItemSchema = z.object({
    rateClass: z.string(),
    base: z.number().default(0),
    adjusted: z.number().default(0),
    hourlyRate: z.number().default(0),
    amount: z.number().default(0),
})

// Offer schema
export const OfferSchema = z.object({
    file: z.string().default(""),
    date: z
        .date()
        .optional()
        .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
    amount: z.number().default(0),
    remark: z.string().default(""),
})

// Adjudication schema
export const AdjudicationSchema = z.object({
    file: z.string().default(""),
    date: z
        .date()
        .optional()
        .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
    amount: z.number().default(0),
    remark: z.string().default(""),
})

// ============================================================================
// Frontend Invoice Schema (with flat structure matching DB)
// ============================================================================

export const InvoiceSchema = z.object({
    id: z.string().default(""),
    projectId: z.number().optional(),
    status: InvoiceStatusEnum.default("draft"),

    // Basic fields
    invoiceNumber: z.string().default(""),
    reference: z.string().default(""),
    type: z.string().default("Facture"),
    billingMode: BillingModeEnum.default(BILLING_MODE_KEYS.ACCORDING_TO_DATA),
    description: z.string().default(""),

    // Dates
    issueDate: dateSchema.optional(),
    dueDate: dateSchema.nullable().optional(),
    periodStart: dateSchema.optional(),
    periodEnd: dateSchema.optional(),

    // Client and recipient
    clientId: z.number().optional(),
    clientName: z.string().default(""),
    clientAddress: z.string().default(""),
    recipientName: z.string().default(""),
    recipientAddress: z.string().default(""),

    // Fees - flat structure
    feesBase: z.number().default(0),
    feesAdjusted: z.number().default(0),
    feesTotal: z.number().default(0),
    feesOthers: z.number().default(0),
    feesFinalTotal: z.number().default(0),
    feesMultiplicationFactor: z.number().default(1),
    feesDiscountPercentage: z.number().nullable().default(null),
    feesDiscountAmount: z.number().nullable().default(null),

    // Expenses - flat structure
    expensesTravelBase: z.number().default(0),
    expensesTravelAdjusted: z.number().default(0),
    expensesTravelRate: z.number().default(0.65),
    expensesTravelAmount: z.number().default(0),
    expensesOtherBase: z.number().default(0),
    expensesOtherAmount: z.number().default(0),
    expensesTotal: z.number().default(0),
    expensesThirdPartyAmount: z.number().default(0),
    expensesPackagePercentage: z.number().nullable().default(null),
    expensesPackageAmount: z.number().nullable().default(null),
    expensesTotalExpenses: z.number().default(0),

    // Totals - flat structure
    totalHT: z.number().default(0),
    vatRate: z.number().default(8.0),
    vatAmount: z.number().default(0),
    totalTTC: z.number().default(0),

    // Other services and remarks
    otherServices: z.string().default(""),
    remarksOtherServices: z.string().default(""),
    remarksTravelExpenses: z.string().default(""),
    remarksExpenses: z.string().default(""),
    remarksThirdPartyExpenses: z.string().default(""),

    // Related arrays (kept as arrays since they're separate tables)
    rates: z.array(RateItemSchema).default([]),
    offers: z.array(OfferSchema).default([]),
    adjudications: z.array(AdjudicationSchema).default([]),

    // Activity IDs for marking as billed after invoice creation
    activityIds: z.array(z.number()).optional(),
})

// Export TypeScript type
export type Invoice = z.infer<typeof InvoiceSchema>

// Helper function to create empty invoice with default values
export const createEmptyInvoice = (invoice: Partial<Invoice>): Invoice => {
    return InvoiceSchema.parse(invoice)
}

// ============================================================================
// API Create Schema
// ============================================================================

export const invoiceCreateSchema = z.object({
    projectId: z.number(),
    invoiceNumber: z.string(),
    reference: z.string(),
    type: z.string().default("Facture"),
    billingMode: BillingModeEnum.default(BILLING_MODE_KEYS.ACCORDING_TO_DATA),
    status: InvoiceStatusEnum.default("draft"),
    description: z.string(),

    // Dates
    issueDate: dateSchema,
    dueDate: dateSchema.optional(),
    periodStart: dateSchema,
    periodEnd: dateSchema,

    // Client and recipient
    clientId: z.number(),
    recipientName: z.string(),
    recipientAddress: z.string(),

    // All flat fields with defaults
    feesBase: z.number().default(0),
    feesAdjusted: z.number().default(0),
    feesTotal: z.number().default(0),
    feesOthers: z.number().default(0),
    feesFinalTotal: z.number().default(0),
    feesMultiplicationFactor: z.number().default(1),
    feesDiscountPercentage: z.number().nullable().optional(),
    feesDiscountAmount: z.number().nullable().optional(),

    expensesTravelBase: z.number().default(0),
    expensesTravelAdjusted: z.number().default(0),
    expensesTravelRate: z.number().default(0.65),
    expensesTravelAmount: z.number().default(0),
    expensesOtherBase: z.number().default(0),
    expensesOtherAmount: z.number().default(0),
    expensesTotal: z.number().default(0),
    expensesThirdPartyAmount: z.number().default(0),
    expensesPackagePercentage: z.number().nullable().optional(),
    expensesPackageAmount: z.number().nullable().optional(),
    expensesTotalExpenses: z.number().default(0),

    totalHT: z.number().default(0),
    vatRate: z.number().default(8.0),
    vatAmount: z.number().default(0),
    totalTTC: z.number().default(0),

    otherServices: z.string().default(""),
    remarksOtherServices: z.string().default(""),
    remarksTravelExpenses: z.string().default(""),
    remarksExpenses: z.string().default(""),
    remarksThirdPartyExpenses: z.string().default(""),

    // Arrays
    rates: z.array(RateItemSchema).default([]),
    offers: z.array(OfferSchema).default([]),
    adjudications: z.array(AdjudicationSchema).default([]),

    // Activity IDs to mark as billed after invoice creation
    activityIds: z.array(z.number()).optional(),
})

export type InvoiceCreateInput = z.infer<typeof invoiceCreateSchema>

// ============================================================================
// API Update Schema
// ============================================================================

export const invoiceUpdateSchema = invoiceCreateSchema.partial()

export type InvoiceUpdateInput = z.infer<typeof invoiceUpdateSchema>

// ============================================================================
// API Response Schema (fully flattened)
// ============================================================================

export const invoiceResponseSchema = z
    .object({
        id: z.number(),
        projectId: z.number(),
        invoiceNumber: z.string(),
        reference: z.string(),
        type: z.string(),
        billingMode: BillingModeEnum,
        status: InvoiceStatusEnum,
        description: z.string(),

        // Dates - flat
        issueDate: z.date().nullable(),
        dueDate: z.date().nullable(),
        periodStart: z.date().nullable(),
        periodEnd: z.date().nullable(),

        // Client - flat
        clientId: z.number(),
        clientName: z.string(),
        clientAddress: z.string(),

        // Recipient - flat
        recipientName: z.string(),
        recipientAddress: z.string(),

        // Fees - flat
        feesBase: z.number(),
        feesAdjusted: z.number(),
        feesTotal: z.number(),
        feesOthers: z.number(),
        feesFinalTotal: z.number(),
        feesMultiplicationFactor: z.number(),
        feesDiscountPercentage: z.number().nullable(),
        feesDiscountAmount: z.number().nullable(),

        // Expenses - flat
        expensesTravelBase: z.number(),
        expensesTravelAdjusted: z.number(),
        expensesTravelRate: z.number(),
        expensesTravelAmount: z.number(),
        expensesOtherBase: z.number(),
        expensesOtherAmount: z.number(),
        expensesTotal: z.number(),
        expensesThirdPartyAmount: z.number(),
        expensesPackagePercentage: z.number().nullable(),
        expensesPackageAmount: z.number().nullable(),
        expensesTotalExpenses: z.number(),

        // Totals - flat
        totalHT: z.number(),
        vatRate: z.number(),
        vatAmount: z.number(),
        totalTTC: z.number(),

        // Other services and remarks - flat
        otherServices: z.string(),
        remarksOtherServices: z.string(),
        remarksTravelExpenses: z.string(),
        remarksExpenses: z.string(),
        remarksThirdPartyExpenses: z.string(),

        // Arrays (kept as arrays since they're separate tables)
        rates: z.array(RateItemSchema),
        offers: z.array(OfferSchema),
        adjudications: z.array(AdjudicationSchema),

        // Relations - flat
        projectName: z.string().nullable(),
        projectNumber: z.string().nullable(),
    })
    .merge(timestampsSchema)

export type InvoiceResponse = z.infer<typeof invoiceResponseSchema>

// ============================================================================
// API Filter Schema
// ============================================================================

export const invoiceFilterSchema = z
    .object({
        projectId: z.coerce.number().optional(),
        clientId: z.coerce.number().optional(),
        status: InvoiceStatusEnum.optional(),
        fromDate: z.coerce.date().optional(),
        toDate: z.coerce.date().optional(),
        sortBy: z.enum(["date", "reference", "total", "status"]).optional().default("date"),
        sortOrder: z.enum(["asc", "desc"]).optional().default("desc"),
    })
    .merge(paginationSchema)

export type InvoiceFilter = z.infer<typeof invoiceFilterSchema>
export type InvoiceFilterInput = z.input<typeof invoiceFilterSchema>

// ============================================================================
// List Response Schema
// ============================================================================

export const invoiceListResponse = createPageResponseSchema(invoiceResponseSchema)

export type InvoiceListResponse = z.infer<typeof invoiceListResponse>
