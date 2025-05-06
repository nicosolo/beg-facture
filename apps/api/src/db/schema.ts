import { mysqlTable, varchar, int, timestamp, boolean, text } from "drizzle-orm/mysql-core"
import type { Class, ProjectAccessLevel, UserRole } from "@beg/types"
import { timestamps } from "./column.helper"

// User table
export const users = mysqlTable("users", {
    id: int("id").primaryKey().autoincrement(),
    email: varchar("email", { length: 255 }).notNull().unique(),
    lastName: varchar("lastName", { length: 255 }).notNull(),
    firstName: varchar("firstName", { length: 255 }).notNull(),
    initials: varchar("initials", { length: 10 }).notNull(),
    archived: boolean("archived").notNull().default(false),
    password: varchar("password", { length: 255 }).notNull(),
    role: varchar("role", { length: 50 }).notNull().$type<UserRole>(),
    ...timestamps,
})

// Region table
export const regions = mysqlTable("regions", {
    id: int("id").primaryKey().autoincrement(),
    name: varchar("name", { length: 255 }).notNull(),
    ...timestamps,
})

// Location table
export const locations = mysqlTable("locations", {
    id: int("id").primaryKey().autoincrement(),
    name: varchar("name", { length: 255 }).notNull(),
    regionId: int("regionId")
        .notNull()
        .references(() => regions.id),
    ...timestamps,
})

// ProjectAccess table
export const projectAccess = mysqlTable("project_access", {
    id: int("id").primaryKey().autoincrement(),
    projectId: int("projectId")
        .notNull()
        .references(() => projects.id),
    userId: int("userId")
        .notNull()
        .references(() => users.id),
    accessLevel: varchar("accessLevel", { length: 50 }).notNull().$type<ProjectAccessLevel>(),
    ...timestamps,
})

// Company table
export const companies = mysqlTable("companies", {
    id: int("id").primaryKey().autoincrement(),
    name: varchar("name", { length: 255 }).notNull(),
    ...timestamps,
})

// Client table
export const clients = mysqlTable("clients", {
    id: int("id").primaryKey().autoincrement(),
    name: varchar("name", { length: 255 }).notNull(),
    ...timestamps,
})

// ProjectType table
export const projectTypes = mysqlTable("project_types", {
    id: int("id").primaryKey().autoincrement(),
    name: varchar("name", { length: 255 }).notNull(),
    ...timestamps,
})

// Engineer table
export const engineers = mysqlTable("engineers", {
    id: int("id").primaryKey().autoincrement(),
    name: varchar("name", { length: 255 }).notNull(),
    ...timestamps,
})

// RateClass table
export const rateClasses = mysqlTable("rate_classes", {
    id: int("id").primaryKey().autoincrement(),
    class: varchar("class", { length: 50 }).notNull().$type<Class>(),
    year: int("year").notNull(),
    amount: int("amount").notNull(),
})

// ActivityRateUser table
export const activityRateUsers = mysqlTable("activity_rate_users", {
    id: int("id").primaryKey().autoincrement(),
    userId: int("userId")
        .notNull()
        .references(() => users.id),
    activityId: int("activityId").notNull(),
    class: varchar("class", { length: 50 }).notNull().$type<Class>(),
    ...timestamps,
})

// Project table
export const projects = mysqlTable("projects", {
    id: int("id").primaryKey().autoincrement(),
    projectNumber: varchar("projectNumber", { length: 50 }).notNull(),
    name: varchar("name", { length: 255 }).notNull(),
    startDate: timestamp("startDate").notNull(),
    locationId: int("locationId").references(() => locations.id),
    clientId: int("clientId").references(() => clients.id),
    engineerId: int("engineerId").references(() => engineers.id),
    companyId: int("companyId").references(() => companies.id),
    typeId: int("typeId")
        .notNull()
        .references(() => projectTypes.id),
    remark: text("remark"),
    projectManagerId: int("projectManagerId").references(() => users.id),
    printFlag: boolean("printFlag").default(false),
    ...timestamps,
})

// ActivityType table
export const activityTypes = mysqlTable("activity_types", {
    id: int("id").primaryKey().autoincrement(),
    name: varchar("name", { length: 255 }).notNull(),
    code: varchar("code", { length: 50 }).notNull(),
    billable: boolean("billable").notNull(),
    ...timestamps,
})

// Activity table
export const activities = mysqlTable("activities", {
    id: int("id").primaryKey().autoincrement(),
    userId: int("userId")
        .notNull()
        .references(() => users.id),
    date: timestamp("date").notNull(),
    duration: int("duration").notNull(),
    kilometers: int("kilometers").notNull(),
    expenses: int("expenses").notNull(),
    rate: int("rate").notNull(),
    projectId: int("projectId")
        .notNull()
        .references(() => projects.id),
    activityTypeId: int("activityTypeId")
        .notNull()
        .references(() => activityTypes.id),
    description: text("description"),
    billed: boolean("billed").notNull().default(false),
    invoiceId: int("invoiceId"),
    disbursement: boolean("disbursement").notNull().default(false),
    ...timestamps,
})
