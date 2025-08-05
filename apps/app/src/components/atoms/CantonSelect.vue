<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="static"
        :options="cantonOptions"
        :display-field="(canton: CantonOption) => canton.name"
        value-field="id"
        :search-fields="['name', 'id']"
        :placeholder="placeholder || $t('common.selectCanton')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event as string | undefined)"
    />
</template>

<script setup lang="ts">
import { computed } from "vue"
import { useI18n } from "vue-i18n"
import { SWISS_CANTONS } from "@beg/validations"
import AutocompleteSelect from "./AutocompleteSelect.vue"

interface CantonOption {
    id: string
    name: string
}

interface CantonSelectProps {
    modelValue: string | undefined
    placeholder?: string
    disabled?: boolean
    required?: boolean
    className?: string
}

defineProps<CantonSelectProps>()

defineEmits<{
    "update:modelValue": [value: string | undefined]
}>()

const {} = useI18n()

// Transform SWISS_CANTONS constant to options array
const cantonOptions = computed<CantonOption[]>(() => {
    return Object.entries(SWISS_CANTONS).map(([value, label]) => ({
        id: value,
        name: label,
    }))
})
</script>
