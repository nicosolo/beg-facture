<template>
    <div class="space-y-2">
        <!-- Date inputs -->
        <div class="grid grid-cols-2 gap-2 sm:gap-4">
            <!-- Date From -->
            <DateField :label="fromLabel" v-model="computedFromDate" :disabled="disabled" />
            <!-- Date To -->
            <DateField :label="toLabel" v-model="computedToDate" :disabled="disabled" />
        </div>
        <!-- Preset and Navigation buttons -->
        <div class="flex flex-wrap gap-1 sm:gap-2">
            <!-- Quick presets -->
            <Button @click="setThisWeek" class="text-xs sm:text-sm">
                <span class="hidden sm:inline">{{ $t("dateRange.thisWeek") }}</span>
                <span class="sm:hidden">{{ $t("dateRange.week") }}</span>
            </Button>
            <Button @click="setThisMonth" class="text-xs sm:text-sm">
                <span class="hidden sm:inline">{{ $t("dateRange.thisMonth") }}</span>
                <span class="sm:hidden">{{ $t("dateRange.month") }}</span>
            </Button>
            <Button @click="setThisYear" class="text-xs sm:text-sm">
                <span class="hidden sm:inline">{{ $t("dateRange.thisYear") }}</span>
                <span class="sm:hidden">{{ $t("dateRange.year") }}</span>
            </Button>

            <!-- Week navigation -->
            <div class="flex items-center gap-0 sm:gap-1 rounded-lg border border-gray-300">
                <Button @click="navigateWeek(-1)" :title="$t('dateRange.previousWeek')" class="text-xs sm:text-sm px-1 sm:px-2"> ‹ </Button>
                <span class="px-1 sm:px-2 py-1 text-xs sm:text-sm text-gray-600">
                    {{ $t("dateRange.week") }}
                </span>
                <Button @click="navigateWeek(1)" :title="$t('dateRange.nextWeek')" class="text-xs sm:text-sm px-1 sm:px-2"> › </Button>
            </div>

            <!-- Month navigation -->
            <div class="flex items-center gap-0 sm:gap-1 border border-gray-300 rounded-lg">
                <Button @click="navigateMonth(-1)" :title="$t('dateRange.previousMonth')" class="text-xs sm:text-sm px-1 sm:px-2">
                    ‹
                </Button>
                <span class="px-1 sm:px-2 py-1 text-xs sm:text-sm text-gray-600">
                    {{ $t("dateRange.month") }}
                </span>
                <Button @click="navigateMonth(1)" :title="$t('dateRange.nextMonth')" class="text-xs sm:text-sm px-1 sm:px-2"> › </Button>
            </div>

            <!-- Year navigation -->
            <div class="flex items-center gap-0 sm:gap-1 border border-gray-300 rounded-lg">
                <Button @click="navigateYear(-1)" :title="$t('dateRange.previousYear')" class="text-xs sm:text-sm px-1 sm:px-2"> ‹ </Button>
                <span class="px-1 sm:px-2 py-1 text-xs sm:text-sm text-gray-600">
                    {{ $t("dateRange.year") }}
                </span>
                <Button @click="navigateYear(1)" :title="$t('dateRange.nextYear')" class="text-xs sm:text-sm px-1 sm:px-2"> › </Button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, computed } from "vue"
import DateField from "./DateField.vue"
import Button from "../atoms/Button.vue"

interface DateRangeProps {
    fromDate?: Date
    toDate?: Date
    fromLabel?: string
    toLabel?: string
    disabled?: boolean
}

const props = defineProps<DateRangeProps>()

const emit = defineEmits<{
    (e: "update:fromDate", value?: Date): void
    (e: "update:toDate", value?: Date): void
    (e: "change", value: { fromDate?: Date; toDate?: Date }): void
}>()

const localFromDate = ref(props.fromDate)
const localToDate = ref(props.toDate)

// Computed properties for DateField v-model with proper date handling
const computedFromDate = computed({
    get: () => {
        if (!localFromDate.value) return undefined
        // Create a new date at noon to ensure proper display
        const displayDate = new Date(localFromDate.value)
        // Ensure we're showing the correct date by setting to noon
        displayDate.setHours(12, 0, 0, 0)
        return displayDate
    },
    set: (value?: Date) => {
        if (value) {
            // Ensure date is at start of day
            const adjustedDate = new Date(value)
            adjustedDate.setHours(0, 0, 0, 0)

            // If the from date would be after the to date, adjust the to date
            if (localToDate.value && adjustedDate > localToDate.value) {
                const newToDate = new Date(adjustedDate)
                newToDate.setHours(23, 59, 59, 999)
                localToDate.value = newToDate
                emit("update:toDate", newToDate)
            }

            localFromDate.value = adjustedDate
            emit("update:fromDate", adjustedDate)
            emit("change", { fromDate: adjustedDate, toDate: localToDate.value })
        } else {
            localFromDate.value = value
            emit("update:fromDate", value)
            emit("change", { fromDate: value, toDate: localToDate.value })
        }
    },
})

const computedToDate = computed({
    get: () => {
        if (!localToDate.value) return undefined
        // Create a new date at noon to ensure proper display
        const displayDate = new Date(localToDate.value)
        // Ensure we're showing the correct date by setting to noon
        displayDate.setHours(12, 0, 0, 0)
        return displayDate
    },
    set: (value?: Date) => {
        if (value) {
            // Ensure date is at end of day
            const adjustedDate = new Date(value)
            adjustedDate.setHours(23, 59, 59, 999)

            // If the to date would be before the from date, adjust the from date
            if (localFromDate.value && adjustedDate < localFromDate.value) {
                const newFromDate = new Date(adjustedDate)
                newFromDate.setHours(0, 0, 0, 0)
                localFromDate.value = newFromDate
                emit("update:fromDate", newFromDate)
            }

            localToDate.value = adjustedDate
            emit("update:toDate", adjustedDate)
            emit("change", { fromDate: localFromDate.value, toDate: adjustedDate })
        } else {
            localToDate.value = value
            emit("update:toDate", value)
            emit("change", { fromDate: localFromDate.value, toDate: value })
        }
    },
})

watch(
    () => props.fromDate,
    (newValue) => {
        localFromDate.value = newValue
    }
)

watch(
    () => props.toDate,
    (newValue) => {
        localToDate.value = newValue
    }
)

// Helper to set time to start of day (midnight)
function setStartOfDay(date: Date): Date {
    const d = new Date(date)
    d.setHours(0, 0, 0, 0)
    return d
}

// Helper to set time to end of day
function setEndOfDay(date: Date): Date {
    const d = new Date(date)
    d.setHours(23, 59, 59, 999)
    return d
}

// Helper to get Monday of a week
function getMonday(date: Date): Date {
    const d = new Date(date)
    const day = d.getDay()
    const diff = d.getDate() - day + (day === 0 ? -6 : 1)
    d.setDate(diff)
    return setStartOfDay(d)
}

// Helper to get Sunday of a week
function getSunday(date: Date): Date {
    const d = new Date(date)
    const day = d.getDay()
    const diff = d.getDate() + (day === 0 ? 0 : 7 - day)
    d.setDate(diff)
    return setEndOfDay(d)
}

// Preset functions
function setThisWeek() {
    const today = new Date()
    const monday = getMonday(today)
    const sunday = getSunday(today)

    localFromDate.value = monday
    localToDate.value = sunday

    emit("update:fromDate", monday)
    emit("update:toDate", sunday)
    emit("change", { fromDate: monday, toDate: sunday })
}

// Navigate weeks forward or backward
function navigateWeek(direction: number) {
    let baseDate: Date

    // If we have a current date range, use it as base
    if (localFromDate.value) {
        baseDate = new Date(localFromDate.value)
    } else {
        baseDate = new Date()
    }

    // Move by one week in the specified direction
    baseDate.setDate(baseDate.getDate() + 7 * direction)

    const monday = getMonday(baseDate)
    const sunday = getSunday(baseDate)

    localFromDate.value = monday
    localToDate.value = sunday

    emit("update:fromDate", monday)
    emit("update:toDate", sunday)
    emit("change", { fromDate: monday, toDate: sunday })
}

function setThisMonth() {
    const today = new Date()
    const year = today.getFullYear()
    const month = today.getMonth()

    // First day of month at start of day
    const firstDay = setStartOfDay(new Date(year, month, 1))
    // Last day of month at end of day
    const lastDay = setEndOfDay(new Date(year, month + 1, 0))

    localFromDate.value = firstDay
    localToDate.value = lastDay

    emit("update:fromDate", firstDay)
    emit("update:toDate", lastDay)
    emit("change", { fromDate: firstDay, toDate: lastDay })
}

// Navigate months forward or backward
function navigateMonth(direction: number) {
    let baseYear: number
    let baseMonth: number

    // If we have a current date range, use it as base
    if (localFromDate.value) {
        baseYear = localFromDate.value.getFullYear()
        baseMonth = localFromDate.value.getMonth()
    } else {
        const today = new Date()
        baseYear = today.getFullYear()
        baseMonth = today.getMonth()
    }

    // Calculate new month
    const targetDate = new Date(baseYear, baseMonth + direction, 1)
    const targetYear = targetDate.getFullYear()
    const targetMonth = targetDate.getMonth()

    // First day of month at start of day
    const firstDay = setStartOfDay(new Date(targetYear, targetMonth, 1))
    // Last day of month at end of day
    const lastDay = setEndOfDay(new Date(targetYear, targetMonth + 1, 0))

    localFromDate.value = firstDay
    localToDate.value = lastDay

    emit("update:fromDate", firstDay)
    emit("update:toDate", lastDay)
    emit("change", { fromDate: firstDay, toDate: lastDay })
}

function setThisYear() {
    const today = new Date()
    const year = today.getFullYear()

    // First day of year at start of day
    const firstDay = setStartOfDay(new Date(year, 0, 1))
    // Last day of year at end of day
    const lastDay = setEndOfDay(new Date(year, 11, 31))

    localFromDate.value = firstDay
    localToDate.value = lastDay

    emit("update:fromDate", firstDay)
    emit("update:toDate", lastDay)
    emit("change", { fromDate: firstDay, toDate: lastDay })
}

// Navigate years forward or backward
function navigateYear(direction: number) {
    let baseYear: number

    // If we have a current date range, use it as base
    if (localFromDate.value) {
        baseYear = localFromDate.value.getFullYear()
    } else {
        baseYear = new Date().getFullYear()
    }

    // Calculate new year
    const targetYear = baseYear + direction

    // First day of year at start of day
    const firstDay = setStartOfDay(new Date(targetYear, 0, 1))
    // Last day of year at end of day
    const lastDay = setEndOfDay(new Date(targetYear, 11, 31))

    localFromDate.value = firstDay
    localToDate.value = lastDay

    emit("update:fromDate", firstDay)
    emit("update:toDate", lastDay)
    emit("change", { fromDate: firstDay, toDate: lastDay })
}
</script>
