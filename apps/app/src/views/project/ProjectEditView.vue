<template>
    <FormLayout
        :title="isNewProject ? $t('projects.new') : $t('projects.edit')"
        :loading="isSubmitting || loadingData"
        :error-message="errorMessage"
    >
        <form @submit.prevent="saveProject" id="projectForm" class="space-y-4">
            <FormField
                :label="$t('projects.startDate')"
                :error="errors.startDate"
                required
                class=""
            >
                <template #input>
                    <Input type="date" v-model="formattedDate" required />
                </template>
            </FormField>
            <!-- Parent Project Selection (for new sub-projects) -->
            <div v-if="isNewProject" class="">
                <FormField :label="$t('projects.parentProject')" :error="errors.parentProjectId">
                    <template #input>
                        <ProjectSelect
                            v-model="form.parentProjectId"
                            :placeholder="$t('projects.selectParentProject')"
                            :include-ended="false"
                            :include-archived="false"
                            @update:model-value="handleParentProjectChange"
                        />
                    </template>
                </FormField>
            </div>

            <!-- First Line: Number (1/3) and Name (2/3) -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <FormField :label="$t('projects.mandat')" :error="errors.projectNumber" required>
                    <template #input>
                        <Input
                            type="text"
                            v-model="form.projectNumber"
                            :disabled="!!form.parentProjectId"
                            required
                        />
                    </template>
                </FormField>

                <div class="md:col-span-2">
                    <FormField :label="$t('projects.designation')" :error="errors.name" required>
                        <template #input>
                            <Input type="text" v-model="form.name" required />
                        </template>
                    </FormField>
                </div>
            </div>
            <pre>{{ form }}</pre>
            <!-- Second Line: Project Manager, Type, and Company -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <FormField :label="$t('projects.responsible')" :error="errors.projectManagerId">
                    <template #input>
                        <UserSelect
                            v-model="form.projectManagerId"
                            :placeholder="$t('common.select')"
                        />
                    </template>
                </FormField>

                <FormField :label="$t('projects.type')" :error="errors.typeId" required>
                    <template #input>
                        <ProjectTypeSelect
                            v-model="form.typeId"
                            :placeholder="$t('common.select')"
                            :required="true"
                        />
                    </template>
                </FormField>

                <FormField :label="$t('projects.enterprise')" :error="errors.companyId">
                    <template #input>
                        <CompanySelect
                            v-model="form.companyId"
                            :placeholder="$t('common.select')"
                        />
                    </template>
                </FormField>
            </div>

            <!-- Sub-project Name and Date -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <FormField
                    v-if="form.parentProjectId || (!isNewProject && form.subProjectName)"
                    :label="$t('projects.subProjectName')"
                    :error="errors.subProjectName"
                >
                    <template #input>
                        <Input
                            type="text"
                            v-model="form.subProjectName"
                            :placeholder="$t('projects.subProjectNamePlaceholder')"
                            required
                        />
                    </template>
                </FormField>
            </div>

            <!-- Additional Details: Locality, Client, Engineer -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <FormField :label="$t('projects.locality')" :error="errors.locationId">
                    <template #input>
                        <LocationSelect
                            v-model="form.locationId"
                            :placeholder="$t('common.select')"
                        />
                    </template>
                </FormField>

                <FormField :label="$t('projects.client')" :error="errors.clientId">
                    <template #input>
                        <ClientSelect v-model="form.clientId" :placeholder="$t('common.select')" />
                    </template>
                </FormField>

                <FormField :label="$t('projects.engineer')" :error="errors.engineerId">
                    <template #input>
                        <EngineerSelect
                            v-model="form.engineerId"
                            :placeholder="$t('common.select')"
                        />
                    </template>
                </FormField>
            </div>

            <!-- Remark -->
            <div class="">
                <FormField :label="$t('projects.remark')" :error="errors.remark">
                    <template #input>
                        <Textarea
                            v-model="form.remark"
                            rows="3"
                            class="w-full p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            :placeholder="$t('projects.remarkPlaceholder')"
                        ></Textarea>
                    </template>
                </FormField>
            </div>

            <!-- Invoicing Address -->
            <div class="">
                <FormField
                    :label="$t('projects.invoicingAddress')"
                    :error="errors.invoicingAddress"
                >
                    <template #input>
                        <Textarea
                            v-model="form.invoicingAddress"
                            rows="4"
                            class="w-full p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            :placeholder="$t('projects.invoicingAddressPlaceholder')"
                        ></Textarea>
                    </template>
                </FormField>
            </div>

            <!-- Flags -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <FormField :label="$t('projects.printFlag')">
                    <template #input>
                        <label class="flex items-center">
                            <input
                                type="checkbox"
                                v-model="form.printFlag"
                                class="mr-2 h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                            />
                            <span>{{ $t("projects.enablePrint") }}</span>
                        </label>
                    </template>
                </FormField>

                <FormField :label="$t('projects.statusLabel')">
                    <template #input>
                        <label class="flex items-center">
                            <input
                                type="checkbox"
                                v-model="form.ended"
                                class="mr-2 h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                            />
                            <span>{{ $t("projects.markAsEnded") }}</span>
                        </label>
                    </template>
                </FormField>

                <FormField :label="$t('projects.archive')">
                    <template #input>
                        <label class="flex items-center">
                            <input
                                type="checkbox"
                                v-model="form.archived"
                                class="mr-2 h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                            />
                            <span>{{ $t("projects.markAsArchived") }}</span>
                        </label>
                    </template>
                </FormField>
            </div>
        </form>

        <template #actions>
            <Button variant="secondary" type="button" :to="{ name: 'project-list' }">
                {{ $t("common.cancel") }}
            </Button>
            <Button
                variant="primary"
                type="submit"
                form="projectForm"
                :loading="isSubmitting || loadingData"
            >
                {{ $t("common.save") }}
            </Button>
        </template>
    </FormLayout>
    <!-- Project Access Management - Only for admins editing existing projects -->
    <div v-if="!isNewProject && user?.role === 'admin'" class="">
        <ProjectAccessManagement :project-id="projectId!" />
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import { useToast } from "@/composables/utils/useToast"
import { useAuthStore } from "@/stores/auth"
import Button from "@/components/atoms/Button.vue"
import FormField from "@/components/molecules/FormField.vue"
import FormLayout from "@/components/templates/FormLayout.vue"
import Input from "@/components/atoms/Input.vue"
import ProjectSelect from "@/components/organisms/project/ProjectSelect.vue"
import LocationSelect from "@/components/organisms/location/LocationSelect.vue"
import ClientSelect from "@/components/organisms/client/ClientSelect.vue"
import EngineerSelect from "@/components/organisms/engineer/EngineerSelect.vue"
import CompanySelect from "@/components/organisms/company/CompanySelect.vue"
import ProjectTypeSelect from "@/components/organisms/projectType/ProjectTypeSelect.vue"
import UserSelect from "@/components/organisms/user/UserSelect.vue"
import ProjectAccessManagement from "@/components/organisms/project/ProjectAccessManagement.vue"

// API Composables
import { useFetchProject, useCreateProject, useUpdateProject } from "@/composables/api/useProject"
import type { ProjectCreateInput, ProjectUpdateInput } from "@beg/validations"
import Textarea from "@/components/atoms/Textarea.vue"

const { t } = useI18n()
const route = useRoute()
const router = useRouter()
const { showSuccess, showError } = useToast()
const authStore = useAuthStore()

// Get current user
const user = computed(() => authStore.user)

// Determine if we're creating a new project or editing an existing one
const projectId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewProject = computed(() => !projectId.value)

// Loading states
const isSubmitting = ref(false)
const loadingData = ref(true)

// Form validation errors
const errors = ref<Record<string, string>>({})
const errorMessage = ref<string | null>(null)

// API composables
const { get: fetchProject, data: projectData } = useFetchProject()
const { post: createProject, loading: creating } = useCreateProject()
const { put: updateProject, loading: updating } = useUpdateProject()

// Note: Select components handle their own data fetching

// Form state - Using partial type to allow undefined typeId
const form = ref<
    Partial<ProjectCreateInput> & { projectNumber: string; name: string; startDate: Date }
>({
    projectNumber: "",
    subProjectName: "",
    parentProjectId: undefined,
    name: "",
    startDate: new Date(),
    typeId: undefined,
    locationId: undefined,
    clientId: undefined,
    engineerId: undefined,
    companyId: undefined,
    projectManagerId: undefined,
    remark: "",
    invoicingAddress: "",
    printFlag: false,
    ended: false,
    archived: false,
})

// Note: AutocompleteSelect now uses the raw data directly with displayField prop

// Handle date formatting
const formattedDate = computed({
    get: () => {
        if (!form.value.startDate) return ""
        const date =
            typeof form.value.startDate === "string"
                ? new Date(form.value.startDate)
                : form.value.startDate
        return date.toISOString().split("T")[0]
    },
    set: (value: string) => {
        if (value) {
            form.value.startDate = new Date(value)
        }
    },
})

// Generate next project number for new projects
const generateProjectNumber = () => {
    // Simple implementation - in production, this should query the backend for the next available number
    const year = new Date().getFullYear()
    const random = Math.floor(Math.random() * 10000)
        .toString()
        .padStart(4, "0")
    return `${year}${random}`
}

// Create a separate instance for fetching parent project
const { get: fetchParentProjectData, data: parentProjectData } = useFetchProject()

// Handle parent project selection
const handleParentProjectChange = async (parentProjectId: number | undefined) => {
    if (parentProjectId && isNewProject.value) {
        // Fetch the parent project details
        await fetchParentProjectData({ params: { id: parentProjectId } })

        if (parentProjectData.value) {
            // Copy parent project data
            form.value.projectNumber = parentProjectData.value.projectNumber
            form.value.typeId = parentProjectData.value.type?.id
            form.value.name = parentProjectData.value.name
            form.value.locationId = parentProjectData.value.location?.id
            form.value.clientId = parentProjectData.value.client?.id
            form.value.engineerId = parentProjectData.value.engineer?.id
            form.value.companyId = parentProjectData.value.company?.id
            form.value.projectManagerId = parentProjectData.value.projectManager?.id
        }
    } else if (!parentProjectId) {
        // Clear copied data when parent is deselected
        form.value.projectNumber = generateProjectNumber()
        form.value.subProjectName = ""
    }
}

// Validate form
const validateForm = (): boolean => {
    errors.value = {}
    let isValid = true

    if (!form.value.projectNumber) {
        errors.value.projectNumber = t("validation.required")
        isValid = false
    }

    if (!form.value.name) {
        errors.value.name = t("validation.required")
        isValid = false
    }

    if (!form.value.startDate) {
        errors.value.startDate = t("validation.required")
        isValid = false
    }

    if (!form.value.typeId) {
        errors.value.typeId = t("validation.required")
        isValid = false
    }

    return isValid
}

// Save project function
const saveProject = async () => {
    // Validate form
    if (!validateForm()) {
        errorMessage.value = t("validation.pleaseFillRequired")
        showError(t("validation.pleaseFillRequired"))
        return
    }

    try {
        isSubmitting.value = true
        errorMessage.value = null

        // Prepare data for submission
        const submitData = {
            projectNumber: form.value.projectNumber,
            name: form.value.name,
            startDate: form.value.startDate,
            typeId: form.value.typeId!, // We validated it exists
            subProjectName: form.value.subProjectName,
            parentProjectId: form.value.parentProjectId,
            locationId: form.value.locationId || null,
            clientId: form.value.clientId || null,
            engineerId: form.value.engineerId || null,
            companyId: form.value.companyId || null,
            projectManagerId: form.value.projectManagerId || null,
            remark: form.value.remark,
            invoicingAddress: form.value.invoicingAddress,
            printFlag: form.value.printFlag || false,
            ended: form.value.ended || false,
            archived: form.value.archived || false,
        }

        let savedProjectId = projectId.value

        if (isNewProject.value) {
            // Create new project
            const response = await createProject({ body: submitData as ProjectCreateInput })
            savedProjectId = response?.id
            showSuccess(t("projects.createSuccess"))
        } else {
            // Update existing project
            await updateProject({
                params: { id: projectId.value! },
                body: submitData as ProjectUpdateInput,
            })
            showSuccess(t("projects.updateSuccess"))
        }

        // Redirect to project preview after saving
        if (savedProjectId) {
            router.push({ name: "project-view", params: { id: savedProjectId } })
        } else {
            router.push({ name: "project-list" })
        }
    } catch (error: any) {
        console.error("Error saving project:", error)

        // Handle specific error messages
        if (error.message?.includes("already exists")) {
            errors.value.projectNumber = t("projects.projectNumberExists")
            errorMessage.value = t("projects.projectNumberExists")
            showError(t("projects.projectNumberExists"))
        } else if (error.message?.includes("permissions")) {
            errorMessage.value = t("errors.noPermission")
            showError(t("errors.noPermission"))
        } else {
            errorMessage.value = t("errors.general")
            showError(t("errors.general"))
        }
    } finally {
        isSubmitting.value = false
    }
}

// Load data on mount
onMounted(async () => {
    document.title = "BEG - Modifier le mandat"
    try {
        loadingData.value = true

        // No need to load select options - dedicated components handle their own data

        // Load existing project if editing
        if (projectId.value && !isNaN(projectId.value)) {
            await fetchProject({ params: { id: projectId.value } })

            if (projectData.value) {
                // Map API response to form
                form.value = {
                    projectNumber: projectData.value.projectNumber,
                    subProjectName: projectData.value.subProjectName || "",
                    parentProjectId: undefined,
                    name: projectData.value.name,
                    startDate: projectData.value.startDate,
                    typeId: projectData.value.type?.id,
                    locationId: projectData.value.location?.id,
                    clientId: projectData.value.client?.id,
                    engineerId: projectData.value.engineer?.id,
                    companyId: projectData.value.company?.id,
                    projectManagerId: projectData.value.projectManager?.id,
                    remark: projectData.value.remark || "",
                    invoicingAddress: projectData.value.invoicingAddress || "",
                    printFlag: projectData.value.printFlag || false,
                    ended: projectData.value.ended || false,
                    archived: false, // This field doesn't exist in current response
                }
            }
        } else if (isNewProject.value) {
            // Generate project number for new projects
            form.value.projectNumber = generateProjectNumber()
        }
    } catch (error) {
        console.error("Error loading data:", error)
        showError(t("errors.loadingData"))
    } finally {
        loadingData.value = false
    }
})

// Watch for submission state
watch([creating, updating], ([isCreating, isUpdating]) => {
    isSubmitting.value = isCreating || isUpdating
})
</script>
