<template>
    <div class="bg-white rounded-md shadow">
        <div v-if="items.length === 0" class="p-8 text-center">
            <p class="text-gray-500">{{ emptyMessage }}</p>
        </div>
        <div v-else>
            <!-- Header row (visible only on desktop) -->
            <div
                class="hidden md:grid bg-gray-50 border-b border-gray-200"
                :style="{ gridTemplateColumns }"
            >
                <div
                    v-for="column in columns"
                    :key="column.key"
                    :class="[
                        'px-3 py-3 text-sm font-medium text-gray-500 tracking-wider border-r border-gray-200 last:border-r-0',
                        column.sortKey && 'cursor-pointer hover:bg-gray-100 transition-colors',
                    ]"
                    @click="handleSort(column)"
                >
                    <div class="flex items-center space-x-2 min-w-0">
                        <span class="truncate">{{ column.label }}</span>
                        <span v-if="column.sortKey" class="ml-auto flex-shrink-0">
                            <SortIcon :direction="getSortDirection(column)" />
                        </span>
                    </div>
                </div>
            </div>

            <!-- Data rows -->
            <div class="divide-y divide-gray-200">
                <div
                    v-for="(item, index) in items"
                    :key="getItemKey(item, index)"
                    :class="[
                        'cursor-pointer transition-colors',
                        selectedRows?.has(getItemKey(item, index))
                            ? 'bg-blue-100 hover:bg-blue-200'
                            : 'hover:bg-gray-100',
                    ]"
                    @click="handleRowClick(item, index, $event)"
                    @mousedown="handleMouseDown($event)"
                >
                    <div class="flex flex-col md:hidden">
                        <!-- Mobile view keeps existing layout -->
                        <div
                            v-for="column in columns"
                            :key="column.key"
                            class="border-b border-gray-200 last:border-b-0"
                        >
                            <div class="flex">
                                <div
                                    v-if="!column.actions && !column.fullWidth"
                                    class="px-2 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-1/2"
                                >
                                    {{ column.label }}
                                </div>
                                <div class="px-3 py-2 flex-1">
                                    <div
                                        v-if="column.fullWidth"
                                        class="text-xs font-medium text-gray-500 uppercase tracking-wider -mx-1"
                                    >
                                        {{ column.label }}
                                    </div>
                                    <slot
                                        :name="`cell:${column.key}`"
                                        :item="item"
                                        :column="column"
                                    >
                                        {{ getItemValue(item, column) }}
                                    </slot>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hidden md:grid" :style="{ gridTemplateColumns }">
                        <div
                            v-for="column in columns"
                            :key="column.key"
                            :class="[
                                'px-2 py-0.5 border-r border-gray-200 last:border-r-0 overflow-hidden',
                            ]"
                        >
                            <slot :name="`cell:${column.key}`" :item="item" :column="column">
                                <TruncateWithTooltip
                                    :content="getItemValue(item, column)"
                                    v-if="column.tooltip"
                                    :placement="column.tooltipPlacement || 'left'"
                                />
                                <span v-else>
                                    {{ getItemValue(item, column) }}
                                </span>
                            </slot>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer row with totals -->
            <div v-if="showFooter" class="border-t-3 border-gray-300 bg-gray-50">
                <!-- Mobile footer -->
                <div class="flex flex-col md:hidden">
                    <div
                        v-for="column in columns"
                        :key="`total-mobile-${column.key}`"
                        class="flex border-b border-gray-200 last:border-b-0"
                    >
                        <div
                            class="px-2 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-1/2"
                        >
                            {{ column.label }}
                        </div>
                        <div class="px-3 py-2 font-medium flex-1">
                            <slot :name="`total:${column.key}`" :column="column"> </slot>
                        </div>
                    </div>
                </div>
                <!-- Desktop footer with grid -->
                <div class="hidden md:grid" :style="{ gridTemplateColumns }">
                    <div
                        v-for="column in columns"
                        :key="`total-${column.key}`"
                        class="px-3 py-2 font-medium border-r border-gray-200 last:border-r-0"
                    >
                        <slot :name="`total:${column.key}`" :column="column"> </slot>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed } from "vue"
import SortIcon from "../atoms/SortIcon.vue"
import TruncateWithTooltip from "../atoms/TruncateWithTooltip.vue"
export interface Column {
    key: string
    label: string
    nowrap?: boolean
    width?:
        | "w-1/2"
        | "w-2/3"
        | "w-2/4"
        | "w-1/3"
        | "w-1/4"
        | "w-1/5"
        | "w-1/6"
        | "w-1/12"
        | "w-2/4"
        | "w-2/5"
        | "w-2/6"
        | "w-2/12"
        | string
    actions?: boolean
    fullWidth?: boolean
    sortKey?: string
    tooltip?: boolean
    tooltipPlacement?: "top" | "bottom" | "left" | "right"
}

interface Props {
    items: any[]
    columns: Column[]
    itemKey?: string
    emptyMessage?: string
    showFooter?: boolean
    sort?: { key: string; direction: "asc" | "desc" }
    selectedRows?: Set<string | number>
}
const emit = defineEmits<{
    (e: "sort-change", sort: { key: string; direction: "asc" | "desc" }): void
    (e: "row-click", item: any, index: number, event: MouseEvent): void
}>()
const {
    items,
    columns,
    itemKey,
    emptyMessage = "No items found",
    showFooter = false,
    sort,
    selectedRows,
} = defineProps<Props>()

// Generate grid template columns based on column widths
const gridTemplateColumns = computed(() => {
    return columns
        .map((col) => {
            if (!col.width) return "1fr"

            // Convert Tailwind width classes to CSS values
            const widthMap: Record<string, string> = {
                "w-1/2": "50%",
                "w-2/3": "66.66%",
                "w-2/4": "50%",
                "w-1/3": "33.33%",
                "w-1/4": "25%",
                "w-1/5": "20%",
                "w-1/6": "16.66%",
                "w-1/12": "8.33%",
                "w-2/5": "40%",
                "w-2/6": "33.33%",
                "w-2/12": "16.66%",
                "flex-1": "1fr",
            }

            return widthMap[col.width] || col.width
        })
        .join(" ")
})

// Get a unique key for each item
const getItemKey = (item: any, index: number): string | number => {
    if (itemKey && item[itemKey] !== undefined) {
        return item[itemKey]
    }
    return index
}

// Get the value for a cell based on the column key
const getItemValue = (item: any, column: Column): string => {
    const value = item[column.key]

    if (value === undefined || value === null) {
        return ""
    }

    return String(value)
}

// Handle column header click for sorting
const handleSort = (column: Column) => {
    if (!sort || !column.sortKey) return

    const sortKey = column.sortKey || column.key
    // Toggle direction if clicking the same column, otherwise default to asc
    if (sort.key === sortKey) {
        emit("sort-change", {
            key: sortKey,
            direction: sort.direction === "asc" ? "desc" : "asc",
        })
    } else {
        emit("sort-change", {
            key: sortKey,
            direction: "asc",
        })
    }
}

// Handle row click
const handleRowClick = (item: any, index: number, event: MouseEvent) => {
    // Ignore click if user has selected text
    if (window.getSelection()?.toString()) {
        return
    }
    emit("row-click", item, index, event)
}

// Handle mousedown to prevent text selection on shift+click
const handleMouseDown = (event: MouseEvent) => {
    // Only prevent text selection when shift key is pressed
    if (event.shiftKey) {
        event.preventDefault()
    }
}

// Get sort direction for a column
const getSortDirection = (column: Column): "asc" | "desc" | "none" => {
    if (!sort || !column.sortKey) return "none"

    const sortKey = column.sortKey || column.key
    if (sort.key !== sortKey) return "none"

    return sort.direction
}
</script>
