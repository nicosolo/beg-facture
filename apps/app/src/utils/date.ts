/**
 * Format a date string or Date object to a localized string
 * @param date - The date to format (string or Date)
 * @param includeTime - Whether to include time in the output
 * @returns Formatted date string
 */
export const formatDate = (
    date: string | Date | null | undefined,
    includeTime: boolean = false
): string => {
    if (!date) return ""
    
    try {
        const dateObj = typeof date === "string" ? new Date(date) : date
        
        // Check for invalid date
        if (isNaN(dateObj.getTime())) {
            return ""
        }
        
        const day = dateObj.getDate().toString().padStart(2, "0")
        const month = (dateObj.getMonth() + 1).toString().padStart(2, "0")
        const year = dateObj.getFullYear()
        
        let formatted = `${day}/${month}/${year}`
        
        if (includeTime) {
            const hours = dateObj.getHours().toString().padStart(2, "0")
            const minutes = dateObj.getMinutes().toString().padStart(2, "0")
            formatted += ` ${hours}:${minutes}`
        }
        
        return formatted
    } catch (error) {
        console.error("Error formatting date:", error)
        return ""
    }
}

/**
 * Format a date with time
 * @param date - The date to format
 * @returns Formatted date and time string
 */
export const formatDateTime = (
    date: string | Date | null | undefined
): string => {
    return formatDate(date, true)
}

/**
 * Format a date to ISO string for API
 * @param date - The date to format
 * @returns ISO date string
 */
export const toISOString = (date: Date | null | undefined): string | null => {
    if (!date) return null
    return date.toISOString()
}

/**
 * Parse a date string to Date object
 * @param dateString - The date string to parse
 * @returns Date object or null
 */
export const parseDate = (dateString: string | null | undefined): Date | null => {
    if (!dateString) return null
    
    try {
        const date = new Date(dateString)
        // Check for invalid date
        if (isNaN(date.getTime())) {
            return null
        }
        return date
    } catch (error) {
        console.error("Error parsing date:", error)
        return null
    }
}

/**
 * Format a date relative to today (e.g., "Today", "Yesterday", "2 days ago")
 * @param date - The date to format
 * @returns Relative date string
 */
export const formatRelativeDate = (date: string | Date | null | undefined): string => {
    if (!date) return ""
    
    try {
        const dateObj = typeof date === "string" ? new Date(date) : date
        const now = new Date()
        const diffTime = now.getTime() - dateObj.getTime()
        const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
        
        if (diffDays === 0) {
            return "Aujourd'hui"
        } else if (diffDays === 1) {
            return "Hier"
        } else if (diffDays > 1 && diffDays < 7) {
            return `Il y a ${diffDays} jours`
        } else {
            return formatDate(date)
        }
    } catch (error) {
        console.error("Error formatting relative date:", error)
        return formatDate(date)
    }
}