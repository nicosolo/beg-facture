<template>
    <FormLayout
        :title="isNewProject ? $t('projects.new') : $t('projects.edit')"
        :loading="isSubmitting || loadingData"
        :error-message="errorMessage"
    >
        <form @submit.prevent="saveProject" id="projectForm">
            <!-- Basic Information -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <FormField :label="$t('projects.mandat')" :error="errors.projectNumber" required>
                    <template #input>
                        <Input type="text" v-model="form.projectNumber" required />
                    </template>
                </FormField>

                <FormField :label="$t('projects.date')" :error="errors.startDate" required>
                    <template #input>
                        <Input type="date" v-model="formattedDate" required />
                    </template>
                </FormField>
            </div>

            <!-- Project Name -->
            <div class="mb-6">
                <FormField :label="$t('projects.designation')" :error="errors.name" required>
                    <template #input>
                        <Input type="text" v-model="form.name" required />
                    </template>
                </FormField>
            </div>

            <!-- Additional Details -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <FormField :label="$t('projects.locality')" :error="errors.locationId">
                    <template #input>
                        <AutocompleteSelect
                            v-model="form.locationId"
                            :options="locationsData?.data || []"
                            :display-field="(item: any) => item.name"
                            :search-fields="['name']"
                            :placeholder="$t('common.select')"
                            mode="static"
                        />
                    </template>
                </FormField>

                <FormField :label="$t('projects.client')" :error="errors.clientId">
                    <template #input>
                        <AutocompleteSelect
                            v-model="form.clientId"
                            :options="clientsData?.data || []"
                            :display-field="(item: any) => item.name"
                            :search-fields="['name']"
                            :placeholder="$t('common.select')"
                            mode="static"
                        />
                    </template>
                </FormField>

                <FormField :label="$t('projects.engineer')" :error="errors.engineerId">
                    <template #input>
                        <AutocompleteSelect
                            v-model="form.engineerId"
                            :options="engineersData?.data || []"
                            :display-field="(item: any) => item.name"
                            :search-fields="['name']"
                            :placeholder="$t('common.select')"
                            mode="static"
                        />
                    </template>
                </FormField>
            </div>

            <!-- Company and Type -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <FormField :label="$t('projects.enterprise')" :error="errors.companyId">
                    <template #input>
                        <AutocompleteSelect
                            v-model="form.companyId"
                            :options="companiesData?.data || []"
                            :display-field="(item: any) => item.name"
                            :search-fields="['name']"
                            :placeholder="$t('common.select')"
                            mode="static"
                        />
                    </template>
                </FormField>

                <FormField :label="$t('projects.type')" :error="errors.typeId" required>
                    <template #input>
                        <AutocompleteSelect
                            v-model="form.typeId"
                            :options="projectTypesData || []"
                            :display-field="(item: any) => item.name"
                            :search-fields="['name']"
                            :placeholder="$t('common.select')"
                            :required="true"
                            mode="static"
                        />
                    </template>
                </FormField>
            </div>

            <!-- Project Manager -->
            <div class="mb-6">
                <FormField :label="$t('projects.responsible')" :error="errors.projectManagerId">
                    <template #input>
                        <AutocompleteSelect
                            v-model="form.projectManagerId"
                            :options="usersData || []"
                            :display-field="(item: any) => `${item.firstName} ${item.lastName}`"
                            :search-fields="['firstName', 'lastName', 'initials']"
                            :placeholder="$t('common.select')"
                            mode="static"
                        />
                    </template>
                </FormField>
            </div>

            <!-- Remark -->
            <div class="mb-6">
                <FormField :label="$t('projects.remark')" :error="errors.remark">
                    <template #input>
                        <textarea
                            v-model="form.remark"
                            rows="3"
                            class="w-full p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            :placeholder="$t('projects.remarkPlaceholder')"
                        ></textarea>
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

                <FormField :label="$t('projects.status')">
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
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import { useToast } from "@/composables/utils/useToast"
import Button from "@/components/atoms/Button.vue"
import FormField from "@/components/molecules/FormField.vue"
import FormLayout from "@/components/templates/FormLayout.vue"
import Input from "@/components/atoms/Input.vue"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"

// API Composables
import { useFetchProject, useCreateProject, useUpdateProject } from "@/composables/api/useProject"
import { useFetchClientList } from "@/composables/api/useClient"
import { useFetchEngineerList } from "@/composables/api/useEngineer"
import { useFetchCompanyList } from "@/composables/api/useCompany"
import { useFetchLocationList } from "@/composables/api/useLocation"
import { useFetchProjectTypes } from "@/composables/api/useProjectType"
import { useFetchUsers } from "@/composables/api/useUser"
import type { ProjectCreateInput, ProjectUpdateInput } from "@beg/validations"

const { t } = useI18n()
const route = useRoute()
const router = useRouter()
const { showSuccess, showError } = useToast()

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
const { get: fetchProject, loading: loadingProject, data: projectData } = useFetchProject()
const { post: createProject, loading: creating } = useCreateProject()
const { put: updateProject, loading: updating } = useUpdateProject()

// Select options composables
const { get: fetchClients, data: clientsData, loading: loadingClients } = useFetchClientList()
const {
    get: fetchEngineers,
    data: engineersData,
    loading: loadingEngineers,
} = useFetchEngineerList()
const {
    get: fetchCompanies,
    data: companiesData,
    loading: loadingCompanies,
} = useFetchCompanyList()
const {
    get: fetchLocations,
    data: locationsData,
    loading: loadingLocations,
} = useFetchLocationList()
const {
    get: fetchProjectTypes,
    data: projectTypesData,
    loading: loadingProjectTypes,
} = useFetchProjectTypes()
const { get: fetchUsers, data: usersData, loading: loadingUsers } = useFetchUsers()

// Form state
const form = ref<ProjectCreateInput>({
    projectNumber: "",
    name: "",
    startDate: new Date(),
    typeId: undefined,
    locationId: undefined,
    clientId: undefined,
    engineerId: undefined,
    companyId: undefined,
    projectManagerId: undefined,
    remark: "",
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
            ...form.value,
            // Convert undefined to null for optional fields
            locationId: form.value.locationId || undefined,
            clientId: form.value.clientId || undefined,
            engineerId: form.value.engineerId || undefined,
            companyId: form.value.companyId || undefined,
            projectManagerId: form.value.projectManagerId || undefined,
            remark: form.value.remark || undefined,
        }

        if (isNewProject.value) {
            // Create new project
            await createProject({ body: submitData })
            showSuccess(t("projects.createSuccess"))
        } else {
            // Update existing project
            await updateProject({
                params: { id: projectId.value! },
                body: submitData as ProjectUpdateInput,
            })
            showSuccess(t("projects.updateSuccess"))
        }

        // Redirect to project list after saving
        router.push({ name: "project-list" })
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
    try {
        loadingData.value = true

        // Load select options in parallel
        await Promise.all([
            fetchClients({ query: { limit: 1000 } }),
            fetchEngineers({ query: { limit: 1000 } }),
            fetchCompanies({ query: { limit: 1000 } }),
            fetchLocations({ query: { limit: 1000 } }),
            fetchProjectTypes(),
            fetchUsers({ query: { includeArchived: false } }),
        ])

        // Load existing project if editing
        if (projectId.value && !isNaN(projectId.value)) {
            const response = await fetchProject({ params: { id: projectId.value } })

            if (projectData.value) {
                // Map API response to form
                form.value = {
                    projectNumber: projectData.value.projectNumber,
                    name: projectData.value.name,
                    startDate: projectData.value.startDate,
                    typeId: projectData.value.type?.id,
                    locationId: projectData.value.location?.id,
                    clientId: projectData.value.client?.id,
                    engineerId: projectData.value.engineer?.id,
                    companyId: projectData.value.company?.id,
                    projectManagerId: projectData.value.projectManager?.id,
                    remark: projectData.value.remark || "",
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
