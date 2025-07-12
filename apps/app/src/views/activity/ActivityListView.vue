<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des activités</h1>
            <Button variant="primary" :to="{ name: 'activity-new' }"> Nouvelle activité </Button>
        </div>

        <DataTable
            :items="activities"
            :columns="columns"
            item-key="IDAGCactivité"
            empty-message="Aucune activité trouvée"
        >
            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <Button
                        variant="ghost"
                        size="sm"
                        :to="{ name: 'activity-edit', params: { id: item.IDAGCactivité } }"
                        className="text-indigo-600 hover:text-indigo-900"
                    >
                        Modifier
                    </Button>
                </div>
            </template>
        </DataTable>
        </div>
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
// TODO: Import and use when activity types endpoint is available
// import { useFetchActivityTypes } from "@/composables/api/useFetchActivityTypes"

interface Activity {
    IDAGCactivité: number
    Code: string
    Activité: string
    billable?: boolean
}

// TODO: Use API when endpoint is available
// const { get: fetchActivityTypes, loading, data } = useFetchActivityTypes()
const loading = ref(false)

const columns = [
    { key: "IDAGCactivité", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "Code", label: "Code" },
    { key: "Activité", label: "Activité" },
    { key: "actions", label: "Actions" },
]

// TODO: Replace with API data when endpoint is available
// Currently using static data that matches the legacy system
const activities = ref<Activity[]>([
    {
        IDAGCactivité: 1,
        Code: "CO",
        Activité: "Compilation, recherche de documentation",
    },
    {
        IDAGCactivité: 2,
        Code: "RA",
        Activité: "Rapport",
    },
    {
        IDAGCactivité: 3,
        Code: "CA",
        Activité: "Terrain, cartographie",
    },
    {
        IDAGCactivité: 4,
        Code: "TT",
        Activité: "Traitement de données",
    },
    {
        IDAGCactivité: 5,
        Code: "AS",
        Activité: "Administration, secrétariat",
    },
    {
        IDAGCactivité: 6,
        Code: "RS",
        Activité: "Réunion, séance",
    },
    {
        IDAGCactivité: 7,
        Code: "LO",
        Activité: "Laboratoire, ordinateur",
    },
    {
        IDAGCactivité: 8,
        Code: "TH",
        Activité: "Tournées hydrogéologiques",
    },
    {
        IDAGCactivité: 9,
        Code: "CP",
        Activité: "Bibliothèque",
    },
    {
        IDAGCactivité: 10,
        Code: "AU",
        Activité: "Autres",
    },
])

// TODO: Load activity types when API endpoint is available
// onMounted(async () => {
//     await fetchActivityTypes({})
// })

// Watch for API data changes
// watch(data, (newData) => {
//     if (newData) {
//         activities.value = newData.map(item => ({
//             IDAGCactivité: item.id,
//             Code: item.code,
//             Activité: item.name,
//             billable: item.billable
//         }))
//     }
// })
</script>
