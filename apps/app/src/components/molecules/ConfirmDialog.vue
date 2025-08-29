<template>
    <Dialog
        :model-value="modelValue"
        :title="title"
        size="sm"
        @update:model-value="handleDialogUpdate"
    >
        <!-- Content -->
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

            <!-- Message -->
            <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                <div class="mt-2">
                    <p class="text-sm text-gray-500">
                        {{ message }}
                    </p>
                </div>
            </div>
        </div>

        <!-- Footer Actions -->
        <template #footer>
            <Button
                @click="confirm"
                :disabled="loading"
                :variant="type === 'danger' ? 'danger' : 'primary'"
                size="sm"
                class="inline-flex w-full justify-center sm:ml-3 sm:w-auto"
            >
                <LoadingSpinner v-if="loading" size="sm" color="white" class="mr-2" />
                {{ confirmText || $t("common.confirm") }}
            </Button>
            <Button
                @click="cancel"
                :disabled="loading"
                variant="secondary"
                size="sm"
                class="mt-3 inline-flex w-full justify-center sm:mt-0 sm:w-auto"
            >
                {{ cancelText || $t("common.cancel") }}
            </Button>
        </template>
    </Dialog>
</template>

<script setup lang="ts">
import { ref } from "vue"
import LoadingSpinner from "@/components/atoms/LoadingSpinner.vue"
import Button from "@/components/atoms/Button.vue"
import Dialog from "@/components/molecules/Dialog.vue"

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

const handleDialogUpdate = (value: boolean) => {
    if (!value && !loading.value) {
        emit("update:modelValue", false)
        emit("cancel")
    }
}

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
