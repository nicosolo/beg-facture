<template>
    <div class="border border-gray-200 rounded overflow-hidden">
        <div
            @click="togglePanel"
            class="bg-gray-100 p-2 flex justify-between items-center cursor-pointer"
        >
            <div class="flex items-center">
                <span class="mr-2 transition-transform" :class="{ 'rotate-90': isOpen }">▶</span>
                <h3 class="font-medium">
                    <slot name="header">{{ title }}</slot>
                </h3>
            </div>
            <div v-if="$slots.headerActions" class="flex items-center" @click.stop>
                <slot name="headerActions"></slot>
            </div>
        </div>
        <div v-show="isOpen" class="p-4 transition-all">
            <slot name="content">Content goes here</slot>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, inject, onMounted, computed } from "vue"

interface Props {
    id: string
    title?: string
    defaultOpen?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    title: "",
    defaultOpen: false,
})

// Define the accordion group interface
interface AccordionGroup {
    register: (id: string, isOpen: boolean) => void
    toggle: (id: string, isOpen: boolean) => boolean
    isOpen: (id: string) => boolean
}

// Inject accordion group context if available
const accordionGroup = inject<AccordionGroup | null>("accordionGroup", null)
const _isOpen = ref(props.defaultOpen)

// If part of an accordion group, use the group's state management
const isOpen = computed(() => {
    if (accordionGroup) {
        return accordionGroup.isOpen(props.id)
    }
    return _isOpen.value
})

const togglePanel = () => {
    if (accordionGroup) {
        const newState = !isOpen.value
        accordionGroup.toggle(props.id, newState)
    } else {
        _isOpen.value = !_isOpen.value
    }
}

// Register with parent accordion group if available
onMounted(() => {
    if (accordionGroup) {
        accordionGroup.register(props.id, props.defaultOpen)
    }
})

// Expose methods to open/close the accordion programmatically
defineExpose({
    open: () => {
        if (accordionGroup) {
            accordionGroup.toggle(props.id, true)
        } else {
            _isOpen.value = true
        }
    },
    close: () => {
        if (accordionGroup) {
            accordionGroup.toggle(props.id, false)
        } else {
            _isOpen.value = false
        }
    },
    toggle: togglePanel,
})
</script>

<style scoped>
.rotate-90 {
    transform: rotate(90deg);
    transition: transform 0.2s ease;
}
</style>
