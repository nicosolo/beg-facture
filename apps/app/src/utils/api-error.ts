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