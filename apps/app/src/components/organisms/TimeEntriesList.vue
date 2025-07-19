<template>
    <div>
        <DataTable
            showFooter
            :items="activities"
            :columns="columns"
            item-key="id"
            :empty-message="emptyMessage"
            :sort="sort"
            @sort-change="handleSort"
        >
            <template #cell:user="{ item }">
                {{ item.user ? `${item.user.initials}` : "-" }}
            </template>

            <template #cell:project="{ item }">
                <div class="flex flex-col">
                    <span class="font-medium">{{ item.project?.projectNumber }}</span>
                    <span class="text-sm text-gray-600">{{ item.project?.name }}</span>
                </div>
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

            <template #cell:status="{ item }">
                <Badge :variant="item.billed ? 'success' : 'warning'">
                    {{ item.billed ? $t("time.status.billed") : $t("time.status.unbilled") }}
                </Badge>
                <Badge v-if="item.disbursement" variant="info" class="ml-1">
                    {{ $t("time.status.disbursement") }}
                </Badge>
            </template>

            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <slot name="actions" :item="item">
                        <Button
                            variant="ghost"
                            size="sm"
                            :to="{ name: editRoute, params: { id: item.id } }"
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
import { computed } from "vue"
import { useI18n } from "vue-i18n"
import DataTable, { type Column } from "../molecules/DataTable.vue"
import Badge from "../atoms/Badge.vue"
import Button from "../atoms/Button.vue"
import { useFormat } from "@/composables/utils/useFormat"
import type { ActivityResponse } from "@beg/validations"

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
}>()

const defaultColumns: Column[] = [
    { key: "date", label: t("time.columns.date"), sortKey: "date", width: "7rem" },
    { key: "user", label: t("time.columns.user"), width: "7rem" },
    { key: "project", label: t("time.columns.project"), width: "7rem" },
    { key: "activityType", label: t("time.columns.activityType"), width: "7rem" },
    { key: "duration", label: t("time.columns.duration"), sortKey: "duration", width: "7rem" },
    {
        key: "kilometers",
        label: t("time.columns.kilometers"),
        sortKey: "kilometers",
        width: "4rem",
    },
    { key: "expenses", label: t("time.columns.expenses"), sortKey: "expenses", width: "4rem" },
    { key: "description", label: t("time.columns.description") },
    { key: "status", label: t("time.columns.status"), width: "4rem" },
    { key: "actions", label: t("common.actions"), actions: true, width: "4rem" },
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
</script>
