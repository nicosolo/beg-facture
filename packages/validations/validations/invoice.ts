import { z } from "zod"

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
    billingMode: z.string().default("selon données présentes"),
    period: z.object({
        startDate: z
            .date()
            .optional()
            .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
        endDate: z
            .date()
            .optional()
            .or(z.string().transform((str) => (str ? new Date(str) : new Date()))),
    }),
    client: z.object({
        name: z.string().default(""),
        address: z.string().default(""),
        city: z.string().default(""),
        zipCode: z.string().default(""),
        country: z.string().default(""),
    }),
    recipient: z.object({
        name: z.string().default(""),
        company: z.string().default(""),
        address: z.string().default(""),
        city: z.string().default(""),
        zipCode: z.string().default(""),
        country: z.string().default(""),
    }),
    description: z.string().default(""),
    offers: z.array(OfferSchema).default([]),
    adjudications: z.array(AdjudicationSchema).default([]),

    // Financial details
    fees: z.object({
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
                    (val.percentage == null && val.amount != null),
                {
                    message: "Exactly one of percentage or amount must be provided, not both",
                }
            ),
    }),
    expenses: z.object({
        travel: z.object({
            base: z.number().default(0),
            adjusted: z.number().default(0),
            rate: z.number().default(0),
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
                percentage: z.number().default(0).nullable(),
                amount: z.number().default(0).nullable(),
            })
            .refine(
                (val) =>
                    (val.percentage != null && val.amount == null) ||
                    (val.percentage == null && val.amount != null),
                {
                    message: "Exactly one of percentage or amount must be provided, not both",
                }
            ),
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
    otherServices: z.string().default(""),
    remarks: RemarksSchema,
})

// Export TypeScript type
export type Invoice = z.infer<typeof InvoiceSchema>

// Helper function to create empty invoice with default values
export const createEmptyInvoice = (): Invoice => {
    return InvoiceSchema.parse({})
}

// Helper function to create a demo invoice with sample data
export const createDemoInvoice = (): Invoice => {
    return InvoiceSchema.parse({
        id: "",
        invoiceNumber: "",
        otherServices: "",
        reference: "5650 Cour de Gare - Sion",
        type: "Facture",
        billingMode: "selon données présentes",
        period: {
            startDate: new Date("2015-11-16"),
            endDate: new Date("2016-09-19"),
        },
        client: {
            name: "Comptoir Immobilier SA",
            address: "Cours de Rive 7",
        },
        recipient: {
            name: "Monsieur Alexandre Castillon",
            company: "Comptoir Immobilier SA",
            address: "Cours de Rive 7",
        },
        offers: [
            {
                file: "5650 O 2016-02-02 FAC",
                date: new Date("2016-02-02"),
                amount: 0,
            },
        ],
        adjudications: [
            {
                file: "Adjudication.eml",
                date: new Date("2016-05-12"),
                amount: 0,
            },
        ],
        description: `Selon notre offre ...`,
        fees: {
            base: 248.75,
            adjusted: 105.0,
            total: 14599.0,
            others: 123.0,
            discount: {
                percentage: 0.0,
                amount: null,
            },
            finalTotal: 14722.0,
            multiplicationFactor: 1.75,
            rates: [
                { rateClass: "B", base: 0, adjusted: 0, hourlyRate: 182.0, amount: 0 },
                {
                    rateClass: "C",
                    base: 154.0 * 60,
                    adjusted: 45.0 * 60,
                    rate: 157.0,
                    amount: 7065.0,
                },
                {
                    rateClass: "D",
                    base: 54.25 * 60,
                    adjusted: 42.0 * 60,
                    rate: 133.0,
                    amount: 5586.0,
                },
                {
                    rateClass: "E",
                    base: 38.25 * 60,
                    adjusted: 13.0 * 60,
                    rate: 111.0,
                    amount: 1443.0,
                },
                { rateClass: "F", base: 2.25 * 60, adjusted: 5.0 * 60, rate: 101.0, amount: 505.0 },
                { rateClass: "G", base: 0, adjusted: 0, rate: 97.0, amount: 0 },
            ],
        },
        expenses: {
            travel: { base: 584.0, adjusted: 584.0, rate: 0.65, amount: 379.6 },
            other: { base: 110.1, amount: 110.1 },
            total: 489.7,
            package: { percentage: 4.0, amount: null },
            thirdParty: { amount: 0 },
            totalExpenses: 588.9,
        },
        totals: {
            ht: 15310.9,
            vat: { rate: 8.0, amount: 1224.85 },
            ttc: 16535.75,
        },
        remarks: {
            otherServices: `Remarques sur les autres prestations`,
            travelExpenses: `Remarques sur les frais de déplacement`,
            expenses: `Remarques sur les frais`,
            thirdPartyExpenses: `Remarques sur les frais de tiers`,
        },
    } as Invoice)
}
