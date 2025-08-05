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
                            <tr v-for="(rate, index) in rates" :key="rate.id">
                                <td class="px-4 py-2 text-gray-800">{{ rate.name }}</td>
                                <td class="px-4 py-2 text-gray-600">{{ rate.abbreviation }}</td>
                                <td class="px-4 py-2">
                                    <span>{{ formatDuration(rate.base) }}</span>
                                </td>
                                <td class="px-4 py-2">
                                    <InputDuration
                                        :modelValue="rate.adjusted"
                                        @update:modelValue="(value) => updateRate(index, 'adjusted', value)"
                                        class="w-20"
                                    />
                                </td>
                                <td class="px-4 py-2">
                                    <InputNumber
                                        :modelValue="rate.hourlyRate"
                                        @update:modelValue="(value) => updateRate(index, 'hourlyRate', value)"
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
                        <div v-if="hasDiscount" class="flex items-center gap-2">
                            <InputNumber
                                :modelValue="discountPercentage"
                                @update:modelValue="updateDiscountPercentage"
                                :min="0"
                                :max="100"
                                :step="1"
                                class="w-20"
                            />
                            <span class="text-sm">%</span>
                        </div>
                    </div>
                    <div v-if="hasDiscount" class="mt-2 text-sm text-gray-600">
                        Montant de la remise: {{ formatCurrency(discountAmount) }}
                    </div>
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
                        :value="invoice.remarks?.otherServices || ''"
                        @input="(e) => updateRemarks('otherServices', (e.target as HTMLTextAreaElement).value)"
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <AccordionPanel id="deplacements" title="2. Déplacements (voiture)">
                <template #content>
                    <textarea
                        :value="invoice.remarks?.travelExpenses || ''"
                        @input="(e) => updateRemarks('travelExpenses', (e.target as HTMLTextAreaElement).value)"
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <AccordionPanel
                id="frais-remboursables"
                title="3. Frais remboursables (achats...)"
            >
                <template #content>
                    <textarea
                        :value="invoice.remarks?.expenses || ''"
                        @input="(e) => updateRemarks('expenses', (e.target as HTMLTextAreaElement).value)"
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <AccordionPanel
                id="frais-laboratoire"
                title="4. Frais de laboratoire, pelle, minage"
            >
                <template #content>
                    <textarea
                        :value="invoice.remarks?.thirdPartyExpenses || ''"
                        @input="(e) => updateRemarks('thirdPartyExpenses', (e.target as HTMLTextAreaElement).value)"
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
import Button from "@/components/atoms/Button.vue"
import { useFormat } from "@/composables/utils/useFormat"
import InputNumber from "@/components/atoms/InputNumber.vue"
import InputDuration from "@/components/atoms/InputDuration.vue"
import { computed, ref, watch, watchEffect } from "vue"

const props = defineProps<{
    modelValue: Invoice
}>()

const emit = defineEmits<{
    'update:modelValue': [value: Invoice]
}>()

const { formatCurrency, formatDuration } = useFormat()

// Computed property for invoice
const invoice = computed({
    get: () => props.modelValue,
    set: (value) => emit('update:modelValue', value)
})

// Computed properties for data
const rates = computed(() => invoice.value.fees?.rates || [])
const feesBase = computed(() => invoice.value.fees?.base || 0)
const feesAdjusted = computed(() => invoice.value.fees?.adjusted || 0)
const feesTotal = computed(() => invoice.value.fees?.totalAmount || 0)

const hasDiscount = computed(() => (invoice.value.discount?.percentage || 0) > 0)
const discountPercentage = computed(() => invoice.value.discount?.percentage || 0)
const discountAmount = computed(() => invoice.value.discount?.amount || 0)

const otherServicesAmount = computed(() => invoice.value.otherServices?.amount || 0)
const travelExpensesAmount = computed(() => invoice.value.travelExpenses?.amount || 0)
const thirdPartyExpensesAmount = computed(() => invoice.value.thirdPartyExpenses?.amount || 0)

const totalHT = computed(() => invoice.value.subtotal || 0)
const vatRate = computed(() => invoice.value.vat?.rate || 8.1)
const vatAmount = computed(() => invoice.value.vat?.amount || 0)
const totalTTC = computed(() => invoice.value.total || 0)

// Helper function to update remarks
const updateRemarks = (field: string, value: string) => {
    const newInvoice = { ...invoice.value }
    if (!newInvoice.remarks) newInvoice.remarks = {
        expenses: '',
        otherServices: '',
        travelExpenses: '',
        thirdPartyExpenses: ''
    }
    newInvoice.remarks = { ...newInvoice.remarks, [field]: value }
    invoice.value = newInvoice
}

// Update rate
const updateRate = (index: number, field: string, value: any) => {
    const newInvoice = { ...invoice.value }
    if (!newInvoice.fees) newInvoice.fees = { rates: [], base: 0, adjusted: 0, totalAmount: 0 }
    if (!newInvoice.fees.rates) newInvoice.fees.rates = []
    newInvoice.fees.rates = [...newInvoice.fees.rates]
    newInvoice.fees.rates[index] = { ...newInvoice.fees.rates[index], [field]: value }
    
    // Recalculate amount
    const rate = newInvoice.fees.rates[index]
    rate.amount = (rate.adjusted / 60) * rate.hourlyRate
    
    // Recalculate totals
    newInvoice.fees.base = newInvoice.fees.rates.reduce((total, r) => total + (r.base || 0), 0)
    newInvoice.fees.adjusted = newInvoice.fees.rates.reduce((total, r) => total + (r.adjusted || 0), 0)
    newInvoice.fees.totalAmount = newInvoice.fees.rates.reduce((total, r) => total + (r.amount || 0), 0)
    
    invoice.value = newInvoice
}

// Toggle discount
const toggleDiscount = () => {
    const newInvoice = { ...invoice.value }
    if (!newInvoice.discount) {
        newInvoice.discount = { percentage: 10, amount: 0 }
    } else {
        newInvoice.discount.percentage = newInvoice.discount.percentage > 0 ? 0 : 10
    }
    invoice.value = newInvoice
}

// Update discount percentage
const updateDiscountPercentage = (value: number) => {
    const newInvoice = { ...invoice.value }
    if (!newInvoice.discount) newInvoice.discount = { percentage: 0, amount: 0 }
    newInvoice.discount.percentage = value
    invoice.value = newInvoice
}
</script>