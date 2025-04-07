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

            <!-- <SelectField
                :label="$t('projects.filters.includeArchived')"
                v-model="filterData.archived"
                @update:model-value="emitChange"
            >
                <option :value="false">{{ $t("common.no") }}</option>
                <option :value="true">{{ $t("common.yes") }}</option>
            </SelectField> -->

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
                <Label>{{ $t("projects.filters.referentUser") }}</Label>
                <UserSelect
                    v-model="filterData.referentUserId"
                    :placeholder="$t('projects.filters.selectReferentUser')"
                    @update:model-value="emitChange"
                />
            </div>
            <div class="form-group">
                <Label>{{ $t("projects.filters.hasUnbilledTime") }}</Label>
                <Checkbox v-model="filterData.hasUnbilledTime" @update:model-value="emitChange" />
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
    (e: "filter-input-change"): void
}>()

// Create reactive copy of the filter
const filterData = reactive<ProjectFilterProps["filter"]>({
    name: filter.name,
    archived: filter.archived,
    sortBy: filter.sortBy,
    sortOrder: filter.sortOrder,
    fromDate: filter.fromDate,
    toDate: filter.toDate,
    referentUserId: filter.referentUserId || undefined,
    hasUnbilledTime: filter.hasUnbilledTime,
})

// Watch for external filter changes
watch(
    () => filter,
    (newFilter) => {
        filterData.name = newFilter.name
        filterData.archived = newFilter.archived
        filterData.sortBy = newFilter.sortBy
        filterData.sortOrder = newFilter.sortOrder
        filterData.fromDate = newFilter.fromDate
        filterData.toDate = newFilter.toDate
        filterData.referentUserId = newFilter.referentUserId
        filterData.hasUnbilledTime = newFilter.hasUnbilledTime
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
    filterData.referentUserId = undefined

    emitChange()
}
</script>
