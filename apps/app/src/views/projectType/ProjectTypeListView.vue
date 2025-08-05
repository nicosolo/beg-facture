<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold">Types de mandat</h1>
                <Button variant="primary" :to="{ name: 'project-type-new' }"> Nouveau type </Button>
            </div>

            <DataTable
                :items="projectTypes"
                :columns="columns"
                item-key="id"
                empty-message="Aucun type de mandat trouvé"
            >
                <template #cell:actions="{ item }">
                    <div class="flex justify-end gap-2">
                        <Button
                            variant="ghost-primary"
                            size="sm"
                            :to="{ name: 'project-type-edit', params: { id: item.id } }"
                        >
                            Modifier
                        </Button>
                        <Button
                            variant="ghost-danger"
                            size="sm"
                            @click="confirmDelete(item)"
                            className="text-red-600 hover:text-red-900"
                            :disabled="deletingProjectType"
                        >
                            Supprimer
                        </Button>
                    </div>
                </template>
            </DataTable>
        </div>

        <!-- Delete Confirmation Dialog -->
        <Dialog v-model="showDeleteDialog" title="Confirmer la suppression">
            <p class="text-sm text-gray-500">
                Êtes-vous sûr de vouloir supprimer le type de mandat "{{ currentProjectType.name }}"
                ? Cette action ne peut pas être annulée.
            </p>

            <template #footer>
                <Button
                    variant="primary"
                    class="ml-3 bg-red-600 hover:bg-red-700"
                    @click="deleteProjectType"
                    :disabled="deletingProjectType"
                >
                    {{ deletingProjectType ? "Suppression..." : "Supprimer" }}
                </Button>
                <Button variant="secondary" @click="showDeleteDialog = false"> Annuler </Button>
            </template>
        </Dialog>
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import Dialog from "../../components/molecules/Dialog.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import { useFetchProjectTypes, useDeleteProjectType } from "@/composables/api/useProjectType"
import type { ProjectTypeSchema } from "@beg/validations"

const columns = [
    { key: "id", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "name", label: "Type de mandat" },
    { key: "actions", label: "Actions" },
]

// API client
const { get: fetchProjectTypes, loading, data: projectTypesData } = useFetchProjectTypes()
const { delete: deleteProjectTypeApi, loading: deletingProjectType } = useDeleteProjectType()

const projectTypes = ref<ProjectTypeSchema[]>([])

// Dialog state
const showDeleteDialog = ref(false)
const currentProjectType = ref<ProjectTypeSchema>({
    id: 0,
    name: "",
    createdAt: null,
    updatedAt: null,
})

// Load project types on mount
onMounted(async () => {
    await fetchProjectTypes({})
})

// Watch for API data changes
watch(projectTypesData, (newData) => {
    if (newData) {
        projectTypes.value = newData
    }
})

// Open delete confirmation dialog
const confirmDelete = (item: ProjectTypeSchema) => {
    currentProjectType.value = { ...item }
    showDeleteDialog.value = true
}

// Delete project type
const deleteProjectType = async () => {
    try {
        await deleteProjectTypeApi({ params: { id: currentProjectType.value.id } })
        await fetchProjectTypes({}) // Reload data
        showDeleteDialog.value = false
    } catch (error) {
        console.error("Error deleting project type:", error)
    }
}
</script>
