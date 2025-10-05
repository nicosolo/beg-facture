import { z } from "zod"

// Error codes enum for type safety
export const ErrorCode = {
    // Authentication errors
    UNAUTHORIZED: "UNAUTHORIZED",
    FORBIDDEN: "FORBIDDEN",
    INVALID_CREDENTIALS: "INVALID_CREDENTIALS",
    TOKEN_EXPIRED: "TOKEN_EXPIRED",

    // Resource errors
    NOT_FOUND: "NOT_FOUND",
    ALREADY_EXISTS: "ALREADY_EXISTS",

    // Validation errors
    VALIDATION_ERROR: "VALIDATION_ERROR",
    INVALID_INPUT: "INVALID_INPUT",
    MISSING_REQUIRED_FIELD: "MISSING_REQUIRED_FIELD",
    INVALID_FORMAT: "INVALID_FORMAT",
    NO_PROJECT_FOLDER: "NO_PROJECT_FOLDER",

    // Business logic errors
    DUPLICATE_ENTRY: "DUPLICATE_ENTRY",
    CONSTRAINT_VIOLATION: "CONSTRAINT_VIOLATION",
    OPERATION_NOT_ALLOWED: "OPERATION_NOT_ALLOWED",

    // Server errors
    INTERNAL_ERROR: "INTERNAL_ERROR",
    DATABASE_ERROR: "DATABASE_ERROR",
    EXTERNAL_SERVICE_ERROR: "EXTERNAL_SERVICE_ERROR",

    // Rate limiting
    RATE_LIMIT_EXCEEDED: "RATE_LIMIT_EXCEEDED",

    // Unknown
    UNKNOWN_ERROR: "UNKNOWN_ERROR",

    // Response validation errors
    RESPONSE_VALIDATION_ERROR: "RESPONSE_VALIDATION_ERROR",
    BAD_REQUEST: "BAD_REQUEST",
} as const

export type ErrorCodeType = (typeof ErrorCode)[keyof typeof ErrorCode]

// Error code schema
export const errorCodeSchema = z.enum([
    ErrorCode.UNAUTHORIZED,
    ErrorCode.FORBIDDEN,
    ErrorCode.INVALID_CREDENTIALS,
    ErrorCode.TOKEN_EXPIRED,
    ErrorCode.NOT_FOUND,
    ErrorCode.ALREADY_EXISTS,
    ErrorCode.VALIDATION_ERROR,
    ErrorCode.INVALID_INPUT,
    ErrorCode.MISSING_REQUIRED_FIELD,
    ErrorCode.INVALID_FORMAT,
    ErrorCode.DUPLICATE_ENTRY,
    ErrorCode.CONSTRAINT_VIOLATION,
    ErrorCode.OPERATION_NOT_ALLOWED,
    ErrorCode.INTERNAL_ERROR,
    ErrorCode.DATABASE_ERROR,
    ErrorCode.EXTERNAL_SERVICE_ERROR,
    ErrorCode.RATE_LIMIT_EXCEEDED,
    ErrorCode.UNKNOWN_ERROR,
    ErrorCode.RESPONSE_VALIDATION_ERROR,
    ErrorCode.NO_PROJECT_FOLDER,
    ErrorCode.BAD_REQUEST,
])

// Validation error details
export const validationErrorDetailSchema = z.object({
    field: z.string(),
    message: z.string(),
    code: z.string().optional(),
})

// API error response schema
export const apiErrorResponseSchema = z.object({
    code: errorCodeSchema,
    message: z.string(),
    details: z.array(validationErrorDetailSchema).optional(),
    timestamp: z.string().datetime(),
    path: z.string().optional(),
    requestId: z.string().optional(),
})

export type ApiErrorResponse = z.infer<typeof apiErrorResponseSchema>
export type ValidationErrorDetail = z.infer<typeof validationErrorDetailSchema>

// Helper to create standardized error responses
export function createApiError(
    code: ErrorCodeType,
    message: string,
    details?: ValidationErrorDetail[]
): ApiErrorResponse {
    return {
        code,
        message,
        details,
        timestamp: new Date().toISOString(),
    }
}
