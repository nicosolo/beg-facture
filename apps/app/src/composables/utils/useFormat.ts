const intlNumberFormat = new Intl.NumberFormat("de-CH", {
    notation: "standard",
})
export const useFormat = () => {
    const formatCurrency = (amount: number, showCurrency = true) => {
        return `${new Intl.NumberFormat("ch-FR", {
            currency: "CHF",
            maximumFractionDigits: 2,
            minimumFractionDigits: 2,
            signDisplay: "never",
        }).format(amount)}${showCurrency ? ".-" : ""}`
    }

    const formatPercentage = (percentage: number) => {
        return new Intl.NumberFormat("de-CH", {
            style: "percent",
            minimumFractionDigits: 2,
        }).format(percentage)
    }

    const formatNumber = (number: number) => {
        return intlNumberFormat.format(number)
    }

    const formatDuration = (duration: number | null | undefined) => {
        if (duration === undefined || duration === null) return "-"

        // Round to nearest 0.25 (quarter hour)
        const roundedHours = Math.round(duration * 4) / 4
        return formatNumber(roundedHours)
    }

    const formatDate = (date: Date | null | undefined) => {
        if (!date) return "N/A"
        return new Date(date).toLocaleDateString("fr-CH")
    }

    return { formatCurrency, formatPercentage, formatDuration, formatDate, formatNumber }
}
