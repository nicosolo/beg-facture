<template>
    <div class="form-group">
        <Label :className="labelClassName" v-if="label">{{ label }}</Label>
        <slot name="input"> </slot>
    </div>
</template>

<script setup lang="ts">
import Label from "../atoms/Label.vue"
import Input from "../atoms/Input.vue"

interface FormFieldProps {
    label?: string
    modelValue?: string
    type?: string
    placeholder?: string
    disabled?: boolean
    labelClassName?: string
}

const { label, modelValue, type, placeholder, disabled, labelClassName } =
    defineProps<FormFieldProps>()

defineEmits<{
    (e: "update:modelValue", value: string): void
}>()
</script>
