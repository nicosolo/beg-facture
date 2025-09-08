<template>
    <div class="bg-white rounded-lg">
        <h3 class="text-lg font-semibold mb-4">{{ $t("projects.accessManagement") }}</h3>

        <!-- Confirm Dialog for removing access -->
        <ConfirmDialog
            v-model="showDeleteConfirm"
            :title="$t('projects.removeAccess')"
            :message="deleteConfirmMessage"
            type="danger"
            :confirm-text="$t('common.remove')"
            :cancel-text="$t('common.cancel')"
            @confirm="confirmRemoveAccess"
            @cancel="cancelRemoveAccess"
        />

        <div v-if="loading" class="text-center py-4">
            <span>{{ $t("common.loading") }}</span>
        </div>

        <div v-else-if="error" class="text-red-500 mb-4">
            {{ error }}
        </div>

        <div v-else>
            <!-- Add new user access -->
            <div class="mb-6 p-4 border rounded-lg bg-gray-50">
                <h4 class="text-md font-medium mb-3">{{ $t("projects.addUserAccess") }}</h4>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <UserSelect
                        v-model="newAccess.userId"
                        :placeholder="$t('projects.selectUser')"
                        :disabled="saving"
                    />
                    <select
                        v-model="newAccess.accessLevel"
                        class="px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        :disabled="saving"
                    >
                        <option value="">{{ $t("projects.selectAccessLevel") }}</option>
                        <option value="read">{{ $t("projects.readAccess") }}</option>
                        <option value="write">{{ $t("projects.writeAccess") }}</option>
                    </select>
                    <Button
                        variant="primary"
                        type="button"
                        @click="addUserAccess"
                        :disabled="!newAccess.userId || !newAccess.accessLevel || saving"
                        :loading="saving"
                    >
                        {{ $t("common.add") }}
                    </Button>
                </div>
            </div>

            <!-- Users list with access levels -->
            <div class="space-y-2">
                <h4 class="text-md font-medium mb-3">{{ $t("projects.currentAccess") }}</h4>

                <div v-if="projectAccesses.length === 0" class="text-gray-500 text-center py-4">
                    {{ $t("projects.noAccessConfigured") }}
                </div>

                <div
                    v-for="access in projectAccesses"
                    :key="access.id"
                    class="flex items-center justify-between p-3 border rounded-lg hover:bg-gray-50"
                >
                    <div class="flex items-center space-x-3">
                        <div>
                            <div class="font-medium">{{ access.user?.name }}</div>
                            <div class="text-sm text-gray-500">{{ access.user?.email }}</div>
                        </div>
                    </div>

                    <div class="flex items-center space-x-3">
                        <select
                            v-model="access.accessLevel"
                            @change="updateAccess(access)"
                            class="px-3 py-1 border border-gray-300 rounded-md text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            :disabled="saving"
                        >
                            <option value="read">{{ $t("projects.readAccess") }}</option>
                            <option value="write">{{ $t("projects.writeAccess") }}</option>
                        </select>

                        <Button
                            variant="danger"
                            size="sm"
                            type="button"
                            @click="removeAccess(access)"
                            :disabled="saving"
                        >
                            {{ $t("common.remove") }}
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue"
import { useI18n } from "vue-i18n"
import { useAlert } from "@/composables/utils/useAlert"
import Button from "@/components/atoms/Button.vue"
import UserSelect from "@/components/organisms/user/UserSelect.vue"
import ConfirmDialog from "@/components/molecules/ConfirmDialog.vue"
import {
    useFetchProjectAccesses,
    useCreateProjectAccess,
    useUpdateProjectAccess,
    useDeleteProjectAccess,
} from "@/composables/api/useProjectAccess"
import type { ProjectAccessResponse, ProjectAccessLevel } from "@beg/validations"

interface ProjectAccessManagementProps {
    projectId: number
}

const props = defineProps<ProjectAccessManagementProps>()

const { t } = useI18n()
const { successAlert, errorAlert } = useAlert()

// State
const loading = ref(false)
const saving = ref(false)
const error = ref<string | null>(null)
const projectAccesses = ref<ProjectAccessResponse[]>([])

// Delete confirmation state
const showDeleteConfirm = ref(false)
const accessToDelete = ref<ProjectAccessResponse | null>(null)

// Computed message for delete confirmation
const deleteConfirmMessage = computed(() => {
    if (!accessToDelete.value) return ""
    return t("projects.confirmRemoveAccessMessage", {
        user: accessToDelete.value.user?.name || accessToDelete.value.user?.email || "",
    })
})

// New access form
const newAccess = ref<{
    userId: number | undefined
    accessLevel: ProjectAccessLevel | ""
}>({
    userId: undefined,
    accessLevel: "",
})

// API composables
const { get: fetchAccesses, data: accessesData } = useFetchProjectAccesses()
const { post: createAccess } = useCreateProjectAccess()
const { put: updateAccessApi } = useUpdateProjectAccess()
const { delete: deleteAccess } = useDeleteProjectAccess()

// Load project accesses
const loadProjectAccesses = async () => {
    try {
        loading.value = true
        error.value = null
        await fetchAccesses({ params: { projectId: props.projectId } })
        if (accessesData.value) {
            projectAccesses.value = [...accessesData.value]
        }
    } catch (err: any) {
        console.error("Error loading project accesses:", err)
        error.value = t("errors.loadingData")
        errorAlert(t("errors.loadingData"))
    } finally {
        loading.value = false
    }
}

// Add new user access
const addUserAccess = async () => {
    if (!newAccess.value.userId || !newAccess.value.accessLevel) {
        return
    }

    try {
        saving.value = true
        error.value = null

        // Check if user already has access
        const existingAccess = projectAccesses.value.find(
            (a) => a.userId === newAccess.value.userId
        )
        if (existingAccess) {
            errorAlert(t("projects.userAlreadyHasAccess"))
            return
        }

        const response = await createAccess({
            body: {
                projectId: props.projectId,
                userId: newAccess.value.userId,
                accessLevel: newAccess.value.accessLevel as ProjectAccessLevel,
            },
        })

        if (response) {
            projectAccesses.value.push(response)
            newAccess.value = { userId: undefined, accessLevel: "" }
            successAlert(t("projects.accessAdded"))
        }
    } catch (err: any) {
        console.error("Error adding user access:", err)
        error.value = t("errors.general")
        errorAlert(t("errors.general"))
    } finally {
        saving.value = false
    }
}

// Update existing access
const updateAccess = async (access: ProjectAccessResponse) => {
    try {
        saving.value = true
        error.value = null

        await updateAccessApi({
            params: { id: access.id },
            body: { accessLevel: access.accessLevel },
        })

        successAlert(t("projects.accessUpdated"))
    } catch (err: any) {
        console.error("Error updating access:", err)
        error.value = t("errors.general")
        errorAlert(t("errors.general"))
        // Reload to revert changes
        await loadProjectAccesses()
    } finally {
        saving.value = false
    }
}

// Remove user access - show confirmation dialog
const removeAccess = (access: ProjectAccessResponse) => {
    accessToDelete.value = access
    showDeleteConfirm.value = true
}

// Confirm remove access
const confirmRemoveAccess = async () => {
    if (!accessToDelete.value) return

    try {
        saving.value = true
        error.value = null

        await deleteAccess({ params: { id: accessToDelete.value.id } })

        // Remove from local list
        const index = projectAccesses.value.findIndex((a) => a.id === accessToDelete.value!.id)
        if (index !== -1) {
            projectAccesses.value.splice(index, 1)
        }

        successAlert(t("projects.accessRemoved"))
        showDeleteConfirm.value = false
        accessToDelete.value = null
    } catch (err: any) {
        console.error("Error removing access:", err)
        error.value = t("errors.general")
        errorAlert(t("errors.general"))
        showDeleteConfirm.value = false
    } finally {
        saving.value = false
    }
}

// Cancel remove access
const cancelRemoveAccess = () => {
    showDeleteConfirm.value = false
    accessToDelete.value = null
}

// Load accesses when component mounts or projectId changes
onMounted(() => {
    if (props.projectId) {
        loadProjectAccesses()
    }
})

watch(
    () => props.projectId,
    (newProjectId) => {
        if (newProjectId) {
            loadProjectAccesses()
        }
    }
)
</script>
