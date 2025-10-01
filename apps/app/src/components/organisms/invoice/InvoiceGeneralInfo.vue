<template>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Left Column -->
        <div>
            <!-- Invoice Reference -->
            <div class="mb-4">
                <h3 class="text-sm font-medium text-gray-700 mb-1">Objet de la facture</h3>
                <Input v-model="invoice.reference" type="text" required />
            </div>
            <!-- Invoice Period -->
            <div class="mb-4">
                <h3 class="text-sm font-medium text-gray-700 mb-1">Période de facturation</h3>
                <div class="flex gap-2">
                    <Input
                        v-model="startDate"
                        type="date"
                        placeholder="Date début"
                        className="w-1/2"
                    />
                    <Input v-model="endDate" type="date" placeholder="Date fin" className="w-1/2" />
                </div>
            </div>

            <!-- Description -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceDescription">
                    Description des prestations
                </label>
                <Textarea id="invoiceDescription" v-model="invoice.description" :rows="6" />
            </div>

            <!-- Note -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceNote">
                    Note
                </label>
                <Textarea
                    id="invoiceNote"
                    v-model="invoice.note"
                    :rows="4"
                    placeholder="Note additionnelle pour la facture"
                />
            </div>
        </div>

        <!-- Right Column -->
        <div>
            <!-- Invoice Type and Billing Mode on same line -->
            <div class="grid grid-cols-2 gap-4 mb-4">
                <!-- Invoice Type -->
                <div>
                    <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceType">
                        Type de facture
                    </label>
                    <Select
                        id="invoiceType"
                        v-model="invoice.type"
                        :options="[
                            { value: 'invoice', label: $t('invoice.type.invoice') },
                            { value: 'credit_note', label: $t('invoice.type.credit_note') },
                            { value: 'proforma', label: $t('invoice.type.proforma') },
                            { value: 'quote', label: $t('invoice.type.quote') },
                        ]"
                    />
                </div>

                <!-- Billing mode -->
                <div>
                    <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceBillingMode">
                        Mode de facturation
                    </label>
                    <Select
                        id="invoiceBillingMode"
                        v-model="invoice.billingMode"
                        :options="[
                            {
                                value: 'accordingToData',
                                label: $t('invoice.billingMode.accordingToData'),
                            },
                            {
                                value: 'accordingToOffer',
                                label: $t('invoice.billingMode.accordingToOffer'),
                            },
                            {
                                value: 'accordingToInvoice',
                                label: $t('invoice.billingMode.accordingToInvoice'),
                            },
                            { value: 'fixedPrice', label: $t('invoice.billingMode.fixedPrice') },
                        ]"
                    />
                    <div v-if="invoice.billingMode === 'accordingToInvoice'" class="mt-4">
                        <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceDocument">
                            {{ $t("invoice.document.label") }}
                        </label>
                        <input
                            id="invoiceDocument"
                            ref="invoiceDocumentInput"
                            type="file"
                            class="block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer focus:outline-none focus:ring-2 focus:ring-blue-500"
                            accept=".pdf,.doc,.docx,.xls,.xlsx"
                            :required="invoice.billingMode === 'accordingToInvoice'"
                            @change="handleInvoiceDocumentChange"
                        />
                        <p class="mt-1 text-xs text-gray-500">
                            {{ $t("invoice.document.helper") }}
                        </p>
                        <div
                            v-if="invoice.invoiceDocument"
                            class="mt-2 flex items-center justify-between rounded border border-blue-100 bg-blue-50 px-3 py-2 text-sm text-blue-700"
                        >
                            <span class="truncate">
                                {{ invoice.invoiceDocument }}
                            </span>
                            <button
                                type="button"
                                class="ml-3 text-xs font-medium text-blue-700 hover:underline"
                                @click="clearInvoiceDocument"
                            >
                                {{ $t("invoice.document.clear") }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Invoice Status -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceStatus">
                    {{ $t("invoice.status.title") }}
                </label>
                <Select
                    id="invoiceStatus"
                    v-model="invoice.status"
                    :options="[
                        { value: 'draft', label: $t('invoice.status.draft') },
                        { value: 'controle', label: $t('invoice.status.controle') },
                        { value: 'sent', label: $t('invoice.status.sent') },
                        { value: 'paid', label: $t('invoice.status.paid') },
                        { value: 'overdue', label: $t('invoice.status.overdue') },
                        { value: 'cancelled', label: $t('invoice.status.cancelled') },
                    ]"
                />
            </div>
            <!-- Period String -->
            <div class="mb-4">
                <label class="text-sm font-medium text-gray-700 mb-1" for="invoicePeriod">
                    Période
                </label>
                <Input
                    id="invoicePeriod"
                    v-model="invoice.period"
                    type="text"
                    placeholder="Ex: Janvier 2025 - Mars 2025"
                    required
                />
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
                                    <Input
                                        :modelValue="offer.file"
                                        @update:modelValue="
                                            (value) => updateOffer(index, 'file', value)
                                        "
                                        type="text"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <Input
                                        :modelValue="offer.date"
                                        @update:modelValue="
                                            (value) => updateOffer(index, 'date', value)
                                        "
                                        type="text"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <Input
                                        :modelValue="String(offer.amount || '')"
                                        @update:modelValue="
                                            (value) =>
                                                updateOffer(index, 'amount', parseFloat(value) || 0)
                                        "
                                        type="number"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <Input
                                        :modelValue="offer.remark"
                                        @update:modelValue="
                                            (value) => updateOffer(index, 'remark', value)
                                        "
                                        type="text"
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
                                    <Input
                                        :modelValue="adjudication.file"
                                        @update:modelValue="
                                            (value) => updateAdjudication(index, 'file', value)
                                        "
                                        type="text"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <Input
                                        :modelValue="adjudication.date"
                                        @update:modelValue="
                                            (value) => updateAdjudication(index, 'date', value)
                                        "
                                        type="text"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <Input
                                        :modelValue="String(adjudication.amount || '')"
                                        @update:modelValue="
                                            (value) =>
                                                updateAdjudication(
                                                    index,
                                                    'amount',
                                                    parseFloat(value) || 0
                                                )
                                        "
                                        type="number"
                                    />
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-900">
                                    <Input
                                        :modelValue="adjudication.remark"
                                        @update:modelValue="
                                            (value) => updateAdjudication(index, 'remark', value)
                                        "
                                        type="text"
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

    <!-- Addresses Section - Full Width -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
        <!-- Client Information -->
        <div>
            <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceClientAddress">
                Adresse de facturation (société)
            </label>
            <Textarea
                id="invoiceClientAddress"
                v-model="invoice.clientAddress"
                :rows="4"
                placeholder="Adresse de facturation (société)"
            />
        </div>

        <!-- Recipient Information -->
        <div>
            <label class="text-sm font-medium text-gray-700 mb-1" for="invoiceRecipientAddress">
                Adresse d'envoi de la facture
            </label>
            <Textarea
                id="invoiceRecipientAddress"
                v-model="invoice.recipientAddress"
                :rows="4"
                placeholder="Adresse d'envoi de la facture"
            />
        </div>
    </div>
</template>

<script setup lang="ts">
import { type Invoice } from "@beg/validations"
import { computed, ref, watch } from "vue"
import Input from "@/components/atoms/Input.vue"
import Select from "@/components/atoms/Select.vue"
import Textarea from "@/components/atoms/Textarea.vue"

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

const invoiceDocumentInput = ref<HTMLInputElement | null>(null)

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

const handleInvoiceDocumentChange = (event: Event) => {
    const target = event.target as HTMLInputElement
    const file = target.files?.[0]
    const updatedInvoice = {
        ...invoice.value,
        invoiceDocument: file ? file.name : "",
    }
    invoice.value = updatedInvoice
}

const clearInvoiceDocument = () => {
    if (!invoice.value.invoiceDocument) return
    invoice.value = {
        ...invoice.value,
        invoiceDocument: "",
    }
    if (invoiceDocumentInput.value) {
        invoiceDocumentInput.value.value = ""
    }
}

watch(
    () => invoice.value.billingMode,
    (mode) => {
        if (mode !== "accordingToInvoice" && invoice.value.invoiceDocument) {
            invoice.value = {
                ...invoice.value,
                invoiceDocument: "",
            }
            if (invoiceDocumentInput.value) {
                invoiceDocumentInput.value.value = ""
            }
        }
    }
)
</script>
