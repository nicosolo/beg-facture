<template>
    <div class="mb-6">
        <h1 class="text-2xl font-bold">
            {{ isNewCollaborator ? "Nouveau collaborateur" : "Modifier collaborateur" }}
        </h1>
    </div>

    <div class="bg-white shadow-md rounded-lg p-6">
        <form @submit.prevent="saveCollaborator">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Prénom -->
                <div>
                    <label for="firstname" class="block text-sm font-medium text-gray-700 mb-1"
                        >Prénom</label
                    >
                    <input
                        type="text"
                        id="firstname"
                        v-model="collaborator.Prénom"
                        class="w-full p-2 border border-gray-300 rounded-md"
                    />
                </div>

                <!-- Nom -->
                <div>
                    <label for="lastname" class="block text-sm font-medium text-gray-700 mb-1"
                        >Nom</label
                    >
                    <input
                        type="text"
                        id="lastname"
                        v-model="collaborator.Nom"
                        class="w-full p-2 border border-gray-300 rounded-md"
                    />
                </div>

                <!-- Initiales -->
                <div>
                    <label for="initials" class="block text-sm font-medium text-gray-700 mb-1"
                        >Initiales</label
                    >
                    <input
                        type="text"
                        id="initials"
                        v-model="collaborator.Initiales"
                        class="w-full p-2 border border-gray-300 rounded-md"
                    />
                </div>

                <!-- Mot de passe -->
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1"
                        >Mot de passe</label
                    >
                    <input
                        type="password"
                        id="password"
                        v-model="collaborator['Mot de passe']"
                        class="w-full p-2 border border-gray-300 rounded-md"
                    />
                </div>
            </div>

            <!-- Activities Section -->
            <div class="mt-8">
                <h2 class="text-lg font-medium mb-4">Activités associées</h2>
                <div class="bg-gray-50 p-4 rounded-md">
                    <div v-if="activities.length === 0" class="text-gray-500">
                        Aucune activité disponible
                    </div>
                    <div v-else class="space-y-3">
                        <!-- Column Headers -->
                        <div class="flex items-center space-x-2 pb-2 mb-2 border-b border-gray-200">
                            <div class="w-6"></div>
                            <!-- Checkbox column -->
                            <div class="flex-grow font-medium text-gray-700">Activité</div>
                            <div class="w-24 text-center font-medium text-gray-700">Classe</div>
                        </div>

                        <!-- Activity Items -->
                        <div
                            v-for="activity in activities"
                            :key="activity.IDAGCactivité"
                            class="flex items-center space-x-2"
                        >
                            <input
                                type="checkbox"
                                :id="`activity-${activity.IDAGCactivité}`"
                                v-model="selectedActivities[activity.IDAGCactivité]"
                                class="h-4 w-4 text-indigo-600 border-gray-300 rounded"
                            />
                            <label :for="`activity-${activity.IDAGCactivité}`" class="flex-grow">
                                <span class="font-medium">{{ activity.Code }}</span> -
                                {{ activity.Activité }}
                            </label>
                            <select
                                v-if="selectedActivities[activity.IDAGCactivité]"
                                v-model="activityClasses[activity.IDAGCactivité]"
                                class="block w-24 pl-3 pr-10 py-1 text-base border-gray-300 sm:text-sm rounded-md"
                            >
                                <option value="B">B</option>
                                <option value="C">C</option>
                                <option value="D">D</option>
                                <option value="E">E</option>
                                <option value="F">F</option>
                                <option value="G">G</option>
                                <option value="R">R</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-8 flex justify-end space-x-3">
                <Button variant="secondary" type="button" :to="{ name: 'collaborator-list' }">
                    Annuler
                </Button>
                <Button variant="primary" type="submit"> Enregistrer </Button>
            </div>
        </form>
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"

interface Collaborator {
    IDcollaborateur: number
    Prénom: string
    Nom: string
    Initiales: string
    "Mot de passe": string
}

interface Activity {
    IDAGCactivité: number
    Code: string
    Activité: string
}

interface CollaboratorActivity {
    IDcollaborateur: number
    IDactivité: number
    Classe: string
}

const route = useRoute()
const router = useRouter()
const collaboratorId = computed(() =>
    route.params.id ? parseInt(route.params.id as string) : null
)
const isNewCollaborator = computed(() => !collaboratorId.value)

// Dummy data for the form
const collaborator = ref<Collaborator>({
    IDcollaborateur: collaboratorId.value || 0,
    Prénom: "",
    Nom: "",
    Initiales: "",
    "Mot de passe": "",
})

// Activities data
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

// Track selected activities and their classes
const selectedActivities = ref<Record<number, boolean>>({})
const activityClasses = ref<Record<number, string>>({})

// If editing, let's pretend we're loading data
if (collaboratorId.value) {
    // Simulating data loading with dummy data
    collaborator.value = {
        IDcollaborateur: collaboratorId.value,
        Prénom: "Jean",
        Nom: "Dupont",
        Initiales: "jd",
        "Mot de passe": "password123",
    }

    // Simulating loading activity associations
    const collaboratorActivities: CollaboratorActivity[] = [
        { IDcollaborateur: collaboratorId.value, IDactivité: 1, Classe: "C" },
        { IDcollaborateur: collaboratorId.value, IDactivité: 2, Classe: "D" },
        { IDcollaborateur: collaboratorId.value, IDactivité: 3, Classe: "C" },
        { IDcollaborateur: collaboratorId.value, IDactivité: 5, Classe: "C" },
        { IDcollaborateur: collaboratorId.value, IDactivité: 6, Classe: "D" },
    ]

    // Set up selected activities and their classes
    collaboratorActivities.forEach((link) => {
        selectedActivities.value[link.IDactivité] = true
        activityClasses.value[link.IDactivité] = link.Classe
    })
}

// Initialize default class for all activities
activities.value.forEach((activity) => {
    if (!activityClasses.value[activity.IDAGCactivité]) {
        activityClasses.value[activity.IDAGCactivité] = "C" // Default class
    }
})

const saveCollaborator = () => {
    // This is just a dummy function that would save the collaborator
    console.log("Saving collaborator:", collaborator.value)

    // Collect activity associations
    const activityAssociations = Object.keys(selectedActivities.value)
        .filter((key) => selectedActivities.value[Number(key)])
        .map((key) => ({
            IDcollaborateur: collaborator.value.IDcollaborateur,
            IDactivité: Number(key),
            Classe: activityClasses.value[Number(key)],
        }))

    console.log("Activity associations:", activityAssociations)

    // Redirect to the list page
    router.push({ name: "collaborator-list" })
}
</script>
