<template>
    <div class="mb-6">
        <h1 class="text-2xl font-bold">{{ $t("projects.preview") }}</h1>
    </div>

    <LoadingOverlay :loading="loading">
        <div v-if="project" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Project Details -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-lg p-6 border border-gray-200">
                    <h2 class="text-lg font-semibold mb-4">{{ $t("projects.details") }}</h2>

                    <div class="space-y-4">
                        <div>
                            <p class="text-sm text-gray-500">{{ $t("projects.mandat") }}</p>
                            <p class="font-medium">{{ project.projectNumber }}</p>
                        </div>

                        <div>
                            <p class="text-sm text-gray-500">{{ $t("projects.designation") }}</p>
                            <p class="font-medium">{{ project.name }}</p>
                        </div>

                        <div>
                            <p class="text-sm text-gray-500">{{ $t("projects.date") }}</p>
                            <p class="font-medium">{{ formatDate(project.startDate) }}</p>
                        </div>

                        <div v-if="project.client">
                            <p class="text-sm text-gray-500">{{ $t("projects.client") }}</p>
                            <p class="font-medium">{{ project.client.name }}</p>
                        </div>

                        <div v-if="project.projectManager">
                            <p class="text-sm text-gray-500">{{ $t("projects.responsible") }}</p>
                            <p class="font-medium">
                                {{ project.projectManager.firstName }}
                                {{ project.projectManager.lastName }}
                            </p>
                        </div>

                        <div v-if="project.company">
                            <p class="text-sm text-gray-500">{{ $t("projects.enterprise") }}</p>
                            <p class="font-medium">{{ project.company.name }}</p>
                        </div>

                        <div v-if="project.type">
                            <p class="text-sm text-gray-500">{{ $t("projects.type") }}</p>
                            <p class="font-medium">{{ project.type.name }}</p>
                        </div>

                        <div v-if="invoiceAddress">
                            <p class="text-sm text-gray-500">{{ $t("projects.invoice") }}</p>
                            <p class="font-medium whitespace-pre-line">{{ invoiceAddress }}</p>
                        </div>

                        <div v-if="project.remark">
                            <p class="text-sm text-gray-500">{{ $t("projects.remark") }}</p>
                            <p class="font-medium whitespace-pre-line">{{ project.remark }}</p>
                        </div>
                    </div>

                    <div class="mt-6">
                        <Button
                            variant="primary"
                            :to="{ name: 'project-edit', params: { id: project.id } }"
                        >
                            {{ $t("common.edit") }}
                        </Button>
                    </div>
                </div>
            </div>

            <!-- Time Entries -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-lg p-6 border border-gray-200">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-semibold">{{ $t("timeEntries.title") }}</h2>
                    </div>
                    <TimeFilterPanel />
                    <TimeEntriesList
                        :timeEntries="timeEntries"
                        :emptyMessage="$t('timeEntries.empty')"
                        editRoute="time-new"
                        :hideColumns="['IDHeure']"
                    />
                </div>
            </div>
        </div>
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute } from "vue-router"
import { useI18n } from "vue-i18n"
import Button from "@/components/atoms/Button.vue"
import TimeEntriesList from "@/components/organisms/time/TimeEntriesList.vue"
import { useFormat } from "@/composables/utils/useFormat"
import type { TimeEntry } from "@/components/organisms/time/TimeEntriesList.vue"
import TimeFilterPanel from "@/components/organisms/time/TimeFilterPanel.vue"
import { useFetchProject } from "@/composables/api/useProject"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"

const { t } = useI18n()
const route = useRoute()
const { formatDuration } = useFormat()

// API client
const { get: fetchProject, loading, data: projectData } = useFetchProject()

// Format date function
const formatDate = (date: Date | string | null): string => {
    if (!date) return "-"
    try {
        const dateObj = typeof date === "string" ? new Date(date) : date
        const day = dateObj.getDate().toString().padStart(2, "0")
        const month = (dateObj.getMonth() + 1).toString().padStart(2, "0")
        const year = dateObj.getFullYear()
        return `${day}.${month}.${year}`
    } catch (e) {
        return "-"
    }
}

// Get project ID from route
const projectId = computed(() => parseInt(route.params.id as string))

// Project data from API
const project = computed(() => {
    if (!projectData.value) return null
    return {
        id: projectData.value.id,
        projectNumber: projectData.value.projectNumber,
        name: projectData.value.name,
        startDate: projectData.value.startDate,
        remark: projectData.value.remark,
        client: projectData.value.client,
        location: projectData.value.location,
        engineer: projectData.value.engineer,
        company: projectData.value.company,
        type: projectData.value.type,
        projectManager: projectData.value.projectManager,
        printFlag: projectData.value.printFlag,
    }
})

// Get client invoice address (TODO: This should come from a separate API endpoint)
const invoiceAddress = ref("")

// TODO: Fetch time entries from API when endpoint is available
const timeEntries = ref<TimeEntry[]>([])

// Load project data on mount
onMounted(async () => {
    console.log("projectId", projectId.value)
    if (projectId.value && !isNaN(projectId.value)) {
        await fetchProject({ params: { id: projectId.value } })
    }
})

// Watch for project data changes
watch(projectData, (newData) => {
    if (newData && newData.client) {
        // TODO: Format invoice address from client data
        invoiceAddress.value = `${newData.client.name}`
    }
})
</script>
