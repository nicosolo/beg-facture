<template>
    <Dialog v-model="isOpen" :title="isNewLocation ? $t('location.new') : $t('location.edit')">
        <form @submit.prevent="saveLocation" class="space-y-6">
            <div class="grid grid-cols-1 gap-6">
                <!-- Name -->
                <div>
                    <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t("location.name") }} *
                    </label>
                    <Input
                        id="name"
                        v-model="location.name"
                        type="text"
                        required
                        :placeholder="$t('location.namePlaceholder')"
                    />
                </div>

                <!-- Country -->
                <div>
                    <label for="country" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t("location.country") }} *
                    </label>
                    <CountrySelect
                        id="country"
                        v-model="location.country"
                        required
                        :placeholder="$t('location.selectCountry')"
                        @update:model-value="onCountryChange"
                    />
                </div>

                <!-- Canton (only for Switzerland) -->
                <div v-if="location.country === 'CH'">
                    <label for="canton" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t("location.canton") }} *
                    </label>
                    <CantonSelect
                        id="canton"
                        v-model="location.canton"
                        :required="location.country === 'CH'"
                        :placeholder="$t('location.selectCanton')"
                    />
                </div>

                <!-- Region -->
                <div>
                    <label for="region" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t("location.region") }}
                    </label>
                    <Input
                        id="region"
                        v-model="location.region"
                        type="text"
                        :placeholder="$t('location.regionPlaceholder')"
                    />
                </div>

                <!-- Address -->
                <div>
                    <label for="address" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t("location.address") }}
                    </label>
                    <Textarea
                        id="address"
                        v-model="location.address"
                        :rows="4"
                        :placeholder="$t('location.addressPlaceholder')"
                    />
                </div>
            </div>

            <!-- Error message -->
            <div v-if="errorMessage" class="rounded-md bg-red-50 p-4">
                <div class="flex">
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-red-800">{{ errorMessage }}</h3>
                    </div>
                </div>
            </div>
        </form>

        <template #footer>
            <Button variant="secondary" type="button" @click="closeModal">
                {{ $t("common.cancel") }}
            </Button>
            <Button
                variant="primary"
                type="submit"
                :disabled="saving || loading"
                :loading="saving"
                @click="saveLocation"
            >
                {{ $t("common.save") }}
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
import Textarea from "@/components/atoms/Textarea.vue"
import CountrySelect from "@/components/atoms/CountrySelect.vue"
import CantonSelect from "@/components/atoms/CantonSelect.vue"
import {
    useFetchLocation,
    useCreateLocation,
    useUpdateLocation,
} from "@/composables/api/useLocation"
import { type CantonCode, type CountryCode } from "@beg/validations"
import { useAlert } from "@/composables/utils/useAlert"

const props = defineProps<{
    modelValue: boolean
    locationId?: number | null
}>()

const emit = defineEmits<{
    "update:modelValue": [value: boolean]
    saved: []
}>()

const { t } = useI18n()
const { successAlert } = useAlert()

const isOpen = computed({
    get: () => props.modelValue,
    set: (value) => emit("update:modelValue", value),
})

const isNewLocation = computed(() => !props.locationId)

// Location data
const location = ref<{
    name: string
    country?: string
    canton?: string
    region?: string
    address?: string
}>({
    name: "",
    country: "",
    canton: undefined,
    region: undefined,
    address: undefined,
})

// States
const errorMessage = ref<string | null>(null)

// API composables
const { get: fetchLocation, loading } = useFetchLocation()
const { post: createLocation, loading: creating } = useCreateLocation()
const { put: updateLocation, loading: updating } = useUpdateLocation()

const saving = computed(() => creating.value || updating.value || loading.value)

// Watch for locationId changes to load data
watch(
    () => [props.locationId, props.modelValue],
    async ([newLocationId, newIsOpen]) => {
        if (newIsOpen && newLocationId) {
            errorMessage.value = null
            try {
                const locationData = await fetchLocation({
                    params: { id: newLocationId as number },
                })
                if (locationData) {
                    location.value = {
                        name: locationData.name,
                        country: locationData.country || undefined,
                        canton: locationData.canton || undefined,
                        region: locationData.region || undefined,
                        address: locationData.address || undefined,
                    }
                }
            } catch (error) {
                console.error("Error loading location:", error)
                errorMessage.value = t("common.errorLoading")
            }
        } else if (newIsOpen && !newLocationId) {
            // Reset form for new location
            location.value = {
                name: "",
                country: "",
                canton: undefined,
                region: undefined,
                address: undefined,
            }
            errorMessage.value = null
        }
    },
    { immediate: true }
)

// Handle country change
const onCountryChange = (newCountry: string | undefined) => {
    // Clear canton when changing from CH to another country
    if (location.value.country === "CH" && newCountry !== "CH") {
        location.value.canton = undefined
    }
    location.value.country = newCountry || ""
}

// Save location
const saveLocation = async () => {
    try {
        const locationData = {
            name: location.value.name.trim(),
            country: location.value.country as CountryCode,
            canton: location.value.canton as CantonCode | undefined,
            region: location.value.region?.trim() || undefined,
            address: location.value.address?.trim() || undefined,
        }

        if (isNewLocation.value) {
            await createLocation({
                body: locationData,
            })
            successAlert(t("location.created"))
        } else {
            await updateLocation({
                params: { id: props.locationId! },
                body: locationData,
            })
            successAlert(t("location.updated"))
        }

        emit("saved")
        closeModal()
    } catch (error: any) {
        console.error("Error saving location:", error)

        // Handle specific API errors
        if (error?.response?.data?.error) {
            const apiError = error.response.data.error
            errorMessage.value = apiError
        } else if (error?.message) {
            errorMessage.value = error.message
        } else {
            errorMessage.value = t("common.errorSaving")
        }
    }
}

const closeModal = () => {
    isOpen.value = false
}
</script>
