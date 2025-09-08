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
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Type de facture
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ $t(`invoice.type.${invoice.type || "invoice"}`) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Statut
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ $t(`invoice.status.${invoice.status || "draft"}`) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Date d'émission
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ formatDate(invoice.issueDate || new Date()) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.dueDate">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Date d'échéance
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ formatDate(invoice.dueDate) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Mode de facturation
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ billingModeLabel }}
                        </td>
                    </tr>
                    <tr v-if="invoice.note">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Note
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.note }}
                        </td>
                    </tr>
                    <tr v-if="invoice.invoiceNumber">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Numéro de facture
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
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
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Adresse de facturation
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.clientAddress }}<br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Adresse d'envoi
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.recipientAddress }}<br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Objet
                        </td>
                        <td class="info2 border border-gray-300 bg-gray-300 font-bold">
                            {{ invoice.reference }}
                        </td>
                    </tr>
                    <tr v-if="invoice.period">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Période
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.period }}
                        </td>
                    </tr>
                    <tr v-else-if="invoice.periodStart && invoice.periodEnd">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Période de facturation
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            Du {{ formatDate(invoice.periodStart) }} au
                            {{ formatDate(invoice.periodEnd) }}
                        </td>
                    </tr>
                    <tr>
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Prestations
                        </td>
                        <td class="info2 border border-gray-300" v-html="formattedDescription"></td>
                    </tr>
                </tbody>
            </table>

            <table class="fac w-[70%] border border-gray-300 border-collapse">
                <caption class="sub text-left font-bold p-1 text-sm">
                    Honoraires
                </caption>
                <thead>
                    <tr>
                        <td class="fac1 border border-gray-300 p-1 text-xs">Classe</td>
                        <td class="fac2 text-right border border-gray-300 p-1 text-xs w-1/4">
                            Heures
                        </td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs w-1/4">
                            Tarif
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs w-1/4">
                            Montant
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="rate in filteredRates" :key="rate.rateClass">
                        <td class="fac1 border border-gray-300 p-1 text-xs">
                            {{ rate.rateClass }}
                        </td>
                        <td class="fac2 text-right border border-gray-300 p-1 text-xs">
                            {{ formatDuration(rate.adjusted) }}
                        </td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(rate.hourlyRate) }}
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(rate.amount) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="2">
                            Total h.
                        </td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs">
                            {{ formatDuration(invoice.feesAdjusted || 0) }}
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(invoice.feesTotal || 0) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.feesOthers && invoice.feesOthers !== 0">
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="3">
                            Autres honoraires
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(invoice.feesOthers) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.feesDiscountPercentage">
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="2">Rabais</td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs">
                            {{ invoice.feesDiscountPercentage }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            -{{ formatCurrency(invoice.feesDiscountAmount || 0) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.feesDiscountAmount && !invoice.feesDiscountPercentage">
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="3">Rabais</td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            -{{ formatCurrency(invoice.feesDiscountAmount) }}
                        </td>
                    </tr>
                    <tr
                        v-if="
                            invoice.feesMultiplicationFactor &&
                            invoice.feesMultiplicationFactor !== 1
                        "
                    >
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="2">Facteur</td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs">
                            x{{ invoice.feesMultiplicationFactor }}
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(invoice.feesFinalTotal || 0) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table class="fac w-[70%] border border-gray-300 border-collapse">
                <caption class="sub text-left font-bold p-1 text-sm">
                    Frais
                </caption>
                <tbody>
                    <tr v-if="invoice.expensesTravelAmount > 0">
                        <td class="fac1 border border-gray-300 p-1 text-xs">
                            Frais de déplacement
                        </td>
                        <td class="fac2 text-right border border-gray-300 p-1 text-xs w-1/4">
                            {{ invoice.expensesTravelBase }} km
                        </td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs w-1/4">
                            {{ formatCurrency(invoice.expensesTravelRate) }}/km
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs w-1/4">
                            {{ formatCurrency(invoice.expensesTravelAmount) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.expensesOtherAmount > 0">
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="3">
                            Autres frais
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(invoice.expensesOtherAmount) }}
                        </td>
                    </tr>
                    <tr v-if="invoice.expensesThirdPartyAmount > 0">
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="3">
                            Frais tiers
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(invoice.expensesThirdPartyAmount) }}
                        </td>
                    </tr>
                    <tr
                        v-if="
                            invoice.expensesPackagePercentage &&
                            invoice.expensesPackagePercentage > 0
                        "
                    >
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="2">
                            Frais BEG au %
                        </td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs w-1/4">
                            {{ invoice.expensesPackagePercentage }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs w-1/4">
                            {{ formatCurrency(invoice.expensesPackageAmount || 0) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="3">
                            Total des frais
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(invoice.expensesTotalExpenses || 0) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table class="fac w-[70%] border border-gray-300 border-collapse">
                <caption class="sub text-left font-bold p-1 text-sm">
                    Montant total
                </caption>
                <tbody>
                    <tr>
                        <td class="fac1 border border-gray-300 p-1 text-xs font-bold" colspan="3">
                            TOTAL HT
                        </td>
                        <td
                            class="fac4 text-right border border-gray-300 p-1 text-xs font-bold w-1/4"
                        >
                            {{ formatCurrency(invoice.totalHT || 0) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300 p-1 text-xs" colspan="2">TVA</td>
                        <td class="fac3 text-right border border-gray-300 p-1 text-xs w-1/4">
                            {{ invoice.vatRate || 8.0 }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs">
                            {{ formatCurrency(invoice.vatAmount || 0) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300 p-1 text-xs font-bold" colspan="3">
                            TOTAL TTC
                        </td>
                        <td class="fac4 text-right border border-gray-300 p-1 text-xs font-bold">
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
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Autres prestations
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.otherServices }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksOtherServices">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Remarques prestations
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.remarksOtherServices }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksTravelExpenses">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Remarques déplacements
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.remarksTravelExpenses }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksExpenses">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Remarques frais
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
                            {{ invoice.remarksExpenses }}
                        </td>
                    </tr>
                    <tr v-if="invoice.remarksThirdPartyExpenses">
                        <td
                            class="info1 font-bold pr-4 text-right w-[4cm] border border-gray-300 p-2 text-xs"
                        >
                            Remarques frais tiers
                        </td>
                        <td class="info2 border border-gray-300 p-2 text-xs">
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
                        <td class="doc1 w-[1.8cm] border-none p-1 text-xs">
                            {{ formatDate(offer.date) }}
                        </td>
                        <td class="doc2 w-[5.7cm] border-none p-1 text-xs">{{ offer.file }}</td>
                        <td class="doc3 border-none p-1 text-xs">{{ offer.remark }}</td>
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
                        <td class="doc1 w-[1.8cm] border-none p-1 text-xs">
                            {{ formatDate(adjudication.date) }}
                        </td>
                        <td class="doc2 w-[5.7cm] border-none p-1 text-xs">
                            {{ adjudication.file }}
                        </td>
                        <td class="doc3 border-none p-1 text-xs">{{ adjudication.remark }}</td>
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
