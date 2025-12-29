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
defineOptions({ name: "TimeListView" })

import { computed, onActivated } from "vue"
import { useRoute } from "vue-router"
import TimeEntriesManager from "@/components/organisms/time/TimeEntriesManager.vue"
import { useAuthStore } from "@/stores/auth"
import { getTodayRange } from "@/composables/utils/useDateRangePresets"
const { from: initialFromDate, to: initialToDate } = getTodayRange()
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
    fromDate: initialFromDate,
    toDate: initialToDate,
}))

onActivated(() => {
    document.title = "BEG - Saisie des heures"
})
</script>
