<template>
    <div>
        <div class="mb-4" v-if="!hideHeader">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between mb-4">
                <h2 class="text-lg font-semibold">{{ $t("invoice.title") }}</h2>
                <Button
                    variant="primary"
                    size="md"
                    class="w-full sm:w-auto"
                    :to="{ name: 'invoice-new', query: { projectId: initialFilter?.projectId } }"
                >
                    {{ $t("invoice.new") }}
                </Button>
            </div>
        </div>

        <LoadingOverlay :loading="loading">
            <div v-if="error" class="mb-4 p-4 bg-red-100 text-red-700 rounded">
                {{ $t("errors.loadingData") }}: {{ error }}
            </div>

            <DataTable
                :items="invoices"
                :columns="visibleColumns"
                item-key="id"
                :empty-message="emptyMessage"
                :loading="loading"
            >
                <template #cell:invoiceNumber="{ item }">
                    {{ item.invoiceNumber || item.reference || "-" }}
                </template>
                <template #cell:client="{ item }">
                    {{ item.project?.client?.name }}
                </template>
                <template #cell:project="{ item }">
                    {{ item.project?.projectNumber
                    }}{{ item.project?.subProjectName ? ` ${item.project.subProjectName}` : "" }} -
                    {{ item.project?.name }}
                </template>

                <template #cell:issueDate="{ item }">
                    {{ formatDate(item.issueDate) }}
                </template>

                <template #cell:totalTTC="{ item }">
                    {{ formatCurrency(item.totalTTC) }}
                </template>

                <template #cell:status="{ item }">
                    <Badge :variant="getStatusVariant(item.status)">
                        {{ $t(`invoice.status.${item.status}`) }}
                    </Badge>
                </template>

                <template #cell:actions="{ item }">
                    <div class="flex justify-end gap-2">
                        <Button
                            variant="primary"
                            size="sm"
                            :to="{ name: 'invoice-preview', params: { id: item.id } }"
                        >
                            {{ $t("common.view") }}
                        </Button>
                        <Button
                            variant="ghost-primary"
                            size="sm"
                            :to="{ name: 'invoice-edit', params: { id: item.id } }"
                        >
                            {{ $t("common.edit") }}
                        </Button>
                    </div>
                </template>
            </DataTable>

            <Pagination
                v-if="totalCount > 0"
                :current-page="currentPage"
                :total-pages="totalPages"
                :total-items="totalCount"
                :page-size="itemsPerPage"
                @prev="currentPage > 1 && loadInvoices(currentPage - 1)"
                @next="currentPage < totalPages && loadInvoices(currentPage + 1)"
                @go-to="loadInvoices"
            />
        </LoadingOverlay>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useI18n } from "vue-i18n"
import Button from "@/components/atoms/Button.vue"
import Badge from "@/components/atoms/Badge.vue"
import DataTable from "@/components/molecules/DataTable.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import { useFetchInvoiceList } from "@/composables/api/useInvoice"
import { useAlert } from "@/composables/utils/useAlert"
import type { InvoiceFilter } from "@beg/validations"

interface Props {
    emptyMessage?: string
    showProjectFilter?: boolean
    initialFilter?: Partial<InvoiceFilter>
    hideColumns?: string[]
    hideHeader?: boolean
    showDelete?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    emptyMessage: "Aucune facture trouvée",
    showProjectFilter: true,
    hideHeader: false,
    showDelete: true,
})

const { t } = useI18n()
const { errorAlert } = useAlert()

// Define all possible columns
const allColumns = [
    { key: "invoiceNumber", label: t("invoice.invoiceNumber"), width: "w-1/6" },
    { key: "client", label: t("projects.client"), width: "w-1/6" },
    { key: "project", label: t("projects.title"), width: "w-1/6" },
    { key: "issueDate", label: t("invoice.issueDate") },
    { key: "totalTTC", label: t("invoice.totalTTC") },
    { key: "status", label: t("invoice.status.title") },
    { key: "actions", label: t("common.actions") },
]

// Compute visible columns based on hideColumns prop
const visibleColumns = computed(() => {
    return allColumns.filter((col) => !props.hideColumns?.includes(col.key))
})

const { get: fetchInvoices, loading, error, data: invoicesData } = useFetchInvoiceList()

const invoices = computed(() => invoicesData.value?.data || [])
const totalCount = computed(() => invoicesData.value?.total || 0)
const totalPages = computed(
    () => invoicesData.value?.totalPages || Math.ceil(totalCount.value / itemsPerPage.value)
)

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)

// Load invoices
const loadInvoices = async (page?: number) => {
    if (page) currentPage.value = page

    try {
        await fetchInvoices({
            query: {
                page: currentPage.value,
                limit: itemsPerPage.value,
                ...props.initialFilter,
            },
        })
    } catch (err) {
        console.error("Failed to load invoices:", err)
        errorAlert(t("errors.loadingData"))
    }
}

// Load initial data
onMounted(() => {
    loadInvoices()
})

// Formatting functions
const formatCurrency = (value: number): string => {
    return new Intl.NumberFormat("fr-CH", { style: "currency", currency: "CHF" }).format(value)
}

const formatDate = (value: string | Date | null): string => {
    if (!value) return "-"
    const date = typeof value === "string" ? new Date(value) : value
    return new Intl.DateTimeFormat("fr-CH").format(date)
}

const getStatusVariant = (status: string): "success" | "error" | "warning" | "info" | undefined => {
    const variants = {
        sent: "info",
        draft: undefined,
        controle: "warning",
    } as Record<string, "success" | "error" | "warning" | "info" | undefined>

    return variants[status] || undefined
}

// Expose methods that parent components might need
defineExpose({
    loadInvoices,
})
</script>
