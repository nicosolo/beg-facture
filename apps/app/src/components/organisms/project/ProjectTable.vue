<template>
    <DataTable
        :items="projects"
        :columns="columns"
        itemKey="id"
        :emptyMessage="$t('projects.noProjectsFound')"
    >
        <template #cell:unBilledDuration="{ item }">
            <div class="text-sm text-gray-900">
                {{ formatDuration(item.unBilledDuration) }}
            </div>
        </template>

        <template #cell:totalDuration="{ item }">
            <div class="text-sm text-gray-900">
                {{ formatDuration(item.totalDuration) }}
            </div>
        </template>

        <template #cell:firstActivityDate="{ item }">
            <div class="text-sm text-gray-900">
                {{ formatDate(item.firstActivityDate) }}
            </div>
        </template>

        <template #cell:lastActivityDate="{ item }">
            <div class="text-sm text-gray-900">
                {{ formatDate(item.lastActivityDate) }}
            </div>
        </template>

        <template #cell:actions="{ item }">
            <div class="flex flex-row sm:flex-col md:flex-row gap-2">
                <Button
                    :to="{ name: 'time-new', query: { projectId: item.name } }"
                    variant="secondary"
                    class="whitespace-nowrap inline-block w-fit"
                >
                    Ajouter des heures
                </Button>

                <Button
                    :to="{ name: 'time-list', query: { projectId: item.name } }"
                    variant="ghost"
                    class="whitespace-nowrap inline-block w-fit"
                >
                    Heures
                </Button>

                <Button
                    :to="{ name: 'project-view', params: { id: item.id } }"
                    variant="primary"
                    class="whitespace-nowrap inline-block w-fit"
                >
                    Voir
                </Button>
            </div>
        </template>
    </DataTable>
</template>

<script setup lang="ts">
import type { Project } from "@beg/types"
import Badge from "@/components/atoms/Badge.vue"
import DataTable from "@/components/molecules/DataTable.vue"
import Button from "@/components/atoms/Button.vue"
import { useI18n } from "vue-i18n"
import { useFormat } from "@/composables/utils/useFormat"
import { ref } from "vue"

interface Props {
    projects: Project[]
}

const { t } = useI18n()

const { projects } = defineProps<Props>()

const columns = ref([
    {
        key: "name",
        label: t("projects.name"),
        width: "w-1/3",
    },

    {
        key: "unBilledDuration",
        label: t("projects.unBilledDuration"),
        nowrap: true,
    },
    {
        key: "totalDuration",
        label: t("projects.totalDuration"),
        nowrap: true,
    },
    {
        key: "firstActivityDate",
        label: t("projects.firstActivity"),
        nowrap: true,
    },
    {
        key: "lastActivityDate",
        label: t("projects.lastActivity"),
    },

    {
        key: "actions",
        label: t("projects.actions"),
        nowrap: false,
        width: "w-1/3" as "w-1/3",
    },
])

// Formatting helpers
const formatDate = (date: Date | null | undefined) => {
    if (!date) return t("common.notAvailable")
    return new Date(date).toLocaleDateString()
}

const { formatDuration } = useFormat()
</script>
