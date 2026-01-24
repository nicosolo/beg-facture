<template>
    <Select
        :model-value="modelValue"
        :loading="loading"
        :options="options"
        :disabled="disabled"
        :required="required"
        :class="className"
        @update:model-value="handleUpdate"
    />
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import Select from "@/components/atoms/Select.vue"
import { useFetchActivityTypeFiltered } from "@/composables/api/useActivityType"

interface Props {
    modelValue?: number | string | null
    disabled?: boolean
    required?: boolean
    className?: string
    placeholder?: string
    showAllOption?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    showAllOption: false,
    filtered: true,
})

const emit = defineEmits<{
    "update:modelValue": [value: number | string | null | undefined]
}>()

const { t } = useI18n()

const {
    get: fetchFiltered,
    loading: loadingFiltered,
    data: filteredData,
} = useFetchActivityTypeFiltered()

const loading = computed(() => loadingFiltered.value)
const activityTypesData = computed(() => filteredData.value)

const options = computed(() => {
    const typeOptions = activityTypesData.value
        ? activityTypesData.value.map((type) => ({
              label: `${type.code} - ${type.name}`,
              value: type.id,
          }))
        : []

    if (props.showAllOption) {
        return [{ label: t("common.all"), value: null }, ...typeOptions]
    }

    return [
        { label: props.placeholder || t("common.select", "Select..."), value: "" },
        ...typeOptions,
    ]
})

function handleUpdate(value: string | number | boolean | null) {
    if (typeof value === "boolean") return
    emit("update:modelValue", value)
}

onMounted(() => {
    fetchFiltered()
})
</script>
