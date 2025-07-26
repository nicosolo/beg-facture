<template>
    <div class="flex items-center gap-2">
        <div class="flex-1">
            <input
                type="number"
                :value="hours"
                @input="updateHours"
                @blur="formatHours"
                min="0"
                max="999"
                :disabled="disabled"
                :required="required && !modelValue"
                :class="[
                    'w-full px-3 py-2 text-center border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
                    disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
                ]"
                placeholder="0"
            />
            <span class="block text-xs text-gray-500 text-center mt-1">{{ $t('common.hours', 'hours') }}</span>
        </div>
        
        <span class="text-lg font-semibold text-gray-500 pb-5">:</span>
        
        <div class="flex-1">
            <input
                type="number"
                :value="minutes"
                @input="updateMinutes"
                @blur="formatMinutes"
                min="0"
                max="59"
                :disabled="disabled"
                :class="[
                    'w-full px-3 py-2 text-center border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
                    disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
                ]"
                placeholder="00"
            />
            <span class="block text-xs text-gray-500 text-center mt-1">{{ $t('common.minutes', 'min') }}</span>
        </div>
        
        <!-- Increment/Decrement buttons -->
        <div class="flex flex-col gap-1">
            <button
                @click="incrementDuration"
                type="button"
                :disabled="disabled"
                class="px-2 py-1 text-xs bg-gray-100 hover:bg-gray-200 rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
                :title="`+${step} min`"
            >
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v12m6-6H6" />
                </svg>
            </button>
            <button
                @click="decrementDuration"
                type="button"
                :disabled="disabled || (modelValue || 0) < step"
                class="px-2 py-1 text-xs bg-gray-100 hover:bg-gray-200 rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
                :title="`-${step} min`"
            >
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6" />
                </svg>
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
    modelValue?: number // Duration in minutes
    disabled?: boolean
    step?: number // Step size in minutes for increment/decrement
    required?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    modelValue: 0,
    disabled: false,
    step: 15,
    required: false
})

const emit = defineEmits<{
    'update:modelValue': [value: number]
}>()

// Computed values for hours and minutes
const hours = computed(() => Math.floor((props.modelValue || 0) / 60))
const minutes = computed(() => (props.modelValue || 0) % 60)


// Update hours
const updateHours = (event: Event) => {
    const target = event.target as HTMLInputElement
    const value = parseInt(target.value) || 0
    if (value >= 0) {
        const newDuration = value * 60 + minutes.value
        emit('update:modelValue', newDuration)
    }
}

// Update minutes
const updateMinutes = (event: Event) => {
    const target = event.target as HTMLInputElement
    let value = parseInt(target.value) || 0
    
    // Allow values > 59 to automatically convert to hours
    if (value > 59) {
        const additionalHours = Math.floor(value / 60)
        const remainingMinutes = value % 60
        const newDuration = (hours.value + additionalHours) * 60 + remainingMinutes
        emit('update:modelValue', newDuration)
    } else if (value >= 0) {
        const newDuration = hours.value * 60 + value
        emit('update:modelValue', newDuration)
    }
}

// Format hours on blur (ensure it's a valid number)
const formatHours = (event: Event) => {
    const target = event.target as HTMLInputElement
    const value = parseInt(target.value) || 0
    target.value = value.toString()
}

// Format minutes on blur (ensure 2 digits)
const formatMinutes = (event: Event) => {
    const target = event.target as HTMLInputElement
    const value = parseInt(target.value) || 0
    target.value = value.toString().padStart(2, '0')
}

// Increment duration by step
const incrementDuration = () => {
    const newDuration = (props.modelValue || 0) + props.step
    emit('update:modelValue', newDuration)
}

// Decrement duration by step
const decrementDuration = () => {
    const newDuration = Math.max(0, (props.modelValue || 0) - props.step)
    emit('update:modelValue', newDuration)
}
</script>