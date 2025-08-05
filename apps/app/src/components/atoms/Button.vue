<template>
    <component
        :is="to ? 'router-link' : 'button'"
        :type="to ? undefined : type"
        :to="to"
        :class="[
            'rounded-md font-medium focus:outline-none focus:ring-2 cursor-pointer leading-none block',
            variantClasses,
            sizeClasses,
            disabled ? 'cursor-not-allowed opacity-60' : '',
            className,
        ]"
        :disabled="to ? undefined : disabled"
        @click="$emit('click', $event)"
    >
        <slot></slot>
    </component>
</template>

<script setup lang="ts">
import type { RouteLocationRaw } from "vue-router"

interface Props {
    type?: "button" | "submit" | "reset"
    variant?:
        | "primary"
        | "secondary"
        | "danger"
        | "ghost"
        | "custom"
        | "ghost-danger"
        | "ghost-primary"
    size?: "xs" | "sm" | "md" | "lg"
    disabled?: boolean
    className?: string
    to?: RouteLocationRaw
}

const { type = "button", variant, size, disabled, className, to } = defineProps<Props>()

defineEmits<{
    (e: "click", event: MouseEvent): void
}>()

// Generate variant classes
const variantClasses = (() => {
    switch (variant) {
        case "primary":
            return "bg-indigo-600 hover:bg-indigo-700 text-white"
        case "secondary":
            return "bg-gray-200 hover:bg-gray-300 text-gray-700"
        case "danger":
            return "bg-red-600 hover:bg-red-700 text-white"
        case "ghost":
            return "bg-transparent hover:bg-gray-100 text-gray-700"
        case "ghost-primary":
            return "hover:bg-indigo-200 text-indigo-700"
        case "ghost-danger":
            return "hover:bg-red-100 text-red-600"
        case "custom":
            return ""
        default:
            return "bg-gray-200 hover:bg-gray-300 text-gray-700"
    }
})()

// Generate size classes
const sizeClasses = (() => {
    switch (size) {
        case "xs":
            return "text-sm px-1.5 py-1"
        case "sm":
            return "text-sm px-3 py-1.5"
        case "lg":
            return "text-base px-6 py-3"
        default:
            return "text-sm px-4 py-2" // default to medium
    }
})()
</script>
