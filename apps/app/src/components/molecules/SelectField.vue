<template>
    <div class="form-group">
        <Label :className="labelClassName" v-if="label">{{ label }}</Label>
        <Select
            :model-value="modelValue"
            :disabled="disabled"
            @update:model-value="$emit('update:modelValue', $event)"
        >
            <slot></slot>
        </Select>
    </div>
</template>

<script setup lang="ts">
import Label from "../atoms/Label.vue"
import Select from "../atoms/Select.vue"

defineProps<{
    label?: string
    modelValue: string | number | boolean
    disabled?: boolean
    labelClassName?: string
}>()

defineEmits<{
    (e: "update:modelValue", value: string | number | boolean): void
}>()
</script>
