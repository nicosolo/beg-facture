<template>
    <div class="container mx-auto py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">
                {{ isNewProjectType ? "Nouveau type de mandat" : "Modifier type de mandat" }}
            </h1>
        </div>

        <div class="bg-white shadow-md rounded-lg p-6">
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
                    <Button variant="primary" type="submit" :disabled="creatingProjectType || updatingProjectType || loadingProjectType"> 
                        {{ creatingProjectType || updatingProjectType ? 'Enregistrement...' : 'Enregistrer' }}
                    </Button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"
import { useFetchProjectType, useCreateProjectType, useUpdateProjectType } from "@/composables/api/useProjectType"

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

// API composables
const { get: fetchProjectType, loading: loadingProjectType } = useFetchProjectType()
const { post: createProjectType, loading: creatingProjectType } = useCreateProjectType()
const { put: updateProjectType, loading: updatingProjectType } = useUpdateProjectType()

// Load existing project type data if editing
onMounted(async () => {
    if (projectTypeId.value) {
        try {
            const projectTypeData = await fetchProjectType({ params: { id: projectTypeId.value.toString() } })
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
    try {
        if (isNewProjectType.value) {
            await createProjectType({
                body: {
                    name: projectType.value.name,
                },
            })
        } else {
            await updateProjectType({
                params: { id: projectTypeId.value! },
                body: {
                    name: projectType.value.name,
                },
            })
        }
        router.push({ name: "project-type-list" })
    } catch (error) {
        console.error("Error saving project type:", error)
    }
}
</script>