<template>
    <div class="container mx-auto py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">
                {{ isNewTariff ? "Nouveau tarif" : "Modifier tarif" }}
            </h1>
        </div>

        <div class="bg-white shadow-md rounded-lg p-6">
            <!-- Error Message -->
            <div v-if="errorMessage" class="mb-6 p-4 bg-red-50 border border-red-200 rounded-md">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                            <path
                                fill-rule="evenodd"
                                d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                                clip-rule="evenodd"
                            />
                        </svg>
                    </div>
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-red-800">
                            {{ errorMessage }}
                        </h3>
                    </div>
                    <div class="ml-auto pl-3">
                        <div class="-mx-1.5 -my-1.5">
                            <button
                                @click="clearError"
                                type="button"
                                class="inline-flex bg-red-50 rounded-md p-1.5 text-red-500 hover:bg-red-100"
                            >
                                <svg class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                    <path
                                        fill-rule="evenodd"
                                        d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                        clip-rule="evenodd"
                                    />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <form @submit.prevent="saveTariff">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Classe -->
                    <div>
                        <label for="class" class="block text-sm font-medium text-gray-700 mb-1">
                            Classe
                        </label>
                        <select
                            id="class"
                            v-model="tariff.class"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        >
                            <option value="">Sélectionnez une classe</option>
                            <option v-for="classe in classes" :key="classe" :value="classe">
                                {{ classe }}
                            </option>
                        </select>
                    </div>

                    <!-- Année -->
                    <div>
                        <label for="year" class="block text-sm font-medium text-gray-700 mb-1">
                            Année
                        </label>
                        <input
                            type="number"
                            id="year"
                            v-model.number="tariff.year"
                            min="1990"
                            max="2100"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>

                    <!-- Tarif -->
                    <div>
                        <label for="tariff" class="block text-sm font-medium text-gray-700 mb-1">
                            Tarif (CHF)
                        </label>
                        <input
                            type="number"
                            id="tariff"
                            v-model.number="tariff.amount"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3">
                    <Button variant="secondary" type="button" :to="{ name: 'tariff-list' }">
                        Annuler
                    </Button>
                    <Button
                        variant="primary"
                        type="submit"
                        :disabled="creatingRate || updatingRate || loadingRate"
                    >
                        {{ creatingRate || updatingRate ? "Enregistrement..." : "Enregistrer" }}
                    </Button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import Button from "../../components/atoms/Button.vue"
import { useFetchRate, useCreateRate, useUpdateRate } from "@/composables/api/useRate"
import { ApiError } from "@/utils/api-error"
import { ErrorCode } from "@beg/validations"

const route = useRoute()
const router = useRouter()
const { t } = useI18n()
const tariffId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewTariff = computed(() => !tariffId.value)

// Available classes
const classes = ["A", "B", "C", "D", "E", "F", "G", "R", "Z"]

// Rate data
const tariff = ref<{
    class: string
    year: number
    amount: number
}>({
    class: "",
    year: new Date().getFullYear(),
    amount: 0,
})

// Error handling
const errorMessage = ref<string | null>(null)

// API composables
const { get: fetchRate, loading: loadingRate } = useFetchRate()
const { post: createRate, loading: creatingRate } = useCreateRate()
const { put: updateRate, loading: updatingRate } = useUpdateRate()

// Load existing rate data if editing
onMounted(async () => {
    if (tariffId.value) {
        try {
            const rateData = await fetchRate({ params: { id: tariffId.value.toString() } })
            if (rateData) {
                tariff.value = {
                    class: rateData.class,
                    year: rateData.year,
                    amount: rateData.amount,
                }
            }
        } catch (error) {
            console.error("Error loading rate:", error)
        }
    }
})

const clearError = () => {
    errorMessage.value = null
}

const saveTariff = async () => {
    // Clear any previous error
    clearError()

    // Basic validation
    if (!tariff.value.class) {
        errorMessage.value = t("validation.required")
        return
    }

    if (!tariff.value.year || tariff.value.year < 1990 || tariff.value.year > 2100) {
        errorMessage.value = t("validation.min", { min: 1990 }) + " - " + t("validation.max", { max: 2100 })
        return
    }

    if (!tariff.value.amount || tariff.value.amount <= 0) {
        errorMessage.value = t("validation.min", { min: 0 })
        return
    }

    try {
        if (isNewTariff.value) {
            await createRate({
                body: {
                    class: tariff.value.class as any,
                    year: tariff.value.year,
                    amount: tariff.value.amount,
                },
            })
        } else {
            await updateRate({
                params: { id: tariffId.value! },
                body: {
                    class: tariff.value.class as any,
                    year: tariff.value.year,
                    amount: tariff.value.amount,
                },
            })
        }

        router.push({ name: "tariff-list" })
    } catch (error: any) {
        console.error("Error saving rate:", error)
        
        // Handle our standardized API errors
        if (error instanceof ApiError) {
            if (error.is(ErrorCode.DUPLICATE_ENTRY)) {
                errorMessage.value = `Un tarif pour la classe ${tariff.value.class} et l'année ${tariff.value.year} existe déjà.`
            } else {
                errorMessage.value = error.getLocalizedMessage(t)
            }
        } else {
            errorMessage.value = t("errors.general")
        }
    }
}
</script>
