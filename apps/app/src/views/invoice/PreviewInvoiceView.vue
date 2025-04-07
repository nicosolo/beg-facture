<template>
    <div class="container mx-auto p-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Aperçu de la facture</h1>
            <button
                @click="printInvoice"
                class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            >
                Imprimer la facture
            </button>
        </div>

        <InvoicePreview v-if="invoice" :invoice="invoice" />

        <div class="mt-6">
            <router-link
                :to="{ name: 'invoice-edit', params: { id: $route.params.id } }"
                class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
            >
                Retour à l'édition
            </router-link>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue"
import { useRoute } from "vue-router"
import InvoicePreview from "@/components/organisms/invoice/InvoicePreview.vue"
import { createDemoInvoice } from "@beg/validations"
import type { Invoice } from "@beg/validations"

const route = useRoute()
const invoiceId = computed(() => route.params.id as string | undefined)

// In a real app, you would fetch the invoice data from an API
// For now, we'll use the demo invoice
const invoice = ref<Invoice>(createDemoInvoice())

const printInvoice = () => {
    window.print()
}
</script>

<style>
@media print {
    .container > div:first-child,
    .container > div:last-child {
        display: none;
    }

    .container {
        padding: 0;
        margin: 0;
        max-width: none;
    }
}
</style>
