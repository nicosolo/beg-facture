<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="async"
        :items="projectTypes || []"
        :loading="loading"
        :fetch-function="fetchProjectTypes"
        :display-field="(type: ProjectTypeSchema) => type.name"
        :placeholder="placeholder || $t('common.select')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event)"
    />
</template>

<script setup lang="ts">
import { onMounted } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchProjectTypes } from "@/composables/api/useProjectType"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import type { ProjectTypeSchema } from "@beg/validations"

interface ProjectTypeSelectProps {
    modelValue: number | undefined
    placeholder?: string
    disabled?: boolean
    required?: boolean
    className?: string
}

defineProps<ProjectTypeSelectProps>()

defineEmits<{
    "update:modelValue": [value: number | undefined]
}>()

const {} = useI18n()
const { loading, data: projectTypes, get } = useFetchProjectTypes()

// Fetch function that receives search text
const fetchProjectTypes = async (searchText: string) => {
    // For now, fetch all project types
    // In the future, the API could support search parameter
    await get()

    // If we had search support in the API:
    // await get({ query: { search: searchText } })
}

onMounted(() => {
    // Load initial data
    get()
})
</script>
