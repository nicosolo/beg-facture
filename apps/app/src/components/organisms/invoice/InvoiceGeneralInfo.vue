<template>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Left Column -->
        <div>
            <!-- Invoice Reference -->
            <div class="mb-4">
                <h3 class="text-sm font-medium text-gray-700 mb-1">Objet de la facture</h3>
                <input
                    type="text"
                    v-model="invoice.reference"
                    class="w-full p-2 border border-gray-300 rounded"
                />
            </div>
            <!-- Invoice Period -->
            <div class="mb-4">
                <h3 class="text-sm font-medium text-gray-700 mb-1">Période de facturation</h3>
                <div class="flex gap-2">
                    <input
                        type="date"
                        v-model="startDate"
                        placeholder="Date début"
                        class="w-1/2 p-2 border border-gray-300 rounded"
                    />
                    <input
                        type="date"
                        v-model="endDate"
                        placeholder="Date fin"
                        class="w-1/2 p-2 border border-gray-300 rounded"
                    />
                </div>
            </div>

            <!-- Client Information -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceClientAddress">
                    Adresse de facturation (société)
                </label>
                <textarea
                    id="invoiceClientAddress"
                    v-model="invoice.client.address"
                    rows="4"
                    placeholder="Adresse de facturation (société)"
                    class="w-full p-2 border border-gray-300 rounded"
                ></textarea>
            </div>

            <!-- Description -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceDescription">
                    Description des prestations
                </label>
                <textarea
                    id="invoiceDescription"
                    v-model="invoice.description"
                    rows="6"
                    class="w-full p-2 border border-gray-300 rounded"
                ></textarea>
            </div>
        </div>

        <!-- Right Column -->
        <div>
            <!-- Invoice Type -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceType">
                    Type de facture
                </label>
                <select
                    id="invoiceType"
                    v-model="invoice.type"
                    class="w-full p-2 border border-gray-300 rounded"
                >
                    <option value="Facture finale">Facture finale</option>
                    <option value="Facture">Facture</option>
                    <option value="Situation">Situation</option>
                    <option value="Acompte">Acompte</option>
                </select>
            </div>

            <!-- Billing mode -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceBillingMode">
                    Mode de facturation
                </label>
                <select
                    id="invoiceBillingMode"
                    class="w-full p-2 border border-gray-300 rounded"
                    v-model="invoice.billingMode"
                >
                    <option :value="BILLING_MODE_KEYS.ACCORDING_TO_DATA">
                        {{ BILLING_MODE_LABELS[BILLING_MODE_KEYS.ACCORDING_TO_DATA] }}
                    </option>
                    <option :value="BILLING_MODE_KEYS.ACCORDING_TO_INVOICE">
                        {{ BILLING_MODE_LABELS[BILLING_MODE_KEYS.ACCORDING_TO_INVOICE] }}
                    </option>
                    <option :value="BILLING_MODE_KEYS.FIXED_PRICE">
                        {{ BILLING_MODE_LABELS[BILLING_MODE_KEYS.FIXED_PRICE] }}
                    </option>
                </select>
            </div>

            <!-- Recipient Information -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceRecipientAddress">
                    Adresse d'envoi de la facture
                </label>
                <textarea
                    id="invoiceRecipientAddress"
                    v-model="invoice.recipient.address"
                    placeholder="Adresse d'envoi de la facture"
                    rows="4"
                    class="w-full p-2 border border-gray-300 rounded"
                ></textarea>
            </div>

            <!-- Offers -->
            <div class="mb-4">
                <h3 class="text-sm font-medium text-gray-700 mb-1">Offres</h3>
                <div class="border border-gray-300 rounded">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Fichier
                                </th>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Date
                                </th>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Montant
                                </th>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Remarque
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr v-for="(offer, index) in invoice.offers" :key="index">
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        v-model="offer.file"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        v-model="offer.date"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="number"
                                        v-model="offer.amount"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        v-model="offer.remark"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="p-2">
                        <button
                            class="px-2 py-1 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 text-sm"
                        >
                            + Ajouter une offre
                        </button>
                    </div>
                </div>
            </div>

            <!-- Adjudications -->
            <div class="mb-4">
                <h3 class="text-sm font-medium text-gray-700 mb-1">Adjudications</h3>
                <div class="border border-gray-300 rounded">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Fichier
                                </th>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Date
                                </th>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Montant
                                </th>
                                <th
                                    class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase"
                                >
                                    Remarque
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr
                                v-for="(adjudication, index) in invoice.adjudications"
                                :key="`adjudication-${index}`"
                            >
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        v-model="adjudication.file"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        v-model="adjudication.date"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="number"
                                        v-model="adjudication.amount"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        v-model="adjudication.remark"
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="p-2">
                        <button
                            class="px-2 py-1 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 text-sm"
                        >
                            + Ajouter une adjudication
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { type Invoice, BILLING_MODE_KEYS, BILLING_MODE_LABELS } from "@beg/validations"
import { computed } from "vue"

const { invoice } = defineProps<{
    invoice: Invoice
}>()

const startDate = computed({
    get: () => invoice.period.startDate?.toISOString().split("T")[0],
    set: (value: Date) => {
        invoice.period.startDate = value
    },
})

const endDate = computed({
    get: () => invoice.period.endDate?.toISOString().split("T")[0],
    set: (value: Date) => {
        invoice.period.endDate = value
    },
})
</script>
