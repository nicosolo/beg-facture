<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold">Types d'activité</h1>
                <Button variant="primary" :to="{ name: 'activity-new' }">
                    Nouveau type d'activité
                </Button>
            </div>

            <DataTable
                :items="activityTypes || []"
                :columns="columns"
                item-key="id"
                empty-message="Aucun type d'activité trouvé"
            >
                <template #cell:billable="{ item }">
                    <span :class="item.billable ? 'text-green-600' : 'text-red-600'">
                        {{ item.billable ? "Facturable" : "Non facturable" }}
                    </span>
                </template>

                <template #cell:actions="{ item }">
                    <div class="flex justify-end gap-2">
                        <Button
                            variant="ghost-primary"
                            size="sm"
                            :to="{
                                name: 'activity-edit',
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
import { onMounted } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import { useFetchActivityTypes } from "@/composables/api/useActivityType"

// API client
const { get: fetchActivityTypes, loading, data: activityTypes } = useFetchActivityTypes()

const columns = [
    { key: "id", label: "ID" },
    { key: "name", label: "Nom" },
    { key: "code", label: "Code" },
    { key: "billable", label: "Facturable" },
    { key: "actions", label: "Actions" },
]

// Load activity types on mount
onMounted(async () => {
    await fetchActivityTypes()
})
</script>
