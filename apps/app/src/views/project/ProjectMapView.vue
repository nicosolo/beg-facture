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
                <ProjectMap v-else-if="projects" :projects="projects" class="h-full" />
            </LoadingOverlay>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchProjectMap } from "@/composables/api/useProjectMap"
import ProjectMap from "@/components/organisms/project/ProjectMap.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import ProjectFilterPanel, {
    type ProjectFilterModel,
} from "@/components/organisms/project/ProjectFilterPanel.vue"
import { getYearRange } from "@/composables/utils/useDateRangePresets"

// Initialize i18n
const { t } = useI18n()

// API client
const { get: fetchProjectMap, loading, data: projects } = useFetchProjectMap()

// Initialize filter with default values
const { from, to } = getYearRange(new Date(), 10)
const filter = ref<ProjectFilterModel>({
    name: "",
    includeArchived: false,
    includeEnded: false,
    includeDraft: false,
    sortBy: "name",
    sortOrder: "asc",
    fromDate: from,
    toDate: to,
    referentUserId: undefined,
    hasUnbilledTime: false,
})

const loadProjects = async () => {
    await fetchProjectMap({
        query: filter.value,
    })
}

const handleFilterChange = (newFilter: ProjectFilterModel) => {
    filter.value = newFilter
    loadProjects()
}

// Initial load
onMounted(() => {
    document.title = "BEG - Projects Map"
    loadProjects()
})
</script>
