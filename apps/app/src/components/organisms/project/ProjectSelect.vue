<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="async"
        :items="projects"
        :loading="loading"
        :fetch-function="fetchProjects"
        :display-field="formatProjectDisplay"
        :placeholder="placeholder || $t('common.selectProject')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event)"
    />
</template>

<script setup lang="ts">
import { onMounted, computed } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchProjectList } from "@/composables/api/useProject"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import type { ProjectResponse } from "@beg/validations"

interface ProjectSelectProps {
    modelValue: number | undefined
    placeholder?: string
    disabled?: boolean
    required?: boolean
    className?: string
    includeArchived?: boolean
    includeEnded?: boolean
}

const props = withDefaults(defineProps<ProjectSelectProps>(), {
    includeArchived: false,
    includeEnded: false,
})

defineEmits<{
    "update:modelValue": [value: number | undefined]
}>()

const {} = useI18n()
const { loading, data, get } = useFetchProjectList()

// Format project display
const formatProjectDisplay = (project: ProjectResponse): string => {
    return `${project.projectNumber} - ${project.name}`
}

// Extract projects from paginated response
const projects = computed(() => {
    return data.value?.data || []
})

// Fetch function that receives search text
const fetchProjects = async (searchText: string) => {
    await get({
        query: {
            name: searchText,
            includeArchived: props.includeArchived,
            includeEnded: props.includeEnded,
            limit: 50, // Reasonable limit for dropdown
        },
    })
}

onMounted(() => {
    // Load initial data
    fetchProjects("")
})
</script>
