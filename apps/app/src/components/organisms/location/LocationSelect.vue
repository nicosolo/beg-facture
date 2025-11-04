<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="async"
        :items="locations"
        :loading="loading"
        :fetch-function="fetchLocations"
        :display-field="formatLocationDisplay"
        :placeholder="placeholder || $t('location.select')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event as number | undefined)"
    />
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchLocationList, useFetchLocation } from "@/composables/api/useLocation"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import { COUNTRIES, SWISS_CANTONS, type Location } from "@beg/validations"

interface LocationSelectProps {
    modelValue: number | null | undefined | string
    placeholder?: string
    disabled?: boolean
    className?: string
    required?: boolean
}

const props = defineProps<LocationSelectProps>()

defineEmits<{
    "update:modelValue": [value: number | undefined]
}>()

const {} = useI18n()
const { get, loading } = useFetchLocationList()
const { get: fetchSingleLocation } = useFetchLocation()

// Local state for locations
const locations = ref<Location[]>([])

// Format location display with country and canton
const formatLocationDisplay = (location: Location): string => {
    let display = location.name

    // Add country name
    const countryName = COUNTRIES[location.country as keyof typeof COUNTRIES]
    if (countryName) {
        display += ` - ${countryName}`
    }

    // Add canton for Swiss locations
    if (location.country === "CH" && location.canton) {
        const cantonName = SWISS_CANTONS[location.canton as keyof typeof SWISS_CANTONS]
        if (cantonName) {
            display += ` (${cantonName})`
        }
    }

    return display
}

// Async fetch function for AutocompleteSelect
const fetchLocations = async (searchText: string) => {
    const response = await get({
        query: {
            name: searchText,
            limit: 20,
        },
    })

    locations.value = response?.data || []
}

// Fetch selected item when modelValue changes
const fetchSelectedItem = async () => {
    if (props.modelValue && !locations.value.find((l) => l.id === props.modelValue)) {
        const data = await fetchSingleLocation({ params: { id: props.modelValue } })
        if (data) {
            // Add the selected item to the locations array if not already there
            locations.value = [data, ...locations.value.filter((l) => l.id !== data!.id)]
        }
    }
}

// Watch for modelValue changes
watch(() => props.modelValue, fetchSelectedItem, { immediate: true })

// Load initial data
onMounted(() => {
    fetchLocations("")
})
</script>
