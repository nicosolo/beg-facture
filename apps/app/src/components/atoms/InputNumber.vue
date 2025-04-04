<template>
    <div :class="['w-24', 'flex', 'items-center', 'gap-1']">
        <input
            v-bind="$attrs"
            type="number"
            :value="modelValue"
            @input="
                $emit('update:modelValue', parseFloat(($event.target as HTMLInputElement).value))
            "
            :step="computedStep"
            :class="[computedClass, className]"
        />
        <span v-if="type === 'percentage'">%</span>
        <span v-if="type === 'distance'">km</span>
    </div>
</template>

<script setup lang="ts">
import { computed } from "vue"

const {
    modelValue,
    className,
    type = "number",
} = defineProps<{
    modelValue: number | null
    className?: string
    type?: "percentage" | "amount" | "number" | "distance"
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
    return 0.1
})
</script>
