<template>
    <div class="w-full">
        <AutocompleteSelect
            v-model="selected"
            mode="async"
            :items="companies"
            :fetch-function="fetchCompanies"
            :loading="loading"
            :placeholder="placeholder || $t('company.selectCompany')"
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
import { useFetchCompanyList } from "@/composables/api/useCompany"
import type { Company } from "@beg/validations"

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

const { get: fetchCompanyListApi, loading } = useFetchCompanyList()
const selected = ref<number | null>(props.modelValue || null)
const companies = ref<Company[]>([])

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

// Fetch companies for autocomplete
const fetchCompanies = async (search: string) => {
    const response = await fetchCompanyListApi({
        query: {
            name: search || undefined,
            limit: 20,
            page: 1,
        },
    })

    if (response?.data) {
        companies.value = response.data
    }
}</script>