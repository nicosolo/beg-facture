<template>
    <div
        ref="containerRef"
        class="transition-colors"
        :class="isOver ? highlightClass : normalClass"
        @dragenter.prevent="handleDragEnter"
        @dragover.prevent="handleDragOver"
        @dragleave.prevent="handleDragLeave"
        @drop.prevent="handleDrop"
    >
        <slot></slot>
    </div>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from "vue"
import { useTauri } from "@/composables/useTauri"
import { resolveFilePath, type ResolvedFile } from "@/composables/useFileResolver"

const props = withDefaults(
    defineProps<{
        multiple?: boolean
        highlightClass?: string
        normalClass?: string
    }>(),
    {
        multiple: true,
        highlightClass: "border-blue-500 border-2 bg-blue-50",
        normalClass: "",
    }
)

const emit = defineEmits<{
    (e: "drop", files: ResolvedFile[]): void
}>()

const { isTauri, dragPosition, pendingDrop, ensureDragDropListener, consumePendingDrop } =
    useTauri()

const containerRef = ref<HTMLElement | null>(null)
const isOver = ref(false)
let dragCounter = 0

const isPositionInContainer = (pos: { x: number; y: number }): boolean => {
    if (!containerRef.value) return false
    const rect = containerRef.value.getBoundingClientRect()
    return pos.x >= rect.left && pos.x <= rect.right && pos.y >= rect.top && pos.y <= rect.bottom
}

// Tauri: watch drag position for visual highlight
watch(dragPosition, (pos) => {
    if (!isTauri.value) return
    if (!pos) {
        isOver.value = false
        return
    }
    isOver.value = isPositionInContainer(pos)
})

// Tauri: watch for pending drop
watch(pendingDrop, async (drop) => {
    if (!drop || !isTauri.value) return
    if (!isPositionInContainer(drop.position)) return

    const paths = consumePendingDrop()
    if (!paths || paths.length === 0) return

    isOver.value = false

    const filesToProcess = props.multiple ? paths : [paths[0]]
    const results: ResolvedFile[] = []

    for (const filePath of filesToProcess) {
        try {
            results.push(await resolveFilePath(filePath))
        } catch (error) {
            console.error("Failed to resolve dropped file:", filePath, error)
        }
    }

    if (results.length > 0) {
        emit("drop", results)
    }
})

// Browser DnD handlers
const handleDragEnter = (e: DragEvent) => {
    if (isTauri.value) return
    dragCounter++
    if (e.dataTransfer?.types.includes("Files")) {
        isOver.value = true
    }
}

const handleDragOver = (e: DragEvent) => {
    if (isTauri.value) return
    if (e.dataTransfer?.types.includes("Files")) {
        isOver.value = true
    }
}

const handleDragLeave = () => {
    if (isTauri.value) return
    dragCounter--
    if (dragCounter <= 0) {
        isOver.value = false
        dragCounter = 0
    }
}

const handleDrop = (e: DragEvent) => {
    if (isTauri.value) return

    isOver.value = false
    dragCounter = 0

    const files = e.dataTransfer?.files
    if (!files || files.length === 0) return

    const fileArray = props.multiple ? Array.from(files) : [files[0]]
    const results: ResolvedFile[] = fileArray.map((file) => ({
        relativePath: file.name,
        file,
    }))

    emit("drop", results)
}

onMounted(() => {
    ensureDragDropListener()
})
</script>
