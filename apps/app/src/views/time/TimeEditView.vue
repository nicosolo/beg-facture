<template>
    <div class="container mx-auto py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">
                {{ isNewEntry ? "Nouvelle entrée d'heures" : "Modifier entrée d'heures" }}
            </h1>
        </div>

        <!-- Project and Date header section -->
        <div class="bg-white rounded-lg p-6 mb-4 border border-gray-200">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <div class="mb-4 md:mb-0 md:mr-6 flex-1">
                    <Label class="text-lg font-medium text-gray-700 mb-1">Mandat</Label>
                    <div class="w-full border-gray-300 rounded-md bg-gray-50">
                        {{ projectId }}
                    </div>
                </div>
                <div class="flex-1">
                    <Label class="text-lg font-medium text-gray-700 mb-1">Date</Label>
                    <input
                        type="date"
                        id="date"
                        v-model="formattedDate"
                        class="w-full p-2 border border-gray-300 rounded-md"
                    />
                </div>
                <!-- Collaborateur (disabled) -->
                <div class="flex-1">
                    <Label for="collaborator" class="block text-sm font-medium text-gray-700 mb-1">
                        Collaborateur
                    </Label>
                    <select
                        id="collaborator"
                        v-model="timeEntry.IDcollaborateur"
                        class="w-full p-2 border border-gray-300 rounded-md bg-gray-100"
                        disabled
                    >
                        <option v-for="(name, id) in collaborators" :key="id" :value="Number(id)">
                            {{ name }}
                        </option>
                    </select>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg p-6 border border-gray-200">
            <form @submit.prevent="saveTimeEntry">
                <!-- Hours, Km, Fees section -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
                    <div>
                        <label for="activity" class="block text-sm font-medium text-gray-700 mb-1">
                            Activité
                        </label>
                        <select
                            id="activity"
                            v-model="timeEntry.IDactivité"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        >
                            <option value="">Sélectionnez une activité</option>
                            <option v-for="(name, id) in activities" :key="id" :value="Number(id)">
                                {{ name }}
                            </option>
                        </select>
                    </div>
                    <div class="flex-1">
                        <label for="hours" class="block text-sm font-medium text-gray-700 mb-1">
                            Heures
                        </label>
                        <input
                            type="number"
                            id="hours"
                            v-model.number="timeEntry.Heures"
                            step="0.5"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>

                    <div>
                        <label for="km" class="block text-sm font-medium text-gray-700 mb-1">
                            Km
                        </label>
                        <input
                            type="number"
                            id="km"
                            v-model.number="timeEntry.Km"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>

                    <div>
                        <label for="expenses" class="block text-sm font-medium text-gray-700 mb-1">
                            Frais
                        </label>
                        <input
                            type="number"
                            id="expenses"
                            v-model.number="timeEntry.Frais"
                            step="0.01"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Activité -->

                    <!-- Facturé - only show if not a new entry -->
                    <div v-if="!isNewEntry" class="flex items-center mt-4">
                        <input
                            type="checkbox"
                            id="invoiced"
                            v-model="isInvoiced"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded"
                        />
                        <label for="invoiced" class="ml-2 block text-sm text-gray-700">
                            Facturé
                        </label>
                    </div>

                    <!-- Débours -->
                    <div class="flex items-center mt-4">
                        <input
                            type="checkbox"
                            id="disbursement"
                            v-model="isDisbursement"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded"
                        />
                        <label for="disbursement" class="ml-2 block text-sm text-gray-700">
                            Débours
                        </label>
                    </div>

                    <!-- Remarque -->
                    <div class="md:col-span-2">
                        <label for="comment" class="block text-sm font-medium text-gray-700 mb-1">
                            Remarque
                        </label>
                        <textarea
                            id="comment"
                            v-model="timeEntry.Remarque"
                            rows="3"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        ></textarea>
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3">
                    <Button variant="secondary" type="button" :to="{ name: 'time-list' }">
                        Annuler
                    </Button>
                    <Button variant="primary" type="submit"> Enregistrer </Button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"

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

const route = useRoute()
const router = useRouter()
const entryId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewEntry = computed(() => !entryId.value)
const projectId = computed(() => {
    return route.query.projectId
})

// Mock current user ID (assuming this would come from an auth store in real app)
const currentUserId = ref<number>(22) // This would be the logged in user's ID

// Dummy data for the form
const timeEntry = ref<TimeEntry>({
    IDHeure: entryId.value || 0,
    IDcollaborateur: currentUserId.value, // Set to current user
    Date: new Date().toISOString(),
    Heures: 0,
    Km: 0,
    Frais: 0,
    IDmandat: 0,
    IDactivité: 0,
    Remarque: "",
    Facturé: 0,
    Débours: 0,
})

// Set project ID from query param for new entries
if (isNewEntry.value) {
    timeEntry.value.IDmandat = Number(projectId.value)
}

// Mock data for collaborators and activities for display purposes
const collaborators: Record<number, string> = {
    9: "Michael Digout",
    22: "Jérémie Pralong",
    25: "Jacques Bechet",
}

// Mock project names
const projects: Record<number, string> = {
    1502: "Project Alpha",
    3875: "Project Beta",
    3701: "Project Gamma",
}

// Get project name for display
const projectName = "Project Alpha"

const activities: Record<number, string> = {
    2: "Rapport",
    4: "Traitement de données",
    6: "Réunion, séance",
    12: "Autre activité",
}

// Convert numeric values to checkbox values
const isInvoiced = computed({
    get: () => !!timeEntry.value.Facturé,
    set: (value: boolean) => {
        timeEntry.value.Facturé = value ? 1 : 0
    },
})

const isDisbursement = computed({
    get: () => !!timeEntry.value.Débours,
    set: (value: boolean) => {
        timeEntry.value.Débours = value ? 1 : 0
    },
})

// Handle date formatting
const formattedDate = computed({
    get: () => {
        try {
            const date = new Date(timeEntry.value.Date)
            return date.toISOString().split("T")[0]
        } catch (e) {
            return new Date().toISOString().split("T")[0]
        }
    },
    set: (value: string) => {
        timeEntry.value.Date = new Date(value).toISOString()
    },
})

// If editing, let's pretend we're loading data
if (entryId.value) {
    // Simulating data loading with dummy data
    const timeEntryMap: Record<number, TimeEntry> = {
        1: {
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
        2: {
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
        3: {
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
    }

    if (entryId.value in timeEntryMap) {
        timeEntry.value = { ...timeEntryMap[entryId.value] }
    }
}

const saveTimeEntry = () => {
    // This is just a dummy function that would save the time entry
    console.log("Saving time entry:", timeEntry.value)

    // Redirect to the list page
    router.push({ name: "time-list" })
}
</script>
