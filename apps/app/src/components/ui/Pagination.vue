<template>
    <div class="flex items-center justify-between border-t border-gray-200 px-4 py-3 sm:px-6">
        <!-- Mobile pagination controls -->
        <div class="flex flex-1 justify-between sm:hidden">
            <button
                @click="$emit('prev')"
                :disabled="currentPage === 1"
                :class="[
                    'relative inline-flex items-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium',
                    currentPage === 1
                        ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                        : 'bg-white text-gray-700 hover:bg-gray-50',
                ]"
            >
                Previous
            </button>
            <button
                @click="$emit('next')"
                :disabled="currentPage >= totalPages"
                :class="[
                    'relative ml-3 inline-flex items-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium',
                    currentPage >= totalPages
                        ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                        : 'bg-white text-gray-700 hover:bg-gray-50',
                ]"
            >
                Next
            </button>
        </div>

        <!-- Desktop pagination controls -->
        <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
            <div>
                <p class="text-sm text-gray-700">
                    Showing
                    <span class="font-medium">{{ startItem }}</span>
                    to
                    <span class="font-medium">{{ endItem }}</span>
                    of
                    <span class="font-medium">{{ totalItems }}</span>
                    results
                </p>
            </div>
            <div>
                <nav
                    class="isolate inline-flex -space-x-px rounded-md shadow-sm"
                    aria-label="Pagination"
                >
                    <button
                        @click="$emit('go-to', 1)"
                        :disabled="currentPage === 1"
                        :class="[
                            'relative inline-flex items-center rounded-l-md border border-gray-300 bg-white px-2 py-2 text-sm font-medium',
                            currentPage === 1
                                ? 'text-gray-400 cursor-not-allowed'
                                : 'text-gray-500 hover:bg-gray-50',
                        ]"
                    >
                        <span class="sr-only">First</span>
                        &laquo;
                    </button>
                    <button
                        @click="$emit('prev')"
                        :disabled="currentPage === 1"
                        :class="[
                            'relative inline-flex items-center border border-gray-300 bg-white px-2 py-2 text-sm font-medium',
                            currentPage === 1
                                ? 'text-gray-400 cursor-not-allowed'
                                : 'text-gray-500 hover:bg-gray-50',
                        ]"
                    >
                        <span class="sr-only">Previous</span>
                        &lsaquo;
                    </button>

                    <template v-for="page in displayedPages" :key="page">
                        <button
                            v-if="page !== '...'"
                            @click="$emit('go-to', Number(page))"
                            :class="[
                                'relative inline-flex items-center border px-4 py-2 text-sm font-medium',
                                currentPage === Number(page)
                                    ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
                                    : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
                            ]"
                        >
                            {{ page }}
                        </button>
                        <span
                            v-else
                            class="relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700"
                        >
                            {{ page }}
                        </span>
                    </template>

                    <button
                        @click="$emit('next')"
                        :disabled="currentPage >= totalPages"
                        :class="[
                            'relative inline-flex items-center border border-gray-300 bg-white px-2 py-2 text-sm font-medium',
                            currentPage >= totalPages
                                ? 'text-gray-400 cursor-not-allowed'
                                : 'text-gray-500 hover:bg-gray-50',
                        ]"
                    >
                        <span class="sr-only">Next</span>
                        &rsaquo;
                    </button>
                    <button
                        @click="$emit('go-to', totalPages)"
                        :disabled="currentPage >= totalPages"
                        :class="[
                            'relative inline-flex items-center rounded-r-md border border-gray-300 bg-white px-2 py-2 text-sm font-medium',
                            currentPage >= totalPages
                                ? 'text-gray-400 cursor-not-allowed'
                                : 'text-gray-500 hover:bg-gray-50',
                        ]"
                    >
                        <span class="sr-only">Last</span>
                        &raquo;
                    </button>
                </nav>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed } from "vue"

const props = defineProps<{
    currentPage: number
    totalPages: number
    totalItems: number
    pageSize: number
}>()

// Emitted events
defineEmits<{
    (e: "prev"): void
    (e: "next"): void
    (e: "go-to", page: number): void
}>()

// Computed properties
const startItem = computed(() => {
    if (props.totalItems === 0) return 0
    return (props.currentPage - 1) * props.pageSize + 1
})

const endItem = computed(() => {
    if (props.totalItems === 0) return 0
    return Math.min(props.currentPage * props.pageSize, props.totalItems)
})

const displayedPages = computed(() => {
    if (props.totalPages <= 7) {
        return Array.from({ length: props.totalPages }, (_, i) => String(i + 1))
    }

    if (props.currentPage <= 4) {
        return ["1", "2", "3", "4", "5", "...", String(props.totalPages)]
    }

    if (props.currentPage >= props.totalPages - 3) {
        return [
            "1",
            "...",
            String(props.totalPages - 4),
            String(props.totalPages - 3),
            String(props.totalPages - 2),
            String(props.totalPages - 1),
            String(props.totalPages),
        ]
    }

    return [
        "1",
        "...",
        String(props.currentPage - 1),
        String(props.currentPage),
        String(props.currentPage + 1),
        "...",
        String(props.totalPages),
    ]
})
</script>
