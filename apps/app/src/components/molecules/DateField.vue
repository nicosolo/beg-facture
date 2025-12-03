<template>
    <div class="form-group">
        <Label :className="labelClassName" v-if="label">{{ label }}</Label>
        <Input
            type="date"
            :model-value="dateString"
            :disabled="disabled"
            :min="minString"
            :max="maxString"
            @update:model-value="handleDateChange"
        />
    </div>
</template>

<script setup lang="ts">
import { computed } from "vue"
import Label from "../atoms/Label.vue"
import Input from "../atoms/Input.vue"

interface DateFieldProps {
    label?: string
    modelValue?: Date
    disabled?: boolean
    labelClassName?: string
    min?: Date
    max?: Date
}

const { label, modelValue, disabled, labelClassName, min, max } = defineProps<DateFieldProps>()

const emit = defineEmits<{
    (e: "update:modelValue", value?: Date): void
}>()

const dateString = computed(() => {
    if (!modelValue) return ""
    return modelValue.toISOString().split("T")[0]
})

const minString = computed(() => min?.toISOString().split("T")[0])
const maxString = computed(() => max?.toISOString().split("T")[0])

function handleDateChange(value: string) {
    if (!value) {
        emit("update:modelValue", undefined)
    } else {
        emit("update:modelValue", new Date(value))
    }
}
</script>
