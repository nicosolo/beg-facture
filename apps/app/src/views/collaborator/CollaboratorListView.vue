<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold">Liste des collaborateurs</h1>
                <Button variant="primary" :to="{ name: 'collaborator-new' }">
                    Nouveau collaborateur
                </Button>
            </div>

            <DataTable
                :items="collaborators || []"
                :columns="columns"
                item-key="IDcollaborateur"
                empty-message="Aucun collaborateur trouvé"
            >
                <template #cell:fullName="{ item }">
                    {{ item.firstName }} {{ item.lastName }}
                </template>

                <template #cell:actions="{ item }">
                    <div class="flex justify-end gap-2">
                        <Button
                            variant="ghost"
                            size="sm"
                            :to="{
                                name: 'collaborator-edit',
                                params: { id: item.id },
                            }"
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
import { ref, onMounted, watch } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import { useFetchUsers } from "@/composables/api/useFetchUsers"

interface Collaborator {
    IDcollaborateur: number
    Prénom: string
    Nom: string
    Initiales: string
    "Mot de passe"?: string
    email?: string
    role?: string
}

// API client
const { get: fetchUsers, loading, data: collaborators } = useFetchUsers()

const columns = [
    { key: "id", label: "ID" },
    { key: "fullName", label: "Nom" },
    { key: "email", label: "Email" },
    { key: "role", label: "Rôle" },
    { key: "initials", label: "Initiales" },
    { key: "actions", label: "Actions" },
]

// Load users on mount
onMounted(async () => {
    await fetchUsers({})
})
</script>
