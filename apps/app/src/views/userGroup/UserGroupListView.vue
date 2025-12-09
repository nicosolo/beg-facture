<template>
    <LoadingOverlay :loading="loading">
        <div class="container mx-auto">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between mb-6">
                <h1 class="text-2xl font-bold">Groupes d'utilisateurs</h1>
                <Button variant="primary" @click="openCreateDialog" class="w-full sm:w-auto">
                    Nouveau groupe
                </Button>
            </div>

            <DataTable
                :items="userGroups || []"
                :columns="columns"
                item-key="id"
                empty-message="Aucun groupe trouvé"
            >
                <template #cell:actions="{ item }">
                    <div class="flex justify-end gap-2">
                        <Button variant="ghost-primary" size="sm" @click="openEditDialog(item)">
                            Modifier
                        </Button>
                        <Button
                            variant="ghost-danger"
                            size="sm"
                            @click="confirmDelete(item)"
                            :disabled="deletingUserGroup"
                        >
                            Supprimer
                        </Button>
                    </div>
                </template>
            </DataTable>
        </div>

        <!-- Create/Edit Dialog -->
        <Dialog v-model="showDialog" :title="dialogTitle" size="md">
            <UserGroupForm
                :user-group="selectedUserGroup"
                :loading="savingUserGroup"
                @submit="handleSave"
                @cancel="closeDialog"
            />
        </Dialog>

        <!-- Delete Confirmation Dialog -->
        <ConfirmDialog
            v-model="showDeleteDialog"
            title="Confirmer la suppression"
            :message="`Êtes-vous sûr de vouloir supprimer le groupe '${userGroupToDelete?.name}' ?`"
            type="danger"
            confirm-text="Supprimer"
            cancel-text="Annuler"
            @confirm="deleteUserGroup"
        />
    </LoadingOverlay>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import Button from "@/components/atoms/Button.vue"
import DataTable from "@/components/molecules/DataTable.vue"
import Dialog from "@/components/molecules/Dialog.vue"
import ConfirmDialog from "@/components/molecules/ConfirmDialog.vue"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import UserGroupForm from "@/components/organisms/userGroup/UserGroupForm.vue"
import {
    useFetchUserGroups,
    useCreateUserGroup,
    useUpdateUserGroup,
    useDeleteUserGroup,
} from "@/composables/api/useUserGroup"
import { useAlert } from "@/composables/utils/useAlert"
import type { UserGroupResponse } from "@beg/validations"
import { useI18n } from "vue-i18n"

// API composables
const { get: fetchUserGroups, loading, data: userGroupsData } = useFetchUserGroups()
const { post: createUserGroup, loading: creatingUserGroup } = useCreateUserGroup()
const { put: updateUserGroup, loading: updatingUserGroup } = useUpdateUserGroup()
const { delete: deleteUserGroupApi, loading: deletingUserGroup } = useDeleteUserGroup()

// Alert composable
const { successAlert } = useAlert()
const { t } = useI18n()
// State
const showDialog = ref(false)
const showDeleteDialog = ref(false)
const selectedUserGroup = ref<UserGroupResponse | null>(null)
const userGroupToDelete = ref<UserGroupResponse | null>(null)

// Computed
const userGroups = computed(() => userGroupsData.value?.data || [])
const savingUserGroup = computed(() => creatingUserGroup.value || updatingUserGroup.value)
const dialogTitle = computed(() =>
    selectedUserGroup.value ? "Modifier le groupe" : "Nouveau groupe"
)

const columns = [
    { key: "id", label: "ID", width: "20%" },
    { key: "name", label: "Nom du groupe", width: "60%" },
    { key: "actions", label: "Actions", width: "20%", actions: true },
]

// Load user groups on mount
onMounted(async () => {
    document.title = "BEG - " + t("navigation.userGroups")
    await fetchUserGroups()
})

// Dialog handlers
const openCreateDialog = () => {
    selectedUserGroup.value = null
    showDialog.value = true
}

const openEditDialog = (userGroup: UserGroupResponse) => {
    selectedUserGroup.value = userGroup
    showDialog.value = true
}

const closeDialog = () => {
    showDialog.value = false
    selectedUserGroup.value = null
}

// Save handler
const handleSave = async (data: { name: string }) => {
    if (selectedUserGroup.value) {
        await updateUserGroup({
            params: { id: selectedUserGroup.value.id },
            body: data,
        })
        successAlert(`Groupe '${data.name}' modifié avec succès`)
    } else {
        await createUserGroup({
            body: data,
        })
        successAlert(`Groupe '${data.name}' créé avec succès`)
    }

    await fetchUserGroups()
    closeDialog()
}

// Delete handlers
const confirmDelete = (userGroup: UserGroupResponse) => {
    userGroupToDelete.value = userGroup
    showDeleteDialog.value = true
}

const deleteUserGroup = async () => {
    if (!userGroupToDelete.value) return

    try {
        await deleteUserGroupApi({ params: { id: userGroupToDelete.value.id } })
        successAlert(`Groupe '${userGroupToDelete.value.name}' supprimé avec succès`)
        await fetchUserGroups()
        showDeleteDialog.value = false
        userGroupToDelete.value = null
    } catch {
        showDeleteDialog.value = false
    }
}
</script>
