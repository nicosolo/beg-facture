import { sqliteTable, text, integer, index } from "drizzle-orm/sqlite-core"

import { timestamps } from "./column.helper"
import type {
    ActivityRateUser,
    ClassSchema,
    ProjectAccessLevel,
    UserRole,
    COUNTRIES,
    SWISS_CANTONS,
} from "@beg/validations"
// User table
export const users = sqliteTable(
    "users",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        email: text("email").notNull().unique(),
        lastName: text("lastName").notNull(),
        firstName: text("firstName").notNull(),
        initials: text("initials").notNull(),
        archived: integer("archived", { mode: "boolean" }).notNull().default(false),
        password: text("password").notNull(),
        role: text("role").$type<UserRole>().notNull(),
        activityRates: text("activityRates", { mode: "json" })
            .$type<ActivityRateUser[]>()
            .default([]),
        ...timestamps,
    },
    (table) => [
        // Index for email lookups (authentication)
        index("users_email_idx").on(table.email),
        // Index for filtering by archived status
        index("users_archived_idx").on(table.archived),
        // Index for role-based queries
        index("users_role_idx").on(table.role),
        // Composite index for name searches
        index("users_name_idx").on(table.lastName, table.firstName),
    ]
)

// Location table
export const locations = sqliteTable(
    "locations",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        name: text("name").notNull(),
        country: text("country", { length: 2 }).$type<keyof typeof COUNTRIES>(),
        canton: text("canton", { length: 2 }).$type<keyof typeof SWISS_CANTONS>(),
        region: text("region"),
        address: text("address"),
        ...timestamps,
    },
    () => []
)

// Company table
export const companies = sqliteTable(
    "companies",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        name: text("name").notNull(),
        ...timestamps,
    },
    () => []
)

// Client table
export const clients = sqliteTable(
    "clients",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        name: text("name").notNull(),
        ...timestamps,
    },
    () => []
)

// ProjectType table
export const projectTypes = sqliteTable(
    "project_types",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        name: text("name").notNull(),
        ...timestamps,
    },
    () => []
)

// Engineer table
export const engineers = sqliteTable(
    "engineers",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        name: text("name").notNull(),
        ...timestamps,
    },
    () => []
)

// RateClass table
export const rateClasses = sqliteTable(
    "rate_classes",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        class: text("class").$type<ClassSchema>().notNull(),
        year: integer("year").notNull(),
        amount: integer("amount").notNull(),
    },
    () => []
)

// Project table
export const projects = sqliteTable(
    "projects",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        projectNumber: text("projectNumber").notNull(),
        name: text("name").notNull(),
        startDate: integer("startDate", { mode: "timestamp" }).notNull(),
        locationId: integer("locationId").references(() => locations.id, {
            onDelete: "set null",
        }),
        clientId: integer("clientId").references(() => clients.id, { onDelete: "set null" }),
        engineerId: integer("engineerId").references(() => engineers.id, { onDelete: "set null" }),
        companyId: integer("companyId").references(() => companies.id, { onDelete: "set null" }),
        typeId: integer("typeId")
            .notNull()
            .references(() => projectTypes.id, { onDelete: "set null" }),
        remark: text("remark"),
        projectManagerId: integer("projectManagerId").references(() => users.id, {
            onDelete: "set null",
        }),
        printFlag: integer("printFlag", { mode: "boolean" }).default(false),
        firstActivityDate: integer("firstActivityDate", { mode: "timestamp" }),
        lastActivityDate: integer("lastActivityDate", { mode: "timestamp" }),
        totalDuration: integer("totalDuration").default(0),
        unBilledDuration: integer("unBilledDuration").default(0),
        unBilledDisbursementDuration: integer("unBilledDisbursementDuration").default(0),
        ended: integer("ended", { mode: "boolean" }).default(false),
        archived: integer("archived", { mode: "boolean" }).default(false),
        ...timestamps,
    },
    (table) => [
        // Index for project manager queries (filtering by projectManagerId)
        index("projects_project_manager_idx").on(table.projectManagerId),
        // Index for project name searches (case-insensitive LIKE queries)
        index("projects_name_idx").on(table.name),
        // Index for project number searches (prefix LIKE queries)
        index("projects_project_number_idx").on(table.projectNumber),
        // Index for date range queries (filtering by startDate)
        index("projects_start_date_idx").on(table.startDate),
        // Composite index for sorting by updatedAt (last activity approximation)
        index("projects_updated_at_idx").on(table.updatedAt),
        // Foreign key indexes for JOIN performance
        index("projects_location_idx").on(table.locationId),
        index("projects_client_idx").on(table.clientId),
        index("projects_engineer_idx").on(table.engineerId),
        index("projects_company_idx").on(table.companyId),
        index("projects_type_idx").on(table.typeId),
        index("projects_first_activity_date_idx").on(table.firstActivityDate),
        index("projects_last_activity_date_idx").on(table.lastActivityDate),
        index("projects_total_duration_idx").on(table.totalDuration),
        index("projects_archived_idx").on(table.archived),
        index("projects_ended_idx").on(table.ended),
        index("projects_un_billed_duration_idx").on(table.unBilledDuration),
        index("projects_un_billed_disbursement_duration_idx").on(
            table.unBilledDisbursementDuration
        ),
        index("projects_project_manager_idx").on(table.projectManagerId),
    ]
)

// ProjectAccess table
export const projectAccess = sqliteTable(
    "project_access",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        projectId: integer("projectId")
            .notNull()
            .references(() => projects.id, { onDelete: "cascade" }),
        userId: integer("userId")
            .notNull()
            .references(() => users.id, { onDelete: "cascade" }),
        accessLevel: text("accessLevel").$type<ProjectAccessLevel>().notNull(),
        ...timestamps,
    },
    (table) => [
        // Index for user-project access queries (most common pattern)
        index("project_access_user_project_idx").on(table.userId, table.projectId),
        // Index for finding all projects a user has access to
        index("project_access_user_idx").on(table.userId),
        // Index for finding all users with access to a project
        index("project_access_project_idx").on(table.projectId),
        // Index for access level queries
        index("project_access_level_idx").on(table.accessLevel),
    ]
)

// ActivityType table
export const activityTypes = sqliteTable(
    "activity_types",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        name: text("name").notNull(),
        code: text("code").notNull(),
        billable: integer("billable", { mode: "boolean" }).notNull(),
        ...timestamps,
    },
    () => []
)

// Activity table
export const activities = sqliteTable(
    "activities",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        userId: integer("userId")
            .notNull()
            .references(() => users.id, { onDelete: "set null" }),
        date: integer("date", { mode: "timestamp" }).notNull(),
        duration: integer("duration").notNull(),
        kilometers: integer("kilometers").notNull(),
        expenses: integer("expenses").notNull(),
        rate: integer("rate").notNull(),
        projectId: integer("projectId")
            .notNull()
            .references(() => projects.id, { onDelete: "set null" }),
        activityTypeId: integer("activityTypeId")
            .notNull()
            .references(() => activityTypes.id, { onDelete: "set null" }),
        description: text("description"),
        billed: integer("billed", { mode: "boolean" }).notNull().default(false),
        invoiceId: integer("invoiceId").references(() => invoices.id, {
            onDelete: "set null",
        }),
        // Disbursement flag (if this activity is a disbursement)
        disbursement: integer("disbursement", { mode: "boolean" }).notNull().default(false),
        ...timestamps,
    },
    (table) => [
        // Index for user-project combinations (optimizes access control queries)
        index("activities_user_project_idx").on(table.userId, table.projectId),
        // Index for date-based queries
        index("activities_date_idx").on(table.date),
        // Index for billing queries
        index("activities_billed_idx").on(table.billed),
        // Composite index for project billing queries (optimizes hasUnbilledTime filter)
        index("activities_project_billed_idx").on(table.projectId, table.billed),
        // Index for invoice queries
        index("activities_invoice_idx").on(table.invoiceId),
    ]
)

// Invoice table
export const invoices = sqliteTable(
    "invoices",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        projectId: integer("projectId")
            .notNull()
            .references(() => projects.id, { onDelete: "set null" }),
        invoiceNumber: text("invoiceNumber").notNull().unique(),
        reference: text("reference").notNull(),
        type: text("type").notNull().default("Facture"),
        billingMode: text("billingMode").notNull().default("accordingToData"),
        status: text("status")
            .$type<"draft" | "sent" | "paid" | "overdue" | "cancelled">()
            .notNull()
            .default("draft"),
        issueDate: integer("issueDate", { mode: "timestamp" }).notNull(),
        dueDate: integer("dueDate", { mode: "timestamp" }),
        periodStart: integer("periodStart", { mode: "timestamp" }).notNull(),
        periodEnd: integer("periodEnd", { mode: "timestamp" }).notNull(),
        clientId: integer("clientId")
            .notNull()
            .references(() => clients.id, { onDelete: "set null" }),
        recipientName: text("recipientName").notNull(),
        recipientAddress: text("recipientAddress").notNull(),
        description: text("description").notNull(),
        // Fee totals
        feesBase: integer("feesBase").notNull().default(0),
        feesAdjusted: integer("feesAdjusted").notNull().default(0),
        feesTotal: integer("feesTotal").notNull().default(0),
        feesOthers: integer("feesOthers").notNull().default(0),
        feesFinalTotal: integer("feesFinalTotal").notNull().default(0),
        feesMultiplicationFactor: integer("feesMultiplicationFactor").notNull().default(100), // stored as percentage
        feesDiscountPercentage: integer("feesDiscountPercentage"),
        feesDiscountAmount: integer("feesDiscountAmount"),
        // Expense totals
        expensesTravelBase: integer("expensesTravelBase").notNull().default(0),
        expensesTravelAdjusted: integer("expensesTravelAdjusted").notNull().default(0),
        expensesTravelRate: integer("expensesTravelRate").notNull().default(65), // stored as percentage
        expensesTravelAmount: integer("expensesTravelAmount").notNull().default(0),
        expensesOtherBase: integer("expensesOtherBase").notNull().default(0),
        expensesOtherAmount: integer("expensesOtherAmount").notNull().default(0),
        expensesTotal: integer("expensesTotal").notNull().default(0),
        expensesThirdPartyAmount: integer("expensesThirdPartyAmount").notNull().default(0),
        expensesPackagePercentage: integer("expensesPackagePercentage"),
        expensesPackageAmount: integer("expensesPackageAmount"),
        expensesTotalExpenses: integer("expensesTotalExpenses").notNull().default(0),
        // Final totals
        totalHT: integer("totalHT").notNull().default(0),
        vatRate: integer("vatRate").notNull().default(800), // stored as basis points (8.00% = 800)
        vatAmount: integer("vatAmount").notNull().default(0),
        totalTTC: integer("totalTTC").notNull().default(0),
        // Remarks
        otherServices: text("otherServices").default(""),
        remarksOtherServices: text("remarksOtherServices").default(""),
        remarksTravelExpenses: text("remarksTravelExpenses").default(""),
        remarksExpenses: text("remarksExpenses").default(""),
        remarksThirdPartyExpenses: text("remarksThirdPartyExpenses").default(""),
        ...timestamps,
    },
    (table) => [
        // Index for invoice number lookups
        index("invoices_invoice_number_idx").on(table.invoiceNumber),
        // Index for project queries
        index("invoices_project_idx").on(table.projectId),
        // Index for client queries
        index("invoices_client_idx").on(table.clientId),
        // Index for status queries
        index("invoices_status_idx").on(table.status),
        // Index for date queries
        index("invoices_issue_date_idx").on(table.issueDate),
        // Composite index for listing invoices by project and status
        index("invoices_project_status_idx").on(table.projectId, table.status),
    ]
)

// Invoice rate details table
export const invoiceRates = sqliteTable(
    "invoice_rates",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        invoiceId: integer("invoiceId")
            .notNull()
            .references(() => invoices.id, { onDelete: "cascade" }),
        rateClass: text("rateClass").notNull(),
        baseMinutes: integer("baseMinutes").notNull().default(0),
        adjustedMinutes: integer("adjustedMinutes").notNull().default(0),
        hourlyRate: integer("hourlyRate").notNull().default(0),
        amount: integer("amount").notNull().default(0),
        ...timestamps,
    },
    (table) => [
        // Index for invoice queries
        index("invoice_rates_invoice_idx").on(table.invoiceId),
    ]
)

// Invoice offers table
export const invoiceOffers = sqliteTable(
    "invoice_offers",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        invoiceId: integer("invoiceId")
            .notNull()
            .references(() => invoices.id, { onDelete: "cascade" }),
        file: text("file").notNull().default(""),
        date: integer("date", { mode: "timestamp" }).notNull(),
        amount: integer("amount").notNull().default(0),
        remark: text("remark").default(""),
        ...timestamps,
    },
    (table) => [
        // Index for invoice queries
        index("invoice_offers_invoice_idx").on(table.invoiceId),
    ]
)

// Invoice adjudications table
export const invoiceAdjudications = sqliteTable(
    "invoice_adjudications",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        invoiceId: integer("invoiceId")
            .notNull()
            .references(() => invoices.id, { onDelete: "cascade" }),
        file: text("file").notNull().default(""),
        date: integer("date", { mode: "timestamp" }).notNull(),
        amount: integer("amount").notNull().default(0),
        remark: text("remark").default(""),
        ...timestamps,
    },
    (table) => [
        // Index for invoice queries
        index("invoice_adjudications_invoice_idx").on(table.invoiceId),
    ]
)
