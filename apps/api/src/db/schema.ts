import { sqliteTable, text, integer, blob } from "drizzle-orm/sqlite-core"
import type { Class, ProjectAccessLevel, UserRole } from "@beg/types"
import { timestamps } from "./column.helper"

// User table
export const users = sqliteTable("users", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    email: text("email").notNull().unique(),
    lastName: text("lastName").notNull(),
    firstName: text("firstName").notNull(),
    initials: text("initials").notNull(),
    archived: integer("archived", { mode: "boolean" }).notNull().default(false),
    password: text("password").notNull(),
    role: text("role").$type<UserRole>().notNull(),
    ...timestamps,
})

// Region table
export const regions = sqliteTable("regions", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    ...timestamps,
})

// Location table
export const locations = sqliteTable("locations", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    regionId: integer("regionId")
        .notNull()
        .references(() => regions.id),
    ...timestamps,
})

// ProjectAccess table
export const projectAccess = sqliteTable("project_access", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    projectId: integer("projectId")
        .notNull()
        .references(() => projects.id),
    userId: integer("userId")
        .notNull()
        .references(() => users.id),
    accessLevel: text("accessLevel").$type<ProjectAccessLevel>().notNull(),
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
export const projects = sqliteTable("projects", {
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
})

// ActivityType table
export const activityTypes = sqliteTable("activity_types", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    code: text("code").notNull(),
    billable: integer("billable", { mode: "boolean" }).notNull(),
    ...timestamps,
})

// Activity table
export const activities = sqliteTable("activities", {
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
})
