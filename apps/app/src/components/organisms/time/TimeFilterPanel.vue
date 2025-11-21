<template>
    <div>
        <!-- Desktop filters (hidden on mobile) -->
        <div class="bg-indigo-50 p-4 border border-gray-200 rounded-lg mb-6">
            <div class="flex flex-col lg:flex-row gap-4">
                <!-- Left section with main filters -->
                <div class="flex-1">
                    <div class="grid grid-cols-1 md:grid-cols-12 gap-4">
                        <!-- DateRange - adapts width based on whether user filter is shown -->
                        <div
                            class="col-span-1 md:col-span-12"
                            :class="{
                                'lg:col-span-6': isRole('admin'),
                                'lg:col-span-8': !isRole('admin') && showProjectFilter,
                                'lg:col-span-9': !isRole('admin') && !showProjectFilter,
                            }"
                        >
                            <DateRange
                                :from-date="localFilter.fromDate"
                                :to-date="localFilter.toDate"
                                :from-label="$t('time.filters.fromDate')"
                                :to-label="$t('time.filters.toDate')"
                                @update:from-date="
                                    (value) => {
                                        localFilter.fromDate = value
                                        handleFilterChange()
                                    }
                                "
                                @update:to-date="
                                    (value) => {
                                        localFilter.toDate = value
                                        handleFilterChange()
                                    }
                                "
                            />
                        </div>

                        <!-- User Filter - only shown for admin -->
                        <div
                            class="form-group col-span-1 md:col-span-6 lg:col-span-3"
                            v-if="isRole('admin')"
                        >
                            <Label>{{ $t("shared.selectReferentUser") }}</Label>
                            <UserSelect
                                v-model="localFilter.userId"
                                :placeholder="$t('shared.selectReferentUser')"
                                @update:modelValue="handleFilterChange"
                            />
                        </div>

                        <!-- Project Filter - adapts width when user filter is not shown -->
                        <div
                            class="form-group col-span-1 md:col-span-6"
                            :class="{
                                'lg:col-span-2': isRole('admin'),
                                'lg:col-span-3': !isRole('admin'),
                            }"
                            v-if="showProjectFilter"
                        >
                            <Label>{{ $t("time.filters.project") }}</Label>
                            <ProjectSelect
                                v-model="localFilter.projectId"
                                :placeholder="$t('projects.filters.searchByNameAndNumber')"
                                @update:modelValue="handleFilterChange"
                            />
                        </div>

                        <!-- Activity Type Filter - adapts to fill remaining space -->
                        <div
                            class="form-group col-span-1 md:col-span-12"
                            :class="{
                                'lg:col-span-12': showProjectFilter,
                                'lg:col-span-3': !showProjectFilter,
                            }"
                        >
                            <Label>{{ $t("time.filters.activityType") }}</Label>
                            <Select
                                v-model="localFilter.activityTypeId"
                                :loading="loadingActivityTypes"
                                :options="[
                                    { label: $t('common.all'), value: null },
                                    ...activityTypeOptions,
                                ]"
                                @update:modelValue="handleFilterChange"
                            ></Select>
                        </div>
                    </div>

                    <div class="mt-4"></div>
                </div>

                <!-- Right section with billing status checkboxes -->
                <div class="w-full lg:w-48 border-t lg:border-t-0 lg:border-l pt-4 lg:pt-0 lg:pl-4">
                    <div class="form-group">
                        <div class="space-y-2 mt-2">
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
                                    v-model="localFilter.includeBilled"
                                    @change="handleFilterChange"
                                    class="h-4 w-4 text-indigo-600 border-gray-300 rounded mr-2"
                                />
                                {{ $t("time.filters.billed") }}
                            </label>
                            <label class="flex items-center" v-if="isRole('admin')">
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
            </div>

            <div class="flex mt-4">
                <Button @click="resetFilters" variant="secondary">
                    {{ $t("common.resetFilters") }}
                </Button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import Label from "@/components/atoms/Label.vue"
import Select from "@/components/atoms/Select.vue"
import Button from "@/components/atoms/Button.vue"
import DateRange from "@/components/molecules/DateRange.vue"
import ProjectSelect from "@/components/organisms/project/ProjectSelect.vue"
import { useFetchUsers } from "@/composables/api/useUser"
import { useFetchActivityTypes } from "@/composables/api/useActivityType"
import type { ActivityFilter } from "@beg/validations"
import UserSelect from "@/components/organisms/user/UserSelect.vue"
import { useAuthStore } from "@/stores/auth"
import { getTodayRange } from "@/composables/utils/useDateRangePresets"

// For backwards compatibility, keep the old interface name as an alias
export type TimeFilters = ActivityFilter

interface Props {
    filter: ActivityFilter
    showProjectFilter?: boolean
    initialFilter?: Partial<ActivityFilter>
}

const { filter, showProjectFilter = true, initialFilter } = defineProps<Props>()
const { isRole } = useAuthStore()
const emit = defineEmits<{
    "update:filter": [value: ActivityFilter]
}>()

// Local filter state
const localFilter = ref<ActivityFilter>({ ...filter })

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
    () => filter,
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
    const { from, to } = getTodayRange()
    localFilter.value = {
        userId: undefined,
        projectId: undefined,
        activityTypeId: undefined,
        fromDate: from,
        toDate: to,
        includeBilled: false,
        includeUnbilled: false,
        includeDisbursement: false,
        sortBy: "date",
        sortOrder: "desc",
        ...(initialFilter || {}),
    }
    handleFilterChange()
}

// Load data on mount
onMounted(async () => {
    await Promise.all([fetchUsers(), fetchActivityTypes()])
})
</script>
