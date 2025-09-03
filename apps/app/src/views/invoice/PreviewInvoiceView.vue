<template>
    <div class="container mx-auto p-4">
        <div v-if="loading" class="text-center py-8">
            <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
            <p class="mt-2 text-gray-600">Chargement de la facture...</p>
        </div>

        <div v-else-if="error" class="mb-4 p-4 bg-red-100 text-red-700 rounded">
            {{ error }}
        </div>

        <template v-else>
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
        </template>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue"
import { useRoute, useRouter } from "vue-router"
import InvoicePreview from "@/components/organisms/invoice/InvoicePreview.vue"
import { useFetchInvoice } from "@/composables/api/useInvoice"
import type { InvoiceResponse } from "@beg/validations"

const route = useRoute()
const router = useRouter()
const invoiceId = computed(() => route.params.id as string | undefined)

// API composable
const { get: fetchInvoice, loading, error } = useFetchInvoice()

// Invoice data
const invoice = ref<InvoiceResponse | null>(null)

// Load invoice
const loadInvoice = async () => {
    if (invoiceId.value) {
        try {
            const data = await fetchInvoice({ params: { id: parseInt(invoiceId.value) } })
            if (data) {
                invoice.value = data
            }
        } catch (err) {
            console.error("Failed to load invoice:", err)
            // If loading fails, redirect back to list
            router.push({ name: "invoice-list" })
        }
    }
}

const printInvoice = () => {
    window.print()
}

onMounted(() => {
    document.title = 'BEG - Aperçu de facture'
    loadInvoice()
})
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