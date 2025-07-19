<template>
    <div class="container mx-auto py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">
                {{ isNewEntry ? $t('time.new') : $t('common.edit') }}
            </h1>
        </div>

        <!-- Project and Date header section -->
        <div class="bg-white rounded-lg p-6 mb-4 border border-gray-200">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <div class="mb-4 md:mb-0 md:mr-6 flex-1">
                    <Label class="text-lg font-medium text-gray-700 mb-1">{{ $t('projects.title') }}</Label>
                    <Select
                        v-model="activity.projectId"
                        :loading="loadingProjects"
                        :options="projectOptions"
                        :disabled="!isNewEntry"
                        class="w-full"
                    />
                </div>
                <div class="flex-1">
                    <Label class="text-lg font-medium text-gray-700 mb-1">{{ $t('time.columns.date') }}</Label>
                    <input
                        type="date"
                        id="date"
                        v-model="formattedDate"
                        class="w-full p-2 border border-gray-300 rounded-md"
                    />
                </div>
                <!-- User (disabled for non-admin) -->
                <div class="flex-1" v-if="isAdmin">
                    <Label for="user" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t('time.columns.user') }}
                    </Label>
                    <Select
                        v-model="activity.userId"
                        :loading="loadingUsers"
                        :options="userOptions"
                        class="w-full"
                    />
                </div>
                <div class="flex-1" v-else>
                    <Label class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t('time.columns.user') }}
                    </Label>
                    <div class="w-full p-2 border border-gray-300 rounded-md bg-gray-100">
                        {{ currentUserName }}
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg p-6 border border-gray-200">
            <form @submit.prevent="saveActivity">
                <!-- Hours, Km, Fees section -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
                    <div>
                        <label for="activityType" class="block text-sm font-medium text-gray-700 mb-1">
                            {{ $t('time.columns.activityType') }}
                        </label>
                        <Select
                            v-model="activity.activityTypeId"
                            :loading="loadingActivityTypes"
                            :options="activityTypeOptions"
                            class="w-full"
                        />
                    </div>
                    <div class="flex-1">
                        <label for="duration" class="block text-sm font-medium text-gray-700 mb-1">
                            {{ $t('time.columns.duration') }} (minutes)
                        </label>
                        <input
                            type="number"
                            id="duration"
                            v-model.number="activity.duration"
                            step="15"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>

                    <div>
                        <label for="kilometers" class="block text-sm font-medium text-gray-700 mb-1">
                            {{ $t('time.columns.kilometers') }}
                        </label>
                        <input
                            type="number"
                            id="kilometers"
                            v-model.number="activity.kilometers"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>

                    <div>
                        <label for="expenses" class="block text-sm font-medium text-gray-700 mb-1">
                            {{ $t('time.columns.expenses') }} (CHF)
                        </label>
                        <input
                            type="number"
                            id="expenses"
                            v-model.number="activity.expenses"
                            step="0.01"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Activité -->

                    <!-- Billed - only show if not a new entry -->
                    <div v-if="!isNewEntry" class="flex items-center mt-4">
                        <input
                            type="checkbox"
                            id="billed"
                            v-model="activity.billed"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded"
                        />
                        <label for="billed" class="ml-2 block text-sm text-gray-700">
                            {{ $t('time.status.billed') }}
                        </label>
                    </div>

                    <!-- Disbursement -->
                    <div class="flex items-center mt-4">
                        <input
                            type="checkbox"
                            id="disbursement"
                            v-model="activity.disbursement"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded"
                        />
                        <label for="disbursement" class="ml-2 block text-sm text-gray-700">
                            {{ $t('time.status.disbursement') }}
                        </label>
                    </div>

                    <!-- Description -->
                    <div class="md:col-span-2">
                        <label for="description" class="block text-sm font-medium text-gray-700 mb-1">
                            {{ $t('time.columns.description') }}
                        </label>
                        <textarea
                            id="description"
                            v-model="activity.description"
                            rows="3"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        ></textarea>
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3">
                    <Button variant="secondary" type="button" :to="{ name: 'time-list' }">
                        {{ $t('common.cancel') }}
                    </Button>
                    <Button
                        variant="primary"
                        type="submit"
                        :disabled="creatingActivity || updatingActivity || loadingActivity"
                    >
                        {{ creatingActivity || updatingActivity ? $t('common.loading') : $t('common.save') }}
                    </Button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import Button from "../../components/atoms/Button.vue"
import Label from "@/components/atoms/Label.vue"
import Select from "@/components/atoms/Select.vue"
import { useFetchActivity, useCreateActivity, useUpdateActivity } from "@/composables/api/useActivity"
import { useFetchProjectList } from "@/composables/api/useProject"
import { useFetchUsers } from "@/composables/api/useUser"
import { useFetchActivityTypes } from "@/composables/api/useActivityType"
import { useAuthStore } from "@/stores/auth"
import { ApiError } from "@/utils/api-error"
import { ErrorCode } from "@beg/validations"
import type { ActivityCreateInput, ActivityUpdateInput } from "@beg/validations"

const route = useRoute()
const router = useRouter()
const { t } = useI18n()
const authStore = useAuthStore()

const activityId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewEntry = computed(() => !activityId.value)
const projectIdFromQuery = computed(() => route.query.projectId ? Number(route.query.projectId) : undefined)

// User info
const currentUser = computed(() => authStore.user)
const isAdmin = computed(() => currentUser.value?.role === 'admin')
const currentUserName = computed(() => 
    currentUser.value ? `${currentUser.value.firstName} ${currentUser.value.lastName}` : ''
)

// Activity data
const activity = ref<ActivityCreateInput>({
    projectId: projectIdFromQuery.value || 0,
    activityTypeId: 0,
    date: new Date(),
    duration: 0,
    kilometers: 0,
    expenses: 0,
    description: "",
    billed: false,
    disbursement: false,
    userId: currentUser.value?.id,
})

// Error handling
const errorMessage = ref<string | null>(null)

// API composables
const { get: fetchActivity, loading: loadingActivity } = useFetchActivity()
const { post: createActivity, loading: creatingActivity } = useCreateActivity()
const { put: updateActivity, loading: updatingActivity } = useUpdateActivity()
const { get: fetchProjects, loading: loadingProjects, data: projectsData } = useFetchProjectList()
const { get: fetchUsers, loading: loadingUsers, data: usersData } = useFetchUsers()
const { get: fetchActivityTypes, loading: loadingActivityTypes, data: activityTypesData } = useFetchActivityTypes()

// Options for dropdowns
const projectOptions = ref<Array<{ label: string; value: number }>>([])
const userOptions = ref<Array<{ label: string; value: number }>>([])
const activityTypeOptions = ref<Array<{ label: string; value: number }>>([])

// Watch for data changes and update options
watch(projectsData, (newData) => {
    if (newData) {
        projectOptions.value = newData.data.map((project) => ({
            label: `${project.projectNumber} - ${project.name}`,
            value: project.id,
        }))
    }
})

watch(usersData, (newData) => {
    if (newData) {
        userOptions.value = newData.map((user: any) => ({
            label: `${user.firstName} ${user.lastName}`,
            value: user.id,
        }))
    }
})

watch(activityTypesData, (newData) => {
    if (newData) {
        activityTypeOptions.value = newData.map((activityType) => ({
            label: activityType.name,
            value: activityType.id,
        }))
    }
})

// Clear error
const clearError = () => {
    errorMessage.value = null
}

// Handle date formatting
const formattedDate = computed({
    get: () => {
        try {
            return activity.value.date.toISOString().split("T")[0]
        } catch (e) {
            return new Date().toISOString().split("T")[0]
        }
    },
    set: (value: string) => {
        activity.value.date = new Date(value)
    },
})

// Load existing activity data if editing
const loadActivityData = async () => {
    if (!activityId.value) return

    try {
        const response = await fetchActivity({
            params: { id: activityId.value },
        })

        if (response) {
            activity.value = {
                projectId: response.project?.id || 0,
                activityTypeId: response.activityType?.id || 0,
                date: new Date(response.date),
                duration: response.duration,
                kilometers: response.kilometers,
                expenses: response.expenses,
                description: response.description || "",
                billed: response.billed,
                disbursement: response.disbursement,
                userId: response.user?.id,
            }
        }
    } catch (error) {
        if (error instanceof ApiError) {
            errorMessage.value = t(`errors.${error.code}`)
        } else {
            errorMessage.value = t('errors.general')
        }
    }
}

const saveActivity = async () => {
    errorMessage.value = null

    try {
        const activityData: ActivityCreateInput | ActivityUpdateInput = {
            ...activity.value,
            userId: isAdmin.value && activity.value.userId ? activity.value.userId : undefined,
        }

        if (isNewEntry.value) {
            await createActivity({
                body: activityData as ActivityCreateInput,
            })
        } else {
            await updateActivity({
                params: { id: activityId.value! },
                body: activityData as ActivityUpdateInput,
            })
        }

        // Redirect to the list page
        router.push({ name: 'time-list' })
    } catch (error) {
        if (error instanceof ApiError) {
            if (error.code === ErrorCode.DUPLICATE_ENTRY) {
                errorMessage.value = t('errors.DUPLICATE_ENTRY')
            } else {
                errorMessage.value = t(`errors.${error.code}`)
            }
        } else {
            errorMessage.value = t('errors.general')
        }
    }
}

// Load data on mount
onMounted(async () => {
    await Promise.all([
        fetchProjects({ query: { page: 1, limit: 100, includeArchived: false, includeEnded: false } }),
        fetchActivityTypes(),
        isAdmin.value ? fetchUsers() : Promise.resolve(),
    ])

    if (!isNewEntry.value) {
        await loadActivityData()
    }
})
</script>
