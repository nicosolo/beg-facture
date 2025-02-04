// Base interfaces that match the database schema
export interface BaseUser {
    id: number
    email: string
    name: string
    createdAt: Date
}

export interface BasePost {
    id: number
    title: string
    content: string
    authorId: number
    createdAt: Date
}
