<template>
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold">{{ $t("projects.title") }}</h1>
        <div class="flex gap-2">
            <DropdownMenu>
                <template #trigger="{ toggle }">
                    <Button variant="secondary" size="md" @click="toggle" :disabled="exportLoading">
                        {{
                            exportLoading
                                ? $t("projects.export.exporting")
                                : $t("projects.export.button")
                        }}
                    </Button>
                </template>
                <template #items="{ close }">
                    <button
                        @click="
                            () => {
                                handleExport(false)
                                close()
                            }
                        "
                        class="block w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 cursor-pointer transition-colors"
                        role="menuitem"
                        type="button"
                    >
                        {{ $t("projects.export.all") }}
                    </button>
                    <button
                        @click="
                            () => {
                                handleExport(true)
                                close()
                            }
                        "
                        class="block w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 cursor-pointer transition-colors"
                        role="menuitem"
                        type="button"
                    >
                        {{ $t("projects.export.perUser") }}
                    </button>
                </template>
            </DropdownMenu>
            <Button
                v-if="authStore.isRole('admin')"
                :to="{ name: 'project-new' }"
                variant="primary"
                size="md"
            >
                {{ $t("projects.new") }}
            </Button>
        </div>
    </div>
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
import { useFetchProjectList, useExportProjects } from "@/composables/api/useProject"
import ProjectFilterPanel, {
    type ProjectFilterModel,
} from "@/components/organisms/project/ProjectFilterPanel.vue"
import ProjectTable from "@/components/organisms/project/ProjectTable.vue"
import Pagination from "@/components/organisms/Pagination.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import TimeEntryModal from "@/components/organisms/time/TimeEntryModal.vue"
import Button from "@/components/atoms/Button.vue"
import DropdownMenu from "@/components/atoms/DropdownMenu.vue"
import type { PageResponse, ProjectFilter, ProjectResponse } from "@beg/validations"
import { useAuthStore } from "@/stores/auth"

// Initialize i18n
const { t } = useI18n()

// API client
const { get: fetchProjects, loading, data } = useFetchProjectList()
const { get: exportProjects, loading: exportLoading } = useExportProjects()

// State
const projects = ref<ProjectResponse[]>([])
const totalItems = ref(0)
const totalPages = ref(0)
const currentPage = ref(1)
const pageSize = ref(100)

// Modal state
const showTimeEntryModal = ref(false)
const selectedProjectId = ref<number | null>(null)
const authStore = useAuthStore()
// Filter state

const filter = ref<ProjectFilterModel>({
    name: "",
    includeArchived: false,
    includeEnded: false,
    includeDraft: false,
    sortBy: "lastActivityDate",
    sortOrder: "desc",
    fromDate: undefined,
    toDate: undefined,
    referentUserId: authStore.user?.id,
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
    document.title = "BEG - Mandats"
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

// Export handler
const handleExport = async (perUser: boolean = false) => {
    try {
        const arrayBuffer = await exportProjects({
            query: { ...filter.value, perUser },
        })

        if (!arrayBuffer) {
            return
        }

        const blob = new Blob([arrayBuffer], {
            type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        })

        const today = new Date().toISOString().split("T")[0]
        const filename = `mandats-${today}.xlsx`

        const url = URL.createObjectURL(blob)
        const link = document.createElement("a")
        link.href = url
        link.download = filename
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
        URL.revokeObjectURL(url)
    } catch (error) {
        console.error("Failed to export projects:", error)
    }
}
</script>
