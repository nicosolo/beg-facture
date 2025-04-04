<template>
    <div>
        <!-- Honoraires section -->
        <section class="mb-8">
            <h2 class="text-lg font-medium mb-4 bg-gray-100 p-2 text-center">HONORAIRES</h2>
            <div class="border border-gray-200 rounded overflow-x-scroll">
                <table class="w-full divide-y divide-gray-200 text-left min-w-[600px]">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase"></th>
                            <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase"></th>
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
                        <tr v-for="rate in invoice.fees.rates" :key="rate.rateClass">
                            <td class="px-4 py-2 text-gray-900 font-medium w-10" colspan="2">
                                {{ rate.rateClass }}
                            </td>
                            <td class="px-4 py-2 text-gray-900">
                                <div class="w-24 p-1">{{ formatDuration(rate.base) }}</div>
                            </td>
                            <td class="px-4 py-2 text-gray-900">
                                <InputDuration v-model="rate.adjusted" />
                            </td>
                            <td class="px-4 py-2 text-gray-900">
                                <InputNumber v-model="rate.hourlyRate" />
                            </td>
                            <td class="px-4 py-2 text-gray-900 font-medium">
                                {{ formatCurrency(rate.amount) }}
                            </td>
                        </tr>
                        <!-- Total row -->
                        <tr class="bg-gray-50">
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">Total h.</td>
                            <td class="px-4 py-2 font-medium">
                                {{ formatDuration(invoice.fees.base) }}
                            </td>
                            <td class="px-4 py-2 font-medium">
                                {{ formatDuration(invoice.fees.adjusted) }}
                            </td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">
                                {{ formatCurrency(invoice.fees.total) }}
                            </td>
                        </tr>
                        <!-- Autres row -->
                        <tr>
                            <td class="px-4 py-2 font-bold">1</td>
                            <td class="px-4 py-2">Autres</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-medium">
                                <InputNumber type="amount" v-model="invoice.fees.others" />
                            </td>
                        </tr>
                        <!-- Subtotal -->
                        <tr>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">Total</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">
                                {{
                                    formatCurrency(invoice.fees.total + (invoice.fees.others || 0))
                                }}
                            </td>
                        </tr>
                        <!-- Discount -->
                        <tr>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">Rabais</td>
                            <td class="px-4 py-2 text-center">
                                <Button
                                    @click="toggleDiscount()"
                                    variant="secondary"
                                    class="flex items-center gap-1 w-36"
                                    size="sm"
                                >
                                    <PercentBadgeIcon
                                        v-if="invoice.fees.discount.percentage !== null"
                                        class="w-6 h-6"
                                    />
                                    <CurrencyDollarIcon v-else class="w-6 h-6" />
                                    <div>
                                        {{
                                            invoice.fees.discount.percentage !== null
                                                ? "au pourcent"
                                                : "au forfait"
                                        }}
                                    </div>
                                </Button>
                            </td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2">
                                <InputNumber
                                    type="percentage"
                                    v-if="invoice.fees.discount.percentage !== null"
                                    v-model="invoice.fees.discount.percentage"
                                />
                            </td>
                            <td class="px-4 py-2 font-medium">
                                <InputNumber
                                    type="amount"
                                    v-if="invoice.fees.discount.amount !== null"
                                    v-model="invoice.fees.discount.amount"
                                />
                            </td>
                        </tr>
                        <!-- Total after discount -->
                        <tr>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">TOTAL</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">
                                {{ formatCurrency(invoice.fees.finalTotal) }}
                            </td>
                        </tr>
                        <!-- Multiplication factor -->
                        <tr>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">N.F.</td>
                            <td class="px-4 py-2" colspan="4">
                                <InputNumber
                                    type="number"
                                    v-model="invoice.fees.multiplicationFactor"
                                    :step="0.01"
                                />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Frais section -->
        <section class="mb-8">
            <h2 class="text-lg font-medium mb-4 bg-gray-100 p-2 text-center">FRAIS</h2>
            <div class="flex justify-end mb-3">
                <div class="flex items-center gap-2">
                    <span class="text-sm font-medium">Mode:</span>
                    <Button
                        @click="isExpensesPackage = !isExpensesPackage"
                        variant="secondary"
                        size="sm"
                        class="flex items-center gap-1 w-36"
                    >
                        <CalculatorIcon v-if="!isExpensesPackage" class="w-5 h-5" />
                        <CurrencyDollarIcon v-else class="w-5 h-5" />
                        <div>{{ isExpensesPackage ? "Forfait" : "Calculé" }}</div>
                    </Button>
                </div>
            </div>
            <div class="border border-gray-200 rounded overflow-x-scroll">
                <table class="w-full divide-y divide-gray-200 text-left min-w-[600px]">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase"></th>
                            <th class="px-4 py-2 text-xs font-medium text-gray-500 uppercase"></th>
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
                        <!-- Kilometers row - only shown in calculated mode -->
                        <tr v-show="!isExpensesPackage">
                            <td class="px-4 py-2 text-gray-900 font-medium">2</td>
                            <td class="px-4 py-2 text-gray-900">Km</td>
                            <td class="px-4 py-2 text-gray-900">
                                <div class="w-24 p-1">
                                    {{ invoice.expenses.travel.base.toFixed(2) }}
                                </div>
                            </td>
                            <td class="px-4 py-2 text-gray-900">
                                <InputNumber
                                    type="distance"
                                    v-model="invoice.expenses.travel.adjusted"
                                />
                            </td>
                            <td class="px-4 py-2 text-gray-900">
                                <InputNumber type="amount" v-model="invoice.expenses.travel.rate" />
                            </td>
                            <td class="px-4 py-2 text-gray-900 font-medium">
                                {{ formatCurrency(invoice.expenses.travel.amount) }}
                            </td>
                        </tr>
                        <!-- Other expenses row - only shown in calculated mode -->
                        <tr v-show="!isExpensesPackage">
                            <td class="px-4 py-2 text-gray-900 font-medium">3</td>
                            <td class="px-4 py-2 text-gray-900">Frais</td>
                            <td class="px-4 py-2 text-gray-900">
                                <div class="w-24 p-1">
                                    {{ formatCurrency(invoice.expenses.other.base) }}
                                </div>
                            </td>
                            <td class="px-4 py-2 text-gray-900"></td>
                            <td class="px-4 py-2 text-gray-900"></td>
                            <td class="px-4 py-2 text-gray-900 font-medium">
                                {{ formatCurrency(invoice.expenses.other.amount) }}
                            </td>
                        </tr>
                        <!-- Subtotal of calculated expenses - only shown in calculated mode -->
                        <tr v-show="!isExpensesPackage" class="bg-gray-50">
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">Total</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">
                                {{ formatCurrency(invoice.expenses.total) }}
                            </td>
                        </tr>
                        <!-- Package adjustment - only shown in forfait mode -->
                        <tr v-show="isExpensesPackage">
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 text-gray-900 font-medium">Forfait</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 text-gray-900 font-medium">
                                <InputNumber
                                    type="amount"
                                    v-model="invoice.expenses.package.amount"
                                />
                            </td>
                        </tr>
                        <!-- Package adjustment in calculated mode -->
                        <tr v-show="!isExpensesPackage">
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 text-gray-900 font-medium">Forfait</td>
                            <td class="px-4 py-2 text-gray-900 text-center">
                                <Button
                                    @click="togglePackage()"
                                    variant="secondary"
                                    size="sm"
                                    class="flex items-center gap-1 w-36"
                                >
                                    <PercentBadgeIcon
                                        v-if="invoice.expenses.package.percentage !== null"
                                        class="w-6 h-6"
                                    />
                                    <CurrencyDollarIcon v-else class="w-6 h-6" />
                                    <div>
                                        {{
                                            invoice.expenses.package.percentage !== null
                                                ? "au pourcent"
                                                : "au forfait"
                                        }}
                                    </div>
                                </Button>
                            </td>
                            <td class="px-4 py-2 text-gray-900"></td>
                            <td class="px-4 py-2 text-gray-900">
                                <div
                                    v-if="invoice.expenses.package.percentage !== null"
                                    class="flex items-center gap-1"
                                >
                                    <InputNumber
                                        type="percentage"
                                        v-model="invoice.expenses.package.percentage"
                                    />
                                </div>
                            </td>
                            <td class="px-4 py-2 text-gray-900 font-medium">
                                <input
                                    type="number"
                                    v-if="invoice.expenses.package.percentage === null"
                                    v-model.number="packageAmountValue"
                                    step="0.01"
                                    class="w-24 p-1 border border-gray-300 rounded"
                                />
                                <span v-else>
                                    {{ formatCurrency(getPackageAmount()) }}
                                </span>
                            </td>
                        </tr>
                        <!-- Third party -->
                        <tr>
                            <td class="px-4 py-2 text-gray-900 font-medium">4</td>
                            <td class="px-4 py-2 text-gray-900">Tiers</td>
                            <td class="px-4 py-2 text-gray-900"></td>
                            <td class="px-4 py-2 text-gray-900"></td>
                            <td class="px-4 py-2 text-gray-900"></td>
                            <td class="px-4 py-2 text-gray-900 font-medium">
                                <InputNumber
                                    type="amount"
                                    v-model="invoice.expenses.thirdParty.amount"
                                />
                            </td>
                        </tr>
                        <!-- Total expenses -->
                        <tr class="bg-gray-50">
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">Total</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">
                                {{ formatCurrency(invoice.expenses.totalExpenses) }}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Total section -->
        <section class="mb-8">
            <h2 class="text-lg font-medium mb-4 bg-gray-100 p-2 text-center">
                TOTAL (honoraires+frais)
            </h2>
            <div class="border border-gray-200 rounded overflow-x-scroll">
                <table class="w-full divide-y divide-gray-200 text-left min-w-[600px]">
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">Total HT</td>

                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">
                                {{ formatCurrency(invoice.totals.ht) }}
                            </td>
                        </tr>
                        <tr>
                            <td class="px-4 py-2 font-bold">TVA</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2">
                                <InputNumber type="percentage" v-model="invoice.totals.vat.rate" />
                            </td>
                            <td class="px-4 py-2 font-bold">
                                {{ formatCurrency(invoice.totals.vat.amount) }}
                            </td>
                        </tr>
                        <tr class="bg-yellow-50">
                            <td class="px-4 py-2 font-bold">Total TTC</td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2"></td>
                            <td class="px-4 py-2 font-bold">
                                {{ formatCurrency(invoice.totals.ttc) }}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Collapsible sections for other services -->
        <div class="space-y-4">
            <!-- 1. Autres prestations -->
            <AccordionPanel
                id="otherServices"
                title="1. Autres prestations (ME, inclinos, pénétros...)"
                :default-open="true"
            >
                <template #content>
                    <textarea
                        v-model="invoice.remarks.otherServices"
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <AccordionPanel id="deplacements" title="2. Déplacements (voiture)">
                <template #content>
                    <textarea
                        v-model="invoice.remarks.travelExpenses"
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <!-- 3. Frais -->
            <AccordionPanel id="frais" title="3. Frais (train, achats de matériel, etc.)">
                <template #content>
                    <textarea
                        v-model="invoice.remarks.expenses"
                        rows="6"
                        class="w-full p-2 border border-gray-300 rounded"
                    ></textarea>
                </template>
            </AccordionPanel>

            <!-- 4. Frais de tiers -->
            <AccordionPanel id="fraisTiers" title="4. Frais de tiers (laboratoire, pelle...)">
                <template #content>
                    <textarea
                        v-model="invoice.remarks.thirdPartyExpenses"
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
import { computed, ref } from "vue"

interface Props {
    invoice: Invoice
}
const { invoice } = defineProps<Props>()

console.log(invoice)

const { formatCurrency, formatDuration } = useFormat()

// State to track whether we're in forfait mode
const isExpensesPackage = ref(false)

// Handle package amount with a computed property to avoid null issues
const packageAmountValue = computed({
    get: () => invoice.expenses.package.amount || 0,
    set: (value) => {
        invoice.expenses.package.amount = value
    },
})

// Get package amount based on percentage or direct amount
const getPackageAmount = () => {
    if (invoice.expenses.package.percentage !== null) {
        return invoice.expenses.total * (invoice.expenses.package.percentage / 100)
    }
    return invoice.expenses.package.amount || 0
}

const togglePackage = () => {
    invoice.expenses.package =
        invoice.expenses.package?.amount !== null
            ? { percentage: 0, amount: null }
            : {
                  amount: 0,
                  percentage: null,
              }
}

const toggleDiscount = () => {
    invoice.fees.discount =
        invoice.fees.discount.amount !== null
            ? { percentage: 0, amount: null }
            : { amount: 0, percentage: null }
}
</script>
