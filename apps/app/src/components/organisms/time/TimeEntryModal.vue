<template>
    <Dialog
        :model-value="modelValue"
        @update:model-value="$emit('update:modelValue', $event)"
        :title="isNewEntry ? $t('time.new') : $t('common.edit')"
    >
        <form @submit.prevent="handleSubmit" ref="formRef" id="timeEntryForm">
            <div class="space-y-4">
                <!-- Error message -->
                <div
                    v-if="errorMessage"
                    class="p-4 bg-red-100 border border-red-400 text-red-700 rounded"
                >
                    {{ errorMessage }}
                </div>

                <!-- Project and Date section -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <Label>{{ $t("projects.title") }}</Label>
                        <ProjectSelect
                            v-if="isNewEntry && !props.projectId"
                            v-model="activity.projectId"
                            :disabled="loading"
                            required
                        />
                        <ProjectSelect
                            v-else-if="activity.projectId"
                            v-model="activity.projectId"
                            :disabled="true"
                            required
                        />
                    </div>
                    <div>
                        <Label>{{ $t("projects.date") }}</Label>
                        <input
                            type="date"
                            v-model="formattedDate"
                            :disabled="loading"
                            required
                            class="w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                        />
                    </div>
                </div>

                <!-- Activity details section -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
                    <div>
                        <Label
                            >{{ $t("time.columns.activityType") }}
                            <span class="text-red-500">*</span></Label
                        >
                        <Select
                            v-model="activity.activityTypeId"
                            :loading="loadingActivityTypes"
                            :options="[
                                { label: $t('common.select', 'Select...'), value: '' },
                                ...activityTypeOptions,
                            ]"
                            :disabled="loading"
                            :required="true"
                            class="w-full"
                        />
                    </div>
                    <div>
                        <Label
                            >{{ $t("time.columns.duration") }}
                            <span class="text-red-500">*</span></Label
                        >
                        <InputNumber
                            type="time"
                            v-model.number="activity.duration"
                            :disabled="loading"
                            :required="true"
                            class="w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                        />
                    </div>
                    <div>
                        <Label>{{ $t("time.columns.kilometers") }}</Label>
                        <input
                            type="number"
                            v-model.number="activity.kilometers"
                            min="0"
                            step="1"
                            :disabled="loading"
                            class="w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                        />
                    </div>
                </div>

                <!-- Expenses and Description -->
                <div class="space-y-4">
                    <div>
                        <Label>{{ $t("time.columns.expenses") }} (CHF)</Label>
                        <input
                            type="number"
                            v-model.number="activity.expenses"
                            min="0"
                            step="0.01"
                            :disabled="loading"
                            class="w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                        />
                    </div>
                    <div>
                        <Label>{{ $t("time.columns.description") }}</Label>
                        <textarea
                            v-model="activity.description"
                            rows="3"
                            :disabled="loading"
                            class="w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                        ></textarea>
                    </div>
                </div>

                <!-- User info (read-only) -->
                <div v-if="currentUser">
                    <Label>{{ $t("time.columns.user") }}</Label>
                    <div class="w-full p-2 border border-gray-300 rounded-md bg-gray-100">
                        {{ currentUser.firstName }} {{ currentUser.lastName }}
                    </div>
                </div>
            </div>
        </form>

        <template #footer>
            <Button @click="closeModal" :disabled="saving" variant="secondary">
                {{ $t("common.cancel") }}
            </Button>
            <Button
                type="submit"
                form="timeEntryForm"
                :loading="saving"
                variant="primary"
                class="ml-2"
                @click="submitForm"
            >
                {{ $t("common.save") }}
            </Button>
        </template>
    </Dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import Dialog from "@/components/molecules/Dialog.vue"
import Button from "@/components/atoms/Button.vue"
import Label from "@/components/atoms/Label.vue"
import Select from "@/components/atoms/Select.vue"
import ProjectSelect from "@/components/organisms/project/ProjectSelect.vue"
import DurationInput from "@/components/molecules/DurationInput.vue"
import {
    useFetchActivity,
    useCreateActivity,
    useUpdateActivity,
} from "@/composables/api/useActivity"
import { useFetchActivityTypeFiltered } from "@/composables/api/useActivityType"
import { useAuthStore } from "@/stores/auth"
import { ApiError } from "@/utils/api-error"
import type { ActivityCreateInput, ActivityUpdateInput, ActivityResponse } from "@beg/validations"
import InputNumber from "@/components/atoms/InputNumber.vue"

interface Props {
    modelValue: boolean
    activityId?: number | null
    projectId?: number | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
    "update:modelValue": [value: boolean]
    saved: [activity: ActivityResponse]
}>()

const { t } = useI18n()
const authStore = useAuthStore()

// Computed properties
const isNewEntry = computed(() => !props.activityId)
const currentUser = computed(() => authStore.user)

const saving = computed(() => creatingActivity.value || updatingActivity.value)

const loading = computed(() => loadingActivity.value || saving.value)

// State
const errorMessage = ref<string | null>(null)

const formRef = ref<HTMLFormElement | null>(null)

// Activity data
const activity = ref<ActivityCreateInput>({
    projectId: props.projectId || 0,
    activityTypeId: "" as any, // Start with empty string for validation
    date: new Date(),
    duration: 0,
    kilometers: 0,
    expenses: 0,
    description: "",
    billed: false,
    disbursement: false,
    userId: currentUser.value?.id,
})

// API composables
const { get: fetchActivity, loading: loadingActivity } = useFetchActivity()
const { post: createActivity, loading: creatingActivity } = useCreateActivity()
const { put: updateActivity, loading: updatingActivity } = useUpdateActivity()
const {
    get: fetchActivityTypes,
    loading: loadingActivityTypes,
    data: activityTypesData,
} = useFetchActivityTypeFiltered()

// Options
const activityTypeOptions = computed(() => {
    return activityTypesData.value
        ? activityTypesData.value.map((type) => ({
              label: `${type.code} - ${type.name}`,
              value: type.id,
          }))
        : []
})

// Date formatting
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

// Load activity data if editing
const loadActivityData = async () => {
    if (!props.activityId) return

    try {
        const response = await fetchActivity({
            params: { id: props.activityId },
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
        console.error("Error loading activity:", error)
        errorMessage.value = t("errors.general")
    }
}

// Handle form submission
const handleSubmit = async () => {
    await saveActivity()
}

// Submit form programmatically
const submitForm = () => {
    if (formRef.value) {
        // Check duration separately since it uses custom inputs
        if (activity.value.duration === 0) {
            errorMessage.value = t("validation.required", { field: t("time.columns.duration") })
            return
        }

        // Check if form is valid
        if (formRef.value.checkValidity()) {
            handleSubmit()
        } else {
            // Trigger browser validation UI
            formRef.value.reportValidity()
        }
    }
}

// Save activity
const saveActivity = async () => {
    errorMessage.value = null

    try {
        let response: ActivityResponse | null = null

        // Convert empty string back to 0 for activityTypeId
        const activityData = {
            ...activity.value,
            activityTypeId:
                !activity.value.activityTypeId || activity.value.activityTypeId === ("" as any)
                    ? 0
                    : Number(activity.value.activityTypeId),
        }

        if (isNewEntry.value) {
            response = await createActivity({
                body: activityData,
            })
        } else if (props.activityId) {
            const updateData: ActivityUpdateInput = {
                activityTypeId: activityData.activityTypeId,
                date: activityData.date,
                duration: activityData.duration,
                kilometers: activityData.kilometers,
                expenses: activityData.expenses,
                description: activityData.description,
                billed: activityData.billed,
                disbursement: activityData.disbursement,
            }

            response = await updateActivity({
                params: { id: props.activityId },
                body: updateData,
            })
        }

        if (response) {
            emit("saved", response)
            closeModal()
        }
    } catch (error) {
        if (error instanceof ApiError) {
            errorMessage.value = error.message
        } else {
            errorMessage.value = t("errors.general")
        }
    }
}

// Close modal
const closeModal = () => {
    emit("update:modelValue", false)
}

// Reset form when modal opens
const resetForm = () => {
    errorMessage.value = null
    activity.value = {
        projectId: props.projectId || 0,
        activityTypeId: "" as any, // Start with empty string for validation
        date: new Date(),
        duration: 0,
        kilometers: 0,
        expenses: 0,
        description: "",
        billed: false,
        disbursement: false,
        userId: currentUser.value?.id,
    }
}

// Watch modal visibility
watch(
    () => props.modelValue,
    async (isOpen) => {
        if (isOpen) {
            // Load activity types
            await fetchActivityTypes()

            if (props.activityId) {
                await loadActivityData()
            } else {
                resetForm()
            }
        }
    }
)

// Initial load of activity types
onMounted(() => {
    fetchActivityTypes()
})
</script>
