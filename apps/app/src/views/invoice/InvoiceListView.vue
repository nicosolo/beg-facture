<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des factures</h1>
            <Button variant="primary" :to="{ name: 'invoice-new' }"> Nouvelle facture </Button>
        </div>

        <DataTable
            :items="invoices"
            :columns="columns"
            item-key="id"
            empty-message="Aucune facture trouvée"
        >
            <template #cell:client="{ item }">
                {{ item.client.name }}
            </template>

            <template #cell:totals="{ item }">
                {{ formatCurrency(item.totals.ttc) }}
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
                        :to="`/invoices/${item.id}`"
                        className="text-blue-600 hover:text-blue-900"
                    >
                        Voir
                    </Button>
                    <Button
                        variant="ghost"
                        size="sm"
                        :to="`/invoices/${item.id}/edit`"
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
import Badge from "../../components/atoms/Badge.vue"
import DataTable from "../../components/molecules/DataTable.vue"

interface InvoiceClient {
    name: string
    address: string
    city: string
    zipCode: string
    country: string
}

interface InvoiceTotals {
    ht: number
    vat: {
        rate: number
        amount: number
    }
    ttc: number
}

interface Invoice {
    id: string
    reference: string
    client: InvoiceClient
    date: string
    totals: InvoiceTotals
    status: string
}

const columns = [
    { key: "reference", label: "Référence" },
    { key: "client", label: "Client" },
    { key: "date", label: "Date" },
    { key: "totals", label: "Montant TTC" },
    { key: "status", label: "Statut" },
    { key: "actions", label: "Actions" },
]

const invoices = ref<Invoice[]>([
    {
        id: "1",
        reference: "5650 Cour de Gare - Sion",
        client: {
            name: "Comptoir Immobilier SA",
            address: "Cours de Rive 7",
            city: "Genève",
            zipCode: "1204",
            country: "Suisse",
        },
        date: "19.09.2023",
        totals: {
            ht: 15182.95,
            vat: { rate: 8.0, amount: 1214.65 },
            ttc: 16397.6,
        },
        status: "Payée",
    },
    {
        id: "2",
        reference: "2145 Résidence Les Alpes",
        client: {
            name: "Alpina Construction SA",
            address: "Rue du Mont-Blanc 14",
            city: "Lausanne",
            zipCode: "1000",
            country: "Suisse",
        },
        date: "05.03.2024",
        totals: {
            ht: 23450.75,
            vat: { rate: 8.0, amount: 1876.06 },
            ttc: 25326.81,
        },
        status: "En attente",
    },
    {
        id: "3",
        reference: "3789 Villa Moderna",
        client: {
            name: "Riviera Développement",
            address: "Avenue du Lac 28",
            city: "Montreux",
            zipCode: "1820",
            country: "Suisse",
        },
        date: "12.01.2024",
        totals: {
            ht: 8750.5,
            vat: { rate: 8.0, amount: 700.04 },
            ttc: 9450.54,
        },
        status: "Envoyée",
    },
    {
        id: "4",
        reference: "4230 Immeuble Les Cèdres",
        client: {
            name: "Foncière Suisse SA",
            address: "Boulevard des Philosophes 6",
            city: "Genève",
            zipCode: "1205",
            country: "Suisse",
        },
        date: "28.02.2024",
        totals: {
            ht: 12375.2,
            vat: { rate: 8.0, amount: 990.02 },
            ttc: 13365.22,
        },
        status: "Retard",
    },
    {
        id: "5",
        reference: "5112 Centre Commercial Léman",
        client: {
            name: "Retail Investment Group",
            address: "Quai du Mont-Blanc 15",
            city: "Genève",
            zipCode: "1201",
            country: "Suisse",
        },
        date: "10.03.2024",
        totals: {
            ht: 34280.6,
            vat: { rate: 8.0, amount: 2742.45 },
            ttc: 37023.05,
        },
        status: "Brouillon",
    },
])

const formatCurrency = (value: number): string => {
    return new Intl.NumberFormat("fr-CH", { style: "currency", currency: "CHF" }).format(value)
}

const getStatusVariant = (status: string): "success" | "error" | "warning" | "info" | undefined => {
    const variants = {
        paid: "success",
        pending: "warning",
        sent: "info",
        delayed: "error",
        draft: undefined,
    } as Record<string, "success" | "error" | "warning" | "info" | undefined>

    return variants[status]
}
</script>
