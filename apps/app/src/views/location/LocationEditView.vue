<template>
    <FormLayout
        :title="isNewLocation ? $t('location.new') : $t('location.edit')"
        :loading="loading"
        :error-message="errorMessage"
    >
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
        </form>

        <template #actions>
            <Button variant="secondary" type="button" :to="{ name: 'location-list' }">
                {{ $t("common.cancel") }}
            </Button>
            <Button variant="primary" type="submit" :disabled="saving" @click="saveLocation">
                {{ saving ? $t("common.saving") : $t("common.save") }}
            </Button>
        </template>
    </FormLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import { useAuthStore } from "@/stores/auth"
import FormLayout from "@/components/templates/FormLayout.vue"
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

const route = useRoute()
const router = useRouter()
const { t } = useI18n()
const authStore = useAuthStore()

// Check if user is admin on mount
onMounted(() => {
    if (authStore.user?.role !== "admin") {
        router.push({ name: "location-list" })
    }
})

const locationId = computed(() => {
    const id = route.params.id
    return id ? parseInt(id as string) : null
})

const isNewLocation = computed(() => !locationId.value)

// Location data - using type that allows empty string for country
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
const loading = ref(false)
const saving = ref(false)
const errorMessage = ref<string | null>(null)
const successMessage = ref<string | null>(null)

// API composables
const { get: fetchLocation } = useFetchLocation()
const { post: createLocation } = useCreateLocation()
const { put: updateLocation } = useUpdateLocation()

// Load existing location data if editing
onMounted(async () => {
    if (locationId.value) {
        loading.value = true
        try {
            const locationData = await fetchLocation({
                params: { id: locationId.value },
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
        } finally {
            loading.value = false
        }
    }
})

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
    // Clear any previous messages
    errorMessage.value = null
    successMessage.value = null

    // Validation
    if (!location.value.name || location.value.name.trim() === "") {
        errorMessage.value = t("validation.required", { field: t("location.name") })
        return
    }

    if (!location.value.country) {
        errorMessage.value = t("validation.required", { field: t("location.country") })
        return
    }

    if (location.value.country === "CH" && !location.value.canton) {
        errorMessage.value = t("validation.required", { field: t("location.canton") })
        return
    }

    saving.value = true

    try {
        // Ensure country is valid before saving
        if (!["CH", "FR", "IT", "DE"].includes(location.value.country)) {
            errorMessage.value = t("validation.invalid", { field: t("location.country") })
            saving.value = false
            return
        }

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

            successMessage.value = t("location.created")
        } else {
            await updateLocation({
                params: { id: locationId.value! },
                body: locationData,
            })
            successMessage.value = t("location.updated")
        }

        router.push({ name: "location-list" })
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
    } finally {
        saving.value = false
    }
}
</script>
