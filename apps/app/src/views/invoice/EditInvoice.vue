<template>
    <div class="container mx-auto p-4">
        <h1 class="text-2xl font-bold mb-4">
            {{ isNewInvoice ? "Créer une facture" : "Modifier la facture" }}
        </h1>

        <div class="mb-6">
            <div class="border-b border-gray-200">
                <nav class="flex -mb-px">
                    <button
                        @click="activeTab = 'general'"
                        :class="[
                            'py-4 px-6 font-medium text-sm',
                            activeTab === 'general'
                                ? 'border-b-2 border-blue-500 text-blue-600'
                                : 'text-gray-500 hover:text-gray-700 hover:border-gray-300',
                        ]"
                    >
                        Données de facturation et documents
                    </button>
                    <button
                        @click="activeTab = 'details'"
                        :class="[
                            'py-4 px-6 font-medium text-sm',
                            activeTab === 'details'
                                ? 'border-b-2 border-blue-500 text-blue-600'
                                : 'text-gray-500 hover:text-gray-700 hover:border-gray-300',
                        ]"
                    >
                        Préparation de la facture et heures réalisées
                    </button>
                </nav>
            </div>
        </div>

        <div class="tab-content">
            <InvoiceGeneralInfo v-if="activeTab === 'general'" :invoice="invoice" />
            <InvoiceDetails v-if="activeTab === 'details'" :invoice="invoice" />
        </div>

        <div class="mt-6 flex gap-4">
            <button class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
                Enregistrer
            </button>
            <button class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">
                Annuler
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue"
import { useRoute } from "vue-router"
import InvoiceGeneralInfo from "../../components/organisms/invoice/InvoiceGeneralInfo.vue"
import InvoiceDetails from "../../components/organisms/invoice/InvoiceDetails.vue"
import { type Invoice, createDemoInvoice } from "@beg/validations"

const route = useRoute()
const invoiceId = computed(() => route.params.id as string | undefined)
const isNewInvoice = computed(() => !invoiceId.value)

const activeTab = ref("general")

// Initialize with demo invoice or empty invoice data
const invoice = ref<Invoice>(createDemoInvoice())

// If we have an ID, we would typically fetch the invoice data from the API
// For now, we're using the demo data
</script>
