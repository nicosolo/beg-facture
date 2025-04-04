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

        <template #cell:status="{ item }">
            <Badge v-if="item.archived" variant="error">{{ $t("projects.status.archived") }}</Badge>
            <Badge v-else variant="success">{{ $t("projects.status.active") }}</Badge>
        </template>
    </DataTable>
</template>

<script setup lang="ts">
import type { Project } from "@beg/types"
import Badge from "@/components/atoms/Badge.vue"
import DataTable from "@/components/molecules/DataTable.vue"
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
        nowrap: true,
        width: "w-1/3",
    },
    {
        key: "shortDescription",
        label: t("projects.description"),
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
        nowrap: true,
    },
    {
        key: "status",
        label: t("projects.statusLabel"),
        nowrap: true,
    },
])

// Formatting helpers
const formatDate = (date: Date | null | undefined) => {
    if (!date) return t("common.notAvailable")
    return new Date(date).toLocaleDateString()
}

const { formatDuration } = useFormat()
</script>
