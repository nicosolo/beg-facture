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
            <Button @click="setToday" :variant="presetVariant('today')" class="text-xs sm:text-sm">
                <span class="hidden sm:inline">{{ $t("dateRange.today") }}</span>
                <span class="sm:hidden">{{ $t("dateRange.today") }}</span>
            </Button>
            <Button
                @click="setThisWeek"
                :variant="presetVariant('week')"
                class="text-xs sm:text-sm"
            >
                <span class="hidden sm:inline">{{ $t("dateRange.thisWeek") }}</span>
                <span class="sm:hidden">{{ $t("dateRange.week") }}</span>
            </Button>
            <Button
                @click="setThisMonth"
                :variant="presetVariant('month')"
                class="text-xs sm:text-sm"
            >
                <span class="hidden sm:inline">{{ $t("dateRange.thisMonth") }}</span>
                <span class="sm:hidden">{{ $t("dateRange.month") }}</span>
            </Button>
            <Button
                @click="setThisYear"
                :variant="presetVariant('year')"
                class="text-xs sm:text-sm"
            >
                <span class="hidden sm:inline">{{ $t("dateRange.thisYear") }}</span>
                <span class="sm:hidden">{{ $t("dateRange.year") }}</span>
            </Button>

            <!-- Week navigation -->
            <div class="flex items-center gap-0 sm:gap-1 rounded-lg border border-gray-300">
                <Button
                    @click="navigateWeek(-1)"
                    :title="$t('dateRange.previousWeek')"
                    class="text-xs sm:text-sm px-1 sm:px-2"
                >
                    ‹
                </Button>
                <span class="px-1 sm:px-2 py-1 text-xs sm:text-sm text-gray-600">
                    {{ $t("dateRange.week") }}
                </span>
                <Button
                    @click="navigateWeek(1)"
                    :title="$t('dateRange.nextWeek')"
                    class="text-xs sm:text-sm px-1 sm:px-2"
                >
                    ›
                </Button>
            </div>

            <!-- Month navigation -->
            <div class="flex items-center gap-0 sm:gap-1 border border-gray-300 rounded-lg">
                <Button
                    @click="navigateMonth(-1)"
                    :title="$t('dateRange.previousMonth')"
                    class="text-xs sm:text-sm px-1 sm:px-2"
                >
                    ‹
                </Button>
                <span class="px-1 sm:px-2 py-1 text-xs sm:text-sm text-gray-600">
                    {{ $t("dateRange.month") }}
                </span>
                <Button
                    @click="navigateMonth(1)"
                    :title="$t('dateRange.nextMonth')"
                    class="text-xs sm:text-sm px-1 sm:px-2"
                >
                    ›
                </Button>
            </div>

            <!-- Year navigation -->
            <div class="flex items-center gap-0 sm:gap-1 border border-gray-300 rounded-lg">
                <Button
                    @click="navigateYear(-1)"
                    :title="$t('dateRange.previousYear')"
                    class="text-xs sm:text-sm px-1 sm:px-2"
                >
                    ‹
                </Button>
                <span class="px-1 sm:px-2 py-1 text-xs sm:text-sm text-gray-600">
                    {{ $t("dateRange.year") }}
                </span>
                <Button
                    @click="navigateYear(1)"
                    :title="$t('dateRange.nextYear')"
                    class="text-xs sm:text-sm px-1 sm:px-2"
                >
                    ›
                </Button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, computed, onMounted } from "vue"
import DateField from "./DateField.vue"
import Button from "../atoms/Button.vue"
import {
    detectPreset,
    getMonthRange,
    getTodayRange,
    getWeekRange,
    getYearRange,
    normaliseFromDate,
    normaliseToDate,
    shiftMonthRange,
    shiftWeekRange,
    shiftYearRange,
    type DateRangePresetKey,
} from "@/composables/utils/useDateRangePresets"

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
const activePreset = ref<DateRangePresetKey | null>(null)

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
            const adjustedDate = normaliseFromDate(value)

            // If the from date would be after the to date, adjust the to date
            if (localToDate.value && adjustedDate > localToDate.value) {
                const newToDate = normaliseToDate(adjustedDate)
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
            const adjustedDate = normaliseToDate(value)

            // If the to date would be before the from date, adjust the from date
            if (localFromDate.value && adjustedDate < localFromDate.value) {
                const newFromDate = normaliseFromDate(adjustedDate)
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

watch(
    [localFromDate, localToDate],
    ([from, to]) => {
        activePreset.value = detectPreset(from, to)
    },
    { immediate: true }
)

function presetVariant(preset: DateRangePresetKey): "primary" | "secondary" {
    return activePreset.value === preset ? "primary" : "secondary"
}

function applyRange(from: Date, to: Date) {
    localFromDate.value = from
    localToDate.value = to

    emit("update:fromDate", from)
    emit("update:toDate", to)
    emit("change", { fromDate: from, toDate: to })
}

// Preset functions
function setToday() {
    const { from, to } = getTodayRange()
    applyRange(from, to)
}

function setThisWeek() {
    const { from, to } = getWeekRange()
    applyRange(from, to)
}

// Navigate weeks forward or backward
function navigateWeek(direction: number) {
    const { from, to } = shiftWeekRange(localFromDate.value, direction)
    applyRange(from, to)
}

function setThisMonth() {
    const { from, to } = getMonthRange()
    applyRange(from, to)
}

// Navigate months forward or backward
function navigateMonth(direction: number) {
    const { from, to } = shiftMonthRange(localFromDate.value, direction)
    applyRange(from, to)
}

function setThisYear() {
    const { from, to } = getYearRange()
    applyRange(from, to)
}

// Navigate years forward or backward
function navigateYear(direction: number) {
    const { from, to } = shiftYearRange(localFromDate.value, direction)
    applyRange(from, to)
}

onMounted(() => {
    if (!localFromDate.value && !localToDate.value) {
        setToday()
    }
})
</script>
