<template>
    <div class="bg-white rounded-lg shadow-sm border border-gray-200">
        <!-- Filter Header -->
        <div class="px-4 py-3 border-b border-gray-200">
            <div class="flex items-center justify-between">
                <h3 class="text-sm font-medium text-gray-900 flex items-center gap-2">
                    {{ $t("common.filters") }}
                    <span
                        v-if="activeFilterCount > 0"
                        class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-800"
                    >
                        {{ activeFilterCount }}
                    </span>
                </h3>
                <button
                    v-if="activeFilterCount > 0"
                    @click="$emit('clear')"
                    class="text-sm text-indigo-600 hover:text-indigo-700 font-medium"
                >
                    {{ $t("common.clearAll") }}
                </button>
            </div>
        </div>

        <!-- Filter Content -->
        <div class="p-4 space-y-4">
            <slot />
        </div>
    </div>
</template>

<script setup lang="ts">
interface FilterPanelProps {
    activeFilterCount?: number
}

withDefaults(defineProps<FilterPanelProps>(), {
    activeFilterCount: 0,
})

defineEmits<{
    clear: []
}>()
</script>
