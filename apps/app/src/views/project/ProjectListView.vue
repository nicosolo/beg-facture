<template>
    <h1 class="text-2xl font-bold mb-6">{{ $t("projects.title") }}</h1>

    <ProjectFilterPanel v-model:filter="filter" />
    <LoadingOverlay :loading="loading">
        <ProjectTable
            :projects="projects"
            :sort="sort"
            @sort-change="handleSortChange"
            @add-hours="openTimeEntryModal"
        />

        <Pagination
            v-if="projects.length > 0 || totalItems > 0"
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
        :project-id="selectedProjectId"
        @saved="onTimeEntrySaved"
    />
</template>

<script setup lang="ts">
import { ref, watch, onMounted, computed } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchProjectList } from "@/composables/api/useProject"
import ProjectFilterPanel, {
    type ProjectFilterModel,
} from "@/components/organisms/project/ProjectFilterPanel.vue"
import ProjectTable from "@/components/organisms/project/ProjectTable.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import TimeEntryModal from "@/components/organisms/TimeEntryModal.vue"
import type { PageResponse, ProjectFilter, ProjectResponse } from "@beg/validations"

// Initialize i18n
const { t } = useI18n()

// API client
const { get: fetchProjects, loading, data } = useFetchProjectList()

// State
const projects = ref<ProjectResponse[]>([])
const totalItems = ref(0)
const totalPages = ref(0)
const currentPage = ref(1)
const pageSize = ref(100)

// Modal state
const showTimeEntryModal = ref(false)
const selectedProjectId = ref<number | null>(null)

// Filter state
const filter = ref<ProjectFilterModel>({
    name: "",
    includeArchived: false,
    includeEnded: false,
    sortBy: "lastActivityDate",
    sortOrder: "desc",
    fromDate: undefined,
    toDate: undefined,
    referentUserId: undefined,
    hasUnbilledTime: false,
})

const sort = computed(() => ({
    key: filter.value.sortBy,
    direction: filter.value.sortOrder,
}))

const handleSortChange = (sort: {
    key: ProjectFilter["sortBy"] | string
    direction: ProjectFilter["sortOrder"] | "asc" | "desc"
}) => {
    filter.value.sortBy = sort.key as ProjectFilter["sortBy"]
    filter.value.sortOrder = sort.direction as ProjectFilter["sortOrder"]
    loadProjects()
}

// Watch for API data changes
watch(
    data,
    (newData) => {
        if (newData) {
            const pageData = newData as unknown as PageResponse<ProjectResponse>
            projects.value = pageData.data
            totalItems.value = pageData.total
            totalPages.value = pageData.totalPages
        }
    },
    { deep: true }
)

const loadProjects = async () => {
    await fetchProjects({
        query: {
            ...filter.value,
            page: currentPage.value,
            limit: pageSize.value,
        },
    })
}

const goToPage = (page: number) => {
    if (page < 1 || page > totalPages.value) return
    currentPage.value = page
    loadProjects()
}

const prevPage = () => {
    if (currentPage.value > 1) {
        goToPage(currentPage.value - 1)
    }
}

const nextPage = () => {
    if (currentPage.value < totalPages.value) {
        goToPage(currentPage.value + 1)
    }
}

// Watch for page size changes
watch(pageSize, (newValue) => {
    currentPage.value = 1
    loadProjects()
})
// Watch for page size changes
watch(
    filter,
    (newValue) => {
        currentPage.value = 1
        loadProjects()
    },
    {
        deep: true,
    }
)

// Initial load
onMounted(() => {
    loadProjects()
})

// Modal handlers
const openTimeEntryModal = (projectId: number) => {
    selectedProjectId.value = projectId
    showTimeEntryModal.value = true
}

const onTimeEntrySaved = () => {
    // Reload projects to update the unbilled hours
    loadProjects()
}
</script>
