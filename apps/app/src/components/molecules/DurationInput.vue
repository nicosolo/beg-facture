<template>
    <input
        type="number"
        :value="hours"
        @input="updateHours"
        min="0"
        step="0.25"
        :disabled="disabled"
        :required="required"
        :class="[
            'w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
            disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
        ]"
        :placeholder="placeholder"
    />
</template>

<script setup lang="ts">
import { computed } from "vue"

interface Props {
    modelValue?: number // Duration in minutes
    disabled?: boolean
    required?: boolean
    placeholder?: string
}

const props = withDefaults(defineProps<Props>(), {
    modelValue: 0,
    disabled: false,
    required: false,
    placeholder: "0",
})

const emit = defineEmits<{
    "update:modelValue": [value: number]
}>()

// Convert minutes to hours for display
const hours = computed(() => {
    const mins = props.modelValue || 0
    return Math.round((mins / 60) * 100) / 100 // Round to 2 decimal places
})

// Update hours and emit as minutes
const updateHours = (event: Event) => {
    const target = event.target as HTMLInputElement
    const value = parseFloat(target.value) || 0
    if (value >= 0) {
        const newDuration = Math.round(value * 60) // Convert hours to minutes
        emit("update:modelValue", newDuration)
    }
}
</script>
