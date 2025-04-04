export const useFormat = () => {
    const formatCurrency = (amount: number, showCurrency = false) => {
        return new Intl.NumberFormat("ch-FR", {
            style: showCurrency ? "currency" : "decimal",
            currency: showCurrency ? "CHF" : undefined,
            maximumFractionDigits: 2,
            minimumFractionDigits: 2,
        }).format(amount)
    }

    const formatPercentage = (percentage: number) => {
        return new Intl.NumberFormat("ch-FR", {
            style: "percent",
            minimumFractionDigits: 2,
        }).format(percentage)
    }

    const formatDuration = (duration: number | null | undefined) => {
        if (duration === undefined || duration === null) return "-"

        // Format duration in hours
        const hours = Math.floor(duration / 60)
        const minutes = duration % 60

        if (hours === 0) {
            return `${minutes}m`
        }

        return minutes === 0 ? `${hours}h` : `${hours}h ${minutes}m`
    }

    return { formatCurrency, formatPercentage, formatDuration }
}
