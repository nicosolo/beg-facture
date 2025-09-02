<template>
    <input
        type="number"
        :value="modelValue"
        @input="$emit('update:modelValue', parseFloat(($event.target as HTMLInputElement).value))"
        :step="computedStep"
        :class="[computedClass, $attrs.class]"
    />
</template>

<script setup lang="ts">
import { computed } from "vue"

const { modelValue, type = "number" } = defineProps<{
    modelValue: number | null
    type?: "percentage" | "amount" | "number" | "distance" | "time"
}>()

defineEmits<{
    (e: "update:modelValue", value: number): void
}>()

const computedClass = computed(() => {
    if (type === "percentage") {
        return "w-19 p-1 border border-gray-300 rounded"
    }
    if (type === "amount") {
        return "w-24 p-1 border border-gray-300 rounded"
    }
    if (type === "distance") {
        return "w-16 p-1 border border-gray-300 rounded"
    }
    return "w-24 p-1 border border-gray-300 rounded"
})

const computedStep = computed(() => {
    if (type === "percentage") {
        return 0.1
    }
    if (type === "amount") {
        return 0.05
    }
    if (type === "distance") {
        return 1
    }
    if (type === "time") {
        return 0.25
    }
    return 0.1
})
</script>
