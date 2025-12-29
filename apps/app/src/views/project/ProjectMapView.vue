<template>
    <div class="absolute inset-0 flex flex-col">
        <div class="p-6 pb-4">
            <h1 class="text-2xl font-bold">{{ $t("projects.map.title") }}</h1>
            <ProjectFilterPanel
                :filter="filter"
                :show-sort="false"
                :show-checkboxes="false"
                :show-name-input="false"
                @update:filter="handleFilterChange"
            />

            <div class="items-center justify-between mb-4">
                <div>
                    <p v-if="projects && projects.length > 0" class="text-sm text-gray-600 mt-1">
                        {{ $t("projects.map.projectCount", { count: projects.length }) }}
                    </p>
                    <p class="text-xs text-gray-500 mt-1">
                        {{ $t("projects.map.filterInfo") }}
                    </p>
                </div>
            </div>
        </div>
        <div class="flex-1 px-6 pb-6">
            <LoadingOverlay :loading="loading" class="h-full">
                <div
                    v-if="!loading && projects && projects.length === 0"
                    class="h-full flex items-center justify-center"
                >
                    <p class="text-gray-500">{{ $t("projects.map.noProjects") }}</p>
                </div>
                <ProjectMap
                    v-else-if="projects"
                    :projects="projects"
                    class="h-full"
                    @bounds-changed="handleBoundsChanged"
                />
            </LoadingOverlay>
        </div>
    </div>
</template>

<script setup lang="ts">
defineOptions({ name: "ProjectMapView" })

import { ref, onMounted, onActivated } from "vue"
import { useFetchProjectMap } from "@/composables/api/useProjectMap"
import ProjectMap, { type MapBounds } from "@/components/organisms/project/ProjectMap.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import ProjectFilterPanel, {
    type ProjectFilterModel,
} from "@/components/organisms/project/ProjectFilterPanel.vue"

// API client
const { get: fetchProjectMap, loading, data: projects } = useFetchProjectMap()

// Current map bounds (for viewport filtering)
const currentBounds = ref<MapBounds | null>(null)

// Initialize filter with default values
const filter = ref<ProjectFilterModel>({
    name: "",
    includeArchived: false,
    includeEnded: false,
    includeDraft: false,
    sortBy: "name",
    sortOrder: "asc",
    fromDate: undefined,
    toDate: undefined,
    referentUserId: undefined,
    hasUnbilledTime: false,
})

const loadProjects = async () => {
    await fetchProjectMap({
        query: {
            ...filter.value,
            ...(currentBounds.value ?? {}),
        },
    })
}

const handleFilterChange = (newFilter: ProjectFilterModel) => {
    filter.value = newFilter
    loadProjects()
}

const handleBoundsChanged = (bounds: MapBounds) => {
    currentBounds.value = bounds
    loadProjects()
}

onActivated(() => {
    document.title = "BEG - Projects Map"
})
// Initial load
onMounted(() => {
    loadProjects()
})
</script>
