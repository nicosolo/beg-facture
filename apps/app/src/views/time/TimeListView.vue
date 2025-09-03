<template>
    <div>
        <h1 class="text-2xl font-bold mb-6">{{ $t("time.title") }}</h1>
        <TimeEntriesManager
            :project-id="projectId"
            :show-project-filter="showProjectFilter"
            :initial-filter="initialFilter"
            empty-message="Aucune entrée d'heure trouvée"
        />
    </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue"
import { useRoute } from "vue-router"
import TimeEntriesManager from "@/components/organisms/time/TimeEntriesManager.vue"

const route = useRoute()

// Get projectId from query params if present
const projectId = computed(() => {
    const id = route.query.projectId as unknown as number
    return id || undefined
})

// Show project filter only if no projectId is provided
const showProjectFilter = computed(() => !projectId.value)

// Initial filter configuration
const initialFilter = computed(() => ({
    projectId: projectId.value,
}))

onMounted(() => {
    document.title = 'BEG - Saisie des heures'
})
</script>
