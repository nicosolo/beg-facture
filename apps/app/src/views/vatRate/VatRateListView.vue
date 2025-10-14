<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <!-- Header with title and create button -->
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-2xl font-bold">Taux TVA</h1>
                <Button
                    v-if="isAdmin"
                    variant="primary"
                    @click="openCreateModal"
                    class="flex items-center gap-2"
                >
                    <PlusIcon class="h-5 w-5" />
                    Nouveau taux TVA
                </Button>
            </div>

            <!-- Error display -->
            <div v-if="error" class="bg-red-50 text-red-600 p-4 rounded mb-6">
                {{
                    typeof error === "string"
                        ? error
                        : (error as any)?.message || "Une erreur s'est produite"
                }}
            </div>

            <!-- Data table -->
            <DataTable
                :items="vatRates"
                :columns="columns"
                item-key="id"
                :empty-message="'Aucun taux TVA trouvé'"
            >
                <template #cell:createdAt="{ item }">
                    {{ item.createdAt ? formatDate(new Date(item.createdAt)) : "-" }}
                </template>
                <template #cell:updatedAt="{ item }">
                    {{ item.updatedAt ? formatDate(new Date(item.updatedAt)) : "-" }}
                </template>
                <template #cell:actions="{ item }">
                    <div v-if="isAdmin" class="flex justify-end gap-2">
                        <Button variant="ghost-primary" size="sm" @click="openEditModal(item)">
                            Modifier
                        </Button>
                        <Button
                            variant="ghost-danger"
                            size="sm"
                            @click="openDeleteDialog(item)"
                            :disabled="deleteLoading"
                        >
                            Supprimer
                        </Button>
                    </div>
                </template>
            </DataTable>

            <!-- Create/Edit Dialog -->
            <Dialog
                v-model="isModalOpen"
                :title="editingVatRate ? 'Modifier le taux TVA' : 'Nouveau taux TVA'"
                size="md"
            >
                <form @submit.prevent="handleSubmit" class="space-y-4">
                    <div>
                        <label for="year" class="block text-sm font-medium text-gray-700 mb-1">
                            Année
                        </label>
                        <input
                            id="year"
                            v-model.number="form.year"
                            type="number"
                            min="2000"
                            max="2100"
                            required
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>

                    <div>
                        <label for="rate" class="block text-sm font-medium text-gray-700 mb-1">
                            Taux (%)
                        </label>
                        <input
                            id="rate"
                            v-model.number="form.rate"
                            type="number"
                            step="0.01"
                            min="0"
                            max="100"
                            required
                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                    </div>

                    <div class="flex justify-end gap-3 pt-4">
                        <Button variant="secondary" type="button" @click="closeModal">
                            Annuler
                        </Button>
                        <Button
                            variant="primary"
                            type="submit"
                            :loading="createLoading || updateLoading"
                        >
                            {{ editingVatRate ? "Modifier" : "Créer" }}
                        </Button>
                    </div>
                </form>
            </Dialog>

            <!-- Delete Confirmation Dialog -->
            <ConfirmDialog
                v-model="isDeleteDialogOpen"
                title="Supprimer le taux TVA"
                :message="`Êtes-vous sûr de vouloir supprimer le taux TVA de l'année ${deletingVatRate?.year} ?`"
                type="danger"
                @confirm="confirmDelete"
                @cancel="cancelDelete"
            />
        </div>
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import DataTable from "@/components/molecules/DataTable.vue"
import Button from "@/components/atoms/Button.vue"
import Dialog from "@/components/molecules/Dialog.vue"
import ConfirmDialog from "@/components/molecules/ConfirmDialog.vue"
import { PlusIcon } from "@heroicons/vue/24/outline"
import {
    useFetchVatRates,
    useCreateVatRate,
    useUpdateVatRate,
    useDeleteVatRate,
} from "@/composables/api/useVatRate"
import { useAuthStore } from "@/stores/auth"
import { useFormat } from "@/composables/utils/useFormat"
import type { VatRate } from "@beg/validations"
import { useAlert } from "@/composables/utils/useAlert"

const authStore = useAuthStore()
const { formatDate } = useFormat()
const { t } = useI18n()
const { successAlert, errorAlert } = useAlert()

const isAdmin = computed(() => authStore.isRole("admin"))

// API composables
const { get: fetchVatRates, loading, error, data: response } = useFetchVatRates()
const { post: createVatRate, loading: createLoading } = useCreateVatRate()
const { put: updateVatRate, loading: updateLoading } = useUpdateVatRate()
const { delete: deleteVatRate, loading: deleteLoading } = useDeleteVatRate()

// Data - now a simple array
const vatRates = computed(() => response.value || [])

// Modal state
const isModalOpen = ref(false)
const editingVatRate = ref<VatRate | null>(null)
const form = ref({
    year: new Date().getFullYear(),
    rate: 8.0,
})

// Delete dialog state
const isDeleteDialogOpen = ref(false)
const deletingVatRate = ref<VatRate | null>(null)

// Table columns
const columns = [
    { key: "year", label: "Année" },
    { key: "rate", label: "Taux (%)" },
    { key: "createdAt", label: "Créé le" },
    { key: "updatedAt", label: "Modifié le" },
    { key: "actions", label: "Actions" },
]

// Load data on mount
onMounted(() => {
    document.title = "BEG - Taux TVA"
    loadData()
})

// Load VAT rates - no parameters needed
const loadData = async () => {
    await fetchVatRates()
}

// Modal handlers
const openCreateModal = () => {
    editingVatRate.value = null
    form.value = {
        year: new Date().getFullYear(),
        rate: 8.0,
    }
    isModalOpen.value = true
}

const openEditModal = (vatRate: VatRate) => {
    editingVatRate.value = vatRate
    form.value = {
        year: vatRate.year,
        rate: vatRate.rate,
    }
    isModalOpen.value = true
}

const closeModal = () => {
    isModalOpen.value = false
    editingVatRate.value = null
}

// Form submission
const handleSubmit = async () => {
    try {
        if (editingVatRate.value) {
            await updateVatRate({
                params: { id: editingVatRate.value.id },
                body: form.value,
            })
            successAlert(t("vatRate.updateSuccess", { year: form.value.year }))
        } else {
            await createVatRate({ body: form.value })
            successAlert(t("vatRate.createSuccess", { year: form.value.year }))
        }
        closeModal()
        await loadData()
    } catch (error) {
        console.error("Failed to save VAT rate:", error)
        errorAlert(t("vatRate.saveError"))
    }
}

// Delete handlers
const openDeleteDialog = (vatRate: VatRate) => {
    deletingVatRate.value = vatRate
    isDeleteDialogOpen.value = true
}

const confirmDelete = async () => {
    if (!deletingVatRate.value) return

    try {
        await deleteVatRate({ params: { id: deletingVatRate.value.id } })
        successAlert(t("vatRate.deleteSuccess", { year: deletingVatRate.value.year }))
        await loadData()
        cancelDelete()
    } catch (error) {
        console.error("Failed to delete VAT rate:", error)
        errorAlert(t("vatRate.deleteError"))
    }
}

const cancelDelete = () => {
    isDeleteDialogOpen.value = false
    deletingVatRate.value = null
}
</script>
