<template>
    <div class="w-full">
        <AutocompleteSelect
            v-model="selected"
            mode="async"
            :items="clients"
            :fetch-function="fetchClients"
            :loading="loading"
            :placeholder="placeholder || $t('client.selectClient')"
            :required="required"
            :disabled="disabled"
            :display-field="(item) => item.name"
            value-field="id"
            @update:model-value="handleChange"
        />
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import { useFetchClientList, useFetchClient } from "@/composables/api/useClient"
import type { Client } from "@beg/validations"

interface Props {
    modelValue?: number | null | undefined | string
    placeholder?: string
    required?: boolean
    disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    required: false,
    disabled: false,
})

const emit = defineEmits<{
    "update:modelValue": [value: number | null | undefined | string]
}>()

const { get: fetchClientListApi, loading } = useFetchClientList()
const { get: fetchSingleClient } = useFetchClient()
const selected = ref<number | null | undefined | string>(props.modelValue || undefined)
const clients = ref<Client[]>([])

// Fetch selected item when modelValue changes
const fetchSelectedItem = async () => {
    if (props.modelValue && !clients.value.find((c) => c.id === props.modelValue)) {
        const data = await fetchSingleClient({
            params: {
                id:
                    typeof props.modelValue === "string"
                        ? parseInt(props.modelValue)
                        : props.modelValue,
            },
        })
        if (data) {
            // Add the selected item to the clients array if not already there
            clients.value = [data, ...clients.value.filter((c) => c.id !== data!.id)]
        }
    }
}

// Watch for external changes
watch(
    () => props.modelValue,
    async (newValue) => {
        if (newValue !== selected.value) {
            selected.value = newValue || undefined
            await fetchSelectedItem()
        }
    },
    { immediate: true }
)

// Emit changes
const handleChange = (value: string | number | null | undefined) => {
    emit(
        "update:modelValue",
        typeof value === "string" ? parseInt(value) : (value as number | undefined)
    )
}

// Fetch clients for autocomplete
const fetchClients = async (search: string) => {
    const response = await fetchClientListApi({
        query: {
            name: search || undefined,
            limit: 20,
            page: 1,
        },
    })

    if (response?.data) {
        clients.value = response.data
    }
}

// Load initial data
onMounted(() => {
    fetchClients("")
})
</script>
