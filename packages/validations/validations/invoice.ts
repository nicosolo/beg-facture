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
// Reusable Building Blocks
// ============================================================================

// Fee item schema
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

// Remarks schema
export const RemarksSchema = z.object({
    otherServices: z.string().default(""),
    travelExpenses: z.string().default(""),
    expenses: z.string().default(""),
    thirdPartyExpenses: z.string().default(""),
})

// Discount schema with validation
export const DiscountSchema = z
    .object({
        percentage: z.number().nullable().default(null),
        amount: z.number().nullable().default(null),
    })
    .refine(
        (val) =>
            (val.percentage != null && val.amount == null) ||
            (val.percentage == null && val.amount != null) ||
            (val.percentage == null && val.amount == null),
        {
            message: "Only one of percentage or amount can be provided, not both",
        }
    )

// Period schema
export const PeriodSchema = z.object({
    startDate: dateSchema,
    endDate: dateSchema,
})

// Client info schema
export const ClientInfoSchema = z.object({
    id: z.number(),
    name: z.string(),
    address: z.string(),
})

// Recipient schema
export const RecipientSchema = z.object({
    name: z.string(),
    address: z.string(),
})

// Fees schema
export const FeesSchema = z.object({
    base: z.number().default(0),
    adjusted: z.number().default(0),
    total: z.number().default(0),
    others: z.number().default(0),
    finalTotal: z.number().default(0),
    multiplicationFactor: z.number().default(1),
    discount: DiscountSchema,
    rates: z.array(RateItemSchema).default([]),
})

// Travel expenses schema
export const TravelExpensesSchema = z.object({
    base: z.number().default(0),
    adjusted: z.number().default(0),
    rate: z.number().default(0.65),
    amount: z.number().default(0),
})

// Other expenses schema
export const OtherExpensesSchema = z.object({
    base: z.number().default(0),
    amount: z.number().default(0),
})

// Third party expenses schema
export const ThirdPartyExpensesSchema = z.object({
    amount: z.number().default(0),
})

// Package expenses schema
export const PackageExpensesSchema = DiscountSchema

// Expenses schema
export const ExpensesSchema = z.object({
    travel: TravelExpensesSchema,
    other: OtherExpensesSchema,
    total: z.number().default(0),
    thirdParty: ThirdPartyExpensesSchema,
    package: PackageExpensesSchema,
    totalExpenses: z.number().default(0),
})

// VAT schema
export const VatSchema = z.object({
    rate: z.number().default(8.0),
    amount: z.number().default(0),
})

// Totals schema
export const TotalsSchema = z.object({
    ht: z.number().default(0),
    vat: VatSchema,
    ttc: z.number().default(0),
})

// ============================================================================
// Base Invoice Schema (Common Fields)
// ============================================================================

const invoiceCommonFields = z.object({
    invoiceNumber: z.string(),
    reference: z.string(),
    type: z.string().default("Facture"),
    billingMode: BillingModeEnum.default(BILLING_MODE_KEYS.ACCORDING_TO_DATA),
    description: z.string(),
    period: PeriodSchema,
    recipient: RecipientSchema,
    fees: FeesSchema,
    expenses: ExpensesSchema,
    totals: TotalsSchema,
    offers: z.array(OfferSchema).default([]),
    adjudications: z.array(AdjudicationSchema).default([]),
    otherServices: z.string().default(""),
    remarks: RemarksSchema,
})

// ============================================================================
// Frontend Invoice Schema (with defaults for forms)
// ============================================================================

export const InvoiceSchema = invoiceCommonFields
    .extend({
        id: z.string().default(""),
        projectId: z.number().min(1),
        status: InvoiceStatusEnum.default("draft"),
        client: z.object({
            name: z.string().default(""),
            address: z.string().default(""),
        }),
        // Override with defaults for frontend
        invoiceNumber: z.string().default(""),
        reference: z.string().default(""),
        description: z.string().default(""),
        period: z.object({
            startDate: z
                .date()
                .optional()
                .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
            endDate: z
                .date()
                .optional()
                .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
        }).default({}),
        recipient: z.object({
            name: z.string().default(""),
            address: z.string().default(""),
        }).default({}),
        fees: z.object({
            base: z.number().default(0),
            adjusted: z.number().default(0),
            total: z.number().default(0),
            others: z.number().default(0),
            finalTotal: z.number().default(0),
            multiplicationFactor: z.number().default(1),
            rates: z.array(RateItemSchema).default([]),
            discount: z.object({
                percentage: z.number().default(0).nullable(),
                amount: z.number().default(0).nullable(),
            })
                .refine(
                    (val) =>
                        (val.percentage != null && val.amount == null) ||
                        (val.percentage == null && val.amount != null) ||
                        (val.percentage == null && val.amount == null),
                    {
                        message: "Only one of percentage or amount can be provided, not both",
                    }
                )
                .default({ percentage: null, amount: null }),
        }).default({ discount: { percentage: null, amount: null } }),
        expenses: z.object({
            travel: z.object({
                base: z.number().default(0),
                adjusted: z.number().default(0),
                rate: z.number().default(0),
                amount: z.number().default(0),
            }).default({}),
            other: z.object({
                base: z.number().default(0),
                amount: z.number().default(0),
            }).default({}),
            total: z.number().default(0),
            thirdParty: z.object({
                amount: z.number().default(0),
            }).default({}),
            package: z.object({
                percentage: z.number().default(0).nullable(),
                amount: z.number().default(0).nullable(),
            })
                .refine(
                    (val) =>
                        (val.percentage != null && val.amount == null) ||
                        (val.percentage == null && val.amount != null) ||
                        (val.percentage == null && val.amount == null),
                    {
                        message: "Only one of percentage or amount can be provided, not both",
                    }
                )
                .default({ percentage: null, amount: null }),
            totalExpenses: z.number().default(0),
        }).default({
            travel: {},
            other: {},
            thirdParty: {},
            package: { percentage: null, amount: null },
        }),
        totals: z.object({
            ht: z.number().default(0),
            vat: z.object({
                rate: z.number().default(8.0),
                amount: z.number().default(0),
            }).default({}),
            ttc: z.number().default(0),
        }).default({ vat: {} }),
        remarks: RemarksSchema.default({}),
    })

// Export TypeScript type
export type Invoice = z.infer<typeof InvoiceSchema>

// Helper function to create empty invoice with default values
export const createEmptyInvoice = (): Invoice => {
    return InvoiceSchema.parse({})
}

// ============================================================================
// API Create Schema
// ============================================================================

export const invoiceCreateSchema = invoiceCommonFields.extend({
    projectId: z.number(),
    status: InvoiceStatusEnum.default("draft"),
    issueDate: dateSchema,
    dueDate: dateSchema.optional(),
    client: z.object({
        id: z.number(),
    }),
})

export type InvoiceCreateInput = z.infer<typeof invoiceCreateSchema>

// ============================================================================
// API Update Schema
// ============================================================================

export const invoiceUpdateSchema = invoiceCreateSchema.partial()

export type InvoiceUpdateInput = z.infer<typeof invoiceUpdateSchema>

// ============================================================================
// API Response Schema
// ============================================================================

export const invoiceResponseSchema = invoiceCommonFields
    .omit({ 
        // Remove fields that are structured differently in response
    })
    .extend({
        id: z.number(),
        invoiceNumber: z.string(),
        reference: z.string(),
        type: z.string(),
        billingMode: BillingModeEnum,
        status: InvoiceStatusEnum,
        period: PeriodSchema,
        client: ClientInfoSchema,
        recipient: RecipientSchema,
        description: z.string(),
        offers: z.array(OfferSchema),
        adjudications: z.array(AdjudicationSchema),
        fees: FeesSchema,
        expenses: ExpensesSchema,
        totals: TotalsSchema,
        otherServices: z.string(),
        remarks: RemarksSchema,
        // Relations
        project: z
            .object({
                id: z.number(),
                name: z.string(),
                projectNumber: z.string(),
            })
            .nullable(),
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