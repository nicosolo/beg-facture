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
                    required
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

            <!-- Period String -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoicePeriod">
                    Période (optionnel)
                </label>
                <input
                    id="invoicePeriod"
                    type="text"
                    v-model="invoice.period"
                    placeholder="Ex: Janvier 2025 - Mars 2025"
                    class="w-full p-2 border border-gray-300 rounded"
                />
            </div>

            <!-- Client Information -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceClientAddress">
                    Adresse de facturation (société)
                </label>
                <textarea
                    id="invoiceClientAddress"
                    v-model="invoice.clientAddress"
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

            <!-- Note -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceNote">
                    Note (optionnel)
                </label>
                <textarea
                    id="invoiceNote"
                    v-model="invoice.note"
                    rows="4"
                    placeholder="Note additionnelle pour la facture"
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
                    <option value="invoice">{{ $t("invoice.type.invoice") }}</option>
                    <option value="credit_note">{{ $t("invoice.type.credit_note") }}</option>
                    <option value="proforma">{{ $t("invoice.type.proforma") }}</option>
                    <option value="quote">{{ $t("invoice.type.quote") }}</option>
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
                    <option value="accordingToData">
                        {{ $t("invoice.billingMode.accordingToData") }}
                    </option>
                    <option value="accordingToInvoice">
                        {{ $t("invoice.billingMode.accordingToInvoice") }}
                    </option>
                    <option value="fixedPrice">{{ $t("invoice.billingMode.fixedPrice") }}</option>
                </select>
            </div>

            <!-- Recipient Information -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceRecipientAddress">
                    Adresse d'envoi de la facture
                </label>
                <textarea
                    id="invoiceRecipientAddress"
                    v-model="invoice.recipientAddress"
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
                            <tr v-for="(offer, index) in invoice.offers || []" :key="index">
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        :value="offer.file"
                                        @input="
                                            (e) =>
                                                updateOffer(
                                                    index,
                                                    'file',
                                                    (e.target as HTMLInputElement).value
                                                )
                                        "
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        :value="offer.date"
                                        @input="
                                            (e) =>
                                                updateOffer(
                                                    index,
                                                    'date',
                                                    (e.target as HTMLInputElement).value
                                                )
                                        "
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="number"
                                        :value="offer.amount"
                                        @input="
                                            (e) =>
                                                updateOffer(
                                                    index,
                                                    'amount',
                                                    parseFloat(
                                                        (e.target as HTMLInputElement).value
                                                    ) || 0
                                                )
                                        "
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        :value="offer.remark"
                                        @input="
                                            (e) =>
                                                updateOffer(
                                                    index,
                                                    'remark',
                                                    (e.target as HTMLInputElement).value
                                                )
                                        "
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
                                v-for="(adjudication, index) in invoice.adjudications || []"
                                :key="`adjudication-${index}`"
                            >
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        :value="adjudication.file"
                                        @input="
                                            (e) =>
                                                updateAdjudication(
                                                    index,
                                                    'file',
                                                    (e.target as HTMLInputElement).value
                                                )
                                        "
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        :value="adjudication.date"
                                        @input="
                                            (e) =>
                                                updateAdjudication(
                                                    index,
                                                    'date',
                                                    (e.target as HTMLInputElement).value
                                                )
                                        "
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="number"
                                        :value="adjudication.amount"
                                        @input="
                                            (e) =>
                                                updateAdjudication(
                                                    index,
                                                    'amount',
                                                    parseFloat(
                                                        (e.target as HTMLInputElement).value
                                                    ) || 0
                                                )
                                        "
                                        class="w-full p-1 border border-gray-300 rounded"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <input
                                        type="text"
                                        :value="adjudication.remark"
                                        @input="
                                            (e) =>
                                                updateAdjudication(
                                                    index,
                                                    'remark',
                                                    (e.target as HTMLInputElement).value
                                                )
                                        "
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
import { type Invoice } from "@beg/validations"
import { computed } from "vue"

// Helper functions for updating nested arrays
const updateOffer = (index: number, field: string, value: any) => {
    const newInvoice = { ...invoice.value }
    if (!newInvoice.offers) newInvoice.offers = []
    newInvoice.offers = [...newInvoice.offers]
    newInvoice.offers[index] = { ...newInvoice.offers[index], [field]: value }
    invoice.value = newInvoice
}

const updateAdjudication = (index: number, field: string, value: any) => {
    const newInvoice = { ...invoice.value }
    if (!newInvoice.adjudications) newInvoice.adjudications = []
    newInvoice.adjudications = [...newInvoice.adjudications]
    newInvoice.adjudications[index] = { ...newInvoice.adjudications[index], [field]: value }
    invoice.value = newInvoice
}

const props = defineProps<{
    modelValue: Invoice
}>()

const emit = defineEmits<{
    "update:modelValue": [value: Invoice]
}>()

const invoice = computed({
    get: () => props.modelValue,
    set: (value) => emit("update:modelValue", value),
})

const startDate = computed({
    get: () => invoice.value.periodStart?.toISOString().split("T")[0] || "",
    set: (value: string) => {
        const newInvoice = { ...invoice.value }
        newInvoice.periodStart = value ? new Date(value) : undefined
        invoice.value = newInvoice
    },
})

const endDate = computed({
    get: () => invoice.value.periodEnd?.toISOString().split("T")[0] || "",
    set: (value: string) => {
        const newInvoice = { ...invoice.value }
        newInvoice.periodEnd = value ? new Date(value) : undefined
        invoice.value = newInvoice
    },
})
</script>
