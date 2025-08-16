<template>
    <Dialog v-model="isOpen" :title="isNewClient ? $t('client.new') : $t('client.edit')">
        <form @submit.prevent="saveClient" class="space-y-6">
            <div>
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                    {{ $t("client.name") }} *
                </label>
                <Input
                    id="name"
                    v-model="client.name"
                    type="text"
                    required
                    :placeholder="$t('client.namePlaceholder')"
                />
            </div>
        </form>

        <template #footer>
            <Button
                variant="primary"
                @click="saveClient"
                :disabled="saving || !client.name"
            >
                {{ saving ? $t("common.saving") : $t("common.save") }}
            </Button>
            <Button
                variant="secondary"
                @click="closeModal"
                :disabled="saving"
            >
                {{ $t("common.cancel") }}
            </Button>
        </template>
    </Dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from "vue"
import { useI18n } from "vue-i18n"
import Dialog from "@/components/molecules/Dialog.vue"
import Button from "@/components/atoms/Button.vue"
import Input from "@/components/atoms/Input.vue"
import { useFetchClient, useCreateClient, useUpdateClient } from "@/composables/api/useClient"
import { useAlert } from "@/composables/utils/useAlert"
import type { ClientCreateInput, ClientUpdateInput } from "@beg/validations"

interface Props {
    modelValue: boolean
    clientId?: number | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
    "update:modelValue": [value: boolean]
    saved: []
}>()

const { t } = useI18n()
const { successAlert, errorAlert } = useAlert()

// Computed
const isOpen = computed({
    get: () => props.modelValue,
    set: (value) => emit("update:modelValue", value),
})
const isNewClient = computed(() => !props.clientId)

// API composables
const { get: fetchClient } = useFetchClient()
const { post: createClient } = useCreateClient()
const { put: updateClient } = useUpdateClient()

// State
const saving = ref(false)
const client = ref<ClientCreateInput>({
    name: "",
})

// Load client data if editing
const loadClientData = async () => {
    if (!props.clientId) {
        // Reset form for new client
        client.value = {
            name: "",
        }
        return
    }

    try {
        const data = await fetchClient({ params: { id: props.clientId } })
        if (data) {
            client.value = {
                name: data.name,
            }
        }
    } catch (error) {
        console.error("Error loading client:", error)
        errorAlert(t("errors.loadFailed"))
        closeModal()
    }
}

// Save client
const saveClient = async () => {
    if (!client.value.name) {
        errorAlert(t("validation.required", { field: t("client.name") }))
        return
    }

    saving.value = true

    try {
        if (isNewClient.value) {
            await createClient({ body: client.value })
            successAlert(t("client.createSuccess"))
        } else if (props.clientId) {
            await updateClient({
                params: { id: props.clientId },
                body: client.value as ClientUpdateInput,
            })
            successAlert(t("client.updateSuccess"))
        }

        emit("saved")
        closeModal()
    } catch (error: any) {
        console.error("Error saving client:", error)
        errorAlert(error.message || t("errors.saveFailed"))
    } finally {
        saving.value = false
    }
}

// Close modal
const closeModal = () => {
    isOpen.value = false
}

// Watch for modal open/close
watch(isOpen, (newValue) => {
    if (newValue) {
        loadClientData()
    }
})
</script>