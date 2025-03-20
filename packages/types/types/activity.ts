export interface ActivityFilter {
    projectId: number
    userId?: number
    taskId?: number
    categoryId?: number
    startDate?: Date
    endDate?: Date
    validationStatus?: string
    isTemplate?: boolean
}
