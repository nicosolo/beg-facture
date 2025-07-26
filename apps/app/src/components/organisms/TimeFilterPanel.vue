<template>
    <div class="bg-white p-4 border border-gray-200 rounded-lg mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <!-- User Filter -->
            <div class="form-group">
                <Label>{{ $t("shared.selectReferentUser") }}</Label>
                <UserSelect
                    v-model="localFilter.userId"
                    :placeholder="$t('shared.selectReferentUser')"
                    @update:modelValue="handleFilterChange"
                />
            </div>

            <!-- Project Filter -->
            <div class="form-group">
                <Label>{{ $t("time.filters.project") }}</Label>
                <ProjectSelect
                    v-model="localFilter.projectId"
                    :placeholder="$t('projects.filters.searchByNameAndNumber')"
                    @update:modelValue="handleFilterChange"
                />
            </div>

            <!-- Activity Type Filter -->
            <div class="form-group">
                <Label>{{ $t("time.filters.activityType") }}</Label>
                <Select
                    v-model="localFilter.activityTypeId"
                    :loading="loadingActivityTypes"
                    :options="[{ label: $t('common.all'), value: null }, ...activityTypeOptions]"
                    @update:modelValue="handleFilterChange"
                ></Select>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
            <!-- Date From -->
            <DateField
                :label="$t('time.filters.fromDate')"
                v-model="localFilter.fromDate"
                @update:modelValue="handleFilterChange"
            />

            <!-- Date To -->
            <DateField
                :label="$t('time.filters.toDate')"
                v-model="localFilter.toDate"
                @update:modelValue="handleFilterChange"
            />

            <!-- Billing Status -->
            <div class="form-group">
                <Label>{{ $t("time.filters.billingStatus") }}</Label>
                <div class="space-y-2">
                    <label class="flex items-center">
                        <input
                            type="checkbox"
                            v-model="localFilter.includeBilled"
                            @change="handleFilterChange"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded mr-2"
                        />
                        {{ $t("time.filters.billed") }}
                    </label>
                    <label class="flex items-center">
                        <input
                            type="checkbox"
                            v-model="localFilter.includeUnbilled"
                            @change="handleFilterChange"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded mr-2"
                        />
                        {{ $t("time.filters.unbilled") }}
                    </label>
                    <label class="flex items-center">
                        <input
                            type="checkbox"
                            v-model="localFilter.includeDisbursement"
                            @change="handleFilterChange"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded mr-2"
                        />
                        {{ $t("time.filters.disbursement") }}
                    </label>
                </div>
            </div>
        </div>

        <div class="flex mt-4">
            <Button @click="resetFilters" variant="secondary">
                {{ $t("common.resetFilters") }}
            </Button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import Label from "../atoms/Label.vue"
import Select from "../atoms/Select.vue"
import Button from "../atoms/Button.vue"
import DateField from "../molecules/DateField.vue"
import ProjectSelect from "../molecules/ProjectSelect.vue"
import { useFetchUsers } from "@/composables/api/useUser"
import { useFetchActivityTypes } from "@/composables/api/useActivityType"
import type { ActivityFilter } from "@beg/validations"
import UserSelect from "./user/UserSelect.vue"

export interface TimeFilterModel {
    userId?: number
    projectId?: number
    activityTypeId?: number
    fromDate?: Date
    toDate?: Date
    includeBilled: boolean
    includeUnbilled: boolean
    includeDisbursement: boolean
    sortBy: ActivityFilter["sortBy"]
    sortOrder: ActivityFilter["sortOrder"]
}

// For backwards compatibility, keep the old interface name as an alias
export type TimeFilters = TimeFilterModel

interface Props {
    filter: TimeFilterModel
}

const props = defineProps<Props>()

const emit = defineEmits<{
    "update:filter": [value: TimeFilterModel]
}>()

// Local filter state
const localFilter = ref<TimeFilterModel>({ ...props.filter })

// Fetch data for dropdowns
const { get: fetchUsers, loading: loadingUsers, data: usersData } = useFetchUsers()
const {
    get: fetchActivityTypes,
    loading: loadingActivityTypes,
    data: activityTypesData,
} = useFetchActivityTypes()

const userOptions = ref<Array<{ label: string; value: number }>>([])
const activityTypeOptions = ref<Array<{ label: string; value: number }>>([])

// Watch for data changes and update options
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

// Watch for prop changes
watch(
    () => props.filter,
    (newFilter) => {
        localFilter.value = { ...newFilter }
    },
    { deep: true }
)

// Handle filter changes
const handleFilterChange = () => {
    emit("update:filter", { ...localFilter.value })
}

// Reset filters
const resetFilters = () => {
    localFilter.value = {
        userId: undefined,
        projectId: localFilter.value.projectId || undefined,
        activityTypeId: undefined,
        fromDate: undefined,
        toDate: undefined,
        includeBilled: false,
        includeUnbilled: true,
        includeDisbursement: false,
        sortBy: "date",
        sortOrder: "desc",
    }
    handleFilterChange()
}

// Load data on mount
onMounted(async () => {
    await Promise.all([fetchUsers(), fetchActivityTypes()])
})
</script>
