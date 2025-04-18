<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des heures</h1>
            <Button variant="primary" :to="{ name: 'time-new' }"> Nouvelle entrée </Button>
        </div>

        <!-- Filter Panel -->
        <TimeFilterPanel v-model="filters" @reset="onFilterReset" />

        <!-- Time Entries List -->
        <TimeEntriesList
            :timeEntries="timeEntries"
            empty-message="Aucune entrée d'heure trouvée"
            editRoute="time-edit"
        />
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import Button from "../../components/atoms/Button.vue"
import TimeEntriesList from "../../components/organisms/TimeEntriesList.vue"
import TimeFilterPanel from "../../components/organisms/TimeFilterPanel.vue"
import type { TimeEntry } from "../../components/organisms/TimeEntriesList.vue"
import type { TimeFilters } from "../../components/organisms/TimeFilterPanel.vue"

// Initialize filters
const filters = ref<TimeFilters>({
    collaborateur: "",
    project: "",
    activity: "",
    dateFrom: undefined,
    dateTo: undefined,
    status: "",
})

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

// Handle filter reset
const onFilterReset = () => {
    // Additional logic if needed when filters are reset
    // For now, it's handled by the TimeFilterPanel component
}
</script>
