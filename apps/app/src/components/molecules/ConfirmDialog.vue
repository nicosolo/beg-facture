<template>
    <Teleport to="body">
        <Transition
            enter-active-class="transition ease-out duration-300"
            enter-from-class="opacity-0"
            enter-to-class="opacity-100"
            leave-active-class="transition ease-in duration-200"
            leave-from-class="opacity-100"
            leave-to-class="opacity-0"
        >
            <div v-if="modelValue" class="fixed inset-0 z-50 overflow-y-auto">
                <!-- Backdrop -->
                <div class="fixed inset-0 bg-black bg-opacity-25" @click="cancel" />

                <!-- Dialog -->
                <div class="flex min-h-full items-center justify-center p-4">
                    <Transition
                        enter-active-class="transition ease-out duration-300"
                        enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                        enter-to-class="opacity-100 translate-y-0 sm:scale-100"
                        leave-active-class="transition ease-in duration-200"
                        leave-from-class="opacity-100 translate-y-0 sm:scale-100"
                        leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                    >
                        <div
                            v-if="modelValue"
                            class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg"
                        >
                            <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                                <div class="sm:flex sm:items-start">
                                    <!-- Icon -->
                                    <div
                                        :class="[
                                            'mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full sm:mx-0 sm:h-10 sm:w-10',
                                            type === 'danger' ? 'bg-red-100' : 'bg-yellow-100',
                                        ]"
                                    >
                                        <svg
                                            v-if="type === 'danger'"
                                            class="h-6 w-6 text-red-600"
                                            xmlns="http://www.w3.org/2000/svg"
                                            fill="none"
                                            viewBox="0 0 24 24"
                                            stroke="currentColor"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                                            />
                                        </svg>
                                        <svg
                                            v-else
                                            class="h-6 w-6 text-yellow-600"
                                            xmlns="http://www.w3.org/2000/svg"
                                            fill="none"
                                            viewBox="0 0 24 24"
                                            stroke="currentColor"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                                            />
                                        </svg>
                                    </div>

                                    <!-- Content -->
                                    <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                                        <h3 class="text-lg font-medium leading-6 text-gray-900">
                                            {{ title }}
                                        </h3>
                                        <div class="mt-2">
                                            <p class="text-sm text-gray-500">
                                                {{ message }}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                                <button
                                    @click="confirm"
                                    :disabled="loading"
                                    :class="[
                                        'inline-flex w-full justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm sm:ml-3 sm:w-auto',
                                        type === 'danger'
                                            ? 'bg-red-600 hover:bg-red-700'
                                            : 'bg-indigo-600 hover:bg-indigo-700',
                                        loading && 'opacity-50 cursor-not-allowed',
                                    ]"
                                >
                                    <LoadingSpinner
                                        v-if="loading"
                                        size="sm"
                                        color="white"
                                        class="mr-2"
                                    />
                                    {{ confirmText || $t("common.confirm") }}
                                </button>
                                <button
                                    @click="cancel"
                                    :disabled="loading"
                                    class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                    {{ cancelText || $t("common.cancel") }}
                                </button>
                            </div>
                        </div>
                    </Transition>
                </div>
            </div>
        </Transition>
    </Teleport>
</template>

<script setup lang="ts">
import { ref } from "vue"
import LoadingSpinner from "@/components/atoms/LoadingSpinner.vue"

interface ConfirmDialogProps {
    modelValue: boolean
    title: string
    message: string
    type?: "warning" | "danger"
    confirmText?: string
    cancelText?: string
}

withDefaults(defineProps<ConfirmDialogProps>(), {
    type: "warning",
})

const emit = defineEmits<{
    "update:modelValue": [value: boolean]
    confirm: []
    cancel: []
}>()

const loading = ref(false)

const confirm = async () => {
    loading.value = true
    emit("confirm")
    // Keep dialog open - parent component should close it
    loading.value = false
}

const cancel = () => {
    if (!loading.value) {
        emit("update:modelValue", false)
        emit("cancel")
    }
}

// Expose loading state for parent component
defineExpose({
    loading,
})
</script>
