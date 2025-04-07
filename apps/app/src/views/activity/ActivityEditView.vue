<template>
    <div class="container mx-auto py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">
                {{ isNewActivity ? "Nouvelle activité" : "Modifier activité" }}
            </h1>
        </div>

        <div class="bg-white shadow-md rounded-lg p-6">
            <form @submit.prevent="saveActivity">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Code -->
                    <div>
                        <label for="code" class="block text-sm font-medium text-gray-700 mb-1"
                            >Code</label
                        >
                        <input
                            type="text"
                            id="code"
                            v-model="activity.Code"
                            class="w-full p-2 border border-gray-300 rounded-md"
                            maxlength="2"
                        />
                    </div>

                    <!-- Nom de l'activité -->
                    <div class="md:col-span-2">
                        <label for="activity" class="block text-sm font-medium text-gray-700 mb-1"
                            >Activité</label
                        >
                        <input
                            type="text"
                            id="activity"
                            v-model="activity.Activité"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3">
                    <Button variant="secondary" type="button" :to="{ name: 'activity-list' }">
                        Annuler
                    </Button>
                    <Button variant="primary" type="submit"> Enregistrer </Button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"

interface Activity {
    IDAGCactivité: number
    Code: string
    Activité: string
}

const route = useRoute()
const router = useRouter()
const activityId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewActivity = computed(() => !activityId.value)

// Dummy data for the form
const activity = ref<Activity>({
    IDAGCactivité: activityId.value || 0,
    Code: "",
    Activité: "",
})

// If editing, let's pretend we're loading data
if (activityId.value) {
    // Simulating data loading with dummy data
    const activityMap: Record<number, Activity> = {
        1: { IDAGCactivité: 1, Code: "CO", Activité: "Compilation, recherche de documentation" },
        2: { IDAGCactivité: 2, Code: "RA", Activité: "Rapport" },
        3: { IDAGCactivité: 3, Code: "CA", Activité: "Terrain, cartographie" },
        4: { IDAGCactivité: 4, Code: "TT", Activité: "Traitement de données" },
        5: { IDAGCactivité: 5, Code: "AS", Activité: "Administration, secrétariat" },
        6: { IDAGCactivité: 6, Code: "RS", Activité: "Réunion, séance" },
        7: { IDAGCactivité: 7, Code: "LO", Activité: "Laboratoire, ordinateur" },
        8: { IDAGCactivité: 8, Code: "TH", Activité: "Tournées hydrogéologiques" },
        9: { IDAGCactivité: 9, Code: "CP", Activité: "Bibliothèque" },
        10: { IDAGCactivité: 10, Code: "AU", Activité: "Autres" },
    }

    if (activityId.value in activityMap) {
        activity.value = { ...activityMap[activityId.value] }
    }
}

const saveActivity = () => {
    // This is just a dummy function that would save the activity
    console.log("Saving activity:", activity.value)

    // Redirect to the list page
    router.push({ name: "activity-list" })
}
</script>
