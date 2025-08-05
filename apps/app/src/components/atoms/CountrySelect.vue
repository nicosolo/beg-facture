<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="static"
        :options="countryOptions"
        :display-field="(country: CountryOption) => country.name"
        value-field="id"
        :search-fields="['name', 'id']"
        :placeholder="placeholder || $t('common.selectCountry')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event as string | undefined)"
    />
</template>

<script setup lang="ts">
import { computed } from "vue"
import { useI18n } from "vue-i18n"
import { COUNTRIES } from "@beg/validations"
import AutocompleteSelect from "./AutocompleteSelect.vue"

interface CountryOption {
    id: string
    name: string
}

interface CountrySelectProps {
    modelValue: string | undefined
    placeholder?: string
    disabled?: boolean
    required?: boolean
    className?: string
}

defineProps<CountrySelectProps>()

defineEmits<{
    "update:modelValue": [value: string | undefined]
}>()

const {} = useI18n()

// Transform COUNTRIES constant to options array
const countryOptions = computed<CountryOption[]>(() => {
    return Object.entries(COUNTRIES).map(([value, label]) => ({
        id: value,
        name: label,
    }))
})
</script>
