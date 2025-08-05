<template>
    <div class="container mx-auto py-8">
        <FormLayout
            :title="isNewProjectType ? 'Nouveau type de mandat' : 'Modifier type de mandat'"
            :loading="creatingProjectType || updatingProjectType || loadingProjectType"
            :error-message="errorMessage"
        >
            <form @submit.prevent="saveProjectType" id="projectTypeForm">
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

            </form>

            <template #actions>
                <Button variant="secondary" type="button" :to="{ name: 'project-type-list' }">
                    Annuler
                </Button>
                <Button
                    variant="primary"
                    type="submit"
                    form="projectTypeForm"
                    :disabled="creatingProjectType || updatingProjectType || loadingProjectType"
                >
                    {{
                        creatingProjectType || updatingProjectType
                            ? "Enregistrement..."
                            : "Enregistrer"
                    }}
                </Button>
            </template>
        </FormLayout>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"
import FormLayout from "@/components/templates/FormLayout.vue"
import {
    useFetchProjectType,
    useCreateProjectType,
    useUpdateProjectType,
} from "@/composables/api/useProjectType"

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

const saveProjectType = async () => {
    // Clear any previous error
    errorMessage.value = null

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
