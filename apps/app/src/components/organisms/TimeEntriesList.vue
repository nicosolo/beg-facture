<template>
    <div>
        <!-- Bulk actions bar -->
        <div
            v-if="selectedRows.size > 0"
            class="bg-blue-100 border border-blue-300 rounded-lg p-4 mb-4 shadow-sm"
        >
            <div class="flex items-center justify-between">
                <span class="text-sm text-blue-700">
                    {{ $t("common.itemsSelected", { count: selectedRows.size }) }}
                </span>
                <div class="flex gap-2">
                    <Button @click="updateSelectedRows('billed', true)" variant="primary" size="sm">
                        {{ $t("time.actions.markAsBilled") }}
                    </Button>
                    <Button
                        @click="updateSelectedRows('billed', false)"
                        variant="secondary"
                        size="sm"
                    >
                        {{ $t("time.actions.markAsUnbilled") }}
                    </Button>
                    <Button
                        @click="updateSelectedRows('disbursement', true)"
                        variant="secondary"
                        size="sm"
                    >
                        {{ $t("time.actions.markAsDisbursement") }}
                    </Button>
                    <Button
                        @click="updateSelectedRows('disbursement', false)"
                        variant="secondary"
                        size="sm"
                    >
                        {{ $t("time.actions.unmarkAsDisbursement") }}
                    </Button>
                    <Button @click="clearSelection" variant="ghost" size="sm">
                        {{ $t("common.clearSelection") }}
                    </Button>
                </div>
            </div>
        </div>

        <DataTable
            showFooter
            :items="activities"
            :columns="columns"
            item-key="id"
            :empty-message="emptyMessage"
            :sort="sort"
            @sort-change="handleSort"
            @row-click="handleRowClick"
            :selected-rows="selectedRows"
        >
            <template #cell:user="{ item }">
                {{ item.user ? `${item.user.initials}` : "-" }}
            </template>

            <template #cell:project="{ item }">
                <TruncateWithTooltip
                    :content="item.project?.name"
                    placement="right"
                    :disabled="item.project?.name.length < 20"
                >
                    <span class="font-medium mr-2">{{ item.project?.projectNumber }}</span>
                    <span class="text-sm text-gray-600">{{
                        truncateText(item.project?.name, 20)
                    }}</span>
                </TruncateWithTooltip>
            </template>

            <template #cell:activityType="{ item }">
                {{ item.activityType?.code || "-" }}
            </template>

            <template #cell:date="{ item }">
                {{ formatDate(item.date) }}
            </template>

            <template #cell:duration="{ item }">
                {{ formatDuration(item.duration) }}
            </template>

            <template #cell:expenses="{ item }">
                {{ formatCurrency(item.expenses) }}
            </template>

            <template #cell:billed="{ item }">
                <input
                    type="checkbox"
                    :checked="item.billed"
                    @change="updateBilledStatus(item.id, !item.billed)"
                    @click.stop
                    class="h-4 w-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                />
            </template>

            <template #cell:disbursement="{ item }">
                <input
                    type="checkbox"
                    :checked="item.disbursement"
                    @change="updateDisbursementStatus(item.id, !item.disbursement)"
                    @click.stop
                    class="h-4 w-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500"
                />
            </template>

            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <slot name="actions" :item="item">
                        <Button
                            variant="ghost"
                            size="sm"
                            @click="$emit('edit', item.id)"
                            className="text-indigo-600 hover:text-indigo-900"
                        >
                            {{ $t("common.edit") }}
                        </Button>
                    </slot>
                </div>
            </template>

            <!-- Total row customizations -->
            <template #total:duration>
                {{ formatDuration(totals?.duration || 0) }}
            </template>
            <template #total:kilometers> {{ formatNumber(totals?.kilometers || 0) }} km </template>
            <template #total:expenses>{{ formatCurrency(totals?.expenses || 0) }} </template>
        </DataTable>
    </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue"
import { useI18n } from "vue-i18n"
import DataTable, { type Column } from "../molecules/DataTable.vue"
import Button from "../atoms/Button.vue"
import { useFormat } from "@/composables/utils/useFormat"
import { useUpdateActivity } from "@/composables/api/useActivity"
import type { ActivityResponse } from "@beg/validations"
import { truncateText } from "@/utils/text"
import TruncateWithTooltip from "../atoms/TruncateWithTooltip.vue"

const { formatDuration, formatDate, formatNumber, formatCurrency } = useFormat()
const { t } = useI18n()

interface Props {
    activities: ActivityResponse[]
    totals?: {
        duration: number
        kilometers: number
        expenses: number
    }
    emptyMessage?: string
    editRoute?: string
    hideColumns?: string[]
    sort?: {
        key: string
        direction: "asc" | "desc"
    }
}

const props = defineProps<Props>()

const emit = defineEmits<{
    "sort-change": [sort: { key: string; direction: "asc" | "desc" }]
    edit: [activityId: number]
    "activities-updated": []
}>()

// API composables
const updateActivityApi = useUpdateActivity()

// Selection state
const selectedRows = ref<Set<number>>(new Set())
const lastClickedIndex = ref<number | null>(null)

const defaultColumns: Column[] = [
    { key: "date", label: t("time.columns.date"), sortKey: "date", width: "7rem" },
    { key: "user", label: t("time.columns.user"), width: "3rem" },
    { key: "project", label: t("time.columns.project"), width: "11rem" },
    { key: "activityType", label: t("time.columns.activityType"), width: "7rem" },
    { key: "duration", label: t("time.columns.duration"), sortKey: "duration", width: "7rem" },
    {
        key: "kilometers",
        label: t("time.columns.kilometers"),
        sortKey: "kilometers",
        width: "7rem",
    },
    { key: "expenses", label: t("time.columns.expenses"), sortKey: "expenses", width: "6rem" },
    { key: "description", label: t("time.columns.description"), tooltip: true, fullWidth: true },
    { key: "billed", label: t("time.columns.billed"), width: "4rem" },
    { key: "disbursement", label: t("time.columns.disbursement"), width: "4rem" },
    { key: "actions", label: t("common.actions"), actions: true, width: "5rem" },
]

const columns = computed(() => {
    if (!props.hideColumns || props.hideColumns.length === 0) {
        return defaultColumns
    }

    return defaultColumns.filter((col) => !props.hideColumns?.includes(col.key))
})

const handleSort = ({ key, direction }: { key: string; direction: "asc" | "desc" }) => {
    console.log(key, direction)
    emit("sort-change", { key, direction })
}

// Handle row click for selection
const handleRowClick = (item: ActivityResponse, index: number, event: MouseEvent) => {
    const newSelection = new Set(selectedRows.value)

    if (event.shiftKey && lastClickedIndex.value !== null) {
        // Shift+click: select range
        const start = Math.min(lastClickedIndex.value, index)
        const end = Math.max(lastClickedIndex.value, index)

        for (let i = start; i <= end; i++) {
            if (props.activities[i]) {
                newSelection.add(props.activities[i].id)
            }
        }
    } else if (event.ctrlKey || event.metaKey) {
        // Ctrl/Cmd+click: toggle single selection
        if (newSelection.has(item.id)) {
            newSelection.delete(item.id)
        } else {
            newSelection.add(item.id)
        }
    } else {
        // Regular click: select only this row
        newSelection.clear()
        newSelection.add(item.id)
    }

    selectedRows.value = newSelection
    lastClickedIndex.value = index
}

// Update billed status
const updateBilledStatus = async (activityId: number, billed: boolean) => {
    try {
        await updateActivityApi.put({
            params: { id: activityId },
            body: { billed },
        })
        emit("activities-updated")
    } catch (error) {
        console.error("Error updating billed status:", error)
    }
}

// Update disbursement status
const updateDisbursementStatus = async (activityId: number, disbursement: boolean) => {
    try {
        await updateActivityApi.put({
            params: { id: activityId },
            body: { disbursement },
        })
        emit("activities-updated")
    } catch (error) {
        console.error("Error updating disbursement status:", error)
    }
}

// Bulk update selected rows
const updateSelectedRows = async (field: "billed" | "disbursement", value: boolean) => {
    const promises = Array.from(selectedRows.value).map((id) =>
        updateActivityApi.put({
            params: { id },
            body: { [field]: value },
        })
    )

    try {
        await Promise.all(promises)
        emit("activities-updated")
        clearSelection()
    } catch (error) {
        console.error(`Error updating ${field} status:`, error)
    }
}

// Clear selection
const clearSelection = () => {
    selectedRows.value = new Set()
}

// Expose bulk update method for parent components
defineExpose({
    updateSelectedRows,
    selectedRows,
})
</script>
