// Base interfaces that match the database schema

export type UserRole = "admin" | "user"

export interface User {
    id: number
    email: string
    lastName: string
    firstName: string
    initials: string
    archived: boolean
    password: string
    role: UserRole
    createdAt?: Date
    updatedAt?: Date
}

export interface Region {
    id: number
    name: string
    createdAt: Date
    updatedAt: Date
}

export interface Location {
    id: number
    name: string
    regionId: number
    createdAt: Date
    updatedAt: Date
}

export type ProjectAccessLevel = "read" | "write"

export interface ProjectAccess {
    id: number
    projectId: number
    userId: number
    accessLevel: ProjectAccessLevel
    createdAt: Date
    updatedAt: Date
}

export interface Company {
    id: number
    name: string
    createdAt: Date
    updatedAt: Date
}

export interface Client {
    id: number
    name: string
    createdAt: Date
    updatedAt: Date
}

export interface ProjectType {
    id: number
    name: string
    createdAt: Date
    updatedAt: Date
}

export interface Engineer {
    id: number
    name: string
    createdAt: Date
    updatedAt: Date
}

export type Class = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "R" | "Z"

export interface RateClass {
    id: number
    class: Class
    year: number
    amount: number
}

export interface ActivityRateUser {
    id: number
    userId: number
    activityId: number
    class: Class
    createdAt: Date
    updatedAt: Date
}
export interface Project {
    id: number
    projectNumber: string
    name: string
    startDate: Date
    locationId?: number
    localityId?: number
    clientId?: number
    engineerId?: number
    companyId?: number
    typeId: number
    remark?: string
    projectManagerId?: number // User
    printFlag?: boolean
    createdAt: Date
    updatedAt: Date
}

export interface ActivityType {
    id: number
    name: string
    code: string
    billable: boolean
    createdAt: Date
    updatedAt: Date
}

export interface Activity {
    id: number
    userId: number
    date: Date
    duration: number
    kilometers: number
    expenses: number
    rate: number
    projectId: number
    activityTypeId: number
    description?: string
    billed: boolean
    invoiceId?: number
    disbursement: boolean
    createdAt: Date
    updatedAt: Date
}
