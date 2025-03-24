<template>
    <div class="bg-white rounded-md shadow overflow-hidden">
        <div v-if="loading" class="p-4 text-center">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900 mx-auto"></div>
            <p class="mt-2">Loading projects...</p>
        </div>

        <div v-else-if="projects.length === 0" class="p-8 text-center">
            <p class="text-gray-500">No projects found matching your criteria.</p>
        </div>

        <table v-else class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        Name
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        Description
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        Total Duration
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        First Activity
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        Last Activity
                    </th>
                    <th
                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                        Status
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
                        <Badge v-if="project.archived" variant="error">Archived</Badge>
                        <Badge v-else variant="success">Active</Badge>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script setup lang="ts">
import type { Project } from "@beg/types"
import Badge from "../atoms/Badge.vue"

// Define component props
const props = defineProps<{
    projects: Project[]
    loading: boolean
}>()

// Formatting helpers
const formatDate = (date: Date | null | undefined) => {
    if (!date) return "N/A"
    return new Date(date).toLocaleDateString()
}

const formatDuration = (duration: number | null | undefined) => {
    if (duration === undefined || duration === null) return "N/A"

    // Format duration in hours
    const hours = Math.floor(duration / 60)
    const minutes = duration % 60

    if (hours === 0) {
        return `${minutes}m`
    }

    return minutes === 0 ? `${hours}h` : `${hours}h ${minutes}m`
}
</script>
