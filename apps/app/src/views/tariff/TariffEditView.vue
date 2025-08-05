<template>
    <div class="container mx-auto py-8">
        <FormLayout
            :title="isNewTariff ? 'Nouveau tarif' : 'Modifier tarif'"
            :loading="creatingRate || updatingRate || loadingRate"
            :error-message="errorMessage"
        >
            <form @submit.prevent="saveTariff" id="tariffForm">
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

            </form>

            <template #actions>
                <Button variant="secondary" type="button" :to="{ name: 'tariff-list' }">
                    Annuler
                </Button>
                <Button
                    variant="primary"
                    type="submit"
                    form="tariffForm"
                    :disabled="creatingRate || updatingRate || loadingRate"
                >
                    {{ creatingRate || updatingRate ? "Enregistrement..." : "Enregistrer" }}
                </Button>
            </template>
        </FormLayout>
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
import FormLayout from "@/components/templates/FormLayout.vue"

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

const saveTariff = async () => {
    // Clear any previous error
    errorMessage.value = null

    // Basic validation
    if (!tariff.value.class) {
        errorMessage.value = t("validation.required")
        return
    }

    if (!tariff.value.year || tariff.value.year < 1990 || tariff.value.year > 2100) {
        errorMessage.value =
            t("validation.min", { min: 1990 }) + " - " + t("validation.max", { max: 2100 })
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
