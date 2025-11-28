<template>
    <div class="space-y-2">
        <AutocompleteSelect
            :model-value="undefined"
            :id="id"
            mode="static"
            :options="availableTypes"
            :display-field="formatTypeDisplay"
            :filter-function="filterTypes"
            :placeholder="placeholder"
            :disabled="disabled"
            :required="required"
            :class-name="className"
            @update:model-value="addType"
            :clear-on-select="true"
        />
        <div class="flex flex-wrap gap-2">
            <span
                v-for="typeId in modelValue"
                :key="typeId"
                class="inline-flex items-center gap-1 px-2 py-1 bg-indigo-100 text-indigo-800 rounded text-sm"
            >
                {{ getTypeDisplay(typeId) }}
                <Button type="button" @click="removeType(typeId)" variant="ghost" size="xxs">
                    <XMarkIcon class="w-5 h-5" />
                </Button>
            </span>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue"
import { useFetchProjectTypes } from "@/composables/api/useProjectType"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import type { ProjectTypeSchema } from "@beg/validations"
import { XMarkIcon } from "@heroicons/vue/24/outline"
import Button from "@/components/atoms/Button.vue"

interface Props {
    modelValue: number[]
    placeholder?: string
    disabled?: boolean
    required?: boolean
    className?: string
    id?: string
}

const props = withDefaults(defineProps<Props>(), {
    placeholder: "Select types...",
    disabled: false,
    required: false,
    id: undefined,
})

const emit = defineEmits<{
    "update:modelValue": [value: number[]]
}>()

const { data: projectTypes, get } = useFetchProjectTypes()

// Format type display
const formatTypeDisplay = (type: ProjectTypeSchema): string => {
    return type.name
}

// Filter out already selected types
const availableTypes = computed(() => {
    if (!projectTypes.value) return []
    const selectedIds = new Set(props.modelValue)
    return projectTypes.value.filter((type) => !selectedIds.has(type.id))
})

// Custom filter function
const filterTypes = (type: ProjectTypeSchema, searchText: string): boolean => {
    return type.name.toLowerCase().includes(searchText.toLowerCase())
}

// Get type display name by ID
const getTypeDisplay = (typeId: number): string => {
    const type = projectTypes.value?.find((t) => t.id === typeId)
    return type ? formatTypeDisplay(type) : typeId.toString()
}

// Add type to selection
const addType = (typeId: string | number | null | undefined) => {
    if (typeId === undefined || typeId === null) return
    emit("update:modelValue", [...props.modelValue, parseInt(typeId as string)])
}

// Remove type from selection
const removeType = (typeId: number) => {
    emit(
        "update:modelValue",
        props.modelValue.filter((id) => id !== typeId)
    )
}

onMounted(() => {
    get()
})
</script>
