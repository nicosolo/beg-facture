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

                        <div v-if="project.remark">
                            <p class="text-sm text-gray-500">{{ $t("projects.remark") }}</p>
                            <p class="font-medium whitespace-pre-line">{{ project.remark }}</p>
                        </div>
                    </div>

                    <div class="mt-6 space-y-2">
                        <Button
                            variant="primary"
                            :to="{ name: 'project-edit', params: { id: project.id } }"
                            class="w-full"
                        >
                            {{ $t("common.edit") }}
                        </Button>
                        <Button
                            v-if="project.unBilledDuration && project.unBilledDuration > 0"
                            variant="secondary"
                            :to="{ name: 'invoice-new', query: { projectId: project.id } }"
                            class="w-full"
                        >
                            Créer une facture
                        </Button>
                    </div>
                </div>
            </div>

            <!-- Time Entries -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-lg p-6 border border-gray-200">
                    <h2 class="text-lg font-semibold mb-4">{{ $t("timeEntries.title") }}</h2>
                    <TimeEntriesManager
                        :project-id="projectId"
                        :show-project-filter="false"
                        empty-message="Aucune entrée d'heure trouvée pour ce projet"
                    />
                </div>
            </div>
        </div>
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue"
import { useRoute } from "vue-router"
import Button from "@/components/atoms/Button.vue"
import TimeEntriesManager from "@/components/organisms/time/TimeEntriesManager.vue"
import { useFetchProject } from "@/composables/api/useProject"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"

const route = useRoute()

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
        unBilledDuration: projectData.value.unBilledDuration,
    }
})

// Load project data on mount
onMounted(async () => {
    document.title = "BEG - Aperçu du projet"
    console.log("projectId", projectId.value)
    if (projectId.value && !isNaN(projectId.value)) {
        await fetchProject({ params: { id: projectId.value } })
    }
})
</script>
