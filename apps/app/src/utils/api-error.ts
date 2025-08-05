import type { ApiErrorResponse, ErrorCodeType } from "@beg/validations"
import { ErrorCode } from "@beg/validations"
import { useI18n } from "vue-i18n"

export class ApiError extends Error {
    public code: ErrorCodeType
    public statusCode: number
    public details?: ApiErrorResponse["details"]
    public timestamp?: string
    public path?: string
    public requestId?: string

    constructor(response: ApiErrorResponse, statusCode: number) {
        super(response.message)
        this.name = "ApiError"
        this.code = response.code
        this.statusCode = statusCode
        this.details = response.details
        this.timestamp = response.timestamp
        this.path = response.path
        this.requestId = response.requestId
    }

    /**
     * Get a localized error message based on the error code
     * @param t - The i18n translation function
     * @returns Localized error message
     */
    getLocalizedMessage(t: ReturnType<typeof useI18n>["t"]): string {
        const errorKey = `errors.${this.code}`
        
        // Check if we have a translation for this error code
        const translated = t(errorKey)
        
        // If no translation found, check for specific cases
        if (translated === errorKey) {
            // For duplicate entry errors, we can provide more context
            if (this.code === ErrorCode.DUPLICATE_ENTRY && this.details?.[0]) {
                const detail = this.details[0]
                return t("errors.DUPLICATE_ENTRY_DETAIL", { field: detail.field })
            }
            
            // For validation errors with details
            if (this.code === ErrorCode.VALIDATION_ERROR && this.details?.length) {
                const messages = this.details.map(d => d.message).join(", ")
                return t("errors.VALIDATION_ERROR_DETAIL", { details: messages })
            }
            
            // Fallback to server message or generic error
            return this.message || t("errors.UNKNOWN_ERROR")
        }
        
        return translated
    }

    /**
     * Get field-specific error messages for form validation
     * @param t - The i18n translation function
     * @returns Map of field names to error messages
     */
    getFieldErrors(t: ReturnType<typeof useI18n>["t"]): Record<string, string> {
        const fieldErrors: Record<string, string> = {}
        
        if (this.details) {
            for (const detail of this.details) {
                fieldErrors[detail.field] = detail.message || t("errors.INVALID_FIELD")
            }
        }
        
        return fieldErrors
    }

    /**
     * Check if the error is of a specific type
     */
    is(code: ErrorCodeType): boolean {
        return this.code === code
    }

    /**
     * Check if the error is an authentication error
     */
    isAuthError(): boolean {
        const authCodes = [
            ErrorCode.UNAUTHORIZED,
            ErrorCode.FORBIDDEN,
            ErrorCode.INVALID_CREDENTIALS,
            ErrorCode.TOKEN_EXPIRED
        ] as const
        return (authCodes as readonly string[]).includes(this.code)
    }

    /**
     * Check if the error is a validation error
     */
    isValidationError(): boolean {
        const validationCodes = [
            ErrorCode.VALIDATION_ERROR,
            ErrorCode.INVALID_INPUT,
            ErrorCode.MISSING_REQUIRED_FIELD,
            ErrorCode.INVALID_FORMAT,
            ErrorCode.DUPLICATE_ENTRY
        ] as const
        return (validationCodes as readonly string[]).includes(this.code)
    }

    /**
     * Check if the error is a server error
     */
    isServerError(): boolean {
        return this.statusCode >= 500
    }

    /**
     * Check if the error is a not found error
     */
    isNotFoundError(): boolean {
        return this.code === ErrorCode.NOT_FOUND || this.statusCode === 404
    }

    /**
     * Check if the error is a constraint violation
     */
    isConstraintError(): boolean {
        return this.code === ErrorCode.CONSTRAINT_VIOLATION
    }

    /**
     * Get a user-friendly message for common error scenarios
     */
    getUserFriendlyMessage(t: ReturnType<typeof useI18n>["t"]): string {
        // Entity not found errors
        if (this.isNotFoundError()) {
            if (this.path) {
                const entity = this.extractEntityFromPath()
                if (entity) {
                    return t(`errors.${entity}_NOT_FOUND`, t("errors.ENTITY_NOT_FOUND", { entity }))
                }
            }
            return t("errors.NOT_FOUND")
        }

        // Reference constraint errors
        if (this.isConstraintError() && this.details?.[0]) {
            const detail = this.details[0]
            if (detail.field && detail.message?.includes("referenced")) {
                return t("errors.REFERENCE_CONSTRAINT", { 
                    entity: detail.field,
                    message: t("errors.CANNOT_DELETE_REFERENCED")
                })
            }
        }

        // Duplicate entry errors with better context
        if (this.code === ErrorCode.DUPLICATE_ENTRY && this.details?.[0]) {
            const detail = this.details[0]
            const fieldTranslation = t(`fields.${detail.field}`, detail.field)
            return t("errors.DUPLICATE_ENTRY_FIELD", { field: fieldTranslation })
        }

        // Validation errors with field-specific messages
        if (this.isValidationError() && this.details?.length) {
            const fieldMessages = this.details.map(d => {
                const fieldTranslation = t(`fields.${d.field}`, d.field)
                return `${fieldTranslation}: ${d.message}`
            })
            if (fieldMessages.length === 1) {
                return fieldMessages[0]
            }
            return t("errors.VALIDATION_ERRORS", { count: fieldMessages.length })
        }

        // Fall back to localized message
        return this.getLocalizedMessage(t)
    }

    /**
     * Extract entity name from API path
     */
    private extractEntityFromPath(): string | null {
        if (!this.path) return null
        
        // Match patterns like /api/user/123, /api/project/456
        const match = this.path.match(/\/api\/(\w+)(?:\/|$)/)
        return match ? match[1] : null
    }

    /**
     * Format validation errors for form display
     */
    formatForForm(t: ReturnType<typeof useI18n>["t"]): {
        generalError?: string
        fieldErrors: Record<string, string>
    } {
        const fieldErrors = this.getFieldErrors(t)
        
        // If we have field-specific errors, don't show a general error
        if (Object.keys(fieldErrors).length > 0) {
            return { fieldErrors }
        }

        // Otherwise, show a general error message
        return {
            generalError: this.getUserFriendlyMessage(t),
            fieldErrors: {}
        }
    }
}

/**
 * Common error handlers for specific scenarios
 */
export const errorHandlers = {
    /**
     * Handle entity not found errors
     */
    handleNotFound: (error: ApiError, entityName: string, t: ReturnType<typeof useI18n>["t"]): string => {
        return t("errors.ENTITY_NOT_FOUND", { entity: t(`entities.${entityName}`, entityName) })
    },

    /**
     * Handle validation errors with field mapping
     */
    handleValidation: (error: ApiError, t: ReturnType<typeof useI18n>["t"]): Record<string, string> => {
        return error.getFieldErrors(t)
    },

    /**
     * Handle reference constraint errors
     */
    handleConstraint: (error: ApiError, t: ReturnType<typeof useI18n>["t"]): string => {
        if (error.details?.[0]?.message?.includes("delete")) {
            return t("errors.CANNOT_DELETE_REFERENCED")
        }
        if (error.details?.[0]?.message?.includes("update")) {
            return t("errors.CANNOT_UPDATE_REFERENCED")
        }
        return t("errors.CONSTRAINT_VIOLATION")
    },

    /**
     * Handle duplicate entry errors
     */
    handleDuplicate: (error: ApiError, t: ReturnType<typeof useI18n>["t"]): string => {
        if (error.details?.[0]) {
            const field = error.details[0].field
            const fieldName = t(`fields.${field}`, field)
            return t("errors.DUPLICATE_VALUE", { field: fieldName })
        }
        return t("errors.DUPLICATE_ENTRY")
    }
}

/**
 * Parse an API error response
 */
export async function parseApiError(response: Response): Promise<ApiError> {
    try {
        const errorData = await response.json()
        
        // Validate that it matches our error schema
        if (errorData.code && errorData.message && errorData.timestamp) {
            return new ApiError(errorData as ApiErrorResponse, response.status)
        }
        
        // Fallback for non-standard error responses
        return new ApiError({
            code: ErrorCode.UNKNOWN_ERROR,
            message: errorData.message || errorData.error || "An error occurred",
            timestamp: new Date().toISOString()
        }, response.status)
    } catch {
        // If we can't parse the response, create a generic error
        return new ApiError({
            code: ErrorCode.UNKNOWN_ERROR,
            message: `HTTP ${response.status}: ${response.statusText}`,
            timestamp: new Date().toISOString()
        }, response.status)
    }
}