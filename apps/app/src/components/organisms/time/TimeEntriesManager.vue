<template>
    <div>
        <div class="mb-4" v-if="!hideHeader">
            <div class="flex justify-between items-start mb-4">
                <h2 class="text-lg font-semibold">{{ $t("time.title") }}</h2>
                <div class="flex gap-2">
                    <Button
                        variant="secondary"
                        size="md"
                        @click="handleExport"
                        :disabled="exportLoading"
                    >
                        {{ exportLoading ? "Exporting..." : "Export to Excel" }}
                    </Button>
                    <Button variant="primary" size="md" @click="openAddModal">
                        {{ $t("time.new") }}
                    </Button>
                </div>
            </div>
            <TimeFilterPanel
                v-model:filter="filter"
                :show-project-filter="showProjectFilter"
                :initial-filter="initialFilter"
            />
        </div>
        <LoadingOverlay :loading="loading">
            <Pagination
                v-if="activities.length > 0 || totalItems > 0"
                :current-page="currentPage"
                :total-pages="totalPages"
                :total-items="totalItems"
                :page-size="pageSize"
                @prev="prevPage"
                @next="nextPage"
                @go-to="goToPage"
            />
            <TimeEntriesList
                :activities="activities"
                :totals="totals"
                :sort="sort"
                :empty-message="emptyMessage"
                @sort-change="handleSortChange"
                @edit="openEditModal"
                @activities-updated="loadActivities"
                :hide-columns="hideColumns"
            />

            <Pagination
                v-if="activities.length > 0 || totalItems > 0"
                :current-page="currentPage"
                :total-pages="totalPages"
                :total-items="totalItems"
                :page-size="pageSize"
                @prev="prevPage"
                @next="nextPage"
                @go-to="goToPage"
            />
        </LoadingOverlay>

        <!-- Time Entry Modal -->
        <TimeEntryModal
            v-model="showTimeEntryModal"
            :activity-id="selectedActivityId"
            :default-project-id="defaultProjectId"
            @saved="onTimeEntrySaved"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, computed } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchActivityList } from "@/composables/api/useActivity"
import TimeFilterPanel from "@/components/organisms/time/TimeFilterPanel.vue"
import TimeEntriesList from "@/components/organisms/time/TimeEntriesList.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import TimeEntryModal from "@/components/organisms/time/TimeEntryModal.vue"
import Button from "@/components/atoms/Button.vue"
import { exportToCSV, formatDateForExport } from "@/utils/export"
import type { ActivityFilter, ActivityResponse, ActivityListResponse } from "@beg/validations"
import { useAuthStore } from "@/stores/auth"

interface Props {
    emptyMessage?: string
    showProjectFilter?: boolean
    initialFilter?: Partial<ActivityFilter>
    hideColumns?: string[]
    hideHeader?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    emptyMessage: "Aucune entrée d'heure trouvée",
    showProjectFilter: true,
    hideHeader: false,
})

const { t } = useI18n()

// API client
const { get: fetchActivities, loading, data } = useFetchActivityList()
const { get: fetchActivitiesExport, loading: exportLoading } = useFetchActivityList()

// State
const activities = ref<ActivityResponse[]>([])
const totalItems = ref(0)
const totalPages = ref(0)
const currentPage = ref(1)
const pageSize = ref(100)
const totals = ref<{ duration: number; kilometers: number; expenses: number } | undefined>()

// Modal state
const showTimeEntryModal = ref(false)
const selectedActivityId = ref<number | null>(null)
const defaultProjectId = ref<number | undefined>(undefined)
const authStore = useAuthStore()
// Filter state
const filter = ref<ActivityFilter>({
    userId: authStore.user?.id,
    activityTypeId: undefined,
    includeBilled: false,
    includeUnbilled: false,
    includeDisbursement: false,
    sortBy: "date",
    sortOrder: "desc",
    ...props.initialFilter,
})

const sort = computed(() => ({
    key: filter.value.sortBy || "date",
    direction: filter.value.sortOrder || "desc",
}))

const handleSortChange = (sort: {
    key: ActivityFilter["sortBy"] | string
    direction: ActivityFilter["sortOrder"] | "asc" | "desc"
}) => {
    filter.value.sortBy = sort.key as ActivityFilter["sortBy"]
    filter.value.sortOrder = sort.direction as ActivityFilter["sortOrder"]
    loadActivities()
}

// Watch for API data changes
watch(
    data,
    (newData) => {
        if (newData) {
            const pageData = newData as unknown as ActivityListResponse
            activities.value = pageData.data
            totalItems.value = pageData.total
            totalPages.value = pageData.totalPages
            totals.value = pageData.totals
        }
    },
    { deep: true }
)

watch(
    filter,
    (newData) => {
        if (newData) {
            loadActivities()
        }
    },
    { deep: true }
)

const loadActivities = async () => {
    const params: ActivityFilter = {
        page: currentPage.value,
        limit: pageSize.value,
        ...filter.value,
    }

    await fetchActivities({
        query: params,
    })
}

// Pagination handlers
const prevPage = () => {
    if (currentPage.value > 1) {
        currentPage.value--
        loadActivities()
    }
}

const nextPage = () => {
    if (currentPage.value < totalPages.value) {
        currentPage.value++
        loadActivities()
    }
}

const goToPage = (page: number) => {
    currentPage.value = page
    loadActivities()
}

// Load initial data
onMounted(() => {
    loadActivities()
})

// Modal handlers
const openEditModal = (activityId: number) => {
    selectedActivityId.value = activityId
    defaultProjectId.value = undefined // Don't override project when editing
    showTimeEntryModal.value = true
}

const openAddModal = () => {
    selectedActivityId.value = null
    // Use the project ID from filter if available
    defaultProjectId.value = filter.value.projectId
    showTimeEntryModal.value = true
}

const onTimeEntrySaved = () => {
    // Reload activities to update the list
    loadActivities()
}

// Export handler
const handleExport = async () => {
    exportLoading.value = true
    try {
        // Fetch all data without pagination
        const response = await fetchActivitiesExport({
            query: { ...filter.value, limit: 20000, page: 1 },
        })

        if (response && response.data) {
            // Prepare columns for export using translations
            const columns = [
                {
                    key: "date",
                    label: t("time.columns.date"),
                    formatter: (value: any) => formatDateForExport(value),
                },
                { key: "user.initials", label: t("time.columns.user") },
                { key: "rateClass", label: t("time.columns.rateClass") },
                { key: "project.projectNumber", label: t("projects.mandat") },
                { key: "project.name", label: t("time.columns.project") },
                { key: "activityType.code", label: t("time.columns.activityType") },
                {
                    key: "duration",
                    label: t("time.columns.duration"),
                    formatter: (value: any) => value,
                },
                { key: "rate", label: "Tarif", formatter: (value: any) => value },
                {
                    key: "kilometers",
                    label: t("time.columns.kilometers"),
                    formatter: (value: any) => value || "0",
                },
                {
                    key: "expenses",
                    label: t("time.columns.expenses"),
                    formatter: (value: any) => value,
                },
                { key: "description", label: t("time.columns.description") },
                {
                    key: "billed",
                    label: t("time.columns.billed"),
                    formatter: (value: any) => (value ? "Oui" : "Non"),
                },
                {
                    key: "disbursement",
                    label: t("time.columns.disbursement"),
                    formatter: (value: any) => (value ? "Oui" : "Non"),
                },
            ]

            // Generate filename with current date
            const today = new Date().toISOString().split("T")[0]
            const filename = `heures-${today}.csv`

            // Export to CSV
            exportToCSV({
                filename,
                columns,
                data: response.data,
            })
        }
    } catch (error) {
        console.error("Failed to export activities:", error)
        // You might want to show an error message to the user here
    } finally {
        exportLoading.value = false
    }
}

// Expose methods that parent components might need
defineExpose({
    loadActivities,
})
</script>
