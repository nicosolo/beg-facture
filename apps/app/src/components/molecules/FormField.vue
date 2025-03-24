<template>
    <div class="form-group">
        <Label :className="labelClassName" v-if="label">{{ label }}</Label>
        <slot name="input">
            <Input
                :model-value="modelValue || ''"
                :type="type"
                :placeholder="placeholder"
                :disabled="disabled"
                @update:model-value="$emit('update:modelValue', $event)"
            />
        </slot>
    </div>
</template>

<script setup lang="ts">
import Label from "../atoms/Label.vue"
import Input from "../atoms/Input.vue"

defineProps<{
    label?: string
    modelValue?: string
    type?: string
    placeholder?: string
    disabled?: boolean
    labelClassName?: string
}>()

defineEmits<{
    (e: "update:modelValue", value: string): void
}>()
</script>
