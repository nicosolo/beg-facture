<template>
    <div>
        <div class="flex justify-end mb-4">
            <button
                @click="printInvoice"
                class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            >
                Imprimer la facture
            </button>
        </div>

        <div class="invoice-preview print:p-0" style="width: 17cm">
            <table class="line w-full border border-gray-300 border-collapse">
                <caption class="main text-lg font-bold bg-gray-300 mt-8 p-0.5">
                    Informations pour la comptabilité
                </caption>
                <tbody>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Type de facture
                        </td>
                        <td class="info2 border border-gray-300">{{ $t(`invoice.type.${invoice.type}`) }}</td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Responsable
                        </td>
                        <td class="info2 border border-gray-300">{{ invoice.id || "fp" }}</td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Visa
                        </td>
                        <td class="info2 border border-gray-300">{{ formatDate(new Date()) }}</td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Dernière modification
                        </td>
                        <td class="info2 border border-gray-300">{{ formatDate(new Date()) }}</td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Tarif
                        </td>
                        <td class="info2 border border-gray-300">{{ billingModeLabel }}</td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Remarques
                        </td>
                        <td class="info2 border border-gray-300">
                            {{ invoice.remarksOtherServices }}
                        </td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Fichier de facturation
                        </td>
                        <td class="info2 border border-gray-300">{{ invoice.invoiceNumber }}</td>
                    </tr>
                </tbody>
            </table>

            <table class="line w-full border border-gray-300 border-collapse">
                <caption class="main text-lg font-bold bg-gray-300 mt-8 p-0.5">
                    Facture
                </caption>
                <tbody>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Adresse de facturation
                        </td>
                        <td class="info2 border border-gray-300">
                            {{ invoice.clientAddress }}<br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Adresse d'envoi
                        </td>
                        <td class="info2 border border-gray-300">
                            {{ invoice.recipientAddress }}<br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Objet
                        </td>
                        <td class="info2 border border-gray-300 bg-gray-300 font-bold">
                            {{ invoice.reference }}
                        </td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Période de facturation
                        </td>
                        <td class="info2 border border-gray-300">
                            Travaux du {{ formatDate(invoice.periodStart) }} au
                            {{ formatDate(invoice.periodEnd) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="info1 font-bold pr-8 text-right w-[4cm] border border-gray-300">
                            Prestations
                        </td>
                        <td class="info2 border border-gray-300" v-html="formattedDescription"></td>
                    </tr>
                </tbody>
            </table>

            <table class="fac w-[70%] border border-gray-300 border-collapse">
                <caption class="sub text-left font-bold p-0.5">
                    Honoraires
                </caption>
                <thead>
                    <tr>
                        <td class="fac1 border border-gray-300">Classe</td>
                        <td class="fac2 text-right border border-gray-300 w-1/4">Heures</td>
                        <td class="fac3 text-right border border-gray-300 w-1/4">Tarif</td>
                        <td class="fac4 text-right border border-gray-300 w-1/4">Montant</td>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="rate in filteredRates" :key="rate.rateClass">
                        <td class="fac1 border border-gray-300">{{ rate.rateClass }}</td>
                        <td class="fac2 text-right border border-gray-300">
                            {{ formatDuration(rate.adjusted).split("h")[0] }}
                        </td>
                        <td class="fac3 text-right border border-gray-300">
                            {{ formatCurrency(rate.hourlyRate) }}
                        </td>
                        <td class="fac4 text-right border border-gray-300">
                            {{ formatCurrency(rate.amount) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300" colspan="2">Total h.</td>
                        <td class="fac3 text-right border border-gray-300">
                            {{ formatDuration(invoice.feesAdjusted).split("h")[0] }}
                        </td>
                        <td class="fac4 text-right border border-gray-300">
                            {{ formatCurrency(invoice.feesTotal) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table class="fac w-[70%] border border-gray-300 border-collapse">
                <caption class="sub text-left font-bold p-0.5">
                    Frais
                </caption>
                <tbody>
                    <tr>
                        <td class="fac1 border border-gray-300" colspan="2">Frais BEG au %</td>
                        <td class="fac3 text-right border border-gray-300 w-1/4">
                            {{ invoice.expensesPackagePercentage || 0 }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300 w-1/4">
                            {{
                                formatCurrency(
                                    invoice.expensesPackageAmount ||
                                        (invoice.feesTotal *
                                            (invoice.expensesPackagePercentage || 0)) /
                                            100
                                )
                            }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300" colspan="3">Total des frais</td>
                        <td class="fac4 text-right border border-gray-300">
                            {{ formatCurrency(invoice.expensesTotalExpenses) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table class="fac w-[70%] border border-gray-300 border-collapse">
                <caption class="sub text-left font-bold p-0.5">
                    Montant total
                </caption>
                <tbody>
                    <tr>
                        <td class="fac1 border border-gray-300" colspan="3">TOTAL HT</td>
                        <td class="fac4 text-right border border-gray-300 w-1/4">
                            {{ formatCurrency(invoice.totalHT) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300" colspan="2">TVA</td>
                        <td class="fac3 text-right border border-gray-300 w-1/4">
                            {{ invoice.vatRate }}%
                        </td>
                        <td class="fac4 text-right border border-gray-300">
                            {{ formatCurrency(invoice.vatAmount) }}
                        </td>
                    </tr>
                    <tr>
                        <td class="fac1 border border-gray-300" colspan="3">TOTAL TTC</td>
                        <td class="fac4 text-right border border-gray-300">
                            {{ formatCurrency(invoice.totalTTC) }}
                        </td>
                    </tr>
                </tbody>
            </table>

            <table class="line w-full border border-gray-300 border-collapse">
                <caption class="main text-lg font-bold bg-gray-300 mt-8 p-0.5">
                    Liste des documents
                </caption>
            </table>

            <table
                class="line w-full border border-gray-300 border-collapse"
                v-if="invoice.offers.length > 0"
            >
                <caption class="sub text-left font-bold p-0.5">
                    Liste des offres
                </caption>
                <tbody>
                    <tr v-for="(offer, index) in invoice.offers" :key="index">
                        <td class="doc1 w-[1.8cm] border-none">{{ formatDate(offer.date) }}</td>
                        <td class="doc2 w-[5.7cm] border-none">{{ offer.file }}</td>
                        <td class="doc3 border-none">{{ offer.remark }}</td>
                    </tr>
                </tbody>
            </table>

            <table
                class="line w-full border border-gray-300 border-collapse"
                v-if="invoice.adjudications.length > 0"
            >
                <caption class="sub text-left font-bold p-0.5">
                    Liste des adjudications
                </caption>
                <tbody>
                    <tr v-for="(adjudication, index) in invoice.adjudications" :key="index">
                        <td class="doc1 w-[1.8cm] border-none">
                            {{ formatDate(adjudication.date) }}
                        </td>
                        <td class="doc2 w-[5.7cm] border-none">{{ adjudication.file }}</td>
                        <td class="doc3 border-none">{{ adjudication.remark }}</td>
                    </tr>
                </tbody>
            </table>

            <p class="text-right text-xs mt-4">BEGfacture 1.8 © 2014-2016, J. Savary / BEG SA</p>
        </div>
    </div>
</template>

<script setup lang="ts">
import { defineProps, computed } from "vue"
import { type Invoice } from "@beg/validations"
import { useFormat } from "@/composables/utils/useFormat"
import { useI18n } from "vue-i18n"

interface InvoiceProps {
    invoice: Invoice
}

const props = defineProps<InvoiceProps>()
const { formatCurrency, formatDuration, formatDate } = useFormat()
const { t } = useI18n()

const formattedDescription = computed(() => {
    // Replace line breaks with <br> tags for HTML rendering
    return ""
})

const filteredRates = computed(() => {
    // Only show rates with hours > 0
    return ""
})

const billingModeLabel = computed(() => {
    return t(`invoice.billingMode.${props.invoice.billingMode}`)
})

const printInvoice = () => {
    window.print()
}
</script>

<style scoped>
.line {
    width: 100%;
}

.main {
    background-color: #c0c0c0;
    font-size: 125%;
    margin-top: 30px;
    padding: 2px;
}

.sub {
    font-weight: bold;
    text-align: left;
    padding: 2px 2px 0px 2px;
}

@media print {
    button {
        display: none;
    }
}
</style>
