/**
 * Generic pagination response interface
 */
export interface Page<T> {
    data: T[]
    total: number
    page: number
    limit: number
    totalPages: number
}

/**
 * Pagination parameters interface
 */
export interface PaginationParams {
    page?: number
    limit?: number
}
