<template>
    <div class="flex flex-col gap-2">
        <div class="relative inline-flex">
            <input
                ref="fileInput"
                type="file"
                class="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                :accept="accept"
                :disabled="disabled"
                :required="isRequired"
                @change="onFileChange"
            />
            <button
                type="button"
                class="px-2 py-1 text-xs font-medium text-blue-600 border border-blue-300 rounded hover:bg-blue-50 disabled:opacity-60 disabled:cursor-not-allowed"
                :disabled="disabled"
            >
                {{ hasFile ? replaceLabel : uploadLabel }}
            </button>
        </div>
        <div v-if="hasFile" class="flex flex-wrap items-center gap-2 text-xs text-gray-600">
            <span class="truncate max-w-[220px]">{{ displayLabel }}</span>
            <slot name="preview"></slot>
            <button
                type="button"
                class="text-red-600 hover:text-red-700"
                :disabled="disabled"
                @click="handleClear"
            >
                {{ removeLabel }}
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from "vue"

const props = defineProps<{
    fileName?: string | null
    displayName?: string | null
    accept?: string
    uploadLabel?: string
    replaceLabel?: string
    removeLabel?: string
    disabled?: boolean
    required?: boolean
}>()

const emit = defineEmits<{
    (e: "select", file: File | null): void
    (e: "clear"): void
}>()

const fileInput = ref<HTMLInputElement | null>(null)

const hasFile = computed(() => Boolean(props.fileName))
const isRequired = computed(() => (props.required ?? false) && !props.fileName)

const uploadLabel = computed(() => props.uploadLabel ?? "Téléverser")
const replaceLabel = computed(() => props.replaceLabel ?? "Remplacer")
const removeLabel = computed(() => props.removeLabel ?? "Supprimer")
const displayLabel = computed(() => props.displayName ?? props.fileName ?? "")

const onFileChange = (event: Event) => {
    const input = event.target as HTMLInputElement
    const file = input.files?.[0] ?? null
    emit("select", file)
    if (fileInput.value) {
        fileInput.value.value = ""
    }
}

const handleClear = () => {
    if (props.disabled) return
    emit("clear")
    if (fileInput.value) {
        fileInput.value.value = ""
    }
}

watch(
    () => props.fileName,
    (value) => {
        if (!value && fileInput.value) {
            fileInput.value.value = ""
        }
    }
)
</script>
