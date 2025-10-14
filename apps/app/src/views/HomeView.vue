<template>
    <div class="max-w-3xl mx-auto py-12 space-y-8">
        <div class="text-center space-y-2">
            <h1 class="text-3xl font-bold text-gray-900">
                {{ $t("home.title") }}
            </h1>
            <p class="text-gray-600">
                {{ $t("home.subtitle") }}
            </p>
        </div>

        <div class="bg-white border border-gray-200 shadow-sm rounded-lg p-6">
            <form @submit.prevent>
                <div class="space-y-2">
                    <label
                        class="block text-sm font-medium text-gray-700"
                        for="home-project-search"
                    >
                        {{ $t("home.searchLabel") }}
                    </label>
                    <ProjectSelect
                        id="home-project-search"
                        v-model="selectedProjectId"
                        class-name="w-full"
                        :placeholder="$t('home.searchPlaceholder')"
                        :include-archived="true"
                        :include-ended="true"
                        @update:model-value="handleProjectSelect"
                    />
                    <p class="text-sm text-gray-500">
                        {{ $t("home.searchHint") }}
                    </p>
                </div>
            </form>
        </div>
        <div>
            <TimeEntriesManager
                :show-project-filter="false"
                :initial-filter="{ includeBilled: false, includeUnbilled: true }"
                initial-date-preset="today"
                empty-message="Aucune entrée d'heure trouvée"
            />
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue"
import { useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import ProjectSelect from "@/components/organisms/project/ProjectSelect.vue"
import TimeEntriesManager from "@/components/organisms/time/TimeEntriesManager.vue"

const router = useRouter()
const { t } = useI18n()
const selectedProjectId = ref<number | undefined>(undefined)

onMounted(() => {
    document.title = t("home.documentTitle")
})

const handleProjectSelect = async (projectId?: number) => {
    if (!projectId) {
        selectedProjectId.value = undefined
        return
    }

    try {
        await router.push({ name: "project-view", params: { id: projectId } })
    } catch (_error) {
        // Ignore navigation duplication or aborted navigations
    } finally {
        selectedProjectId.value = undefined
    }
}
</script>
