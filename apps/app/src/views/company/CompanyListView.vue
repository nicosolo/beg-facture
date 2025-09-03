<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold">{{ $t("company.title") }}</h1>
                <Button v-if="isAdmin" variant="primary" @click="openCreateModal">
                    {{ $t("company.new") }}
                </Button>
            </div>

            <!-- Filters -->
            <Card class="mb-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <Input
                        v-model="filters.name"
                        :placeholder="$t('company.searchByName')"
                        @update:model-value="debouncedFetch"
                    />
                </div>
            </Card>

            <DataTable
                :items="companies"
                :columns="columns"
                item-key="id"
                :empty-message="$t('company.empty')"
            >
                <template #cell:createdAt="{ item }">
                    {{ formatDate(item.createdAt) }}
                </template>

                <template #cell:actions="{ item }">
                    <div v-if="isAdmin" class="flex justify-end gap-2">
                        <Button variant="ghost-primary" size="sm" @click="openEditModal(item)">
                            {{ $t("common.edit") }}
                        </Button>
                        <Button
                            size="sm"
                            @click="confirmDelete(item)"
                            :disabled="deleting"
                            variant="ghost-danger"
                        >
                            {{ $t("common.delete") }}
                        </Button>
                    </div>
                </template>
            </DataTable>

            <!-- Pagination -->
            <div v-if="companyData && companyData.totalPages > 1" class="mt-6">
                <Pagination
                    :current-page="currentPage"
                    :total-pages="companyData.totalPages"
                    :total-items="companyData.total"
                    :page-size="companyData.limit"
                    @prev="companyData.page > 1 && currentPage--"
                    @next="companyData.page < companyData.totalPages && currentPage++"
                    @go-to="(page) => (currentPage = page)"
                />
            </div>
        </div>

        <!-- Delete Confirmation Dialog -->
        <ConfirmDialog
            v-model="showDeleteDialog"
            :title="$t('common.confirmDelete')"
            :message="$t('company.deleteConfirm', { name: currentCompanyToDelete?.name })"
            type="danger"
            :confirm-text="$t('common.delete')"
            :cancel-text="$t('common.cancel')"
            @confirm="deleteCompany"
        />

        <!-- Company Edit Modal -->
        <CompanyEditModal
            v-model="showEditModal"
            :company-id="editingCompanyId"
            @saved="onCompanySaved"
        />
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useI18n } from "vue-i18n"
import Button from "@/components/atoms/Button.vue"
import Input from "@/components/atoms/Input.vue"
import DataTable, { type Column } from "@/components/molecules/DataTable.vue"
import ConfirmDialog from "@/components/molecules/ConfirmDialog.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import CompanyEditModal from "@/components/organisms/company/CompanyEditModal.vue"
import Card from "@/components/atoms/Card.vue"
import { useFetchCompanyList, useDeleteCompany } from "@/composables/api/useCompany"
import { useAuthStore } from "@/stores/auth"
import { useAlert } from "@/composables/utils/useAlert"
import { formatDate } from "@/utils/date"
import type { Company, CompanyFilter } from "@beg/validations"

const { t } = useI18n()
const authStore = useAuthStore()
const { successAlert, errorAlert } = useAlert()

// Check if user is admin
const isAdmin = computed(() => authStore.user?.role === "admin")

// Table columns
const columns: Column[] = [
    { key: "name", label: t("company.name"), width: "w-1/2" },
    { key: "actions", label: t("common.actions") },
]

// API composables
const { get: fetchCompanyListApi, loading, data: companyData } = useFetchCompanyList()
const { delete: deleteCompanyApi, loading: deleting } = useDeleteCompany()

// Data
const currentPage = ref(1)
const companies = computed(() => companyData?.value?.data || [])

// Filters
const filters = ref<CompanyFilter>({
    name: "",
    page: 1,
    limit: 100,
    sortBy: "name",
    sortOrder: "asc",
})

// Dialog state
const showDeleteDialog = ref(false)
const currentCompanyToDelete = ref<Company | null>(null)
const showEditModal = ref(false)
const editingCompanyId = ref<number | null>(null)

// Fetch companies
const fetchCompanies = async (resetPage = false) => {
    if (resetPage) {
        currentPage.value = 1
    }
    await fetchCompanyListApi({
        query: {
            ...filters.value,
            page: currentPage.value,
        },
    })
}

// Simple debounce implementation
let debounceTimer: ReturnType<typeof setTimeout> | null = null
const debouncedFetch = () => {
    if (debounceTimer) {
        clearTimeout(debounceTimer)
    }
    debounceTimer = setTimeout(() => {
        fetchCompanies(true) // Reset to page 1 when filters change
    }, 300)
}

watch(currentPage, () => {
    fetchCompanies()
})

// Load companies on mount
onMounted(() => {
    document.title = 'BEG - Entreprises'
    fetchCompanies()
})

// Open delete confirmation dialog
const confirmDelete = (company: Company) => {
    currentCompanyToDelete.value = company
    showDeleteDialog.value = true
}

// Delete company
const deleteCompany = async () => {
    if (!currentCompanyToDelete.value) return

    try {
        await deleteCompanyApi({ params: { id: currentCompanyToDelete.value.id } })
        successAlert(t("common.deleteSuccess", { name: currentCompanyToDelete.value.name }))
        showDeleteDialog.value = false
        await fetchCompanies() // Reload data
    } catch (error: any) {
        errorAlert(
            error.message || t("common.deleteError", { name: currentCompanyToDelete.value.name })
        )
        console.error("Error deleting company:", error)
    }
}

// Open create modal
const openCreateModal = () => {
    editingCompanyId.value = null
    showEditModal.value = true
}

// Open edit modal
const openEditModal = (company: Company) => {
    editingCompanyId.value = company.id
    showEditModal.value = true
}

// Handle company saved
const onCompanySaved = async () => {
    await fetchCompanies()
}
</script>
