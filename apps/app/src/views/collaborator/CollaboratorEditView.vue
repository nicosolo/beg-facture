<template>
    <FormLayout
        :title="isNewCollaborator ? 'Nouveau collaborateur' : 'Modifier collaborateur'"
        :loading="loadingCreate || loadingUpdate || loadingUser"
        :error-message="errorMessage"
    >
        <form @submit.prevent="saveCollaborator" id="collaboratorForm">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Prénom -->
                <div>
                    <label for="firstname" class="block text-sm font-medium text-gray-700 mb-1"
                        >Prénom</label
                    >
                    <input
                        type="text"
                        id="firstname"
                        v-model="collaborator.firstName"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        required
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
                        v-model="collaborator.lastName"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        required
                    />
                </div>

                <!-- Email -->
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700 mb-1"
                        >Email</label
                    >
                    <input
                        type="email"
                        id="email"
                        v-model="collaborator.email"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        required
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
                        v-model="collaborator.initials"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        required
                    />
                </div>

                <!-- Rôle -->
                <div>
                    <label for="role" class="block text-sm font-medium text-gray-700 mb-1"
                        >Rôle</label
                    >
                    <select
                        id="role"
                        v-model="collaborator.role"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        required
                    >
                        <option value="user">Utilisateur</option>
                        <option value="admin">Administrateur</option>
                    </select>
                </div>

                <!-- Mot de passe -->
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1"
                        >Mot de passe</label
                    >
                    <input
                        type="password"
                        id="password"
                        v-model="collaborator.password"
                        class="w-full p-2 border border-gray-300 rounded-md"
                        :minlength="8"
                        :required="isNewCollaborator"
                    />
                    <p v-if="!isNewCollaborator" class="text-sm text-gray-500 mt-1">
                        Laissez vide pour conserver le mot de passe actuel
                    </p>
                </div>

                <!-- Archivé -->
                <div>
                    <label class="flex items-center">
                        <input type="checkbox" v-model="collaborator.archived" class="mr-2" />
                        <span class="text-sm font-medium text-gray-700">Archivé</span>
                    </label>
                </div>
            </div>

            <!-- Activities Section -->
            <div class="mt-8">
                <h2 class="text-lg font-medium mb-4">Activités associées</h2>
                <div class="bg-gray-50 p-4 rounded-md">
                    <div v-if="loadingActivityTypes" class="text-gray-500">
                        Chargement des types d'activité...
                    </div>
                    <div
                        v-else-if="!activityTypes || activityTypes.length === 0"
                        class="text-gray-500"
                    >
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
                            v-for="activity in activityTypes"
                            :key="activity.id"
                            class="flex items-center space-x-2"
                        >
                            <input
                                type="checkbox"
                                :id="`activity-${activity.id}`"
                                v-model="selectedActivities[activity.id]"
                                @change="initializeDefaultClasses()"
                                class="h-4 w-4 text-indigo-600 border-gray-300 rounded"
                            />
                            <label :for="`activity-${activity.id}`" class="flex-grow">
                                <span class="font-medium">{{ activity.code }}</span> -
                                {{ activity.name }}
                            </label>
                            <select
                                v-if="selectedActivities[activity.id]"
                                v-model="activityClasses[activity.id]"
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

            <!-- Workloads Section -->
        </form>
        <template #footer>
            <UserWorkloadList v-if="userData?.id" :user-id="userData.id" />
        </template>
        <template #actions>
            <Button variant="secondary" type="button" :to="{ name: 'collaborator-list' }">
                Annuler
            </Button>
            <Button
                variant="primary"
                type="submit"
                form="collaboratorForm"
                :loading="loadingCreate || loadingUpdate"
            >
                {{ $t("common.save") }}
            </Button>
        </template>
    </FormLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "@/components/atoms/Button.vue"
import FormLayout from "@/components/templates/FormLayout.vue"
import { useFetchUser, useCreateUser, useUpdateUser } from "../../composables/api/useUser"
import { useFetchActivityTypes } from "../../composables/api/useActivityType"
import UserWorkloadList from "@/components/organisms/workload/UserWorkloadList.vue"
import type { UserCreateInput, UserUpdateInput } from "@beg/validations"

interface ActivityRate {
    activityId: number
    class: string
}

const route = useRoute()
const router = useRouter()
const collaboratorId = computed(() =>
    route.params.id ? parseInt(route.params.id as string) : null
)
const isNewCollaborator = computed(() => !collaboratorId.value)

// API composables
const { get: getUser, data: userData, loading: loadingUser } = useFetchUser()
const { post: createUser, loading: loadingCreate } = useCreateUser()
const { put: updateUser, loading: loadingUpdate } = useUpdateUser()
const {
    get: getActivityTypes,
    data: activityTypes,
    loading: loadingActivityTypes,
} = useFetchActivityTypes()

// Form data
const collaborator = ref<UserCreateInput | UserUpdateInput>({
    firstName: "",
    lastName: "",
    email: "",
    initials: "",
    password: "",
    role: "user",
    archived: false,
    activityRates: [],
})

// Track selected activities and their classes
const selectedActivities = ref<Record<number, boolean>>({})
const activityClasses = ref<Record<number, string>>({})

// Error state
const errorMessage = ref<string | null>(null)

// Load user data and activity types
onMounted(async () => {
    // Load activity types
    await getActivityTypes()

    if (collaboratorId.value) {
        await getUser({ params: { id: collaboratorId.value } })

        if (userData.value) {
            collaborator.value = {
                firstName: userData.value.firstName,
                lastName: userData.value.lastName,
                email: userData.value.email,
                initials: userData.value.initials,
                role: userData.value.role,
                archived: userData.value.archived,
                activityRates: userData.value.activityRates || [],
                // Don't populate password for security
            }

            // Populate selected activities and classes from existing data
            if (userData.value.activityRates) {
                userData.value.activityRates.forEach((rate) => {
                    selectedActivities.value[rate.activityId] = true
                    activityClasses.value[rate.activityId] = rate.class
                })
            }
        }
    }
})

// Watch for activity types to initialize default classes
const initializeDefaultClasses = () => {
    if (activityTypes.value) {
        activityTypes.value.forEach((activity) => {
            if (!activityClasses.value[activity.id]) {
                activityClasses.value[activity.id] = "C" // Default class
            }
        })
    }
}

const saveCollaborator = async () => {
    errorMessage.value = null

    try {
        // Collect activity rates from selected activities
        const activityRates = Object.keys(selectedActivities.value)
            .filter((key) => selectedActivities.value[Number(key)])
            .map((key) => ({
                activityId: Number(key),
                class: activityClasses.value[Number(key)],
            }))

        // Update collaborator data with activity rates
        const collaboratorData = {
            ...collaborator.value,
            activityRates: activityRates,
        }

        if (isNewCollaborator.value) {
            await createUser({ body: collaboratorData as UserCreateInput })
        } else if (userData.value?.id) {
            await updateUser({
                body: collaboratorData as UserUpdateInput,
                params: { id: userData.value.id },
            })
        }

        // Redirect to the list page
        router.push({ name: "collaborator-list" })
    } catch (error: any) {
        console.error("Error saving collaborator:", error)
        errorMessage.value = error.message || "Une erreur s'est produite lors de l'enregistrement"
    }
}
</script>
