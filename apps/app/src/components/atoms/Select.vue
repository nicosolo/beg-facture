<template>
    <select
        :value="modelValue"
        :disabled="disabled"
        :class="[
            'w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
            disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
            className,
        ]"
        @change="$emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
    >
        <slot></slot>
    </select>
</template>

<script setup lang="ts">
defineProps<{
    modelValue: string | number | boolean
    disabled?: boolean
    className?: string
}>()

defineEmits<{
    (e: "update:modelValue", value: string | number | boolean): void
}>()
</script>
