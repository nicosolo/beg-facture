<template>
    <FormLayout
        :title="isNewInvoice ? 'Créer une facture' : 'Modifier la facture'"
        :subtitle="invoice?.reference"
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
        <div class="tab-content" v-if="invoice">
            <InvoiceGeneralInfo v-if="activeTab === 'general'" v-model="invoice" />
            <InvoiceDetails
                v-if="activeTab === 'details'"
                v-model="invoice"
                :unbilledActivities="unbilledActivities"
            />
        </div>
        <template #actions>
            <Button
                v-if="!isNewInvoice"
                variant="danger"
                type="button"
                @click="handleDelete"
                :disabled="loading || deleteLoading"
            >
                {{ $t("common.delete") }}
            </Button>
            <Button variant="secondary" type="button" @click="handleCancel" :disabled="loading">
                Annuler
            </Button>
            <Button variant="primary" @click="handleSave" :loading="loading">
                {{ $t("common.save") }}
            </Button>
        </template>
    </FormLayout>

    <!-- Delete Confirmation Dialog -->
    <ConfirmDialog
        v-model="showDeleteConfirm"
        :title="$t('common.confirmDelete')"
        :message="$t('invoice.confirmDelete')"
        type="danger"
        :confirm-text="$t('common.delete')"
        :cancel-text="$t('common.cancel')"
        @confirm="confirmDelete"
    />
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import FormLayout from "@/components/templates/FormLayout.vue"
import Button from "@/components/atoms/Button.vue"
import ConfirmDialog from "@/components/molecules/ConfirmDialog.vue"
import InvoiceGeneralInfo from "@/components/organisms/invoice/InvoiceGeneralInfo.vue"
import InvoiceDetails from "@/components/organisms/invoice/InvoiceDetails.vue"
import {
    createEmptyInvoice,
    type ActivityResponse,
    type Invoice,
    type InvoiceResponse,
} from "@beg/validations"
import {
    useFetchInvoice,
    useCreateInvoice,
    useUpdateInvoice,
    useDeleteInvoice,
} from "@/composables/api/useInvoice"
import { useFetchProject } from "@/composables/api/useProject"
import { useFetchUnbilledActivities } from "@/composables/api/useUnbilled"
import { useFormat } from "@/composables/utils/useFormat"

const route = useRoute()
const router = useRouter()
const invoiceId = computed(() => route.params.id as string | undefined)
const isNewInvoice = computed(() => !invoiceId.value)
const { formatDate } = useFormat()
const activeTab = ref("general")
const isUpdatingFromApi = ref(false)
const showDeleteConfirm = ref(false)

// API composables
const {
    get: fetchInvoice,
    loading: fetchLoading,
    error: fetchError,
    data: invoiceResponse,
} = useFetchInvoice()
const { post: createInvoice, loading: createLoading, error: createError } = useCreateInvoice()
const { put: updateInvoice, loading: updateLoading, error: updateError } = useUpdateInvoice()
const { delete: deleteInvoice, loading: deleteLoading } = useDeleteInvoice()
const {
    get: fetchProject,
    loading: fetchProjectLoading,
    error: fetchProjectError,
    data: projectResponse,
} = useFetchProject()

const { get: fetchUnbilledActivities, loading: fetchUnbilledLoading } = useFetchUnbilledActivities()

// Form state
const invoice = ref<Invoice | null>(null)
const unbilledActivities = ref<ActivityResponse[]>([])
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
        type: response.type || "invoice",
        billingMode: response.billingMode,
        description: response.description || "",
        note: response.note || "",

        // Dates - flat
        issueDate: response.issueDate ? new Date(response.issueDate) : undefined,
        dueDate: response.dueDate ? new Date(response.dueDate) : undefined,
        periodStart: response.periodStart ? new Date(response.periodStart) : undefined,
        periodEnd: response.periodEnd ? new Date(response.periodEnd) : undefined,
        period: response.period || "",

        // Client and recipient - flat
        clientAddress: response.clientAddress || "",
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
    console.log(invoice)
    return {
        projectId: invoice.projectId,
        invoiceNumber: invoice.invoiceNumber,
        reference: invoice.reference,
        type: invoice.type,
        billingMode: invoice.billingMode,
        status: "draft",
        description: invoice.description,
        note: invoice.note,

        // Dates
        issueDate: new Date(),
        dueDate: undefined,
        periodStart: invoice.periodStart,
        periodEnd: invoice.periodEnd,
        period: invoice.period,

        // Client and recipient addresses
        clientAddress: invoice.clientAddress,
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
        if (isNewInvoice.value && invoice.value) {
            const data = await createInvoice({ body: convertInvoiceToInput(invoice.value) })
            if (data) {
                router.push({ name: "invoice-preview", params: { id: data.id } })
            }
        } else if (invoiceId.value && invoice.value) {
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

// Delete invoice
const handleDelete = () => {
    showDeleteConfirm.value = true
}

const confirmDelete = async () => {
    try {
        if (invoiceId.value) {
            await deleteInvoice({ params: { id: parseInt(invoiceId.value) } })
            showDeleteConfirm.value = false
            router.push({ name: "invoice-list" })
        }
    } catch (err) {
        console.error("Failed to delete invoice:", err)
        showDeleteConfirm.value = false
        // Error will be handled by the FormLayout error display
    }
}

// Load unbilled activities for new invoice
const loadUnbilledActivities = async (periodStart?: Date, periodEnd?: Date) => {
    if (!projectId.value) return

    try {
        const queryParams: any = {}
        if (periodStart) queryParams.periodStart = periodStart.toISOString()
        if (periodEnd) queryParams.periodEnd = periodEnd.toISOString()

        const unbilledData = await fetchUnbilledActivities({
            params: { projectId: projectId.value },
            query: queryParams,
        })

        if (unbilledData) {
            unbilledActivities.value = unbilledData.activities || []
            // Keep the original period if it was passed, otherwise use API calculation
            const finalPeriodStart =
                periodStart ||
                (unbilledData.periodStart ? new Date(unbilledData.periodStart) : new Date())
            const finalPeriodEnd =
                periodEnd ||
                (unbilledData.periodEnd ? new Date(unbilledData.periodEnd) : new Date())

            // Pre-populate invoice with calculated data from API
            if (!invoice.value) {
                invoice.value = createEmptyInvoice({
                    // Use final period
                    periodStart: finalPeriodStart,
                    periodEnd: finalPeriodEnd,
                    projectId: projectId.value,
                })
            }
            invoice.value.projectId = projectId.value

            // Set reference from project data (projectNumber + subProjectName + name)
            if (projectResponse.value && isNewInvoice.value) {
                const referenceParts = []
                if (projectResponse.value.projectNumber) {
                    referenceParts.push(projectResponse.value.projectNumber)
                }
                if (projectResponse.value.subProjectName) {
                    referenceParts.push(projectResponse.value.subProjectName)
                }
                if (projectResponse.value.name) {
                    referenceParts.push(projectResponse.value.name)
                }
                invoice.value.reference = referenceParts.join(" - ")
            }

            // Set period string from dates
            if (invoice.value.periodStart && invoice.value.periodEnd) {
                invoice.value.period = `Travaux du ${formatDate(finalPeriodStart)} au ${formatDate(finalPeriodEnd)}`
            }

            // Set client address from project if available
            if (projectResponse.value) {
                const addressParts = []

                if (projectResponse.value.client?.name) {
                    addressParts.push(projectResponse.value.client.name)
                }

                if (projectResponse.value.location) {
                    if (projectResponse.value.location.address) {
                        addressParts.push(projectResponse.value.location.address)
                    }

                    const cityLine = []
                    if (projectResponse.value.location.name) {
                        cityLine.push(projectResponse.value.location.name)
                    }
                    if (projectResponse.value.location.canton) {
                        cityLine.push(projectResponse.value.location.canton)
                    }
                    if (cityLine.length > 0) {
                        addressParts.push(cityLine.join(", "))
                    }

                    if (projectResponse.value.location.country) {
                        addressParts.push(projectResponse.value.location.country)
                    }
                }

                invoice.value.clientAddress =
                    projectResponse.value.invoicingAddress || addressParts.join("\n")
            }

            // Fees from API calculation
            invoice.value.feesBase = unbilledData.feesBase
            invoice.value.feesAdjusted = unbilledData.feesAdjusted
            invoice.value.feesTotal = unbilledData.feesTotal
            invoice.value.feesFinalTotal = unbilledData.feesFinalTotal
            invoice.value.feesMultiplicationFactor = 1

            // Expenses from API calculation
            invoice.value.expensesTravelBase = unbilledData.totalKilometers || 0
            invoice.value.expensesTravelAdjusted = unbilledData.totalKilometers || 0
            invoice.value.expensesTravelRate = 0.65
            invoice.value.expensesTravelAmount = unbilledData.expensesTravelAmount
            invoice.value.expensesOtherBase = unbilledData.expensesOtherAmount
            invoice.value.expensesOtherAmount = unbilledData.expensesOtherAmount
            invoice.value.expensesTotal = unbilledData.expensesTotal
            invoice.value.expensesThirdPartyAmount = unbilledData.expensesThirdPartyAmount
            invoice.value.expensesTotalExpenses = unbilledData.expensesTotalExpenses

            // Totals from API calculation
            invoice.value.totalHT = unbilledData.totalHT
            invoice.value.vatRate = unbilledData.vatRate
            invoice.value.vatAmount = unbilledData.vatAmount
            invoice.value.totalTTC = unbilledData.totalTTC

            // Rates array
            invoice.value.rates = unbilledData.rates

            // Store activity IDs for later marking as billed
            invoice.value.activityIds = unbilledData.activityIds
        }
    } catch (err: any) {
        console.error("Failed to load unbilled activities:", err)
    }
}

onMounted(async () => {
    // Set page title
    document.title = isNewInvoice.value ? "BEG - Créer une facture" : "BEG - Modifier la facture"

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
    async () => {
        if (projectId.value) {
            const project = await fetchProject({ params: { id: projectId.value } })

            // Build client address from project location
            if (project && invoice.value) {
                const addressParts = []

                if (project.client?.name) {
                    addressParts.push(project.client.name)
                }

                if (project.location) {
                    if (project.location.address) {
                        addressParts.push(project.location.address)
                    }

                    const cityLine = []
                    if (project.location.name) {
                        cityLine.push(project.location.name)
                    }
                    if (project.location.canton) {
                        cityLine.push(project.location.canton)
                    }
                    if (cityLine.length > 0) {
                        addressParts.push(cityLine.join(", "))
                    }

                    if (project.location.country) {
                        addressParts.push(project.location.country)
                    }
                }

                invoice.value.clientAddress = addressParts.join("\n")

                // Set reference from project data for new invoices
                if (isNewInvoice.value) {
                    const referenceParts = []
                    if (project.projectNumber) {
                        referenceParts.push(project.projectNumber)
                    }
                    if (project.subProjectName) {
                        referenceParts.push(project.subProjectName)
                    }
                    if (project.name) {
                        referenceParts.push(project.name)
                    }
                    invoice.value.reference = referenceParts.join(" - ")
                }
            }
        }
    },
    { immediate: true }
)

// Watch for period changes and refetch unbilled activities
watch(
    () => [invoice.value?.periodStart?.getTime(), invoice.value?.periodEnd?.getTime()],
    ([newStartTime, newEndTime], [oldStartTime, oldEndTime]) => {
        // Skip if we're updating from API to prevent infinite loop
        if (isUpdatingFromApi.value) {
            return
        }

        // Only refetch if the period actually changed
        if (newStartTime === oldStartTime && newEndTime === oldEndTime) {
            return
        }

        // Only refetch if we're creating a new invoice and have a project
        if (
            invoice.value &&
            isNewInvoice.value &&
            projectId.value &&
            (invoice.value.periodStart || invoice.value.periodEnd)
        ) {
            loadUnbilledActivities(invoice.value.periodStart, invoice.value.periodEnd)
        }
    }
)
</script>
