<template>
    <div class="container mx-auto py-8">
        <h1 class="text-2xl font-bold mb-6">{{ $t("projects.title") }}</h1>

        <ProjectFilterPanel
            v-model:filter="filter"
            @filter-change="loadProjects"
            @filter-input-change="debouncedFetch"
        />
        <LoadingOverlay :loading="loading">
            <ProjectTable :projects="projects" />

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
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import type { Project, Page } from "@beg/types"
import { useFetchProject } from "@/composables/api/useFetchProject"
import ProjectFilterPanel, {
    type ProjectFilterModel,
} from "@/components/organisms/project/ProjectFilterPanel.vue"
import ProjectTable from "@/components/organisms/project/ProjectTable.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"

// Initialize i18n
const { t } = useI18n()

// API client
const { get: fetchProjects, loading, data } = useFetchProject()

// State
const projects = ref<Project[]>([])
const totalItems = ref(0)
const totalPages = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)

// Filter state
const filter = ref<ProjectFilterModel>({
    name: "",
    archived: false,
    sortBy: "lastActivityDate",
    sortOrder: "asc",
    fromDate: undefined,
    toDate: undefined,
    referentUserId: undefined,
    hasUnbilledTime: true,
})

// Watch for API data changes
watch(
    data,
    (newData) => {
        if (newData) {
            const pageData = newData as unknown as Page<Project>
            projects.value = pageData.data
            totalItems.value = pageData.total
            totalPages.value = pageData.totalPages
        }
    },
    { deep: true }
)

// Methods
const debouncedFetch = (() => {
    let timeout: ReturnType<typeof setTimeout> | null = null
    return () => {
        if (timeout) clearTimeout(timeout)
        timeout = setTimeout(() => {
            loadProjects()
            timeout = null
        }, 300)
    }
})()

const loadProjects = async () => {
    await fetchProjects({
        ...filter.value,
        page: currentPage.value,
        limit: pageSize.value,
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

// Initial load
onMounted(() => {
    loadProjects()
})
</script>
