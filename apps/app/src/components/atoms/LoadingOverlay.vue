<template>
    <div class="relative w-full h-full">
        <slot></slot>

        <div
            v-if="loading"
            class="absolute -inset-4 bg-black opacity-20 z-10 flex items-center justify-center rounded-lg custom-pulse"
            :style="{ '--pulse-duration': `${duration}s` }"
            @click.stop
        ></div>
    </div>
</template>

<script setup lang="ts">
interface Props {
    loading: boolean
    duration?: number
}

const { loading, duration = 2 } = defineProps<Props>()
</script>

<style scoped>
.custom-pulse {
    animation: pulse var(--pulse-duration, 4s) cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
    0%,
    100% {
        opacity: 0.2;
    }
    50% {
        opacity: 0.4;
    }
}
</style>
