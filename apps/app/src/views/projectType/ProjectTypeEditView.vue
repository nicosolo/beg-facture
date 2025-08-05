<template>
    <div class="container mx-auto py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">
                {{ isNewProjectType ? "Nouveau type de mandat" : "Modifier type de mandat" }}
            </h1>
        </div>

        <Card>
            <!-- Error Message -->
            <div v-if="errorMessage" class="mb-6 p-4 bg-red-50 border border-red-200 rounded-md">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                            <path
                                fill-rule="evenodd"
                                d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                                clip-rule="evenodd"
                            />
                        </svg>
                    </div>
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-red-800">
                            {{ errorMessage }}
                        </h3>
                    </div>
                    <div class="ml-auto pl-3">
                        <div class="-mx-1.5 -my-1.5">
                            <button
                                @click="clearError"
                                type="button"
                                class="inline-flex bg-red-50 rounded-md p-1.5 text-red-500 hover:bg-red-100"
                            >
                                <svg class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                    <path
                                        fill-rule="evenodd"
                                        d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                        clip-rule="evenodd"
                                    />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <form @submit.prevent="saveProjectType">
                <div class="grid grid-cols-1 gap-6">
                    <!-- Type de mandat -->
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                            Type de mandat
                        </label>
                        <input
                            type="text"
                            id="name"
                            v-model="projectType.name"
                            class="w-full p-2 border border-gray-300 rounded-md"
                            required
                        />
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3">
                    <Button variant="secondary" type="button" :to="{ name: 'project-type-list' }">
                        Annuler
                    </Button>
                    <Button
                        variant="primary"
                        type="submit"
                        :disabled="creatingProjectType || updatingProjectType || loadingProjectType"
                    >
                        {{
                            creatingProjectType || updatingProjectType
                                ? "Enregistrement..."
                                : "Enregistrer"
                        }}
                    </Button>
                </div>
            </form>
        </Card>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"
import {
    useFetchProjectType,
    useCreateProjectType,
    useUpdateProjectType,
} from "@/composables/api/useProjectType"
import Card from "@/components/atoms/Card.vue"

const route = useRoute()
const router = useRouter()
const projectTypeId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewProjectType = computed(() => !projectTypeId.value)

// Project type data
const projectType = ref<{
    name: string
}>({
    name: "",
})

// Error handling
const errorMessage = ref<string | null>(null)

// API composables
const { get: fetchProjectType, loading: loadingProjectType } = useFetchProjectType()
const { post: createProjectType, loading: creatingProjectType } = useCreateProjectType()
const { put: updateProjectType, loading: updatingProjectType } = useUpdateProjectType()

// Load existing project type data if editing
onMounted(async () => {
    if (projectTypeId.value) {
        try {
            const projectTypeData = await fetchProjectType({
                params: { id: projectTypeId.value.toString() },
            })
            if (projectTypeData) {
                projectType.value = {
                    name: projectTypeData.name,
                }
            }
        } catch (error) {
            console.error("Error loading project type:", error)
        }
    }
})

const clearError = () => {
    errorMessage.value = null
}

const saveProjectType = async () => {
    // Clear any previous error
    clearError()

    // Basic validation
    if (!projectType.value.name || projectType.value.name.trim() === "") {
        errorMessage.value = "Veuillez saisir un nom pour le type de mandat."
        return
    }

    try {
        if (isNewProjectType.value) {
            await createProjectType({
                body: {
                    name: projectType.value.name.trim(),
                },
            })
        } else {
            await updateProjectType({
                params: { id: projectTypeId.value! },
                body: {
                    name: projectType.value.name.trim(),
                },
            })
        }
        router.push({ name: "project-type-list" })
    } catch (error: any) {
        console.error("Error saving project type:", error)

        // Handle specific API errors
        if (error?.response?.data?.error) {
            const apiError = error.response.data.error
            if (apiError.includes("already exists")) {
                errorMessage.value = `Un type de mandat avec le nom "${projectType.value.name}" existe déjà.`
            } else {
                errorMessage.value = apiError
            }
        } else if (error?.message) {
            errorMessage.value = `Erreur lors de l'enregistrement: ${error.message}`
        } else {
            errorMessage.value = "Une erreur inattendue s'est produite lors de l'enregistrement."
        }
    }
}
</script>
