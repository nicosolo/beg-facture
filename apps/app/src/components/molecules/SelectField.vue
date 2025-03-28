<template>
    <div class="form-group">
        <Label :className="labelClassName" v-if="label">{{ label }}</Label>
        <Select
            :model-value="modelValue"
            :disabled="disabled"
            @update:model-value="$emit('update:modelValue', $event)"
            :options="options"
        >
        </Select>
    </div>
</template>

<script setup lang="ts">
import Label from "../atoms/Label.vue"
import Select, { type SelectOption } from "../atoms/Select.vue"

interface SelectFieldProps {
    label?: string
    modelValue: string | number | boolean
    disabled?: boolean
    options: SelectOption[]
    labelClassName?: string
}

const { label, modelValue, disabled, options, labelClassName } = defineProps<SelectFieldProps>()

defineEmits<{
    (e: "update:modelValue", value: string | number | boolean): void
}>()
</script>
