// Base interfaces that match the database schema
export interface User {
    id: number
    email: string
    active: boolean
    name: string
    firstName: string
    initials: string
    archived: boolean
    createdAt?: Date
    updatedAt?: Date
}

export interface BasePost {
    id: number
    title: string
    content: string
    authorId: number
    createdAt: Date
}
