<template>
    <ProjectListTemplate title="Projects">
        <template #filter>
            <ProjectFilterPanel
                v-model:filter="filter"
                @filter-change="loadProjects"
                @filter-input-change="debouncedFetch"
            />
        </template>

        <template #content>
            <ProjectTable :projects="projects" :loading="loading" />
        </template>

        <template #pagination>
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
        </template>
    </ProjectListTemplate>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import type { Project, Page } from "@beg/types"
import { useFetchProject } from "../composables/api/useFetchProject"
import ProjectFilterPanel, {
    type ProjectFilterModel,
} from "../components/organisms/ProjectFilterPanel.vue"
import ProjectTable from "../components/organisms/ProjectTable.vue"
import Pagination from "../components/organisms/Pagination.vue"
import ProjectListTemplate from "../templates/ProjectListTemplate.vue"

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
    sortBy: "name",
    sortOrder: "asc",
    fromDate: undefined,
    toDate: undefined,
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
    // Create params as a simple object with the correct string formats
    const params: Record<string, string | undefined> = {
        page: currentPage.value.toString(),
        limit: pageSize.value.toString(),
        name: filter.value.name,
        archived: filter.value.archived.toString(),
        sortBy: filter.value.sortBy,
        sortOrder: filter.value.sortOrder,
    }

    // Add date filters if present
    if (filter.value.fromDate) {
        params.fromDate = filter.value.fromDate.toISOString()
    }

    if (filter.value.toDate) {
        params.toDate = filter.value.toDate.toISOString()
    }

    // Use type assertion to bypass type checking
    await fetchProjects(params as any)
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
