<template>
    <div class="bg-white rounded-md shadow overflow-hidden">
        <div v-if="projects.length === 0" class="p-8 text-center">
            <p class="text-gray-500">{{ $t("projects.noProjectsFound") }}</p>
        </div>

        <table v-else class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        {{ $t("projects.name") }}
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        {{ $t("projects.description") }}
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        {{ $t("projects.unBilledDuration") }}
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        {{ $t("projects.totalDuration") }}
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        {{ $t("projects.firstActivity") }}
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        {{ $t("projects.lastActivity") }}
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        {{ $t("projects.statusLabel") }}
                    </th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="project in projects" :key="project.id" class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="font-medium text-gray-900">{{ project.name }}</div>
                    </td>
                    <td class="px-6 py-4">
                        <div class="text-sm text-gray-500">{{ project.shortDescription }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900">
                            {{ formatDuration(project.unBilledDuration) }}
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900">
                            {{ formatDuration(project.totalDuration) }}
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900">
                            {{ formatDate(project.firstActivityDate) }}
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900">
                            {{ formatDate(project.lastActivityDate) }}
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <Badge v-if="project.archived" variant="error">{{
                            $t("projects.status.archived")
                        }}</Badge>
                        <Badge v-else variant="success">{{ $t("projects.status.active") }}</Badge>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script setup lang="ts">
import type { Project } from "@beg/types"
import Badge from "@/components/atoms/Badge.vue"
import { useI18n } from "vue-i18n"

interface Props {
    projects: Project[]
}

// Initialize i18n
const { t } = useI18n()

// Define component props
const { projects } = defineProps<Props>()

// Formatting helpers
const formatDate = (date: Date | null | undefined) => {
    if (!date) return t("common.notAvailable")
    return new Date(date).toLocaleDateString()
}

const formatDuration = (duration: number | null | undefined) => {
    if (duration === undefined || duration === null) return t("common.notAvailable")

    // Format duration in hours
    const hours = Math.floor(duration / 60)
    const minutes = duration % 60

    if (hours === 0) {
        return `${minutes}m`
    }

    return minutes === 0 ? `${hours}h` : `${hours}h ${minutes}m`
}
</script>
