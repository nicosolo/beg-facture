<template>
    <Teleport to="body">
        <Transition name="dialog-fade">
            <div
                v-if="modelValue"
                class="fixed inset-0 z-50 overflow-y-auto"
                aria-labelledby="modal-title"
                role="dialog"
                aria-modal="true"
            >
                <div
                    class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block"
                >
                    <!-- Background overlay -->
                    <div
                        class="fixed inset-0 bg-gray-500/50 transition-opacity"
                        aria-hidden="true"
                        @click="closeDialog"
                    ></div>

                    <!-- Center modal -->
                    <span
                        class="hidden sm:inline-block sm:align-middle sm:h-screen"
                        aria-hidden="true"
                        >&#8203;</span
                    >

                    <div
                        :class="[
                            'inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:w-full',
                            sizeClasses,
                        ]"
                        @click.stop
                    >
                        <div class="bg-white p-4">
                            <div class="sm:flex sm:items-start">
                                <div class="mt-3 text-left w-full">
                                    <h3
                                        class="text-lg leading-6 font-medium text-gray-900"
                                        id="modal-title"
                                    >
                                        {{ title }}
                                    </h3>
                                    <div class="mt-2">
                                        <slot></slot>
                                    </div>
                                </div>
                            </div>

                            <!-- Footer -->
                            <div class="bg-gray-50 pt-6 flex flex-row-reverse">
                                <slot name="footer"></slot>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </Transition>
    </Teleport>
</template>

<script setup lang="ts">
import { watch, computed } from "vue"

interface Props {
    modelValue: boolean
    title: string
    size?: "sm" | "md" | "lg" | "xl" | "full"
}

const props = withDefaults(defineProps<Props>(), {
    size: "lg",
})
const emit = defineEmits(["update:modelValue"])

// Compute size classes based on the size prop
const sizeClasses = computed(() => {
    const sizes = {
        sm: "sm:max-w-md",
        md: "sm:max-w-lg",
        lg: "sm:max-w-3xl",
        xl: "sm:max-w-5xl",
        full: "sm:max-w-full sm:mx-4",
    }
    return sizes[props.size] || sizes.lg
})

const closeDialog = () => {
    emit("update:modelValue", false)
}

// Close dialog when ESC key is pressed
const handleKeyDown = (e: KeyboardEvent) => {
    if (e.key === "Escape" && props.modelValue) {
        closeDialog()
    }
}

watch(
    () => props.modelValue,
    (value) => {
        if (value) {
            document.addEventListener("keydown", handleKeyDown)
            document.body.style.overflow = "hidden" // Prevent body scrolling
        } else {
            document.removeEventListener("keydown", handleKeyDown)
            document.body.style.overflow = "" // Restore body scrolling
        }
    }
)
</script>

<style scoped>
.dialog-fade-enter-active,
.dialog-fade-leave-active {
    transition: opacity 0.3s ease;
}

.dialog-fade-enter-from,
.dialog-fade-leave-to {
    opacity: 0;
}
</style>
