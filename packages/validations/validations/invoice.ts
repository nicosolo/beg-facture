import { z } from "zod"
import { createPageResponseSchema, paginationSchema } from "./pagination"
import { dateSchema, timestampsSchema } from "./base"

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

// Fee item schema
const RateItemSchema = z.object({
    rateClass: z.string(),
    base: z.number().default(0),
    adjusted: z.number().default(0),
    hourlyRate: z.number().default(0),
    amount: z.number().default(0),
})

// Offer schema
const OfferSchema = z.object({
    file: z.string().default(""),
    date: z
        .date()
        .optional()
        .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
    amount: z.number().default(0),
    remark: z.string().default(""),
})

// Adjudication schema
const AdjudicationSchema = z.object({
    file: z.string().default(""),
    date: z
        .date()
        .optional()
        .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
    amount: z.number().default(0),
    remark: z.string().default(""),
})

const RemarksSchema = z.object({
    otherServices: z.string().default(""),
    travelExpenses: z.string().default(""),
    expenses: z.string().default(""),
    thirdPartyExpenses: z.string().default(""),
})

// Invoice schema that combines all properties
export const InvoiceSchema = z.object({
    // General info
    id: z.string().default(""),
    invoiceNumber: z.string().default(""),
    reference: z.string().default(""),
    type: z.string().default("Facture"),
    billingMode: BillingModeEnum.default(BILLING_MODE_KEYS.ACCORDING_TO_DATA),
    period: z
        .object({
            startDate: z
                .date()
                .optional()
                .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
            endDate: z
                .date()
                .optional()
                .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
        })
        .default({}),
    client: z
        .object({
            name: z.string().default(""),
            address: z.string().default(""),
        })
        .default({}),
    recipient: z
        .object({
            name: z.string().default(""),
            address: z.string().default(""),
        })
        .default({}),
    description: z.string().default(""),
    offers: z.array(OfferSchema).default([]),
    adjudications: z.array(AdjudicationSchema).default([]),

    // Financial details
    fees: z
        .object({
            base: z.number().default(0),
            adjusted: z.number().default(0),
            total: z.number().default(0),
            others: z.number().default(0),
            finalTotal: z.number().default(0),
            multiplicationFactor: z.number().default(1),
            rates: z.array(RateItemSchema).default([]),
            discount: z
                .object({
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
        })
        .default({ discount: { percentage: null, amount: null } }),
    expenses: z
        .object({
            travel: z
                .object({
                    base: z.number().default(0),
                    adjusted: z.number().default(0),
                    rate: z.number().default(0),
                    amount: z.number().default(0),
                })
                .default({}),
            other: z
                .object({
                    base: z.number().default(0),
                    amount: z.number().default(0),
                })
                .default({}),
            total: z.number().default(0),
            thirdParty: z
                .object({
                    amount: z.number().default(0),
                })
                .default({}),
            package: z
                .object({
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
        })
        .default({
            travel: {},
            other: {},
            thirdParty: {},
            package: { percentage: null, amount: null },
        }),
    totals: z
        .object({
            ht: z.number().default(0),
            vat: z
                .object({
                    rate: z.number().default(8.0),
                    amount: z.number().default(0),
                })
                .default({}),
            ttc: z.number().default(0),
        })
        .default({ vat: {} }),
    otherServices: z.string().default(""),
    remarks: RemarksSchema.default({}),
})

// Export TypeScript type
export type Invoice = z.infer<typeof InvoiceSchema>

// Helper function to create empty invoice with default values
export const createEmptyInvoice = (): Invoice => {
    return InvoiceSchema.parse({})
}

// API Filter schema for invoice list
export const invoiceFilterSchema = z
    .object({
        projectId: z.coerce.number().optional(),
        clientId: z.coerce.number().optional(),
        status: z.enum(["draft", "sent", "paid", "overdue", "cancelled"]).optional(),
        fromDate: z.coerce.date().optional(),
        toDate: z.coerce.date().optional(),
        sortBy: z.enum(["date", "reference", "total", "status"]).optional().default("date"),
        sortOrder: z.enum(["asc", "desc"]).optional().default("desc"),
    })
    .merge(paginationSchema)

export type InvoiceFilter = z.infer<typeof invoiceFilterSchema>
export type InvoiceFilterInput = z.input<typeof invoiceFilterSchema>

// Create schema for API with nested structure
export const invoiceCreateSchema = z.object({
    projectId: z.number(),
    invoiceNumber: z.string(),
    reference: z.string(),
    type: z.string().default("Facture"),
    billingMode: BillingModeEnum.default(BILLING_MODE_KEYS.ACCORDING_TO_DATA),
    status: z.enum(["draft", "sent", "paid", "overdue", "cancelled"]).default("draft"),
    issueDate: dateSchema,
    dueDate: dateSchema.optional(),
    period: z.object({
        startDate: dateSchema,
        endDate: dateSchema,
    }),
    client: z.object({
        id: z.number(),
    }),
    recipient: z.object({
        name: z.string(),
        address: z.string(),
    }),
    description: z.string(),
    fees: z.object({
        base: z.number().default(0),
        adjusted: z.number().default(0),
        total: z.number().default(0),
        others: z.number().default(0),
        finalTotal: z.number().default(0),
        multiplicationFactor: z.number().default(1),
        discount: z
            .object({
                percentage: z.number().optional(),
                amount: z.number().optional(),
            })
            .optional(),
        rates: z
            .array(
                z.object({
                    rateClass: z.string(),
                    base: z.number().default(0),
                    adjusted: z.number().default(0),
                    hourlyRate: z.number().default(0),
                    amount: z.number().default(0),
                })
            )
            .default([]),
    }),
    expenses: z.object({
        travel: z.object({
            base: z.number().default(0),
            adjusted: z.number().default(0),
            rate: z.number().default(0.65),
            amount: z.number().default(0),
        }),
        other: z.object({
            base: z.number().default(0),
            amount: z.number().default(0),
        }),
        total: z.number().default(0),
        thirdParty: z.object({
            amount: z.number().default(0),
        }),
        package: z
            .object({
                percentage: z.number().optional(),
                amount: z.number().optional(),
            })
            .optional(),
        totalExpenses: z.number().default(0),
    }),
    totals: z.object({
        ht: z.number().default(0),
        vat: z.object({
            rate: z.number().default(8.0),
            amount: z.number().default(0),
        }),
        ttc: z.number().default(0),
    }),
    remarks: z.object({
        otherServices: z.string().default(""),
        travelExpenses: z.string().default(""),
        expenses: z.string().default(""),
        thirdPartyExpenses: z.string().default(""),
    }),
    offers: z.array(OfferSchema).default([]),
    adjudications: z.array(AdjudicationSchema).default([]),
    otherServices: z.string().default(""),
})

export type InvoiceCreateInput = z.infer<typeof invoiceCreateSchema>

// Update schema for API
export const invoiceUpdateSchema = invoiceCreateSchema.partial()

export type InvoiceUpdateInput = z.infer<typeof invoiceUpdateSchema>

// Response schema for API - matches the Invoice type from frontend
export const invoiceResponseSchema = z
    .object({
        id: z.number(),
        invoiceNumber: z.string(),
        reference: z.string(),
        type: z.string(),
        billingMode: BillingModeEnum,
        status: z.enum(["draft", "sent", "paid", "overdue", "cancelled"]),
        period: z.object({
            startDate: dateSchema,
            endDate: dateSchema,
        }),
        client: z.object({
            id: z.number(),
            name: z.string(),
            address: z.string(),
        }),
        recipient: z.object({
            name: z.string(),
            address: z.string(),
        }),
        description: z.string(),
        offers: z.array(OfferSchema),
        adjudications: z.array(AdjudicationSchema),
        fees: z.object({
            base: z.number(),
            adjusted: z.number(),
            total: z.number(),
            others: z.number(),
            finalTotal: z.number(),
            multiplicationFactor: z.number(),
            discount: z.object({
                percentage: z.number().nullable(),
                amount: z.number().nullable(),
            }),
            rates: z.array(RateItemSchema),
        }),
        expenses: z.object({
            travel: z.object({
                base: z.number(),
                adjusted: z.number(),
                rate: z.number(),
                amount: z.number(),
            }),
            other: z.object({
                base: z.number(),
                amount: z.number(),
            }),
            total: z.number(),
            thirdParty: z.object({
                amount: z.number(),
            }),
            package: z.object({
                percentage: z.number().nullable(),
                amount: z.number().nullable(),
            }),
            totalExpenses: z.number(),
        }),
        totals: z.object({
            ht: z.number(),
            vat: z.object({
                rate: z.number(),
                amount: z.number(),
            }),
            ttc: z.number(),
        }),
        otherServices: z.string(),
        remarks: z.object({
            otherServices: z.string(),
            travelExpenses: z.string(),
            expenses: z.string(),
            thirdPartyExpenses: z.string(),
        }),
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

// List response with pagination
export const invoiceListResponse = createPageResponseSchema(invoiceResponseSchema)

export type InvoiceListResponse = z.infer<typeof invoiceListResponse>
