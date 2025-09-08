<template>
    <div class="bg-white rounded-lg shadow-sm">
        <!-- Header with title and actions -->
        <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex justify-between items-center">
                <div class="flex">
                    <h1 class="text-2xl font-bold mr-2">
                        {{ $t("projects.preview") }}
                    </h1>
                    <div>
                        <strong class="text-2xl text-gray-500"
                            >{{ projectData?.projectNumber }}
                            {{
                                projectData?.subProjectName ? ` ${projectData.subProjectName}` : ""
                            }}</strong
                        >
                        <span class="text-1xl text-gray-900">
                            {{ projectData?.name || $t("projects.noName") }}</span
                        >
                    </div>
                </div>
                <div class="flex gap-2">
                    <Button
                        variant="primary"
                        :to="{ name: 'project-edit', params: { id: projectId } }"
                    >
                        {{ $t("common.edit") }}
                    </Button>
                    <Button
                        variant="secondary"
                        :to="{ name: 'invoice-new', query: { projectId: projectId } }"
                    >
                        {{ $t("invoice.new") }}
                    </Button>
                    <Button variant="secondary" @click="showTimeEntryModal = true">
                        {{ $t("time.new") }}
                    </Button>
                </div>
            </div>
        </div>

        <!-- Tabs Navigation -->
        <div class="border-b border-gray-200">
            <nav class="flex -mb-px px-6">
                <button
                    @click="activeTab = 'overview'"
                    :class="[
                        'py-4 px-6 font-medium text-sm cursor-pointer',
                        activeTab === 'overview'
                            ? 'border-b-2 border-blue-500 text-blue-600'
                            : 'text-gray-500 hover:text-gray-700 hover:border-gray-300',
                    ]"
                >
                    {{ $t("projects.tabs.overview") }}
                </button>
                <button
                    @click="activeTab = 'activities'"
                    :class="[
                        'py-4 px-6 font-medium text-sm cursor-pointer',
                        activeTab === 'activities'
                            ? 'border-b-2 border-blue-500 text-blue-600'
                            : 'text-gray-500 hover:text-gray-700 hover:border-gray-300',
                    ]"
                >
                    {{ $t("projects.tabs.activities") }}
                </button>
                <button
                    @click="activeTab = 'invoices'"
                    :class="[
                        'py-4 px-6 font-medium text-sm cursor-pointer',
                        activeTab === 'invoices'
                            ? 'border-b-2 border-blue-500 text-blue-600'
                            : 'text-gray-500 hover:text-gray-700 hover:border-gray-300',
                    ]"
                >
                    {{ $t("projects.tabs.invoices") }}
                </button>
            </nav>
        </div>

        <!-- Tab Content -->
        <LoadingOverlay :loading="loading">
            <div v-if="projectData" class="p-6">
                <!-- Overview Tab -->
                <div v-show="activeTab === 'overview'" class="space-y-6">
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Project Details -->
                        <div class="lg:col-span-2">
                            <div class="bg-gray-50 rounded-lg p-6">
                                <h2 class="text-lg font-semibold mb-4">
                                    {{ $t("projects.details") }}
                                </h2>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.mandat") }}
                                        </p>
                                        <p class="font-medium">
                                            {{ projectData.projectNumber }}
                                            {{
                                                projectData.subProjectName
                                                    ? ` ${projectData.subProjectName}`
                                                    : ""
                                            }}
                                        </p>
                                    </div>

                                    <div>
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.date") }}
                                        </p>
                                        <p class="font-medium">
                                            {{ formatDate(projectData.startDate) }}
                                        </p>
                                    </div>

                                    <div class="col-span-2">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.designation") }}
                                        </p>
                                        <p class="font-medium">{{ projectData.name }}</p>
                                    </div>

                                    <div v-if="projectData.client">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.client") }}
                                        </p>
                                        <p class="font-medium">{{ projectData.client.name }}</p>
                                    </div>

                                    <div v-if="projectData.projectManager">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.responsible") }}
                                        </p>
                                        <p class="font-medium">
                                            {{ projectData.projectManager.firstName }}
                                            {{ projectData.projectManager.lastName }}
                                        </p>
                                    </div>

                                    <div v-if="projectData.company">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.enterprise") }}
                                        </p>
                                        <p class="font-medium">{{ projectData.company.name }}</p>
                                    </div>

                                    <div v-if="projectData.type">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.type") }}
                                        </p>
                                        <p class="font-medium">{{ projectData.type.name }}</p>
                                    </div>

                                    <div v-if="projectData.invoicingAddress" class="col-span-2">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.invoicingAddress") }}
                                        </p>
                                        <p class="font-medium whitespace-pre-line">
                                            {{ projectData.invoicingAddress }}
                                        </p>
                                    </div>

                                    <div v-if="projectData.remark" class="col-span-2">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.remark") }}
                                        </p>
                                        <p class="font-medium whitespace-pre-line">
                                            {{ projectData.remark }}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Project Statistics -->
                        <div>
                            <div class="bg-gray-50 rounded-lg p-6">
                                <h2 class="text-lg font-semibold mb-4">
                                    {{ $t("projects.statistics") }}
                                </h2>
                                <div class="space-y-4">
                                    <div v-if="projectData.totalDuration">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.totalDuration") }}
                                        </p>
                                        <p class="font-medium text-lg">
                                            {{ formatNumber(projectData.totalDuration) }}
                                        </p>
                                    </div>
                                    <div v-if="projectData.unBilledDuration">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.unBilledDuration") }}
                                        </p>
                                        <p class="font-medium text-lg text-orange-600">
                                            {{ formatNumber(projectData.unBilledDuration) }}
                                        </p>
                                    </div>
                                    <div v-if="projectData.firstActivityDate">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.firstActivity") }}
                                        </p>
                                        <p class="font-medium">
                                            {{ formatDate(projectData.firstActivityDate) }}
                                        </p>
                                    </div>
                                    <div v-if="projectData.lastActivityDate">
                                        <p class="text-sm text-gray-500">
                                            {{ $t("projects.lastActivity") }}
                                        </p>
                                        <p class="font-medium">
                                            {{ formatDate(projectData.lastActivityDate) }}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Activities Tab -->
                <div v-show="activeTab === 'activities'">
                    <TimeEntriesManager
                        :show-project-filter="false"
                        :initial-filter="{ projectId: projectId }"
                        :hide-columns="['project']"
                        empty-message="Aucune entrée d'heure trouvée pour ce mandat"
                    />
                </div>

                <!-- Invoices Tab -->
                <div v-show="activeTab === 'invoices'">
                    <InvoiceListManager
                        :initial-filter="{ projectId: projectId }"
                        :hide-columns="['project']"
                        :show-delete="false"
                        empty-message="Aucune facture trouvée pour ce mandat"
                    />
                </div>
            </div>
        </LoadingOverlay>

        <!-- Time Entry Modal -->
        <TimeEntryModal
            v-model="showTimeEntryModal"
            :project-id="projectId"
            @saved="handleTimeEntrySaved"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "@/components/atoms/Button.vue"
import TimeEntriesManager from "@/components/organisms/time/TimeEntriesManager.vue"
import InvoiceListManager from "@/components/organisms/invoice/InvoiceListManager.vue"
import TimeEntryModal from "@/components/organisms/time/TimeEntryModal.vue"
import { useFetchProject } from "@/composables/api/useProject"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import { useFormat } from "@/composables/utils/useFormat"

const route = useRoute()
const router = useRouter()

// Tab state - get from query string or default to overview
const activeTab = computed({
    get: () => (route.query.tab as string) || "overview",
    set: (value) => {
        router.push({
            query: { ...route.query, tab: value },
        })
    },
})
const showTimeEntryModal = ref(false)

// API client
const { get: fetchProject, loading, data: projectData } = useFetchProject()
const { formatNumber, formatDate } = useFormat()

// Get project ID from route
const projectId = computed(() => parseInt(route.params.id as string))

watch(
    () => projectData.value,
    async (newId) => {
        document.title = `BEG - Mandat ${projectData.value?.projectNumber || ""}`
    },
    { immediate: true }
)
// Load project data on mount
onMounted(async () => {
    if (projectId.value && !isNaN(projectId.value)) {
        await fetchProject({ params: { id: projectId.value } })
    }
})

// Handle time entry saved
const handleTimeEntrySaved = async () => {
    // Refresh project data to update unbilled duration
    if (projectId.value && !isNaN(projectId.value)) {
        await fetchProject({ params: { id: projectId.value } })
    }
    // Switch to activities tab to show the new entry
    activeTab.value = "activities"
}
</script>
