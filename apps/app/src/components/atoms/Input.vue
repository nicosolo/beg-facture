<template>
    <input
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :class="[
            'w-full h-[39px] px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
            disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
            className,
        ]"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
    />
</template>

<script setup lang="ts">
defineProps<{
    modelValue?: string
    type?: string
    placeholder?: string
    disabled?: boolean
    className?: string
}>()

defineEmits<{
    (e: "update:modelValue", value: string): void
}>()
</script>
