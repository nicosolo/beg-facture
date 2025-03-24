<template>
    <div class="bg-white p-4 rounded-md shadow mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <FormField
                label="Project Name"
                v-model="filterData.name"
                placeholder="Search by name"
                @update:model-value="emitInputChange"
            />

            <SelectField
                label="Include Archived"
                v-model="filterData.archived"
                @update:model-value="emitChange"
            >
                <option :value="false">No</option>
                <option :value="true">Yes</option>
            </SelectField>

            <div class="form-group">
                <Label>Sort By</Label>
                <div class="flex gap-2">
                    <Select v-model="filterData.sortBy" @update:model-value="emitChange">
                        <option value="name">Name</option>
                        <option value="totalDuration">Total Duration</option>
                        <option value="firstActivityDate">First Activity</option>
                        <option value="lastActivityDate">Last Activity</option>
                    </Select>
                    <Select v-model="filterData.sortOrder" @update:model-value="emitChange">
                        <option value="asc">Ascending</option>
                        <option value="desc">Descending</option>
                    </Select>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
            <DateField
                label="From Date"
                v-model="filterData.fromDate"
                @update:model-value="emitChange"
            />

            <DateField
                label="To Date"
                v-model="filterData.toDate"
                @update:model-value="emitChange"
            />

            <div class="flex items-end">
                <Button @click="resetFilters" variant="secondary"> Reset Filters </Button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { reactive, watch } from "vue"
import Label from "../atoms/Label.vue"
import Select from "../atoms/Select.vue"
import Button from "../atoms/Button.vue"
import FormField from "../molecules/FormField.vue"
import SelectField from "../molecules/SelectField.vue"
import DateField from "../molecules/DateField.vue"

// Define the filter type
export interface ProjectFilterModel {
    name: string
    archived: boolean
    sortBy: "name" | "totalDuration" | "firstActivityDate" | "lastActivityDate"
    sortOrder: "asc" | "desc"
    fromDate?: Date
    toDate?: Date
}

// Define props for the component
const props = defineProps<{
    filter: ProjectFilterModel
}>()

// Define emitted events
const emit = defineEmits<{
    (e: "update:filter", filter: ProjectFilterModel): void
    (e: "filter-change"): void
    (e: "filter-input-change"): void
}>()

// Create reactive copy of the filter
const filterData = reactive<ProjectFilterModel>({
    name: props.filter.name,
    archived: props.filter.archived,
    sortBy: props.filter.sortBy,
    sortOrder: props.filter.sortOrder,
    fromDate: props.filter.fromDate,
    toDate: props.filter.toDate,
})

// Watch for external filter changes
watch(
    () => props.filter,
    (newFilter) => {
        filterData.name = newFilter.name
        filterData.archived = newFilter.archived
        filterData.sortBy = newFilter.sortBy
        filterData.sortOrder = newFilter.sortOrder
        filterData.fromDate = newFilter.fromDate
        filterData.toDate = newFilter.toDate
    },
    { deep: true }
)

// Emit methods
const emitChange = () => {
    emit("update:filter", { ...filterData })
    emit("filter-change")
}

const emitInputChange = () => {
    emit("update:filter", { ...filterData })
    emit("filter-input-change")
}

// Reset filters
const resetFilters = () => {
    filterData.name = ""
    filterData.archived = false
    filterData.sortBy = "name"
    filterData.sortOrder = "asc"
    filterData.fromDate = undefined
    filterData.toDate = undefined

    emitChange()
}
</script>
