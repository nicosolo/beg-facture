<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="static"
        :options="projectTypes || []"
        :loading="loading"
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
    modelValue: number | undefined | null
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

onMounted(() => {
    // Load initial data
    get()
})
</script>
