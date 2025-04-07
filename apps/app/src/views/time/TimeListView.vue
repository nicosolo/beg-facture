<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des heures</h1>
            <Button variant="primary" :to="{ name: 'time-new' }"> Nouvelle entrée </Button>
        </div>

        <!-- Filter Panel -->
        <div class="bg-white p-4 border border-gray-200 rounded-lg mb-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <!-- Collaborateur Filter -->
                <div class="form-group">
                    <Label>Collaborateur</Label>
                    <Select
                        v-model="filterCollaborateur"
                        :options="[
                            { label: 'Tous les collaborateurs', value: '' },
                            { label: 'Michael Digout', value: '9' },
                            { label: 'Jérémie Pralong', value: '22' },
                            { label: 'Jacques Bechet', value: '25' },
                        ]"
                    ></Select>
                </div>

                <!-- Project Filter -->
                <div class="form-group">
                    <Label>Projet</Label>
                    <Select
                        v-model="filterProject"
                        :options="[
                            { label: 'Tous les projets', value: '' },
                            { label: 'Projet BEG', value: '1502' },
                            { label: 'Jaugeage fluo', value: '3485' },
                            { label: 'Carte intensité', value: '3701' },
                            { label: 'Carte phénomènes', value: '3875' },
                            { label: 'Trajectographie', value: '4205' },
                        ]"
                    ></Select>
                </div>

                <!-- Activity Filter -->
                <div class="form-group">
                    <Label>Activité</Label>
                    <Select
                        v-model="filterActivity"
                        :options="[
                            { label: 'Toutes les activités', value: '' },
                            { label: 'Rapport', value: '2' },
                            { label: 'Traitement de données', value: '4' },
                            { label: 'Réunion, séance', value: '6' },
                            { label: 'Autre activité', value: '12' },
                        ]"
                    ></Select>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
                <!-- Date From -->
                <DateField label="Date de début" v-model="filterDateFrom" />

                <!-- Date To -->
                <DateField label="Date de fin" v-model="filterDateTo" />

                <!-- Invoice Status -->
                <div class="form-group">
                    <Label>Statut de facturation</Label>
                    <Select
                        v-model="filterStatus"
                        :options="[
                            { label: 'Tous', value: '' },
                            { label: 'Facturé', value: '1' },
                            { label: 'Non facturé', value: '0' },
                        ]"
                    ></Select>
                </div>
            </div>

            <div class="flex mt-4">
                <Button @click="resetFilters" variant="secondary">
                    Réinitialiser les filtres
                </Button>
            </div>
        </div>

        <DataTable
            showFooter
            :items="timeEntries"
            :columns="columns"
            item-key="IDHeure"
            empty-message="Aucune entrée d'heure trouvée"
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
                    <Button
                        variant="ghost"
                        size="sm"
                        :to="{ name: 'time-edit', params: { id: item.IDHeure } }"
                        className="text-indigo-600 hover:text-indigo-900"
                    >
                        Modifier
                    </Button>
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
import { ref, computed } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import Badge from "../../components/atoms/Badge.vue"
import Label from "../../components/atoms/Label.vue"
import Select from "../../components/atoms/Select.vue"
import DateField from "../../components/molecules/DateField.vue"
import { useFormat } from "@/composables/utils/useFormat"
const { formatDuration } = useFormat()
interface TimeEntry {
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

const columns = [
    { key: "IDHeure", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "collaborator", label: "Collaborateur" },
    { key: "Date", label: "Date" },
    { key: "Heures", label: "Heures" },
    { key: "activity", label: "Activité" },
    { key: "Remarque", label: "Remarque" },
    { key: "invoiced", label: "Statut" },
    { key: "actions", label: "Actions" },
]

// Sample data for time entries
const timeEntries = ref<TimeEntry[]>([
    {
        IDHeure: 1,
        IDcollaborateur: 22,
        Date: "08/07/12 00:00:00",
        Heures: 0.5,
        Km: 0,
        Frais: 0,
        IDmandat: 1502,
        IDactivité: 4,
        Remarque: "divers beg",
        Facturé: 0,
        Débours: 1,
    },
    {
        IDHeure: 2,
        IDcollaborateur: 25,
        Date: "02/23/12 00:00:00",
        Heures: 7.5,
        Km: 0,
        Frais: 0,
        IDmandat: 3875,
        IDactivité: 2,
        Remarque: "carte phénomènes",
        Facturé: 1,
        Débours: 1,
    },
    {
        IDHeure: 3,
        IDcollaborateur: 25,
        Date: "02/23/12 00:00:00",
        Heures: 1,
        Km: 0,
        Frais: 0,
        IDmandat: 3701,
        IDactivité: 2,
        Remarque: "carte intensioté LTO",
        Facturé: 1,
        Débours: 1,
    },
    {
        IDHeure: 4,
        IDcollaborateur: 25,
        Date: "02/24/12 00:00:00",
        Heures: 11,
        Km: 70,
        Frais: 0,
        IDmandat: 3485,
        IDactivité: 6,
        Remarque: "jaugeage fluo",
        Facturé: 1,
        Débours: 1,
    },
    {
        IDHeure: 5,
        IDcollaborateur: 25,
        Date: "02/27/12 00:00:00",
        Heures: 9,
        Km: 0,
        Frais: 0,
        IDmandat: 3875,
        IDactivité: 12,
        Remarque: "carte phénomène et périmètres d'études",
        Facturé: 1,
        Débours: 1,
    },
    {
        IDHeure: 6,
        IDcollaborateur: 25,
        Date: "02/28/12 00:00:00",
        Heures: 8.5,
        Km: 0,
        Frais: 0,
        IDmandat: 3875,
        IDactivité: 2,
        Remarque: "carte phénomène tassement",
        Facturé: 1,
        Débours: 1,
    },
    {
        IDHeure: 7,
        IDcollaborateur: 9,
        Date: "08/06/12 00:00:00",
        Heures: 0.5,
        Km: 0,
        Frais: 0,
        IDmandat: 4205,
        IDactivité: 12,
        Remarque: "trajectographie",
        Facturé: 1,
        Débours: 1,
    },
])

// Mock data for collaborators and activities for display purposes
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

// Simple filter state refs without complex filtering logic
const filterCollaborateur = ref("")
const filterDateFrom = ref<Date | undefined>(undefined)
const filterDateTo = ref<Date | undefined>(undefined)
const filterStatus = ref("")
const filterProject = ref("")
const filterActivity = ref("")

// Simple reset function
const resetFilters = () => {
    filterCollaborateur.value = ""
    filterDateFrom.value = undefined
    filterDateTo.value = undefined
    filterStatus.value = ""
    filterProject.value = ""
    filterActivity.value = ""
}

// Calculate total hours based on filtered entries
const calculateTotalHeures = () => {
    return timeEntries.value.reduce((total, entry) => total + entry.Heures, 0)
}
</script>
