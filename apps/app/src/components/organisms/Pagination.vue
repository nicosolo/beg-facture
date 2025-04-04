<template>
    <div
        class="flex flex-col space-y-3 w-full sm:flex-row sm:space-y-0 sm:items-center justify-between px-4 py-3 sm:px-6 border-t border-gray-200"
    >
        <div>
            <p class="text-sm text-gray-700">
                {{
                    $t("pagination.showing", {
                        from: startItem,
                        to: endItem,
                        total: totalItems,
                    })
                }}
            </p>
            <!-- Mobile pagination controls -->
            <div class="flex flex-1 justify-between sm:hidden">
                <Button
                    @click="$emit('prev')"
                    :disabled="currentPage === 1"
                    variant="secondary"
                    size="sm"
                >
                    {{ $t("pagination.previous") }}
                </Button>
                <Button
                    @click="$emit('next')"
                    :disabled="currentPage >= totalPages"
                    variant="secondary"
                    size="sm"
                >
                    {{ $t("pagination.next") }}
                </Button>
            </div>
        </div>

        <div class="hidden sm:flex justify-between">
            <nav class="isolate inline-flex space-x-1 rounded-md shadow-sm" aria-label="Pagination">
                <Button
                    @click="$emit('go-to', 1)"
                    :disabled="currentPage === 1"
                    :class="['relative inline-flex items-center rounded-l-md px-2 py-2']"
                    variant="ghost"
                    size="sm"
                >
                    <span class="sr-only">{{ $t("pagination.first") }}</span>
                    &laquo;
                </Button>
                <Button
                    @click="$emit('prev')"
                    :disabled="currentPage === 1"
                    :class="['relative inline-flex items-center px-2 py-2']"
                    variant="ghost"
                    size="sm"
                >
                    <span class="sr-only">{{ $t("pagination.previous") }}</span>
                    &lsaquo;
                </Button>

                <template v-for="page in displayedPages" :key="page">
                    <Button
                        v-if="page !== '...'"
                        @click="$emit('go-to', Number(page))"
                        :class="[
                            'relative inline-flex items-center px-4 py-2',
                            currentPage === Number(page)
                                ? 'z-10 bg-indigo-700 text-white hover:bg-indigo-700'
                                : 'border border-gray-300',
                        ]"
                        variant="custom"
                        size="sm"
                    >
                        {{ page }}
                    </Button>
                    <span
                        v-else
                        class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700"
                    >
                        {{ page }}
                    </span>
                </template>

                <Button
                    @click="$emit('next')"
                    :disabled="currentPage >= totalPages"
                    :class="['relative inline-flex items-center px-2 py-2']"
                    variant="ghost"
                    size="sm"
                >
                    <span class="sr-only">{{ $t("pagination.next") }}</span>
                    &rsaquo;
                </Button>
                <Button
                    @click="$emit('go-to', totalPages)"
                    :disabled="currentPage >= totalPages"
                    :class="['relative inline-flex items-center rounded-r-md px-2 py-2']"
                    variant="ghost"
                    size="sm"
                >
                    <span class="sr-only">{{ $t("pagination.last") }}</span>
                    &raquo;
                </Button>
            </nav>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed } from "vue"
import Button from "../atoms/Button.vue"

interface Props {
    currentPage: number
    totalPages: number
    totalItems: number
    pageSize: number
}

const { totalItems, totalPages, currentPage, pageSize } = defineProps<Props>()

// Emitted events
defineEmits<{
    (e: "prev"): void
    (e: "next"): void
    (e: "go-to", page: number): void
}>()

// Computed properties
const startItem = computed(() => {
    if (totalItems === 0) return 0
    return (currentPage - 1) * pageSize + 1
})

const endItem = computed(() => {
    if (totalItems === 0) return 0
    return Math.min(currentPage * pageSize, totalItems)
})

const displayedPages = computed(() => {
    if (totalPages <= 7) {
        return Array.from({ length: totalPages }, (_, i) => String(i + 1))
    }

    if (currentPage <= 4) {
        return ["1", "2", "3", "4", "5", "...", String(totalPages)]
    }

    if (currentPage >= totalPages - 3) {
        return [
            "1",
            "...",
            String(totalPages - 4),
            String(totalPages - 3),
            String(totalPages - 2),
            String(totalPages - 1),
            String(totalPages),
        ]
    }

    return [
        "1",
        "...",
        String(currentPage - 1),
        String(currentPage),
        String(currentPage + 1),
        "...",
        String(totalPages),
    ]
})
</script>
