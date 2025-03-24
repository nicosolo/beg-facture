<template>
    <div class="container mx-auto py-8">
        <h1 class="text-2xl font-bold mb-6">{{ title }}</h1>

        <slot name="filter"></slot>

        <slot name="content"></slot>

        <slot name="pagination"></slot>
    </div>
</template>

<script setup lang="ts">
defineProps<{
    title: string
}>()
</script>
