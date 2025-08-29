<template>
    <div class="min-h-screen bg-gray-50">
        <!-- Form Container -->
        <Card>
            <!-- Loading Overlay -->
            <div
                v-if="loading"
                class="absolute inset-0 bg-white bg-opacity-75 flex items-center justify-center z-10 rounded-lg"
            >
                <LoadingSpinner size="lg" color="indigo" />
            </div>

            <!-- Header -->
            <div class="px-6 py-4 border-b border-gray-200">
                <h1 class="text-xl font-semibold text-gray-900">
                    {{ title }}
                </h1>
                <p v-if="subtitle" class="mt-1 text-sm text-gray-600">
                    {{ subtitle }}
                </p>
            </div>

            <!-- Error Summary -->
            <div
                v-if="errorMessage"
                class="mx-6 mt-4 p-4 bg-red-50 border border-red-200 rounded-md"
            >
                <div class="flex">
                    <div class="flex-shrink-0">
                        <svg
                            class="h-5 w-5 text-red-400"
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 20 20"
                            fill="currentColor"
                        >
                            <path
                                fill-rule="evenodd"
                                d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                                clip-rule="evenodd"
                            />
                        </svg>
                    </div>
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-red-800">
                            {{ $t("common.errorOccurred") }}
                        </h3>
                        <div class="mt-2 text-sm text-red-700">
                            {{ errorMessage }}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form Content -->
            <div class="px-6 py-6">
                <slot />
            </div>

            <!-- Footer Actions -->
            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 rounded-b-lg">
                <div class="flex items-center justify-end gap-3">
                    <slot name="actions" />
                </div>
            </div>
            <!-- Form Content -->
            <div class="px-6 py-6">
                <slot name="footer" />
            </div>
        </Card>
    </div>
</template>

<script setup lang="ts">
import LoadingSpinner from "@/components/atoms/LoadingSpinner.vue"
import Card from "@/components/atoms/Card.vue"

interface FormLayoutProps {
    title: string
    subtitle?: string
    loading?: boolean
    errorMessage?: string | null
}

withDefaults(defineProps<FormLayoutProps>(), {
    loading: false,
})
</script>
