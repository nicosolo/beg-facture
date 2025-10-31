<template>
    <div class="relative" ref="dropdownRef">
        <slot name="trigger" :toggle="toggle" :is-open="isOpen"></slot>

        <Transition
            enter-active-class="transition ease-out duration-100"
            enter-from-class="transform opacity-0 scale-95"
            enter-to-class="transform opacity-100 scale-100"
            leave-active-class="transition ease-in duration-75"
            leave-from-class="transform opacity-100 scale-100"
            leave-to-class="transform opacity-0 scale-95"
        >
            <div
                v-if="isOpen"
                class="absolute right-0 z-50 mt-2 min-w-[200px] origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
                role="menu"
                @click.stop
            >
                <slot name="items" :close="close"></slot>
            </div>
        </Transition>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from "vue"

const isOpen = ref(false)
const dropdownRef = ref<HTMLElement | null>(null)

const toggle = (event?: MouseEvent) => {
    if (event) {
        event.stopPropagation()
    }
    isOpen.value = !isOpen.value
}

const close = () => {
    isOpen.value = false
}

const handleClickOutside = (event: MouseEvent) => {
    if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
        close()
    }
}

onMounted(() => {
    document.addEventListener("click", handleClickOutside)
})

onBeforeUnmount(() => {
    document.removeEventListener("click", handleClickOutside)
})
</script>
