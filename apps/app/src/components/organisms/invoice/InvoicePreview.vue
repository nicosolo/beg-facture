<template>
    <div>
        <div class="invoice-preview print:p-0 p-6 text-sm" style="width: 17cm">
            <table class="line w-full border border-gray-300 border-collapse">
                <caption class="main text-base font-bold bg-gray-300 mt-6 p-1">
                    Informations pour la comptabilité
                </caption>
                <tbody>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Type de facture
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ $t(`invoice.type.${invoice.type || "invoice"}`) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Statut
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ $t(`invoice.status.${invoice.status || "draft"}`) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Date d'émission
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ formatDate(invoice.issueDate || new Date()) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.dueDate">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Date d'échéance
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ formatDate(invoice.dueDate) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Mode de facturation
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ billingModeLabel }}
                        </td>
                    </tr>
                    <tr v-if="invoice.note">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Note
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.note }}
                        </td>
                    </tr>
                    <tr v-if="invoice.invoiceNumber">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Numéro de facture
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.invoiceNumber }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table class="line w-full border border-gray-300 border-collapse">
                <caption class="main text-base font-bold bg-gray-300 mt-6 p-1">
                    Facture
                </caption>
                <tbody>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Adresse de facturation
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.clientAddress }}<br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Adresse d'envoi
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.recipientAddress }}<br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Objet
                        </td>
                        <td class="border border-gray-300 bg-gray-300 font-bold p-1">
                            {{ invoice.reference }}
                        </td>
                    </tr>
                    <tr v-if="invoice.period">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Période
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.period }}
                        </td>
                    </tr>
                    <tr v-else-if="invoice.periodStart && invoice.periodEnd">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Période de facturation
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            Du {{ formatDate(invoice.periodStart) }} au
                            {{ formatDate(invoice.periodEnd) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Prestations
                        </td>
                        <td class="border border-gray-300 p-1" v-html="formattedDescription"></td>
                    </tr>
                </tbody>
            </table>

            <table
                class="fac w-[70%] border border-gray-300 border-collapse"
                v-if="invoice.billingMode !== 'accordingToOffer'"
            >
                <caption class="sub text-left font-bold p-1 text-sm">
                    Honoraires
                </caption>
                <thead>
                    <tr>
                        <td class="border border-gray-300 p-1 text-sm">Classe</td>
                        <td class="text-right border border-gray-300 p-1 text-sm w-1/4">Heures</td>
                        <td class="text-right border border-gray-300 p-1 text-sm w-1/4">Tarif</td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm w-1/4">
                            Montant
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="rate in filteredRates" :key="rate.rateClass">
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ rate.rateClass }}
                        </td>
                        <td class="text-right border border-gray-300 p-1 text-sm">
                            {{ formatDuration(rate.adjusted) }}
                        </td>
                        <td class="text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(rate.hourlyRate) }}
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(rate.amount) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="border border-gray-300 p-1 text-sm" colspan="2">Total h.</td>
                        <td class="text-right border border-gray-300 p-1 text-sm">
                            {{ formatDuration(invoice.feesAdjusted || 0) }}
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(invoice.feesTotal || 0) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.feesOthers && invoice.feesOthers !== 0">
                        <td class="border border-gray-300 p-1 text-sm" colspan="3">
                            Autres honoraires
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(invoice.feesOthers) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.feesDiscountPercentage">
                        <td class="border border-gray-300 p-1 text-sm" colspan="2">Rabais</td>
                        <td class="text-right border border-gray-300 p-1 text-sm">
                            {{ invoice.feesDiscountPercentage }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            -{{ formatCurrency(invoice.feesDiscountAmount || 0) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.feesDiscountAmount && !invoice.feesDiscountPercentage">
                        <td class="border border-gray-300 p-1 text-sm" colspan="3">Rabais</td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            -{{ formatCurrency(invoice.feesDiscountAmount) }}
                        </td>
                    </tr>
                    <tr
                        v-if="
                            invoice.feesMultiplicationFactor &&
                            invoice.feesMultiplicationFactor !== 1
                        "
                    >
                        <td class="border border-gray-300 p-1 text-sm" colspan="2">Facteur</td>
                        <td class="text-right border border-gray-300 p-1 text-sm">
                            x{{ invoice.feesMultiplicationFactor }}
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(invoice.feesFinalTotal || 0) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table
                class="fac w-[70%] border border-gray-300 border-collapse"
                v-if="invoice.billingMode !== 'accordingToOffer'"
            >
                <caption class="sub text-left font-bold p-1 text-sm">
                    Frais
                </caption>
                <tbody>
                    <tr v-if="invoice.expensesTravelAmount > 0">
                        <td class="border border-gray-300 p-1 text-sm">Frais de déplacement</td>
                        <td class="text-right border border-gray-300 p-1 text-sm w-1/4">
                            {{ invoice.expensesTravelBase }} km
                        </td>
                        <td class="text-right border border-gray-300 p-1 text-sm w-1/4">
                            {{ formatCurrency(invoice.expensesTravelAdjusted) }}/km
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm w-1/4">
                            {{ formatCurrency(invoice.expensesTravelAmount) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.expensesOtherAmount > 0">
                        <td class="border border-gray-300 p-1 text-sm" colspan="3">Autres frais</td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(invoice.expensesOtherAmount) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.expensesThirdPartyAmount > 0">
                        <td class="border border-gray-300 p-1 text-sm" colspan="3">Frais tiers</td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(invoice.expensesThirdPartyAmount) }}
                        </td>
                    </tr>
                    <tr
                        v-if="
                            invoice.expensesPackagePercentage &&
                            invoice.expensesPackagePercentage > 0
                        "
                    >
                        <td class="border border-gray-300 p-1 text-sm" colspan="2">
                            Frais BEG au %
                        </td>
                        <td class="text-right border border-gray-300 p-1 text-sm w-1/4">
                            {{ invoice.expensesPackagePercentage }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm w-1/4">
                            {{ formatCurrency(invoice.expensesPackageAmount || 0) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="border border-gray-300 p-1 text-sm" colspan="3">
                            Total des frais
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(invoice.expensesTotalExpenses || 0) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table
                class="fac w-[70%] border border-gray-300 border-collapse"
                v-if="invoice.billingMode !== 'accordingToOffer'"
            >
                <caption class="sub text-left font-bold p-1 text-sm">
                    Montant total
                </caption>
                <tbody>
                    <tr>
                        <td class="border border-gray-300 p-1 text-sm font-bold" colspan="3">
                            TOTAL HT
                        </td>
                        <td
                            class="fac4 text-right border border-gray-300 p-1 text-sm font-bold w-1/4"
                        >
                            {{ formatCurrency(invoice.totalHT || 0) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="border border-gray-300 p-1 text-sm" colspan="2">TVA</td>
                        <td class="text-right border border-gray-300 p-1 text-sm w-1/4">
                            {{ invoice.vatRate || 8.0 }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm">
                            {{ formatCurrency(invoice.vatAmount || 0) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="border border-gray-300 p-1 text-sm font-bold" colspan="3">
                            TOTAL TTC
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-sm font-bold">
                            {{ formatCurrency(invoice.totalTTC || 0) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- Additional services and remarks -->
            <table
                class="fac w-[70%] border border-gray-300 border-collapse"
                v-if="hasAdditionalInfo"
            >
                <caption class="sub text-left font-bold p-1 text-sm">
                    Informations complémentaires
                </caption>
                <tbody>
                    <tr v-if="invoice.otherServices">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Autres prestations
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.otherServices }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksOtherServices">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Remarques prestations
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.remarksOtherServices }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksTravelExpenses">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Remarques déplacements
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.remarksTravelExpenses }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksExpenses">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Remarques frais
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.remarksExpenses }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksThirdPartyExpenses">
                        <td
                            class="font-bold pr-4 text-right w-[4cm] border border-gray-300 p-1 text-sm"
                        >
                            Remarques frais tiers
                        </td>
                        <td class="border border-gray-300 p-1 text-sm">
                            {{ invoice.remarksThirdPartyExpenses }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table class="line w-full border border-gray-300 border-collapse">
                <caption class="main text-base font-bold bg-gray-300 mt-6 p-1">
                    Liste des documents
                </caption>
            </table>

            <table
                class="line w-full border border-gray-300 border-collapse"
                v-if="invoice.offers && invoice.offers.length > 0"
            >
                <caption class="sub text-left font-bold p-1 text-sm">
                    Liste des offres
                </caption>
                <tbody>
                    <tr v-for="(offer, index) in invoice.offers" :key="index">
                        <td class="doc1 w-[1.8cm] border-none p-1 text-sm">
                            {{ formatDate(offer.date) }}
                        </td>
                        <td class="doc2 w-[5.7cm] border-none p-1 text-sm">{{ offer.file }}</td>
                        <td class="doc3 border-none p-1 text-sm">{{ offer.remark }}</td>
                    </tr>
                </tbody>
            </table>

            <table
                class="line w-full border border-gray-300 border-collapse"
                v-if="invoice.adjudications && invoice.adjudications.length > 0"
            >
                <caption class="sub text-left font-bold p-1 text-sm">
                    Liste des adjudications
                </caption>
                <tbody>
                    <tr v-for="(adjudication, index) in invoice.adjudications" :key="index">
                        <td class="doc1 w-[1.8cm] border-none p-1 text-sm">
                            {{ formatDate(adjudication.date) }}
                        </td>
                        <td class="doc2 w-[5.7cm] border-none p-1 text-sm">
                            {{ adjudication.file }}
                        </td>
                        <td class="doc3 border-none p-1 text-sm">{{ adjudication.remark }}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script setup lang="ts">
import { defineProps, computed } from "vue"
import { type InvoiceResponse } from "@beg/validations"
import { useFormat } from "@/composables/utils/useFormat"
import { useI18n } from "vue-i18n"

interface InvoiceProps {
    invoice: InvoiceResponse
}

const props = defineProps<InvoiceProps>()
const { formatCurrency, formatDuration, formatDate } = useFormat()
const { t } = useI18n()

const formattedDescription = computed(() => {
    // Replace line breaks with <br> tags for HTML rendering
    if (!props.invoice.description) return ""
    return props.invoice.description.replace(/\n/g, "<br>")
})

const filteredRates = computed(() => {
    // Only show rates with hours > 0
    if (!props.invoice.rates) return []
    return props.invoice.rates.filter((rate) => rate.adjusted > 0)
})

const billingModeLabel = computed(() => {
    return t(`invoice.billingMode.${props.invoice.billingMode || "accordingToData"}`)
})

const hasAdditionalInfo = computed(() => {
    return !!(
        props.invoice.otherServices ||
        props.invoice.remarksOtherServices ||
        props.invoice.remarksTravelExpenses ||
        props.invoice.remarksExpenses ||
        props.invoice.remarksThirdPartyExpenses
    )
})
</script>

<style scoped>
.line {
    width: 100%;
}

.main {
    background-color: #c0c0c0;
    font-size: 100%;
    margin-top: 20px;
    padding: 4px;
}

.sub {
    font-weight: bold;
    text-align: left;
    padding: 4px;
}
</style>
