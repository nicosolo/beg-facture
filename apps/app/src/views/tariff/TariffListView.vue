<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des tarifs</h1>
            <Button variant="primary" :to="{ name: 'tariff-new' }"> Nouveau tarif </Button>
        </div>

        <DataTable
            :items="tariffs"
            :columns="columns"
            item-key="IDtarif"
            empty-message="Aucun tarif trouvé"
        >
            <template #cell:tarif="{ item }">
                {{ formatCurrency(item.Tarif) }}
            </template>

            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <Button
                        variant="ghost"
                        size="sm"
                        :to="{ name: 'tariff-edit', params: { id: item.IDtarif } }"
                        className="text-indigo-600 hover:text-indigo-900"
                    >
                        Modifier
                    </Button>
                </div>
            </template>
        </DataTable>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"

interface Tariff {
    IDtarif: number
    Classe: string
    Année: number
    Tarif: number
}

const columns = [
    { key: "IDtarif", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "Classe", label: "Classe" },
    { key: "Année", label: "Année" },
    { key: "tarif", label: "Tarif" },
    { key: "actions", label: "Actions" },
]

// Sample data for tariffs
const tariffs = ref<Tariff[]>([
    { IDtarif: 21, Classe: "A", Année: 2000, Tarif: 175 },
    { IDtarif: 30, Classe: "A", Année: 2001, Tarif: 180 },
    { IDtarif: 39, Classe: "A", Année: 2002, Tarif: 180 },
    { IDtarif: 48, Classe: "A", Année: 2003, Tarif: 180 },
    { IDtarif: 57, Classe: "A", Année: 2004, Tarif: 180 },
    { IDtarif: 66, Classe: "A", Année: 2005, Tarif: 195 },
    { IDtarif: 75, Classe: "A", Année: 2006, Tarif: 195 },
    { IDtarif: 84, Classe: "A", Année: 2007, Tarif: 200 },
    { IDtarif: 93, Classe: "A", Année: 2008, Tarif: 200 },
])

// Format currency
const formatCurrency = (value: number): string => {
    return new Intl.NumberFormat("fr-CH", { style: "currency", currency: "CHF" }).format(value)
}
</script>
