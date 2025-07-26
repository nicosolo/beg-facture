<template>
    <div class="bg-white p-4 border border-gray-200 rounded-lg mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <FormField :label="$t('projects.name')">
                <template #input>
                    <Input
                        v-model="filterData.name"
                        :placeholder="$t('projects.filters.searchByName')"
                        @update:model-value="emitInputChange"
                    />
                </template>
            </FormField>

            <div class="form-group">
                <Label>{{ $t("projects.filters.sortBy") }}</Label>
                <div class="flex gap-2">
                    <Select
                        v-model="filterData.sortBy"
                        @update:model-value="emitChange"
                        :options="[
                            { label: $t('projects.unBilledDuration'), value: 'unBilledDuration' },
                            { label: $t('projects.firstActivity'), value: 'firstActivityDate' },
                            { label: $t('projects.lastActivity'), value: 'lastActivityDate' },
                            { label: $t('projects.name'), value: 'name' },
                        ]"
                    ></Select>
                    <Select
                        v-model="filterData.sortOrder"
                        @update:model-value="emitChange"
                        :options="[
                            { label: $t('projects.filters.ascending'), value: 'asc' },
                            { label: $t('projects.filters.descending'), value: 'desc' },
                        ]"
                    ></Select>
                </div>
            </div>
            <div class="form-group">
                <Label>{{ $t("projects.filters.referentUser") }}</Label>
                <UserSelect
                    v-model="filterData.referentUserId"
                    :placeholder="$t('projects.filters.selectReferentUser')"
                    @update:model-value="emitChange"
                />
            </div>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
            <DateField
                :label="$t('projects.filters.fromDate')"
                v-model="filterData.fromDate"
                @update:model-value="emitChange"
            />

            <DateField
                :label="$t('projects.filters.toDate')"
                v-model="filterData.toDate"
                @update:model-value="emitChange"
            />

            <div class="form-group">
                <div class="space-y-2">
                    <Checkbox
                        v-model="filterData.hasUnbilledTime"
                        @update:model-value="emitChange"
                        :label="$t('projects.filters.hasUnbilledTime')"
                        id="hasUnbilledTime"
                    />
                    <Checkbox
                        v-model="filterData.includeArchived"
                        @update:model-value="emitChange"
                        :label="$t('projects.filters.includeArchived')"
                        id="includeArchived"
                    />
                    <Checkbox
                        v-model="filterData.includeEnded"
                        @update:model-value="emitChange"
                        :label="$t('projects.filters.includeEnded')"
                        id="includeEnded"
                    />
                </div>
            </div>
        </div>

        <div class="flex mt-4">
            <Button @click="resetFilters" variant="secondary">{{
                $t("projects.filters.reset")
            }}</Button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { reactive, watch } from "vue"
import Label from "../../atoms/Label.vue"
import Select from "../../atoms/Select.vue"
import Button from "../../atoms/Button.vue"
import FormField from "../../molecules/FormField.vue"
import DateField from "../../molecules/DateField.vue"
import UserSelect from "../../organisms/user/UserSelect.vue"
import type { ProjectFilter } from "@beg/validations"
import Checkbox from "@/components/atoms/Checkbox.vue"
import Input from "@/components/atoms/Input.vue"
import { debounce } from "@/utils/debounce"

export type ProjectFilterModel = Omit<ProjectFilter, "page" | "limit" | "accountId">

interface ProjectFilterProps {
    filter: ProjectFilterModel
}

// Define props for the component
const { filter } = defineProps<ProjectFilterProps>()

// Define emitted events
const emit = defineEmits<{
    (e: "update:filter", filter: ProjectFilterProps["filter"]): void
    (e: "filter-change"): void
}>()

// Create reactive copy of the filter
const filterData = reactive<ProjectFilterProps["filter"]>({
    name: filter.name,
    includeArchived: filter.includeArchived,
    includeEnded: filter.includeEnded,
    sortBy: filter.sortBy,
    sortOrder: filter.sortOrder,
    fromDate: filter.fromDate,
    toDate: filter.toDate,
    referentUserId: filter.referentUserId || undefined,
    hasUnbilledTime: filter.hasUnbilledTime || false,
})

// Watch for external filter changes
watch(
    () => filter,
    (newFilter) => {
        filterData.name = newFilter.name
        filterData.includeArchived = newFilter.includeArchived
        filterData.includeEnded = newFilter.includeEnded
        filterData.sortBy = newFilter.sortBy
        filterData.sortOrder = newFilter.sortOrder
        filterData.fromDate = newFilter.fromDate
        filterData.toDate = newFilter.toDate
        filterData.referentUserId = newFilter.referentUserId
        filterData.hasUnbilledTime = newFilter.hasUnbilledTime
    },
    { deep: true }
)

// Create debounced filter change for text input
const debouncedFilterChange = debounce(() => {
    emit("update:filter", { ...filterData })
}, 300)

// Emit methods
const emitChange = () => {
    emit("update:filter", { ...filterData })
}

const emitInputChange = () => {
    debouncedFilterChange()
}

// Reset filters
const resetFilters = () => {
    filterData.name = ""
    filterData.includeArchived = false
    filterData.includeEnded = false
    filterData.sortBy = "name"
    filterData.sortOrder = "asc"
    filterData.fromDate = undefined
    filterData.toDate = undefined
    filterData.referentUserId = undefined
    filterData.hasUnbilledTime = false
    emitChange()
}
</script>
