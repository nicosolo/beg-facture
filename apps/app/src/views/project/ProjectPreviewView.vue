<template>
    <div class="mb-6">
        <h1 class="text-2xl font-bold">{{ $t("projects.preview") }}</h1>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Project Details -->
        <div class="lg:col-span-1">
            <div class="bg-white rounded-lg p-6 border border-gray-200">
                <h2 class="text-lg font-semibold mb-4">{{ $t("projects.details") }}</h2>

                <div class="space-y-4">
                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.mandat") }}</p>
                        <p class="font-medium">{{ project.Mandat }}</p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.designation") }}</p>
                        <p class="font-medium">{{ project.Désignation }}</p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.date") }}</p>
                        <p class="font-medium">{{ formatDate(project.Début) }}</p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.client") }}</p>
                        <p class="font-medium">{{ getClientName(project.IDmandant) }}</p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.responsible") }}</p>
                        <p class="font-medium">{{ project.Responsable }}</p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.enterprise") }}</p>
                        <p class="font-medium">{{ getCompanyName(project.IDentreprise) }}</p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.type") }}</p>
                        <p class="font-medium">{{ getTypeName(project.IDtype) }}</p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">{{ $t("projects.invoice") }}</p>
                        <p class="font-medium whitespace-pre-line">{{ project.Facture }}</p>
                    </div>

                    <div v-if="project.Remarque">
                        <p class="text-sm text-gray-500">{{ $t("projects.remark") }}</p>
                        <p class="font-medium whitespace-pre-line">{{ project.Remarque }}</p>
                    </div>
                </div>

                <div class="mt-6">
                    <Button
                        variant="primary"
                        :to="{ name: 'project-edit', params: { id: project.IDmandat } }"
                    >
                        {{ $t("common.edit") }}
                    </Button>
                </div>
            </div>
        </div>

        <!-- Time Entries -->
        <div class="lg:col-span-2">
            <div class="bg-white rounded-lg p-6 border border-gray-200">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-lg font-semibold">{{ $t("timeEntries.title") }}</h2>
                    <Button
                        variant="primary"
                        size="sm"
                        :to="{ name: 'time-new', query: { projectId: project.IDmandat } }"
                    >
                        Ajouter des heures
                    </Button>
                </div>
                <TimeFilterPanel />
                <TimeEntriesList
                    :timeEntries="timeEntries"
                    :emptyMessage="$t('timeEntries.empty')"
                    editRoute="time-new"
                    :hideColumns="['IDHeure']"
                />
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import { useRoute } from "vue-router"
import { useI18n } from "vue-i18n"
import Button from "@/components/atoms/Button.vue"
import TimeEntriesList from "@/components/organisms/TimeEntriesList.vue"
import { useFormat } from "@/composables/utils/useFormat"
import type { TimeEntry } from "@/components/organisms/TimeEntriesList.vue"
import TimeFilterPanel from "@/components/organisms/TimeFilterPanel.vue"

const { t } = useI18n()
const route = useRoute()
const { formatDuration } = useFormat()

// Format date function
const formatDate = (dateString: string): string => {
    if (!dateString) return "-"
    try {
        // Convert from MM/DD/YY format to DD.MM.YYYY
        const parts = dateString.split(" ")[0].split("/")
        if (parts.length !== 3) return dateString
        const month = parts[0].padStart(2, "0")
        const day = parts[1].padStart(2, "0")
        const year = `20${parts[2]}`
        return `${day}.${month}.${year}`
    } catch (e) {
        return dateString
    }
}

// Project data (dummy data based on ProjectEditView.vue)
const project = ref({
    IDmandat: 101,
    Mandat: 9591,
    Début: "03/10/25 00:00:00",
    Désignation: "Falaise Pont de la Sionne, Sion",
    IDlocalité: 195,
    IDmandant: 163,
    Facture:
        "Commune de Sion, Travaux publics et Environnement, Rue de Lausanne 23, \nCase postale 2272, 1950 Sion 2",
    IDingénieur: 217,
    IDentreprise: 1,
    IDtype: 43,
    Responsable: "md",
    Remarque: "Surveillance de la falaise instable au-dessus du pont de la Sionne",
    Imprimer: 0,
    Etat: "-",
})

// Helper functions for mapped values
const getClientName = (id: number): string => {
    const clients: Record<number, string> = {
        163: "Commune de Sion",
    }
    return clients[id] || `Client #${id}`
}

const getCompanyName = (id: number): string => {
    const companies: Record<number, string> = {
        1: "Bureau d'Etudes Géologiques SA",
    }
    return companies[id] || `Entreprise #${id}`
}

const getTypeName = (id: number): string => {
    const types: Record<number, string> = {
        43: "Expertise géologique",
    }
    return types[id] || `Type #${id}`
}

// Sample time entries data
const timeEntries = ref<TimeEntry[]>([
    {
        IDHeure: 1001,
        IDcollaborateur: 9,
        Date: "2025-03-15",
        Heures: 4.5,
        Km: 35,
        Frais: 0,
        IDmandat: 101,
        IDactivité: 6,
        Remarque: "Réunion initiale avec le client",
        Facturé: 1,
        Débours: 0,
    },
    {
        IDHeure: 1002,
        IDcollaborateur: 22,
        Date: "2025-03-16",
        Heures: 6,
        Km: 0,
        Frais: 0,
        IDmandat: 101,
        IDactivité: 4,
        Remarque: "Analyse des données existantes",
        Facturé: 1,
        Débours: 0,
    },
    {
        IDHeure: 1003,
        IDcollaborateur: 25,
        Date: "2025-03-18",
        Heures: 2.5,
        Km: 35,
        Frais: 25,
        IDmandat: 101,
        IDactivité: 12,
        Remarque: "Inspection du site",
        Facturé: 0,
        Débours: 0,
    },
    {
        IDHeure: 1004,
        IDcollaborateur: 9,
        Date: "2025-03-20",
        Heures: 3,
        Km: 0,
        Frais: 0,
        IDmandat: 101,
        IDactivité: 2,
        Remarque: "Rédaction du rapport préliminaire",
        Facturé: 0,
        Débours: 0,
    },
])
</script>
