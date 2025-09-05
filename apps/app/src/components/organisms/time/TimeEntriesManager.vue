<template>
    <div>
        <TimeFilterPanel v-model:filter="filter" :show-project-filter="showProjectFilter" />
        <LoadingOverlay :loading="loading">
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
            @saved="onTimeEntrySaved"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, computed } from "vue"
import { useFetchActivityList } from "@/composables/api/useActivity"
import TimeFilterPanel, {
    type TimeFilterModel,
} from "@/components/organisms/time/TimeFilterPanel.vue"
import TimeEntriesList from "@/components/organisms/time/TimeEntriesList.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import TimeEntryModal from "@/components/organisms/time/TimeEntryModal.vue"
import type { ActivityFilter, ActivityResponse, ActivityListResponse } from "@beg/validations"

interface Props {
    emptyMessage?: string
    showProjectFilter?: boolean
    initialFilter?: Partial<TimeFilterModel>
    hideColumns?: string[]
}

const props = withDefaults(defineProps<Props>(), {
    emptyMessage: "Aucune entrée d'heure trouvée",
    showProjectFilter: true,
})

// API client
const { get: fetchActivities, loading, data } = useFetchActivityList()

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

// Filter state
const filter = ref<TimeFilterModel>({
    userId: undefined,
    activityTypeId: undefined,
    includeBilled: false,
    includeUnbilled: false,
    includeDisbursement: false,
    sortBy: "date",
    sortOrder: "desc",
    ...props.initialFilter,
})

const sort = computed(() => ({
    key: filter.value.sortBy,
    direction: filter.value.sortOrder,
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
    showTimeEntryModal.value = true
}

const onTimeEntrySaved = () => {
    // Reload activities to update the list
    loadActivities()
}

// Expose methods that parent components might need
defineExpose({
    loadActivities,
})
</script>
