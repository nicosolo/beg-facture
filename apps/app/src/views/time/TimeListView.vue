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
import { useAuthStore } from "@/stores/auth"
const route = useRoute()
const authStore = useAuthStore()
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
    userId: authStore.user?.id,
}))

onMounted(() => {
    document.title = "BEG - Saisie des heures"
})
</script>
