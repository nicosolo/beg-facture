<template>
    <Transition
        enter-active-class="transition ease-out duration-200"
        enter-from-class="transform opacity-0 -translate-y-2"
        enter-to-class="transform opacity-100 translate-y-0"
        leave-active-class="transition ease-in duration-150"
        leave-from-class="transform opacity-100 translate-y-0"
        leave-to-class="transform opacity-0 -translate-y-2"
    >
        <div
            v-if="selectedCount > 0"
            class="fixed bottom-6 left-1/2 transform -translate-x-1/2 z-20"
        >
            <div class="bg-white rounded-lg shadow-lg border border-gray-200 px-4 py-3">
                <div class="flex items-center gap-4">
                    <!-- Selection count -->
                    <div class="text-sm text-gray-700">
                        {{ $t("common.itemsSelected", { count: selectedCount }) }}
                    </div>

                    <!-- Action buttons -->
                    <div class="flex items-center gap-2 border-l border-gray-200 pl-4">
                        <slot />
                    </div>

                    <!-- Clear selection -->
                    <button
                        @click="$emit('clear')"
                        class="ml-2 text-sm text-gray-500 hover:text-gray-700"
                    >
                        {{ $t("common.clearSelection") }}
                    </button>
                </div>
            </div>
        </div>
    </Transition>
</template>

<script setup lang="ts">
interface BulkActionsProps {
    selectedCount: number
}

defineProps<BulkActionsProps>()

defineEmits<{
    clear: []
}>()
</script>
