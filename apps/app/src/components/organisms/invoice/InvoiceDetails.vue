<template>
    <div class="flex flex-wrap lg:flex-nowrap gap-4">
        <div class="w-full lg:w-2/3">
            <section class="mb-8">
                <h2 class="text-lg font-medium mb-4 bg-gray-100 p-2 text-center">HONORAIRES</h2>
                <div class="border border-gray-200 rounded overflow-x-scroll">
                    <table class="w-full divide-y divide-gray-200 text-left min-w-[600px]">
                        <thead class="bg-gray-50">
                            <tr>
                                <th
                                    class="px-4 py-2 text-xs font-medium text-gray-500 uppercase"
                                ></th>
                                <th
                                    class="px-4 py-2 text-xs font-medium text-gray-500 uppercase"
                                ></th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    base
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    corrigé
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Tarif
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Montant
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200 text-sm">
                            <tr v-for="(rate, index) in rates" :key="index">
                                <td class="px-4 py-2 text-gray-800">{{ rate.rateClass }}</td>
                                <td class="px-4 py-2 text-gray-600">{{ rate.rateClass }}</td>
                                <td class="px-4 py-2">
                                    <span>{{ formatDuration(rate.base) }}</span>
                                </td>
                                <td class="px-4 py-2">
                                    <InputNumber
                                        :modelValue="rate.adjusted"
                                        @update:modelValue="
                                            (value) => updateRate(index, 'adjusted', value)
                                        "
                                        class="w-24"
                                    />
                                </td>
                                <td class="px-4 py-2">
                                    <InputNumber
                                        :modelValue="rate.hourlyRate"
                                        @update:modelValue="
                                            (value) => updateRate(index, 'hourlyRate', value)
                                        "
                                        :currency="true"
                                        class="w-24"
                                    />
                                </td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(rate.amount || 0) }}
                                </td>
                            </tr>
                            <tr class="font-medium">
                                <td class="px-4 py-2">TOTAL HONORAIRES</td>
                                <td class="px-4 py-2"></td>
                                <td class="px-4 py-2">{{ formatDuration(feesBase) }}</td>
                                <td class="px-4 py-2">{{ formatDuration(feesAdjusted) }}</td>
                                <td class="px-4 py-2"></td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(feesTotal) }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- Discount Section -->
                <div class="mt-4 p-4 bg-gray-50 rounded">
                    <div class="flex items-center justify-between">
                        <label class="flex items-center gap-2">
                            <input
                                type="checkbox"
                                :checked="hasDiscount"
                                @change="toggleDiscount"
                                class="h-4 w-4"
                            />
                            <span class="text-sm font-medium">Appliquer une remise</span>
                        </label>
                    </div>
                    <div v-if="hasDiscount" class="mt-3 space-y-3">
                        <!-- Discount type selection -->
                        <div class="flex gap-4">
                            <label class="flex items-center gap-2">
                                <input
                                    type="radio"
                                    name="discountType"
                                    value="percentage"
                                    :checked="discountType === 'percentage'"
                                    @change="setDiscountType('percentage')"
                                    class="h-4 w-4"
                                />
                                <span class="text-sm">Pourcentage</span>
                            </label>
                            <label class="flex items-center gap-2">
                                <input
                                    type="radio"
                                    name="discountType"
                                    value="fixed"
                                    :checked="discountType === 'fixed'"
                                    @change="setDiscountType('fixed')"
                                    class="h-4 w-4"
                                />
                                <span class="text-sm">Au forfait</span>
                            </label>
                        </div>
                        <!-- Input based on type -->
                        <div class="flex items-center gap-2">
                            <InputNumber
                                v-if="discountType === 'percentage'"
                                :modelValue="discountPercentage"
                                @update:modelValue="updateDiscountPercentage"
                                :min="0"
                                :max="100"
                                :step="1"
                                class="w-24"
                            />
                            <span v-if="discountType === 'percentage'" class="text-sm">%</span>
                            <InputNumber
                                v-if="discountType === 'fixed'"
                                :modelValue="discountAmount"
                                @update:modelValue="updateDiscountAmount"
                                :min="0"
                                :step="100"
                                class="w-32"
                            />
                            <span v-if="discountType === 'fixed'" class="text-sm">CHF</span>
                        </div>
                        <div class="text-sm text-gray-600">
                            Montant de la remise: {{ formatCurrency(discountAmount) }}
                        </div>
                    </div>
                </div>
            </section>

            <!-- FRAIS Section -->
            <section class="mb-8">
                <h2 class="text-lg font-medium mb-4 bg-gray-100 p-2 text-center">FRAIS</h2>
                <div class="border border-gray-200 rounded overflow-x-scroll">
                    <table class="w-full divide-y divide-gray-200 text-left min-w-[600px]">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Type
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Base
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Corrigé
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Taux/Montant
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Total
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200 text-sm">
                            <!-- Travel expenses (kilometers) -->
                            <tr>
                                <td class="px-4 py-2">Déplacements (km)</td>
                                <td class="px-4 py-2">{{ invoice.expensesTravelBase || 0 }} km</td>
                                <td class="px-4 py-2">
                                    <InputNumber
                                        :modelValue="invoice.expensesTravelAdjusted || 0"
                                        @update:modelValue="
                                            updateExpense('expensesTravelAdjusted', $event)
                                        "
                                        :step="1"
                                        class="w-24"
                                    />
                                    <span class="ml-1">km</span>
                                </td>
                                <td class="px-4 py-2">
                                    <InputNumber
                                        :modelValue="invoice.expensesTravelRate || 0.65"
                                        @update:modelValue="
                                            updateExpense('expensesTravelRate', $event)
                                        "
                                        :step="0.01"
                                        :currency="true"
                                        class="w-24"
                                    />
                                    <span class="ml-1">CHF/km</span>
                                </td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(invoice.expensesTravelAmount || 0) }}
                                </td>
                            </tr>
                            <!-- Other expenses -->
                            <tr>
                                <td class="px-4 py-2">Autres frais</td>
                                <td class="px-4 py-2">
                                    {{ formatCurrency(invoice.expensesOtherBase || 0) }}
                                </td>
                                <td class="px-4 py-2" colspan="2">
                                    <InputNumber
                                        :modelValue="invoice.expensesOtherAmount || 0"
                                        @update:modelValue="
                                            updateExpense('expensesOtherAmount', $event)
                                        "
                                        :currency="true"
                                        class="w-32"
                                    />
                                </td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(invoice.expensesOtherAmount || 0) }}
                                </td>
                            </tr>
                            <!-- Third-party expenses -->
                            <tr>
                                <td class="px-4 py-2">Frais tiers</td>
                                <td class="px-4 py-2" colspan="3">
                                    <InputNumber
                                        :modelValue="invoice.expensesThirdPartyAmount || 0"
                                        @update:modelValue="
                                            updateExpense('expensesThirdPartyAmount', $event)
                                        "
                                        :currency="true"
                                        class="w-32"
                                    />
                                </td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(invoice.expensesThirdPartyAmount || 0) }}
                                </td>
                            </tr>
                            <!-- Package option -->
                            <tr>
                                <td class="px-4 py-2" colspan="5">
                                    <div class="space-y-2">
                                        <label class="flex items-center gap-2">
                                            <input
                                                type="checkbox"
                                                :checked="hasPackage"
                                                @change="togglePackage"
                                                class="h-4 w-4"
                                            />
                                            <span>Forfait frais</span>
                                        </label>
                                        <div v-if="hasPackage" class="pl-6 space-y-2">
                                            <!-- Package type selection -->
                                            <div class="flex gap-4">
                                                <label class="flex items-center gap-2">
                                                    <input
                                                        type="radio"
                                                        name="packageType"
                                                        value="percentage"
                                                        :checked="packageType === 'percentage'"
                                                        @change="setPackageType('percentage')"
                                                        class="h-4 w-4"
                                                    />
                                                    <span class="text-sm">Pourcentage</span>
                                                </label>
                                                <label class="flex items-center gap-2">
                                                    <input
                                                        type="radio"
                                                        name="packageType"
                                                        value="fixed"
                                                        :checked="packageType === 'fixed'"
                                                        @change="setPackageType('fixed')"
                                                        class="h-4 w-4"
                                                    />
                                                    <span class="text-sm">Au forfait</span>
                                                </label>
                                            </div>
                                            <!-- Input based on type -->
                                            <div class="flex items-center gap-2">
                                                <InputNumber
                                                    v-if="packageType === 'percentage'"
                                                    :modelValue="invoice.expensesPackagePercentage || 0"
                                                    @update:modelValue="updatePackagePercentage"
                                                    :min="0"
                                                    :max="100"
                                                    :step="1"
                                                    class="w-20"
                                                />
                                                <span v-if="packageType === 'percentage'">% des honoraires</span>
                                                <InputNumber
                                                    v-if="packageType === 'fixed'"
                                                    :modelValue="invoice.expensesPackageAmount || 0"
                                                    @update:modelValue="updatePackageAmount"
                                                    :min="0"
                                                    :step="100"
                                                    class="w-32"
                                                />
                                                <span v-if="packageType === 'fixed'">CHF</span>
                                            </div>
                                            <div class="text-sm text-gray-600">
                                                Montant forfait: {{ formatCurrency(invoice.expensesPackageAmount || 0) }}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr class="font-medium">
                                <td class="px-4 py-2" colspan="4">TOTAL FRAIS</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(invoice.expensesTotalExpenses || 0) }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- Récapitulatif -->
            <section class="mb-8">
                <h2 class="text-lg font-medium mb-4 bg-gray-100 p-2 text-center">RÉCAPITULATIF</h2>
                <div class="border border-gray-200 rounded overflow-x-scroll">
                    <table class="w-full divide-y divide-gray-200 text-left min-w-[600px]">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Description
                                </th>
                                <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase">
                                    Montant
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200 text-sm">
                            <tr>
                                <td class="px-4 py-2">TOTAL HONORAIRES</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(feesTotal) }}
                                </td>
                            </tr>
                            <tr v-if="hasDiscount">
                                <td class="px-4 py-2">
                                    REMISE HONORAIRES ({{ discountPercentage }}%)
                                </td>
                                <td class="px-4 py-2 text-right">
                                    -{{ formatCurrency(discountAmount) }}
                                </td>
                            </tr>
                            <tr>
                                <td class="px-4 py-2">AUTRES PRESTATIONS</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(otherServicesAmount) }}
                                </td>
                            </tr>
                            <tr>
                                <td class="px-4 py-2">DÉPLACEMENTS</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(travelExpensesAmount) }}
                                </td>
                            </tr>
                            <tr>
                                <td class="px-4 py-2">FRAIS REMBOURSABLES</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(thirdPartyExpensesAmount) }}
                                </td>
                            </tr>
                            <tr class="font-medium">
                                <td class="px-4 py-2">TOTAL HT</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(totalHT) }}
                                </td>
                            </tr>
                            <tr>
                                <td class="px-4 py-2">TVA ({{ vatRate }}%)</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(vatAmount) }}
                                </td>
                            </tr>
                            <tr class="font-bold text-base">
                                <td class="px-4 py-2">TOTAL TTC</td>
                                <td class="px-4 py-2 text-right">
                                    {{ formatCurrency(totalTTC) }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
        <!-- Collapsible sections for other services -->
        <div class="space-y-4 w-full lg:w-1/3">
            <!-- 1. Autres prestations -->
            <AccordionPanel
                id="otherServices"
                title="1. Autres prestations (ME, inclinos, pénétros...)"
                :default-open="true"
            >
                <template #content>
                    <textarea
                        :value="invoice.remarksOtherServices || ''"
                        @input="
                            (e) =>
                                updateRemarks(
                                    'otherServices',
                                    (e.target as HTMLTextAreaElement).value
                                )
                        "
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <AccordionPanel id="deplacements" title="2. Déplacements (voiture)">
                <template #content>
                    <textarea
                        :value="invoice.remarksTravelExpenses || ''"
                        @input="
                            (e) =>
                                updateRemarks(
                                    'travelExpenses',
                                    (e.target as HTMLTextAreaElement).value
                                )
                        "
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <AccordionPanel id="frais-remboursables" title="3. Frais remboursables (achats...)">
                <template #content>
                    <textarea
                        :value="invoice.remarksExpenses || ''"
                        @input="
                            (e) =>
                                updateRemarks('expenses', (e.target as HTMLTextAreaElement).value)
                        "
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <AccordionPanel id="frais-laboratoire" title="4. Frais de laboratoire, pelle, minage">
                <template #content>
                    <textarea
                        :value="invoice.remarksThirdPartyExpenses || ''"
                        @input="
                            (e) =>
                                updateRemarks(
                                    'thirdPartyExpenses',
                                    (e.target as HTMLTextAreaElement).value
                                )
                        "
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>
        </div>
    </div>
</template>

<script setup lang="ts">
import { type Invoice } from "@beg/validations"
import AccordionPanel from "../../molecules/AccordionPanel.vue"
import { PercentBadgeIcon, CurrencyDollarIcon, CalculatorIcon } from "@heroicons/vue/24/outline"
import { useFormat } from "@/composables/utils/useFormat"
import { computed, ref } from "vue"
import InputNumber from "@/components/atoms/InputNumber.vue"

const props = defineProps<{
    modelValue: Invoice
}>()

const emit = defineEmits<{
    "update:modelValue": [value: Invoice]
}>()

const { formatCurrency, formatDuration } = useFormat()

// Computed property for invoice
const invoice = computed({
    get: () => props.modelValue,
    set: (value) => emit("update:modelValue", value),
})

// Computed properties for data - using flat structure
const rates = computed(() => invoice.value.rates || [])
const feesBase = computed(() => invoice.value.feesBase || 0)
const feesAdjusted = computed(() => invoice.value.feesAdjusted || 0)
const feesTotal = computed(() => invoice.value.feesTotal || 0)

const hasDiscount = computed(() => (invoice.value.feesDiscountPercentage || 0) > 0 || (invoice.value.feesDiscountAmount || 0) > 0)
const discountPercentage = computed(() => invoice.value.feesDiscountPercentage || 0)
const discountAmount = computed(() => invoice.value.feesDiscountAmount || 0)

const hasPackage = computed(() => (invoice.value.expensesPackagePercentage || 0) > 0 || (invoice.value.expensesPackageAmount || 0) > 0)

// Discount and package type states
const discountType = ref<'percentage' | 'fixed'>(
    invoice.value.feesDiscountPercentage && invoice.value.feesDiscountPercentage > 0 ? 'percentage' : 'fixed'
)
const packageType = ref<'percentage' | 'fixed'>(
    invoice.value.expensesPackagePercentage && invoice.value.expensesPackagePercentage > 0 ? 'percentage' : 'fixed'
)

const otherServicesAmount = computed(() => invoice.value.feesOthers || 0)
const travelExpensesAmount = computed(() => invoice.value.expensesTravelAmount || 0)
const thirdPartyExpensesAmount = computed(() => invoice.value.expensesThirdPartyAmount || 0)

const totalHT = computed(() => invoice.value.totalHT || 0)
const vatRate = computed(() => invoice.value.vatRate || 8.0)
const vatAmount = computed(() => invoice.value.vatAmount || 0)
const totalTTC = computed(() => invoice.value.totalTTC || 0)

// Helper function to update remarks
const updateRemarks = (field: string, value: string) => {
    const newInvoice = { ...invoice.value } as any
    // Map field names to flat structure
    const fieldMap: Record<string, string> = {
        otherServices: "remarksOtherServices",
        travelExpenses: "remarksTravelExpenses",
        expenses: "remarksExpenses",
        thirdPartyExpenses: "remarksThirdPartyExpenses",
    }
    const flatField = fieldMap[field]
    if (flatField) {
        newInvoice[flatField] = value
    }
    invoice.value = newInvoice
}

// Update rate
const updateRate = (index: number, field: string, value: any) => {
    const newInvoice = { ...invoice.value }
    if (!newInvoice.rates) newInvoice.rates = []
    newInvoice.rates = [...newInvoice.rates]
    newInvoice.rates[index] = { ...newInvoice.rates[index], [field]: value }

    // Recalculate amount
    const rate = newInvoice.rates[index]
    rate.amount = rate.adjusted * rate.hourlyRate

    // Recalculate totals using flat fields
    newInvoice.feesBase = newInvoice.rates.reduce((total, r) => total + (r.base || 0), 0)
    newInvoice.feesAdjusted = newInvoice.rates.reduce((total, r) => total + (r.adjusted || 0), 0)
    newInvoice.feesFinalTotal = newInvoice.rates.reduce((total, r) => total + (r.amount || 0), 0)
    newInvoice.feesTotal = newInvoice.feesFinalTotal - (newInvoice.feesDiscountAmount || 0)

    invoice.value = newInvoice
}

// Toggle discount
const toggleDiscount = () => {
    const newInvoice = { ...invoice.value }
    if (newInvoice.feesDiscountPercentage) {
        newInvoice.feesDiscountPercentage = newInvoice.feesDiscountPercentage > 0 ? 0 : 10
    } else {
        newInvoice.feesDiscountPercentage = 10
    }
    // Calculate discount amount
    if (newInvoice.feesDiscountPercentage && newInvoice.feesFinalTotal) {
        newInvoice.feesDiscountAmount =
            (newInvoice.feesFinalTotal * newInvoice.feesDiscountPercentage) / 100
    } else {
        newInvoice.feesDiscountAmount = 0
    }
    invoice.value = newInvoice
}

// Set discount type
const setDiscountType = (type: 'percentage' | 'fixed') => {
    discountType.value = type
    const newInvoice = { ...invoice.value }
    
    if (type === 'percentage') {
        // Convert to percentage if was fixed
        if (!newInvoice.feesDiscountPercentage || newInvoice.feesDiscountPercentage === 0) {
            newInvoice.feesDiscountPercentage = 10
            newInvoice.feesDiscountAmount = (newInvoice.feesFinalTotal * 10) / 100
        }
    } else {
        // Convert to fixed if was percentage
        if (!newInvoice.feesDiscountAmount || newInvoice.feesDiscountAmount === 0) {
            newInvoice.feesDiscountAmount = 1000
            newInvoice.feesDiscountPercentage = 0
        }
    }
    recalculateTotals(newInvoice)
    invoice.value = newInvoice
}

// Update discount percentage
const updateDiscountPercentage = (value: number) => {
    const newInvoice = { ...invoice.value }
    newInvoice.feesDiscountPercentage = value
    // Calculate discount amount
    if (value && newInvoice.feesFinalTotal) {
        newInvoice.feesDiscountAmount = (newInvoice.feesFinalTotal * value) / 100
    } else {
        newInvoice.feesDiscountAmount = 0
    }
    // Recalculate totals
    recalculateTotals(newInvoice)
    invoice.value = newInvoice
}

// Update discount amount (fixed)
const updateDiscountAmount = (value: number) => {
    const newInvoice = { ...invoice.value }
    newInvoice.feesDiscountAmount = value
    newInvoice.feesDiscountPercentage = 0 // Clear percentage when using fixed
    // Recalculate totals
    recalculateTotals(newInvoice)
    invoice.value = newInvoice
}

// Update expense field
const updateExpense = (field: string, value: number) => {
    const newInvoice = { ...invoice.value } as any
    newInvoice[field] = value

    // Calculate travel amount if updating travel fields
    if (field === "expensesTravelAdjusted" || field === "expensesTravelRate") {
        newInvoice.expensesTravelAmount =
            (newInvoice.expensesTravelAdjusted || 0) * (newInvoice.expensesTravelRate || 0.65)
    }

    // Recalculate total expenses
    recalculateExpensesTotal(newInvoice)
    recalculateTotals(newInvoice)

    invoice.value = newInvoice
}

// Toggle package
const togglePackage = () => {
    const newInvoice = { ...invoice.value }
    if (newInvoice.expensesPackagePercentage) {
        newInvoice.expensesPackagePercentage = newInvoice.expensesPackagePercentage > 0 ? 0 : 10
    } else {
        newInvoice.expensesPackagePercentage = 10
    }

    // Calculate package amount
    if (newInvoice.expensesPackagePercentage && newInvoice.feesFinalTotal) {
        newInvoice.expensesPackageAmount =
            (newInvoice.feesFinalTotal * newInvoice.expensesPackagePercentage) / 100
    } else {
        newInvoice.expensesPackageAmount = 0
    }

    recalculateExpensesTotal(newInvoice)
    recalculateTotals(newInvoice)
    invoice.value = newInvoice
}

// Set package type
const setPackageType = (type: 'percentage' | 'fixed') => {
    packageType.value = type
    const newInvoice = { ...invoice.value }
    
    if (type === 'percentage') {
        // Convert to percentage if was fixed
        if (!newInvoice.expensesPackagePercentage || newInvoice.expensesPackagePercentage === 0) {
            newInvoice.expensesPackagePercentage = 10
            newInvoice.expensesPackageAmount = (newInvoice.feesFinalTotal * 10) / 100
        }
    } else {
        // Convert to fixed if was percentage
        if (!newInvoice.expensesPackageAmount || newInvoice.expensesPackageAmount === 0) {
            newInvoice.expensesPackageAmount = 500
            newInvoice.expensesPackagePercentage = 0
        }
    }
    recalculateExpensesTotal(newInvoice)
    recalculateTotals(newInvoice)
    invoice.value = newInvoice
}

// Update package percentage
const updatePackagePercentage = (value: number) => {
    const newInvoice = { ...invoice.value }
    newInvoice.expensesPackagePercentage = value

    // Calculate package amount
    if (value && newInvoice.feesFinalTotal) {
        newInvoice.expensesPackageAmount = (newInvoice.feesFinalTotal * value) / 100
    } else {
        newInvoice.expensesPackageAmount = 0
    }

    recalculateExpensesTotal(newInvoice)
    recalculateTotals(newInvoice)
    invoice.value = newInvoice
}

// Update package amount (fixed)
const updatePackageAmount = (value: number) => {
    const newInvoice = { ...invoice.value }
    newInvoice.expensesPackageAmount = value
    newInvoice.expensesPackagePercentage = 0 // Clear percentage when using fixed
    // Recalculate totals
    recalculateExpensesTotal(newInvoice)
    recalculateTotals(newInvoice)
    invoice.value = newInvoice
}

// Helper to recalculate expenses total
const recalculateExpensesTotal = (inv: any) => {
    if (inv.expensesPackagePercentage && inv.expensesPackagePercentage > 0) {
        // If using package, only use package amount
        inv.expensesTotalExpenses = inv.expensesPackageAmount || 0
    } else {
        // Otherwise sum all individual expenses
        inv.expensesTotal =
            (inv.expensesTravelAmount || 0) +
            (inv.expensesOtherAmount || 0) +
            (inv.expensesThirdPartyAmount || 0)
        inv.expensesTotalExpenses = inv.expensesTotal
    }
}

// Helper to recalculate all totals
const recalculateTotals = (inv: any) => {
    // Calculate fees final total after discount
    inv.feesTotal = (inv.feesFinalTotal || 0) - (inv.feesDiscountAmount || 0)

    // Calculate total HT
    inv.totalHT = (inv.feesTotal || 0) + (inv.feesOthers || 0) + (inv.expensesTotalExpenses || 0)

    // Calculate VAT
    inv.vatAmount = (inv.totalHT * (inv.vatRate || 8.0)) / 100

    // Calculate total TTC
    inv.totalTTC = inv.totalHT + inv.vatAmount
}
</script>
