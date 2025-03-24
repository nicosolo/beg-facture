<template>
    <label :class="['block text-sm font-medium', className || 'text-gray-700']">
        <slot></slot>
    </label>
</template>

<script setup lang="ts">
defineProps<{
    className?: string
}>()
</script>
