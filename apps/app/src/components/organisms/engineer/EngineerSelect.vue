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
import { ref, watch } from "vue"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import { useFetchEngineerList } from "@/composables/api/useEngineer"
import type { Engineer } from "@beg/validations"

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

const { get: fetchEngineerListApi, loading } = useFetchEngineerList()
const selected = ref<number | null>(props.modelValue || null)
const engineers = ref<Engineer[]>([])

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
}</script>