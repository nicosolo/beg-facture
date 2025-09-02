<template>
    <FormLayout
        :title="isNewInvoice ? 'Créer une facture' : 'Modifier la facture'"
        :loading="fetchProjectLoading || fetchUnbilledLoading"
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
            <Button variant="secondary" type="button" @click="handleCancel" :disabled="loading">
                Annuler
            </Button>
            <Button variant="primary" @click="handleSave" :loading="loading">
                {{ $t("common.save") }}
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
import { useFetchProject } from "@/composables/api/useProject"
import { useFetchUnbilledActivities } from "@/composables/api/useUnbilled"

const route = useRoute()
const router = useRouter()
const invoiceId = computed(() => route.params.id as string | undefined)
const isNewInvoice = computed(() => !invoiceId.value)

const activeTab = ref("general")

// API composables
const {
    get: fetchInvoice,
    loading: fetchLoading,
    error: fetchError,
    data: invoiceResponse,
} = useFetchInvoice()
const { post: createInvoice, loading: createLoading, error: createError } = useCreateInvoice()
const { put: updateInvoice, loading: updateLoading, error: updateError } = useUpdateInvoice()
const {
    get: fetchProject,
    loading: fetchProjectLoading,
    error: fetchProjectError,
    data: projectResponse,
} = useFetchProject()

const { get: fetchUnbilledActivities, loading: fetchUnbilledLoading } = useFetchUnbilledActivities()

// Form state
const invoice = ref<Invoice>(createEmptyInvoice({}))
const loading = computed(() => fetchLoading.value || createLoading.value || updateLoading.value)
const error = computed(() => fetchError.value || createError.value || updateError.value)
const errorMessage = computed(() => {
    const err = error.value as any
    if (typeof err === "string") return err
    if (err?.message) return err.message
    return err ? "Une erreur s'est produite" : null
})
const projectId = computed<number | undefined>(() => {
    // Check route params first
    if (route.params.projectId) {
        return parseInt(route.params.projectId as string)
    }
    // Check query params for new invoice
    if (route.query.projectId) {
        return parseInt(route.query.projectId as string)
    }
    return undefined
})
// Helper to convert API response to form data (response is already flat)
const convertResponseToInvoice = (response: InvoiceResponse): Invoice => {
    return {
        ...createEmptyInvoice({}),
        id: response.id.toString(),
        projectId: response.projectId,

        // All fields are already flat in response
        invoiceNumber: response.invoiceNumber || "",
        reference: response.reference || "",
        type: response.type || "Facture",
        billingMode: response.billingMode,
        description: response.description || "",

        // Dates - flat
        issueDate: response.issueDate ? new Date(response.issueDate) : undefined,
        dueDate: response.dueDate ? new Date(response.dueDate) : undefined,
        periodStart: response.periodStart ? new Date(response.periodStart) : undefined,
        periodEnd: response.periodEnd ? new Date(response.periodEnd) : undefined,

        // Client and recipient - flat
        clientId: response.clientId,
        clientName: response.clientName || "",
        clientAddress: response.clientAddress || "",
        recipientName: response.recipientName || "",
        recipientAddress: response.recipientAddress || "",

        // All flat fields from response
        feesBase: response.feesBase || 0,
        feesAdjusted: response.feesAdjusted || 0,
        feesTotal: response.feesTotal || 0,
        feesOthers: response.feesOthers || 0,
        feesFinalTotal: response.feesFinalTotal || 0,
        feesMultiplicationFactor: response.feesMultiplicationFactor || 1,
        feesDiscountPercentage: response.feesDiscountPercentage || null,
        feesDiscountAmount: response.feesDiscountAmount || null,

        expensesTravelBase: response.expensesTravelBase || 0,
        expensesTravelAdjusted: response.expensesTravelAdjusted || 0,
        expensesTravelRate: response.expensesTravelRate || 0.65,
        expensesTravelAmount: response.expensesTravelAmount || 0,
        expensesOtherBase: response.expensesOtherBase || 0,
        expensesOtherAmount: response.expensesOtherAmount || 0,
        expensesTotal: response.expensesTotal || 0,
        expensesThirdPartyAmount: response.expensesThirdPartyAmount || 0,
        expensesPackagePercentage: response.expensesPackagePercentage || null,
        expensesPackageAmount: response.expensesPackageAmount || null,
        expensesTotalExpenses: response.expensesTotalExpenses || 0,

        totalHT: response.totalHT || 0,
        vatRate: response.vatRate || 8.0,
        vatAmount: response.vatAmount || 0,
        totalTTC: response.totalTTC || 0,

        otherServices: response.otherServices || "",
        remarksOtherServices: response.remarksOtherServices || "",
        remarksTravelExpenses: response.remarksTravelExpenses || "",
        remarksExpenses: response.remarksExpenses || "",
        remarksThirdPartyExpenses: response.remarksThirdPartyExpenses || "",

        // Arrays
        rates: response.rates || [],
        offers: response.offers || [],
        adjudications: response.adjudications || [],
    }
}

// Helper to convert form data to API input
const convertInvoiceToInput = (invoice: Invoice): any => {
    return {
        projectId: invoice.projectId,
        invoiceNumber: invoice.invoiceNumber,
        reference: invoice.reference,
        type: invoice.type,
        billingMode: invoice.billingMode,
        status: "draft",
        description: invoice.description,

        // Dates
        issueDate: new Date(),
        dueDate: undefined,
        periodStart: invoice.periodStart,
        periodEnd: invoice.periodEnd,

        // Client and recipient
        clientId: invoice.clientId,
        recipientName: invoice.recipientName,
        recipientAddress: invoice.recipientAddress,

        // All flat fields
        feesBase: invoice.feesBase,
        feesAdjusted: invoice.feesAdjusted,
        feesTotal: invoice.feesTotal,
        feesOthers: invoice.feesOthers,
        feesFinalTotal: invoice.feesFinalTotal,
        feesMultiplicationFactor: invoice.feesMultiplicationFactor,
        feesDiscountPercentage: invoice.feesDiscountPercentage,
        feesDiscountAmount: invoice.feesDiscountAmount,

        expensesTravelBase: invoice.expensesTravelBase,
        expensesTravelAdjusted: invoice.expensesTravelAdjusted,
        expensesTravelRate: invoice.expensesTravelRate,
        expensesTravelAmount: invoice.expensesTravelAmount,
        expensesOtherBase: invoice.expensesOtherBase,
        expensesOtherAmount: invoice.expensesOtherAmount,
        expensesTotal: invoice.expensesTotal,
        expensesThirdPartyAmount: invoice.expensesThirdPartyAmount,
        expensesPackagePercentage: invoice.expensesPackagePercentage,
        expensesPackageAmount: invoice.expensesPackageAmount,
        expensesTotalExpenses: invoice.expensesTotalExpenses,

        totalHT: invoice.totalHT,
        vatRate: invoice.vatRate,
        vatAmount: invoice.vatAmount,
        totalTTC: invoice.totalTTC,

        otherServices: invoice.otherServices,
        remarksOtherServices: invoice.remarksOtherServices,
        remarksTravelExpenses: invoice.remarksTravelExpenses,
        remarksExpenses: invoice.remarksExpenses,
        remarksThirdPartyExpenses: invoice.remarksThirdPartyExpenses,

        // Arrays
        rates: invoice.rates || [],
        offers: invoice.offers || [],
        adjudications: invoice.adjudications || [],

        // Activity IDs if present
        activityIds: invoice.activityIds,
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

// Load unbilled activities for new invoice
const loadUnbilledActivities = async () => {
    if (!projectId.value) return

    try {
        const unbilledData = await fetchUnbilledActivities({
            params: { projectId: projectId.value },
        })

        if (unbilledData) {
            // Pre-populate invoice with calculated data from API
            invoice.value = {
                ...createEmptyInvoice({
                    projectId: projectId.value,

                    // Period from API calculation
                    periodStart: unbilledData.periodStart
                        ? new Date(unbilledData.periodStart)
                        : new Date(),
                    periodEnd: unbilledData.periodEnd
                        ? new Date(unbilledData.periodEnd)
                        : new Date(),

                    // Fees from API calculation
                    feesBase: unbilledData.feesBase,
                    feesAdjusted: unbilledData.feesAdjusted,
                    feesTotal: unbilledData.feesTotal,
                    feesFinalTotal: unbilledData.feesFinalTotal,
                    feesMultiplicationFactor: 1,

                    // Expenses from API calculation
                    expensesTravelBase: unbilledData.totalKilometers || 0,
                    expensesTravelAdjusted: unbilledData.totalKilometers || 0,
                    expensesTravelRate: 0.65,
                    expensesTravelAmount: unbilledData.expensesTravelAmount,
                    expensesOtherBase: unbilledData.expensesOtherAmount,
                    expensesOtherAmount: unbilledData.expensesOtherAmount,
                    expensesTotal: unbilledData.expensesTotal,
                    expensesThirdPartyAmount: unbilledData.expensesThirdPartyAmount,
                    expensesTotalExpenses: unbilledData.expensesTotalExpenses,

                    // Totals from API calculation
                    totalHT: unbilledData.totalHT,
                    vatRate: unbilledData.vatRate,
                    vatAmount: unbilledData.vatAmount,
                    totalTTC: unbilledData.totalTTC,

                    // Rates array
                    rates: unbilledData.rates,

                    // Store activity IDs for later marking as billed
                    activityIds: unbilledData.activityIds,
                }),
            }
        }
    } catch (err: any) {
        console.error("Failed to load unbilled activities:", err)
    }
}

onMounted(async () => {
    // If it's a new invoice with a projectId, fetch unbilled activities
    if (isNewInvoice.value && projectId.value) {
        await loadUnbilledActivities()
    } else {
        await loadInvoice()
    }
})

// Reload when route changes
watch(
    () => route.params.id,
    () => {
        loadInvoice()
    }
)
watch(
    () => projectId,
    () => {
        if (projectId.value) {
            fetchProject({ params: { id: projectId.value } })
        }
    },
    { immediate: true }
)
</script>
