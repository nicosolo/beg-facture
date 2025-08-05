<template>
    <h1 class="text-2xl font-bold mb-4">
        {{ isNewInvoice ? "Créer une facture" : "Modifier la facture" }}
    </h1>

    <div class="mb-6">
        <div class="border-b border-gray-200">
            <nav class="flex -mb-px">
                <button
                    @click="activeTab = 'general'"
                    :class="[
                        'py-4 px-6 font-medium text-sm cursor-pointer',
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
                        'py-4 px-6 font-medium text-sm cursor-pointer',
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

    <div v-if="loading" class="text-center py-8">
        <div
            class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"
        ></div>
        <p class="mt-2 text-gray-600">Chargement...</p>
    </div>

    <div v-else-if="error" class="mb-4 p-4 bg-red-100 text-red-700 rounded">
        {{ error }}
    </div>

    <div v-else class="tab-content">
        <InvoiceGeneralInfo v-if="activeTab === 'general'" v-model="invoice" />
        <InvoiceDetails v-if="activeTab === 'details'" v-model="invoice" />
    </div>

    <div v-if="!loading" class="mt-6 flex gap-4">
        <button
            @click="handleSave"
            :disabled="loading"
            class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:opacity-50 disabled:cursor-not-allowed"
        >
            {{ loading ? "Enregistrement..." : "Enregistrer" }}
        </button>
        <button
            @click="handleCancel"
            :disabled="loading"
            class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 disabled:opacity-50"
        >
            Annuler
        </button>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import InvoiceGeneralInfo from "@/components/organisms/invoice/InvoiceGeneralInfo.vue"
import InvoiceDetails from "@/components/organisms/invoice/InvoiceDetails.vue"
import { createEmptyInvoice, type Invoice, type InvoiceResponse } from "@beg/validations"
import { useFetchInvoice, useCreateInvoice, useUpdateInvoice } from "@/composables/api/useInvoice"

const route = useRoute()
const router = useRouter()
const invoiceId = computed(() => route.params.id as string | undefined)
const isNewInvoice = computed(() => !invoiceId.value)

const activeTab = ref("general")

// API composables
const { get: fetchInvoice, loading: fetchLoading, error: fetchError } = useFetchInvoice()
const { post: createInvoice, loading: createLoading, error: createError } = useCreateInvoice()
const { put: updateInvoice, loading: updateLoading, error: updateError } = useUpdateInvoice()

// Form state
const invoice = ref<Invoice>(createEmptyInvoice())
const loading = computed(() => fetchLoading.value || createLoading.value || updateLoading.value)
const error = computed(() => fetchError.value || createError.value || updateError.value)

// Helper to convert API response to form data
const convertResponseToInvoice = (response: InvoiceResponse): Invoice => {
    return {
        ...createEmptyInvoice(),
        id: response.id.toString(),
        invoiceNumber: response.invoiceNumber || "",
        reference: response.reference || "",
        type: response.type || "Facture",
        billingMode: response.billingMode,
        period: {
            startDate: response.period?.startDate ? new Date(response.period.startDate) : undefined,
            endDate: response.period?.endDate ? new Date(response.period.endDate) : undefined,
        },
        client: {
            name: response.client?.name || "",
            address: response.client?.address || "",
        },
        recipient: {
            name: response.recipient?.name || "",
            address: response.recipient?.address || "",
        },
        description: response.description || "",
        offers: response.offers || [],
        adjudications: response.adjudications || [],
        // Keep other fields from response as needed
    }
}

// Helper to convert form data to API input
const convertInvoiceToInput = (invoice: Invoice): any => {
    return {
        invoiceNumber: invoice.invoiceNumber,
        reference: invoice.reference,
        type: invoice.type,
        billingMode: invoice.billingMode,
        status: "draft", // Status is managed by the backend
        periodStartDate: invoice.period?.startDate,
        periodEndDate: invoice.period?.endDate,
        clientId: undefined, // This should be set from a client selector
        clientName: invoice.client?.name,
        recipientName: invoice.recipient?.name,
        recipientAddress: invoice.recipient?.address,
        description: invoice.description,
        projectId: undefined, // This should be set from a project selector
        issueDate: new Date(),
        dueDate: undefined,
        offers: invoice.offers || [],
        adjudications: invoice.adjudications || [],
    }
}

// Load invoice if editing
const loadInvoice = async () => {
    if (!isNewInvoice.value && invoiceId.value) {
        try {
            const data = await fetchInvoice({ params: { id: parseInt(invoiceId.value) } })
            if (data) {
                invoice.value = convertResponseToInvoice(data)
            }
        } catch (err) {
            console.error("Failed to load invoice:", err)
            alert("Erreur lors du chargement de la facture")
            router.push({ name: "invoice-list" })
        }
    }
}

// Save invoice
const handleSave = async () => {
    try {
        if (isNewInvoice.value) {
            const data = await createInvoice({ body: convertInvoiceToInput(invoice.value) })
            if (data) {
                router.push({ name: "invoice-edit", params: { id: data.id } })
            }
        } else if (invoiceId.value) {
            await updateInvoice({
                params: { id: parseInt(invoiceId.value) },
                body: convertInvoiceToInput(invoice.value),
            })
            alert("Facture enregistrée avec succès")
        }
    } catch (err) {
        console.error("Failed to save invoice:", err)
        alert("Erreur lors de l'enregistrement de la facture")
    }
}

// Cancel and go back
const handleCancel = () => {
    router.push({ name: "invoice-list" })
}

onMounted(() => {
    loadInvoice()
})

// Reload when route changes
watch(
    () => route.params.id,
    () => {
        loadInvoice()
    }
)
</script>
