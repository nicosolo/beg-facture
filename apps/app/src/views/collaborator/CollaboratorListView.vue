<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold">Collaborateurs</h1>
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
                            variant="ghost-primary"
                            size="sm"
                            :to="{
                                name: 'collaborator-edit',
                                params: { id: item.id },
                            }"
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
import { ref, onMounted } from "vue"
import Button from "@/components/atoms/Button.vue"
import DataTable, { type Column } from "@/components/molecules/DataTable.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import { useFetchUsers } from "@/composables/api/useUser"

// API client
const { get: fetchUsers, loading, data: collaborators } = useFetchUsers()

const columns: Column[] = [
    { key: "id", label: "ID" },
    { key: "fullName", label: "Nom" },
    { key: "email", label: "Email" },
    { key: "role", label: "Rôle" },
    { key: "initials", label: "Initiales" },
    { key: "actions", label: "Actions" },
]

// Load users on mount
onMounted(async () => {
    document.title = 'BEG - Liste des collaborateurs'
    await fetchUsers({})
})
</script>
