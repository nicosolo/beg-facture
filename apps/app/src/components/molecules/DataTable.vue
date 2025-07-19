<template>
    <div class="bg-white rounded-md shadow overflow-hidden">
        <div v-if="items.length === 0" class="p-8 text-center">
            <p class="text-gray-500">{{ emptyMessage }}</p>
        </div>
        <div v-else>
            <!-- Header row (visible only on desktop) -->
            <div class="hidden md:flex bg-gray-50 divide-y divide-gray-200 w-full gap-2">
                <div
                    v-for="column in columns"
                    :key="column.key"
                    :class="[
                        'px-3 py-3 text-sm font-medium text-gray-500 tracking-wider divide-y divide-gray-200',
                        getWidth(column),
                    ]"
                >
                    {{ column.label }}
                </div>
            </div>

            <!-- Data rows -->
            <div class="divide-y divide-gray-200">
                <div
                    v-for="(item, index) in items"
                    :key="getItemKey(item, index)"
                    class="hover:bg-gray-100"
                >
                    <div class="flex flex-col md:flex-row gap-2">
                        <div
                            v-for="column in columns"
                            :key="column.key"
                            :class="[getWidth(column)]"
                        >
                            <div :class="['flex flex-row md:flex-col sm:w-full']">
                                <div
                                    v-if="!column.actions"
                                    class="md:hidden px-2 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-1/2"
                                >
                                    {{ column.label }}
                                </div>

                                <div :class="['md:px-3 py-2 md:py-2', 'w-full w-1/']">
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
                </div>
            </div>

            <!-- Footer row with totals -->
            <div v-if="showFooter" class="border-t-2 border-gray-300 bg-gray-50">
                <div class="flex flex-col md:flex-row gap-2">
                    <div
                        v-for="column in columns"
                        :key="`total-${column.key}`"
                        :class="[getWidth(column)]"
                    >
                        <div :class="['flex flex-row md:flex-col sm:w-full']">
                            <div
                                class="md:hidden px-2 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-1/2"
                            >
                                {{ column.label }}
                            </div>

                            <div :class="['md:px-3 py-2 md:py-2 font-medium', 'w-full w-1/']">
                                <slot :name="`total:${column.key}`" :column="column"> </slot>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
interface Column {
    key: string
    label: string
    nowrap?: boolean
    width?: "w-1/2" | "w-2/3" | "w-2/4" | "w-1/3"
    actions?: boolean
}

interface Props {
    items: any[]
    columns: Column[]
    itemKey?: string
    emptyMessage?: string
    showFooter?: boolean
}

const {
    items,
    columns,
    itemKey,
    emptyMessage = "No items found",
    showFooter = false,
} = defineProps<Props>()

const getWidth = (column: Column) => {
    return column.width
        ? column.width === "w-1/2"
            ? "md:w-1/2"
            : column.width === "w-2/3"
              ? "md:w-2/3"
              : column.width === "w-2/4"
                ? "md:w-2/4"
                : "md:w-1/3"
        : "md:flex-1"
}
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
</script>
