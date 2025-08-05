<template>
    <FormLayout
        :title="isNewInvoice ? 'Créer une facture' : 'Modifier la facture'"
        :loading="loading"
        :error-message="errorMessage"
    >
        <!-- Tabs Navigation -->
        <div class="-mx-6 -mt-6 mb-6">
            <div class="border-b border-gray-200">
                <nav class="flex -mb-px px-6">
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

        <!-- Tab Content -->
        <div class="tab-content">
            <InvoiceGeneralInfo v-if="activeTab === 'general'" v-model="invoice" />
            <InvoiceDetails v-if="activeTab === 'details'" v-model="invoice" />
        </div>

        <template #actions>
            <Button
                variant="secondary"
                type="button"
                @click="handleCancel"
                :disabled="loading"
            >
                Annuler
            </Button>
            <Button
                variant="primary"
                @click="handleSave"
                :disabled="loading"
            >
                {{ loading ? "Enregistrement..." : "Enregistrer" }}
            </Button>
        </template>
    </FormLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import FormLayout from "@/components/templates/FormLayout.vue"
import Button from "@/components/atoms/Button.vue"
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
const errorMessage = computed(() => {
    const err = error.value as any
    if (typeof err === 'string') return err
    if (err?.message) return err.message
    return err ? "Une erreur s'est produite" : null
})

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
        } catch (err: any) {
            console.error("Failed to load invoice:", err)
            // Error will be displayed in the FormLayout
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
            router.push({ name: "invoice-list" })
        }
    } catch (err: any) {
        console.error("Failed to save invoice:", err)
        // Error will be displayed in the FormLayout
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
