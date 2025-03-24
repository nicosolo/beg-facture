<template>
    <span
        :class="[
            'inline-flex px-2 text-xs leading-5 font-semibold rounded-full',
            variantClasses,
            className,
        ]"
    >
        <slot></slot>
    </span>
</template>

<script setup lang="ts">
const props = defineProps<{
    variant?: "success" | "error" | "warning" | "info"
    className?: string
}>()

// Variant classes
const variantClasses = (() => {
    switch (props.variant) {
        case "success":
            return "bg-green-100 text-green-800"
        case "error":
            return "bg-red-100 text-red-800"
        case "warning":
            return "bg-yellow-100 text-yellow-800"
        case "info":
            return "bg-blue-100 text-blue-800"
        default:
            return "bg-gray-100 text-gray-800"
    }
})()
</script>
