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
import { ref, watch } from "vue"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import { useFetchClientList } from "@/composables/api/useClient"
import type { Client } from "@beg/validations"

interface Props {
    modelValue?: number | null
    placeholder?: string
    required?: boolean
    disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    required: false,
    disabled: false,
})

const emit = defineEmits<{
    "update:modelValue": [value: number | null]
}>()

const { get: fetchClientListApi, loading } = useFetchClientList()
const selected = ref<number | null>(props.modelValue || null)
const clients = ref<Client[]>([])

// Watch for external changes
watch(
    () => props.modelValue,
    (newValue) => {
        if (newValue !== selected.value) {
            selected.value = newValue || null
        }
    }
)

// Emit changes
const handleChange = (value: number | null) => {
    emit("update:modelValue", value)
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
</script>
