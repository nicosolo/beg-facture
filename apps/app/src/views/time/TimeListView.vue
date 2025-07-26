<template>
    <h1 class="text-2xl font-bold mb-6">{{ $t("time.title") }}</h1>

    <TimeFilterPanel
        v-model:filter="filter"
        @filter-change="loadActivities"
        @filter-input-change="debouncedFetch"
    />
    <LoadingOverlay :loading="loading">
        <TimeEntriesList
            :activities="activities"
            :totals="totals"
            :sort="sort"
            empty-message="Aucune entrée d'heure trouvée"
            editRoute="time-edit"
            @sort-change="handleSortChange"
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
</template>

<script setup lang="ts">
import { ref, watch, onMounted, computed } from "vue"
import { useFetchActivityList } from "@/composables/api/useActivity"
import { debounce } from "@/utils/debounce"
import TimeFilterPanel, {
    type TimeFilterModel,
} from "../../components/organisms/TimeFilterPanel.vue"
import TimeEntriesList from "../../components/organisms/TimeEntriesList.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import type { ActivityFilter, ActivityResponse, ActivityListResponse } from "@beg/validations"
import { useRoute } from "vue-router"

// API client
const { get: fetchActivities, loading, data } = useFetchActivityList()

// State
const activities = ref<ActivityResponse[]>([])
const totalItems = ref(0)
const totalPages = ref(0)
const currentPage = ref(1)
const pageSize = ref(20)
const totals = ref<{ duration: number; kilometers: number; expenses: number } | undefined>()
const route = useRoute()
// Filter state
const filter = ref<TimeFilterModel>({
    userId: undefined,
    projectId: (route.query.projectId as unknown as number) || undefined,
    activityTypeId: undefined,
    fromDate: undefined,
    toDate: undefined,
    includeBilled: false,
    includeUnbilled: true,
    includeDisbursement: false,
    sortBy: "date",
    sortOrder: "desc",
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

const debouncedFetch = debounce(loadActivities, 300)

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
</script>
