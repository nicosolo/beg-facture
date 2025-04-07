<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Types de mandat</h1>
            <Button variant="primary" @click="openNewTypeDialog"> Nouveau type </Button>
        </div>

        <DataTable
            :items="projectTypes"
            :columns="columns"
            item-key="IDtype"
            empty-message="Aucun type de mandat trouvé"
        >
            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <Button
                        variant="ghost"
                        size="sm"
                        @click="editProjectType(item)"
                        className="text-indigo-600 hover:text-indigo-900"
                    >
                        Modifier
                    </Button>
                    <Button
                        variant="ghost"
                        size="sm"
                        @click="confirmDelete(item)"
                        className="text-red-600 hover:text-red-900"
                    >
                        Supprimer
                    </Button>
                </div>
            </template>
        </DataTable>

        <!-- Edit/New Dialog -->
        <Dialog
            v-model="showDialog"
            :title="isNewType ? 'Nouveau type de mandat' : 'Modifier type de mandat'"
        >
            <form @submit.prevent="saveProjectType">
                <div class="grid grid-cols-1 gap-6">
                    <!-- Type de mandat -->
                    <div>
                        <label for="type" class="block text-sm font-medium text-gray-700 mb-1">
                            Type de mandat
                        </label>
                        <input
                            type="text"
                            id="type"
                            v-model="currentProjectType.Type"
                            class="w-full p-2 border border-gray-300 rounded-md"
                            required
                        />
                    </div>
                </div>
            </form>

            <template #footer>
                <Button variant="primary" class="ml-3" @click="saveProjectType">
                    Enregistrer
                </Button>
                <Button variant="secondary" @click="showDialog = false"> Annuler </Button>
            </template>
        </Dialog>

        <!-- Delete Confirmation Dialog -->
        <Dialog v-model="showDeleteDialog" title="Confirmer la suppression">
            <p class="text-sm text-gray-500">
                Êtes-vous sûr de vouloir supprimer le type de mandat "{{ currentProjectType.Type }}"
                ? Cette action ne peut pas être annulée.
            </p>

            <template #footer>
                <Button
                    variant="primary"
                    class="ml-3 bg-red-600 hover:bg-red-700"
                    @click="deleteProjectType"
                >
                    Supprimer
                </Button>
                <Button variant="secondary" @click="showDeleteDialog = false"> Annuler </Button>
            </template>
        </Dialog>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import Dialog from "../../components/molecules/Dialog.vue"

interface ProjectType {
    IDtype: number
    Type: string
}

const columns = [
    { key: "IDtype", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "Type", label: "Type de mandat" },
    { key: "actions", label: "Actions" },
]

// Sample data for project types
const projectTypes = ref<ProjectType[]>([
    { IDtype: 1, Type: "×" },
    { IDtype: 2, Type: "Appui au Géologue Cantonal" },
    { IDtype: 4, Type: "Dessin" },
    { IDtype: 5, Type: "Enseignement" },
    { IDtype: 6, Type: "Essais" },
    { IDtype: 8, Type: "Expertise" },
    { IDtype: 9, Type: "Géologie" },
    { IDtype: 10, Type: "Géotechnique" },
    { IDtype: 11, Type: "Hydrogéologie" },
    { IDtype: 12, Type: "Géotechnique + hydrogéologie" },
    { IDtype: 13, Type: "Hydrologie" },
    { IDtype: 16, Type: "Laboratoire" },
    { IDtype: 17, Type: "Philippossian et divers" },
    { IDtype: 18, Type: "Travaux divers pour le BEG" },
    { IDtype: 22, Type: "SIPOL" },
    { IDtype: 26, Type: "Base de donnée éboulement" },
    { IDtype: 29, Type: "Publication" },
    { IDtype: 30, Type: "Carte de dangers" },
    { IDtype: 31, Type: "Administration" },
    { IDtype: 32, Type: "E.I.E" },
    { IDtype: 34, Type: "Sondages" },
    // More project types would be loaded from the API in a real app
])

// Dialog state
const showDialog = ref(false)
const showDeleteDialog = ref(false)
const isNewType = ref(false)
const currentProjectType = ref<ProjectType>({
    IDtype: 0,
    Type: "",
})

// Open dialog for editing
const editProjectType = (item: ProjectType) => {
    currentProjectType.value = { ...item }
    isNewType.value = false
    showDialog.value = true
}

// Open dialog for new project type
const openNewTypeDialog = () => {
    currentProjectType.value = {
        IDtype: Math.max(0, ...projectTypes.value.map((pt) => pt.IDtype)) + 1,
        Type: "",
    }
    isNewType.value = true
    showDialog.value = true
}

// Save project type (create or update)
const saveProjectType = () => {
    if (isNewType.value) {
        // Add new project type to the list
        projectTypes.value.push({ ...currentProjectType.value })
    } else {
        // Update existing project type
        const index = projectTypes.value.findIndex(
            (pt) => pt.IDtype === currentProjectType.value.IDtype
        )
        if (index !== -1) {
            projectTypes.value[index] = { ...currentProjectType.value }
        }
    }

    // Close dialog
    showDialog.value = false
}

// Open delete confirmation dialog
const confirmDelete = (item: ProjectType) => {
    currentProjectType.value = { ...item }
    showDeleteDialog.value = true
}

// Delete project type
const deleteProjectType = () => {
    const index = projectTypes.value.findIndex(
        (pt) => pt.IDtype === currentProjectType.value.IDtype
    )
    if (index !== -1) {
        projectTypes.value.splice(index, 1)
    }
    showDeleteDialog.value = false
}
</script>
