<template>
    <div class="w-full">
        <AutocompleteSelect
            v-model="selected"
            mode="async"
            :items="engineers"
            :fetch-function="fetchEngineers"
            :loading="loading"
            :placeholder="placeholder || $t('engineer.selectEngineer')"
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
import { useFetchEngineerList, useFetchEngineer } from "@/composables/api/useEngineer"
import type { Engineer } from "@beg/validations"

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

const { get: fetchEngineerListApi, loading } = useFetchEngineerList()
const { get: fetchSingleEngineer } = useFetchEngineer()
const selected = ref<number | null | undefined | string>(props.modelValue || undefined)
const engineers = ref<Engineer[]>([])

// Fetch selected item when modelValue changes
const fetchSelectedItem = async () => {
    if (props.modelValue && !engineers.value.find((e) => e.id === props.modelValue)) {
        const data = await fetchSingleEngineer({
            params: {
                id:
                    typeof props.modelValue === "string"
                        ? parseInt(props.modelValue)
                        : props.modelValue,
            },
        })
        if (data) {
            // Add the selected item to the engineers array if not already there
            engineers.value = [data, ...engineers.value.filter((e) => e.id !== data!.id)]
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

// Fetch engineers for autocomplete
const fetchEngineers = async (search: string) => {
    const response = await fetchEngineerListApi({
        query: {
            name: search || undefined,
            limit: 20,
            page: 1,
        },
    })

    if (response?.data) {
        engineers.value = response.data
    }
}

// Load initial data
onMounted(() => {
    fetchEngineers("")
})
</script>
