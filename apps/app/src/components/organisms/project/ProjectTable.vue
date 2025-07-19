<template>
    <DataTable
        :items="projects"
        :columns="columns"
        itemKey="id"
        :sort="sort"
        @sort-change="handleSortChange"
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
import DataTable from "@/components/molecules/DataTable.vue"
import Button from "@/components/atoms/Button.vue"
import { useI18n } from "vue-i18n"
import { useFormat } from "@/composables/utils/useFormat"
import { ref, type Ref } from "vue"
import type { ProjectFilter, ProjectResponse } from "@beg/validations"

interface Props {
    projects: ProjectResponse[]
    sort: { key: ProjectFilter["sortBy"]; direction: ProjectFilter["sortOrder"] }
}

const emit = defineEmits<{
    (e: "sort-change", sort: { key: string; direction: "asc" | "desc" }): void
}>()

const handleSortChange = (sort: { key: string; direction: "asc" | "desc" }) => {
    console.log("handleSortChange", sort)
    emit("sort-change", sort)
}

const { t } = useI18n()

const { projects, sort } = defineProps<Props>()

const columns = ref([
    {
        key: "name",
        label: t("projects.name"),
        width: "w-1/3" as const,
        sortable: true,
    },

    {
        key: "unBilledDuration",
        label: t("projects.unBilledDuration"),
        nowrap: true,
        sortable: true,
    },
    {
        key: "totalDuration",
        label: t("projects.totalDuration"),
        nowrap: true,
        sortKey: "totalDuration",
    },
    {
        key: "firstActivityDate",
        label: t("projects.firstActivity"),
        nowrap: true,
        sortKey: "firstActivityDate",
    },
    {
        key: "lastActivityDate",
        label: t("projects.lastActivity"),
        sortKey: "lastActivityDate",
    },

    {
        key: "actions",
        label: t("projects.actions"),
        nowrap: false,
        actions: true,
        width: "w-1/3" as const,
    },
])

const { formatDuration, formatDate } = useFormat()
</script>
