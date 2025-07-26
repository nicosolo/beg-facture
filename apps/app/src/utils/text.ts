// Truncate text based on configuration
export const truncateText = (
    text: string | undefined,
    truncateLength: boolean | number | undefined = false
): string => {
    if (!text) return ""

    // If truncate is false, return full text
    if (truncateLength === false) return text

    // If truncate is a number, truncate to that length
    if (typeof truncateLength === "number") {
        if (text.length <= truncateLength) return text
        return text.substring(0, truncateLength) + "..."
    }

    // If truncate is true or undefined, use default length of 20
    const defaultLength = 20
    if (text.length <= defaultLength) return text
    return text.substring(0, defaultLength) + "..."
}
