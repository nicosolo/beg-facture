<template>
    <div>
        <DataTable
            showFooter
            :items="timeEntries"
            :columns="columns"
            item-key="IDHeure"
            :empty-message="emptyMessage"
        >
            <template #cell:collaborator="{ item }">
                {{ getCollaboratorName(item.IDcollaborateur) }}
            </template>

            <template #cell:activity="{ item }">
                {{ getActivityName(item.IDactivité) }}
            </template>

            <template #cell:invoiced="{ item }">
                <Badge :variant="item.Facturé ? 'success' : 'warning'">
                    {{ item.Facturé ? "Facturé" : "Non facturé" }}
                </Badge>
            </template>

            <template #cell:Heures="{ item }">
                {{ formatDuration(item.Heures * 60) }}
            </template>

            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <slot name="actions" :item="item">
                        <Button
                            variant="ghost"
                            size="sm"
                            :to="{ name: 'time-edit', params: { id: item.IDHeure } }"
                            className="text-indigo-600 hover:text-indigo-900"
                        >
                            Modifier
                        </Button>
                    </slot>
                </div>
            </template>
            <!-- Total row customizations -->
            <template #total:Heures>
                {{ formatDuration(calculateTotalHeures() * 60) }}
            </template>
        </DataTable>
    </div>
</template>

<script setup lang="ts">
import { computed } from "vue"
import DataTable from "../molecules/DataTable.vue"
import Badge from "../atoms/Badge.vue"
import Button from "../atoms/Button.vue"
import { useFormat } from "@/composables/utils/useFormat"

const { formatDuration } = useFormat()

export interface TimeEntry {
    IDHeure: number
    IDcollaborateur: number
    Date: string
    Heures: number
    Km: number
    Frais: number
    IDmandat: number
    IDactivité: number
    Remarque: string
    Facturé: number
    Débours: number
}

interface Props {
    timeEntries: TimeEntry[]
    emptyMessage?: string
    editRoute?: string
    hideColumns?: string[]
}

const props = defineProps<Props>()

const defaultColumns = [
    { key: "IDHeure", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "collaborator", label: "Collaborateur" },
    { key: "Date", label: "Date" },
    { key: "Heures", label: "Heures" },
    { key: "activity", label: "Activité" },
    { key: "Remarque", label: "Remarque" },
    { key: "invoiced", label: "Statut" },
    { key: "actions", label: "Actions" },
]

const columns = computed(() => {
    if (!props.hideColumns || props.hideColumns.length === 0) {
        return defaultColumns
    }

    return defaultColumns.filter((col) => !props.hideColumns?.includes(col.key))
})

// Data for collaborators and activities for display purposes
const collaborators: Record<number, string> = {
    9: "Michael Digout",
    22: "Jérémie Pralong",
    25: "Jacques Bechet",
}

const activities: Record<number, string> = {
    2: "Rapport",
    4: "Traitement de données",
    6: "Réunion, séance",
    12: "Autre activité",
}

// Helper functions to get names from IDs
const getCollaboratorName = (id: number): string => {
    return collaborators[id] || `Collaborateur #${id}`
}

const getActivityName = (id: number): string => {
    return activities[id] || `Activité #${id}`
}

// Calculate total hours based on entries
const calculateTotalHeures = () => {
    return props.timeEntries.reduce((total, entry) => total + entry.Heures, 0)
}
</script>
