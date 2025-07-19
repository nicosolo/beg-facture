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

    const formatNumber = (number: number, minimumFractionDigits = 2) => {
        return new Intl.NumberFormat("ch-FR", {
            minimumFractionDigits,
        }).format(number)
    }

    const formatDuration = (duration: number | null | undefined) => {
        if (duration === undefined || duration === null) return "-"

        // Format duration in hours
        const hours = Math.floor(duration / 60)
        const minutes = duration % 60

        if (hours === 0) {
            return `${minutes}m`
        }

        return minutes === 0
            ? `${formatNumber(hours, 0)}h`
            : `${formatNumber(hours, 0)}h ${formatNumber(minutes, 0)}m`
    }

    const formatDate = (date: Date | null | undefined) => {
        if (!date) return "N/A"
        return new Date(date).toLocaleDateString()
    }

    return { formatCurrency, formatPercentage, formatDuration, formatDate }
}
