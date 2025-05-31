import { sqliteTable, text, integer, blob, index } from "drizzle-orm/sqlite-core"
import type { Class, ProjectAccessLevel, UserRole } from "@beg/types"
import { timestamps } from "./column.helper"

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
        ...timestamps,
    },
    (table) => ({
        // Index for email lookups (authentication)
        emailIdx: index("users_email_idx").on(table.email),
        // Index for filtering by archived status
        archivedIdx: index("users_archived_idx").on(table.archived),
        // Index for role-based queries
        roleIdx: index("users_role_idx").on(table.role),
        // Composite index for name searches
        nameIdx: index("users_name_idx").on(table.lastName, table.firstName),
    })
)

// Location table
export const locations = sqliteTable("locations", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    country: text("country", { length: 2 }).notNull(),
    canton: text("canton", { length: 2 }),
    region: text("region"),
    address: text("address"),
    ...timestamps,
})

// Company table
export const companies = sqliteTable("companies", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    ...timestamps,
})

// Client table
export const clients = sqliteTable("clients", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    ...timestamps,
})

// ProjectType table
export const projectTypes = sqliteTable("project_types", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    ...timestamps,
})

// Engineer table
export const engineers = sqliteTable("engineers", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    ...timestamps,
})

// RateClass table
export const rateClasses = sqliteTable("rate_classes", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    class: text("class").$type<Class>().notNull(),
    year: integer("year").notNull(),
    amount: integer("amount").notNull(),
})

// ActivityRateUser table
export const activityRateUsers = sqliteTable("activity_rate_users", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    userId: integer("userId")
        .notNull()
        .references(() => users.id),
    activityId: integer("activityId").notNull(),
    class: text("class").$type<Class>().notNull(),
    ...timestamps,
})

// Project table
export const projects = sqliteTable(
    "projects",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        projectNumber: text("projectNumber").notNull(),
        name: text("name").notNull(),
        startDate: integer("startDate", { mode: "timestamp" }).notNull(),
        locationId: integer("locationId").references(() => locations.id),
        clientId: integer("clientId").references(() => clients.id),
        engineerId: integer("engineerId").references(() => engineers.id),
        companyId: integer("companyId").references(() => companies.id),
        typeId: integer("typeId")
            .notNull()
            .references(() => projectTypes.id),
        remark: text("remark"),
        projectManagerId: integer("projectManagerId").references(() => users.id),
        printFlag: integer("printFlag", { mode: "boolean" }).default(false),
        ...timestamps,
    },
    (table) => ({
        // Index for project manager queries (filtering by projectManagerId)
        projectManagerIdx: index("projects_project_manager_idx").on(table.projectManagerId),
        // Index for project name searches (case-insensitive LIKE queries)
        nameIdx: index("projects_name_idx").on(table.name),
        // Index for project number searches (prefix LIKE queries)
        projectNumberIdx: index("projects_project_number_idx").on(table.projectNumber),
        // Index for date range queries (filtering by startDate)
        startDateIdx: index("projects_start_date_idx").on(table.startDate),
        // Composite index for sorting by updatedAt (last activity approximation)
        updatedAtIdx: index("projects_updated_at_idx").on(table.updatedAt),
        // Foreign key indexes for JOIN performance
        locationIdx: index("projects_location_idx").on(table.locationId),
        clientIdx: index("projects_client_idx").on(table.clientId),
        engineerIdx: index("projects_engineer_idx").on(table.engineerId),
        companyIdx: index("projects_company_idx").on(table.companyId),
        typeIdx: index("projects_type_idx").on(table.typeId),
    })
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
    (table) => ({
        // Index for user-project access queries (most common pattern)
        userProjectIdx: index("project_access_user_project_idx").on(table.userId, table.projectId),
        // Index for finding all projects a user has access to
        userIdx: index("project_access_user_idx").on(table.userId),
        // Index for finding all users with access to a project
        projectIdx: index("project_access_project_idx").on(table.projectId),
        // Index for access level queries
        accessLevelIdx: index("project_access_level_idx").on(table.accessLevel),
    })
)

// ActivityType table
export const activityTypes = sqliteTable("activity_types", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    code: text("code").notNull(),
    billable: integer("billable", { mode: "boolean" }).notNull(),
    ...timestamps,
})

// Activity table
export const activities = sqliteTable(
    "activities",
    {
        id: integer("id").primaryKey({ autoIncrement: true }),
        userId: integer("userId")
            .notNull()
            .references(() => users.id),
        date: integer("date", { mode: "timestamp" }).notNull(),
        duration: integer("duration").notNull(),
        kilometers: integer("kilometers").notNull(),
        expenses: integer("expenses").notNull(),
        rate: integer("rate").notNull(),
        projectId: integer("projectId")
            .notNull()
            .references(() => projects.id),
        activityTypeId: integer("activityTypeId")
            .notNull()
            .references(() => activityTypes.id),
        description: text("description"),
        billed: integer("billed", { mode: "boolean" }).notNull().default(false),
        invoiceId: integer("invoiceId"),
        disbursement: integer("disbursement", { mode: "boolean" }).notNull().default(false),
        ...timestamps,
    },
    (table) => ({
        // Index for user-project combinations (optimizes access control queries)
        userProjectIdx: index("activities_user_project_idx").on(table.userId, table.projectId),
        // Index for date-based queries
        dateIdx: index("activities_date_idx").on(table.date),
        // Index for billing queries
        billedIdx: index("activities_billed_idx").on(table.billed),
        // Composite index for project billing queries (optimizes hasUnbilledTime filter)
        projectBilledIdx: index("activities_project_billed_idx").on(table.projectId, table.billed),
    })
)
