<template>
    <button
        :type="type"
        :class="[
            'px-4 py-2 rounded-md font-medium focus:outline-none focus:ring-2 focus:ring-offset-2',
            variantClasses,
            sizeClasses,
            disabled ? 'cursor-not-allowed opacity-60' : '',
            className,
        ]"
        :disabled="disabled"
        @click="$emit('click', $event)"
    >
        <slot></slot>
    </button>
</template>

<script setup lang="ts">
const props = defineProps<{
    type?: "button" | "submit" | "reset"
    variant?: "primary" | "secondary" | "danger" | "ghost"
    size?: "sm" | "md" | "lg"
    disabled?: boolean
    className?: string
}>()

defineEmits<{
    (e: "click", event: MouseEvent): void
}>()

// Set defaults
const type = props.type || "button"

// Generate variant classes
const variantClasses = (() => {
    switch (props.variant) {
        case "primary":
            return "bg-indigo-600 hover:bg-indigo-700 text-white"
        case "secondary":
            return "bg-gray-200 hover:bg-gray-300 text-gray-700"
        case "danger":
            return "bg-red-600 hover:bg-red-700 text-white"
        case "ghost":
            return "bg-transparent hover:bg-gray-100 text-gray-700"
        default:
            return "bg-gray-200 hover:bg-gray-300 text-gray-700" // default to secondary
    }
})()

// Generate size classes
const sizeClasses = (() => {
    switch (props.size) {
        case "sm":
            return "text-xs px-2.5 py-1.5"
        case "lg":
            return "text-base px-6 py-3"
        default:
            return "text-sm px-4 py-2" // default to medium
    }
})()
</script>
