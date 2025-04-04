<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des factures</h1>
            <Button variant="primary" :to="'/invoices/new'"> Nouvelle facture </Button>
        </div>

        <div class="bg-white shadow-md rounded-lg overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th
                                scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Référence
                            </th>
                            <th
                                scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Client
                            </th>
                            <th
                                scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Date
                            </th>
                            <th
                                scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Montant TTC
                            </th>
                            <th
                                scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Statut
                            </th>
                            <th
                                scope="col"
                                class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider"
                            >
                                Actions
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="invoice in invoices" :key="invoice.id" class="hover:bg-gray-50">
                            <td
                                class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                            >
                                {{ invoice.reference }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ invoice.client.name }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ invoice.date }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ formatCurrency(invoice.totals.ttc) }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <Badge :variant="getStatusVariant(invoice.status)">
                                    {{ invoice.status }}
                                </Badge>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <div class="flex justify-end gap-2">
                                    <Button
                                        variant="ghost"
                                        size="sm"
                                        :to="`/invoices/${invoice.id}`"
                                        className="text-blue-600 hover:text-blue-900"
                                    >
                                        Voir
                                    </Button>
                                    <Button
                                        variant="ghost"
                                        size="sm"
                                        :to="`/invoices/${invoice.id}/edit`"
                                        className="text-indigo-600 hover:text-indigo-900"
                                    >
                                        Modifier
                                    </Button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import Button from "../../components/atoms/Button.vue"
import Badge from "../../components/atoms/Badge.vue"

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
