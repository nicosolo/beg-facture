import { z } from "zod"
import { paginationSchema } from "./pagination.js"

// Country and canton constants for location selection

export const COUNTRIES = {
    CH: "Switzerland",
    FR: "France",
    IT: "Italy",
    DE: "Germany",
} as const

export const SWISS_CANTONS = {
    AG: "Aargau",
    AI: "Appenzell Innerrhoden",
    AR: "Appenzell Ausserrhoden",
    BE: "Bern",
    BL: "Basel-Landschaft",
    BS: "Basel-Stadt",
    FR: "Fribourg",
    GE: "Geneva",
    GL: "Glarus",
    GR: "Grisons",
    JU: "Jura",
    LU: "Lucerne",
    NE: "Neuchâtel",
    NW: "Nidwalden",
    OW: "Obwalden",
    SG: "St. Gallen",
    SH: "Schaffhausen",
    SO: "Solothurn",
    SZ: "Schwyz",
    TG: "Thurgau",
    TI: "Ticino",
    UR: "Uri",
    VD: "Vaud",
    VS: "Valais",
    ZG: "Zug",
    ZH: "Zurich",
} as const

export type CountryCode = keyof typeof COUNTRIES
export type CantonCode = keyof typeof SWISS_CANTONS

// Location validation schemas

export const locationSchema = z.object({
    id: z.number(),
    name: z.string().min(1),
    country: z
        .enum(Object.keys(COUNTRIES) as [CountryCode, ...CountryCode[]])
        .optional()
        .nullable(),
    canton: z
        .enum(Object.keys(SWISS_CANTONS) as [CantonCode, ...CantonCode[]])
        .optional()
        .nullable(),
    region: z.string().optional().nullable(),
    address: z.string().optional().nullable(),
    createdAt: z.date().optional().nullable(),
    updatedAt: z.date().optional().nullable(),
})

// Base schema without id and timestamps
export const locationCreateSchema = locationSchema.omit({
    id: true,
    createdAt: true,
    updatedAt: true,
})

// Update schema - partial of base schema, then add validation
export const locationUpdateSchema = locationCreateSchema.partial()

export const locationFilterSchema = paginationSchema.extend({
    name: z.string().optional(),
    country: z.enum(Object.keys(COUNTRIES) as [CountryCode, ...CountryCode[]]).optional(),
    canton: z.enum(Object.keys(SWISS_CANTONS) as [CantonCode, ...CantonCode[]]).optional(),
    sortBy: z
        .enum(["name", "country", "canton", "createdAt", "updatedAt"])
        .optional()
        .default("name"),
    sortOrder: z.enum(["asc", "desc"]).optional().default("asc"),
})

// TypeScript types
export type Location = z.infer<typeof locationSchema>
export type LocationCreate = z.infer<typeof locationCreateSchema>
export type LocationUpdate = z.infer<typeof locationUpdateSchema>
export type LocationFilter = z.infer<typeof locationFilterSchema>
