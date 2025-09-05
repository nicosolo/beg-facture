<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="async"
        :items="projects"
        :loading="loading"
        :fetch-function="fetchProjects"
        :display-field="formatProjectDisplay"
        :placeholder="placeholder || $t('common.select')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event)"
    />
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchProjectList, useFetchProject } from "@/composables/api/useProject"
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
const { get: fetchSingleProject } = useFetchProject()
const projects = ref<ProjectResponse[]>([])

// Format project display
const formatProjectDisplay = (project: ProjectResponse): string => {
    if (project.subProjectName) {
        return `${project.projectNumber} ${project.subProjectName} - ${project.name}`
    }
    return `${project.projectNumber} - ${project.name}`
}

// Fetch selected item when modelValue changes
const fetchSelectedItem = async () => {
    if (props.modelValue && !projects.value.find((p) => p.id === props.modelValue)) {
        const projectData = await fetchSingleProject({ params: { id: props.modelValue } })
        if (projectData) {
            // Add the selected item to the projects array if not already there
            projects.value = [projectData, ...projects.value.filter((p) => p.id !== projectData.id)]
        }
    }
}

// Watch for external changes to modelValue
watch(
    () => props.modelValue,
    async (newValue) => {
        if (newValue) {
            await fetchSelectedItem()
        }
    },
    { immediate: true }
)

// Update local projects when data changes from API
watch(
    () => data.value?.data,
    (newData) => {
        if (newData) {
            // Merge new data with existing projects, avoiding duplicates
            const existingIds = new Set(projects.value.map((p) => p.id))
            const newProjects = newData.filter((p) => !existingIds.has(p.id))
            projects.value = [...projects.value, ...newProjects]
        }
    }
)

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
