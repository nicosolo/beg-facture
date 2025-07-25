<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold">Liste des tarifs</h1>
                <Button variant="primary" :to="{ name: 'tariff-new' }"> Nouveau tarif </Button>
            </div>

            <DataTable
                :items="ratesData || []"
                :columns="columns"
                item-key="IDtarif"
                empty-message="Aucun tarif trouvé"
            >
                <template #cell:amount="{ item }">
                    {{ formatCurrency(item.amount) }}
                </template>

                <template #cell:actions="{ item }">
                    <div class="flex justify-end gap-2">
                        <Button
                            variant="ghost"
                            size="sm"
                            :to="{ name: 'tariff-edit', params: { id: item.id } }"
                            className="text-indigo-600 hover:text-indigo-900"
                        >
                            Modifier
                        </Button>
                        <Button
                            variant="ghost"
                            size="sm"
                            @click="deleteTariff(item.id)"
                            className="text-red-600 hover:text-red-900"
                            :disabled="deletingRate"
                        >
                            Supprimer
                        </Button>
                    </div>
                </template>
            </DataTable>
        </div>
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import { useFetchRates, useDeleteRate } from "@/composables/api/useRate"

interface Tariff {
    IDtarif: number
    Classe: string
    Année: number
    Tarif: number
}

// API client
const { get: fetchRates, loading, data: ratesData } = useFetchRates()
const { delete: deleteRate, loading: deletingRate } = useDeleteRate()

const columns = [
    { key: "id", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "class", label: "Classe" },
    { key: "year", label: "Année" },
    { key: "amount", label: "Tarif" },
    { key: "actions", label: "Actions" },
]

const tariffs = ref<Tariff[]>([])

// Load rates on mount
onMounted(async () => {
    await fetchRates({})
})

// Delete tariff
const deleteTariff = async (id: number) => {
    if (confirm("Êtes-vous sûr de vouloir supprimer ce tarif ?")) {
        try {
            await deleteRate({ params: { id } })
            await fetchRates() // Reload data
        } catch (error) {
            console.error("Error deleting rate:", error)
        }
    }
}

// Format currency
const formatCurrency = (value: number): string => {
    return new Intl.NumberFormat("fr-CH", {
        style: "currency",
        currency: "CHF",
        minimumFractionDigits: 0,
    }).format(value)
}
</script>
