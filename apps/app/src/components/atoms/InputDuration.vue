<template>
    <div class="flex items-center gap-1">
        <div class="flex items-center">
            <input
                type="number"
                :value="hours"
                min="0"
                @input="updateHours(parseInt(($event.target as HTMLInputElement).value || '0'))"
                class="w-12 p-1 border border-gray-300 rounded"
            />
            <span class="mx-1">h</span>
        </div>
        <div class="flex items-center">
            <input
                type="number"
                :value="minutes"
                min="0"
                max="59"
                step="5"
                @input="updateMinutes(parseInt(($event.target as HTMLInputElement).value || '0'))"
                class="w-12 p-1 border border-gray-300 rounded"
            />
            <span class="mx-1">m</span>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed } from "vue"

interface InputDurationProps {
    modelValue: number // Duration in minutes
    className?: string
}

const { modelValue, className } = defineProps<InputDurationProps>()

const emit = defineEmits<{
    (e: "update:modelValue", value: number): void
}>()

// Convert total minutes to hours and minutes
const hours = computed(() => Math.floor(modelValue / 60))
const minutes = computed(() => modelValue % 60)

// Update hours
const updateHours = (newHours: number) => {
    const newValue = newHours * 60 + minutes.value
    emit("update:modelValue", newValue)
}

// Update minutes
const updateMinutes = (newMinutes: number) => {
    // Ensure minutes are within 0-59 range
    const validMinutes = Math.min(Math.max(0, newMinutes), 59)
    const newValue = hours.value * 60 + validMinutes
    emit("update:modelValue", newValue)
}

// Increment total minutes by the specified amount
const increment = (step: number) => {
    emit("update:modelValue", modelValue + step)
}

// Decrement total minutes by the specified amount
const decrement = (step: number) => {
    const newValue = Math.max(0, modelValue - step)
    emit("update:modelValue", newValue)
}
</script>
