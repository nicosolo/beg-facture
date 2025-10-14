<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between mb-6">
                <h1 class="text-2xl font-bold">{{ $t("monthlyHours.title") }}</h1>
                <Button
                    v-if="isAdmin"
                    variant="primary"
                    @click="openCreateModal"
                    class="w-full sm:w-auto"
                >
                    {{ $t("monthlyHours.new") }}
                </Button>
            </div>

            <!-- Filters -->
            <Card class="mb-6">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                        <Label>{{ $t("monthlyHours.year") }}</Label>
                        <Select
                            v-model="filters.year"
                            :options="yearOptions"
                            @update:model-value="fetchMonthlyHours(true)"
                        />
                    </div>
                    <div>
                        <Label>{{ $t("monthlyHours.month") }}</Label>
                        <Select
                            v-model="filters.month"
                            :options="monthOptions"
                            @update:model-value="fetchMonthlyHours(true)"
                        />
                    </div>
                    <div class="flex items-end">
                        <Button @click="resetFilters" variant="secondary">
                            {{ $t("common.resetFilters") }}
                        </Button>
                    </div>
                </div>
            </Card>

            <DataTable
                :items="monthlyHoursList"
                :columns="columns"
                item-key="id"
                :empty-message="$t('monthlyHours.empty')"
            >
                <template #cell:year="{ item }">
                    {{ item.year }}
                </template>

                <template #cell:month="{ item }">
                    {{ $t(`common.months.${item.month}`) }}
                </template>

                <template #cell:amountOfHours="{ item }">
                    {{ formatNumber(item.amountOfHours) }} h
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
            <div v-if="monthlyHoursData && monthlyHoursData.totalPages > 1" class="mt-6">
                <Pagination
                    :current-page="currentPage"
                    :total-pages="monthlyHoursData.totalPages"
                    :total-items="monthlyHoursData.total"
                    :page-size="monthlyHoursData.limit"
                    @prev="monthlyHoursData.page > 1 && currentPage--"
                    @next="monthlyHoursData.page < monthlyHoursData.totalPages && currentPage++"
                    @go-to="(page) => (currentPage = page)"
                />
            </div>
        </div>

        <!-- Delete Confirmation Dialog -->
        <ConfirmDialog
            v-model="showDeleteDialog"
            :title="$t('common.confirmDelete')"
            :message="
                $t('monthlyHours.deleteConfirm', {
                    year: currentMonthlyHoursToDelete?.year,
                    month: currentMonthlyHoursToDelete
                        ? $t(`common.months.${currentMonthlyHoursToDelete.month}`)
                        : '',
                })
            "
            type="danger"
            :confirm-text="$t('common.delete')"
            :cancel-text="$t('common.cancel')"
            @confirm="deleteMonthlyHours"
        />

        <!-- Monthly Hours Edit Modal -->
        <MonthlyHoursEditModal
            v-model="showEditModal"
            :monthly-hours-id="editingMonthlyHoursId"
            @saved="onMonthlyHoursSaved"
        />
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useI18n } from "vue-i18n"
import { useRouter } from "vue-router"
import Button from "@/components/atoms/Button.vue"
import Label from "@/components/atoms/Label.vue"
import Select from "@/components/atoms/Select.vue"
import DataTable from "@/components/molecules/DataTable.vue"
import ConfirmDialog from "@/components/molecules/ConfirmDialog.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import MonthlyHoursEditModal from "@/components/organisms/monthlyHours/MonthlyHoursEditModal.vue"
import Card from "@/components/atoms/Card.vue"
import { useFetchMonthlyHoursList, useDeleteMonthlyHours } from "@/composables/api/useMonthlyHours"
import { useAuthStore } from "@/stores/auth"
import { useAlert } from "@/composables/utils/useAlert"
import type { MonthlyHours, MonthlyHoursFilter } from "@beg/validations"

const { t } = useI18n()
const authStore = useAuthStore()
const router = useRouter()
const { successAlert } = useAlert()

// Check if user is admin
const isAdmin = computed(() => authStore.isRole("admin"))

// Redirect if not admin
if (!isAdmin.value) {
    router.push({ name: "home" })
}

// Format number with localization
const formatNumber = (num: number) => {
    return new Intl.NumberFormat("fr-FR").format(num)
}

// Generate year options (from 2000 to current year + 5)
const currentYear = new Date().getFullYear()
const yearOptions = computed(() => {
    const options: Array<{ value: number | null; label: string }> = [
        { value: null, label: t("common.all") },
    ]
    for (let year = currentYear + 5; year >= 2000; year--) {
        options.push({ value: year, label: year.toString() })
    }
    return options
})

// Month options
const monthOptions = computed(() => {
    const options: Array<{ value: number | null; label: string }> = [
        { value: null, label: t("common.all") },
    ]
    for (let month = 1; month <= 12; month++) {
        options.push({ value: month, label: t(`common.months.${month}`) })
    }
    return options
})

// Table columns
const columns = computed(() => {
    const baseColumns = [
        { key: "year", label: t("monthlyHours.year") },
        { key: "month", label: t("monthlyHours.month") },
        { key: "amountOfHours", label: t("monthlyHours.hours") },
    ]
    if (isAdmin.value) {
        baseColumns.push({ key: "actions", label: t("common.actions") })
    }
    return baseColumns
})

// API composables
const { get: fetchMonthlyHoursApi, loading, data: monthlyHoursData } = useFetchMonthlyHoursList()
const { delete: deleteMonthlyHoursApi, loading: deleting } = useDeleteMonthlyHours()

// Data
const currentPage = ref(1)
const monthlyHoursList = computed(() => monthlyHoursData?.value?.data || [])

// Filters
const filters = ref<MonthlyHoursFilter>({
    year: undefined,
    month: undefined,
    page: 1,
    limit: 100,
    sortBy: "year",
    sortOrder: "desc",
})

// Dialog state
const showDeleteDialog = ref(false)
const currentMonthlyHoursToDelete = ref<MonthlyHours | null>(null)
const showEditModal = ref(false)
const editingMonthlyHoursId = ref<number | null>(null)

// Fetch monthly hours
const fetchMonthlyHours = async (resetPage = false) => {
    if (resetPage) {
        currentPage.value = 1
    }
    await fetchMonthlyHoursApi({
        query: {
            ...filters.value,
            page: currentPage.value,
        },
    })
}

// Reset filters
const resetFilters = () => {
    filters.value.year = undefined
    filters.value.month = undefined
    fetchMonthlyHours(true)
}

watch(currentPage, () => {
    fetchMonthlyHours()
})

// Load monthly hours on mount
onMounted(() => {
    document.title = "BEG - Heures mensuelles"
    fetchMonthlyHours()
})

// Open delete confirmation dialog
const confirmDelete = (monthlyHours: MonthlyHours) => {
    currentMonthlyHoursToDelete.value = monthlyHours
    showDeleteDialog.value = true
}

// Delete monthly hours
const deleteMonthlyHours = async () => {
    if (!currentMonthlyHoursToDelete.value) return

    await deleteMonthlyHoursApi({ params: { id: currentMonthlyHoursToDelete.value.id } })
    successAlert(t("monthlyHours.deleteSuccess"))
    showDeleteDialog.value = false
    await fetchMonthlyHours() // Reload data
}

// Open create modal
const openCreateModal = () => {
    editingMonthlyHoursId.value = null
    showEditModal.value = true
}

// Open edit modal
const openEditModal = (monthlyHours: MonthlyHours) => {
    editingMonthlyHoursId.value = monthlyHours.id
    showEditModal.value = true
}

// Handle monthly hours saved
const onMonthlyHoursSaved = async () => {
    await fetchMonthlyHours()
}
</script>
