<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des factures</h1>
            <Button variant="primary" :to="{ name: 'invoice-new' }"> Nouvelle facture </Button>
        </div>

        <div v-if="error" class="mb-4 p-4 bg-red-100 text-red-700 rounded">
            Erreur lors du chargement des factures: {{ error }}
        </div>

        <DataTable
            :items="invoices"
            :columns="columns"
            item-key="id"
            empty-message="Aucune facture trouvée"
            :loading="loading"
        >
            <template #cell:client="{ item }">
                {{ item.clientName || item.client?.name || item.project?.client?.name || "-" }}
            </template>

            <template #cell:createdAt="{ item }">
                {{ formatDate(item.createdAt) }}
            </template>

            <template #cell:totals="{ item }">
                {{ formatCurrency(item.total) }}
            </template>

            <template #cell:status="{ item }">
                <Badge :variant="getStatusVariant(item.status)">
                    {{ item.status }}
                </Badge>
            </template>

            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <Button
                        variant="ghost"
                        size="sm"
                        :to="`/invoice/${item.id}/preview`"
                        className="text-blue-600 hover:text-blue-900"
                    >
                        Voir
                    </Button>
                    <Button
                        variant="ghost"
                        size="sm"
                        :to="`/invoice/${item.id}/edit`"
                        className="text-indigo-600 hover:text-indigo-900"
                    >
                        Modifier
                    </Button>
                    <Button
                        variant="ghost"
                        size="sm"
                        @click="handleDelete(item.id)"
                        className="text-red-600 hover:text-red-900"
                        :disabled="deleteLoading"
                    >
                        Supprimer
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
            @prev="currentPage > 1 && currentPage--"
            @next="currentPage < totalPages && currentPage++"
            @go-to="(page) => (currentPage = page)"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import Button from "../../components/atoms/Button.vue"
import Badge from "../../components/atoms/Badge.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import Pagination from "../../components/organisms/Pagination.vue"
import { useFetchInvoiceList, useDeleteInvoice } from "../../composables/api/useInvoice"

const columns = [
    { key: "reference", label: "Référence", width: "w-1/3" },
    { key: "client", label: "Client" },
    { key: "createdAt", label: "Date" },
    { key: "totals", label: "Montant TTC" },
    { key: "status", label: "Statut" },
    { key: "actions", label: "Actions" },
]

const { get: fetchInvoices, loading, error, data: invoicesData } = useFetchInvoiceList()
const { delete: deleteInvoice, loading: deleteLoading } = useDeleteInvoice()

const invoices = computed(() => invoicesData.value?.data || [])
const totalCount = computed(() => invoicesData.value?.total || 0)
const totalPages = computed(
    () => invoicesData.value?.totalPages || Math.ceil(totalCount.value / itemsPerPage.value)
)

// Pagination state
const currentPage = ref(1)
const itemsPerPage = ref(10)

// Load invoices
const loadInvoices = async () => {
    try {
        await fetchInvoices({
            query: {
                page: currentPage.value,
                limit: itemsPerPage.value,
            },
        })
    } catch (err) {
        console.error("Failed to load invoices:", err)
    }
}

// Watch pagination changes
watch([currentPage, itemsPerPage], () => {
    loadInvoices()
})

// Delete invoice
const handleDelete = async (id: number) => {
    if (!confirm("Êtes-vous sûr de vouloir supprimer cette facture ?")) {
        return
    }

    try {
        await deleteInvoice({ params: { id } })
        await loadInvoices() // Reload the list
    } catch (err) {
        console.error("Failed to delete invoice:", err)
        alert("Erreur lors de la suppression de la facture")
    }
}

onMounted(() => {
    loadInvoices()
})

const formatCurrency = (value: number): string => {
    return new Intl.NumberFormat("fr-CH", { style: "currency", currency: "CHF" }).format(value)
}

const formatDate = (value: string | Date): string => {
    if (!value) return "-"
    const date = typeof value === "string" ? new Date(value) : value
    return new Intl.DateTimeFormat("fr-CH").format(date)
}

const getStatusVariant = (status: string): "success" | "error" | "warning" | "info" | undefined => {
    const variants = {
        paid: "success",
        pending: "warning",
        sent: "info",
        overdue: "error",
        draft: undefined,
    } as Record<string, "success" | "error" | "warning" | "info" | undefined>

    return variants[status] || undefined
}
</script>
