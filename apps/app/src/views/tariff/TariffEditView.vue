<template>
    <div class="container mx-auto py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">
                {{ isNewTariff ? "Nouveau tarif" : "Modifier tarif" }}
            </h1>
        </div>

        <div class="bg-white shadow-md rounded-lg p-6">
            <form @submit.prevent="saveTariff">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Classe -->
                    <div>
                        <label for="class" class="block text-sm font-medium text-gray-700 mb-1">
                            Classe
                        </label>
                        <select
                            id="class"
                            v-model="tariff.Classe"
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
                            v-model.number="tariff.Année"
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
                            v-model.number="tariff.Tarif"
                            step="5"
                            min="0"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        />
                    </div>
                </div>

                <div class="mt-8 flex justify-end space-x-3">
                    <Button variant="secondary" type="button" :to="{ name: 'tariff-list' }">
                        Annuler
                    </Button>
                    <Button variant="primary" type="submit"> Enregistrer </Button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue"
import { useRoute, useRouter } from "vue-router"
import Button from "../../components/atoms/Button.vue"

interface Tariff {
    IDtarif: number
    Classe: string
    Année: number
    Tarif: number
}

const route = useRoute()
const router = useRouter()
const tariffId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewTariff = computed(() => !tariffId.value)

// Available classes
const classes = ["A", "B", "C", "D", "E"]

// Dummy data for the form
const tariff = ref<Tariff>({
    IDtarif: tariffId.value || 0,
    Classe: "",
    Année: new Date().getFullYear(),
    Tarif: 0,
})

// If editing, let's pretend we're loading data
if (tariffId.value) {
    // Simulating data loading with dummy data
    const tariffMap: Record<number, Tariff> = {
        21: { IDtarif: 21, Classe: "A", Année: 2000, Tarif: 175 },
        30: { IDtarif: 30, Classe: "A", Année: 2001, Tarif: 180 },
        39: { IDtarif: 39, Classe: "A", Année: 2002, Tarif: 180 },
        48: { IDtarif: 48, Classe: "A", Année: 2003, Tarif: 180 },
        57: { IDtarif: 57, Classe: "A", Année: 2004, Tarif: 180 },
        66: { IDtarif: 66, Classe: "A", Année: 2005, Tarif: 195 },
        75: { IDtarif: 75, Classe: "A", Année: 2006, Tarif: 195 },
        84: { IDtarif: 84, Classe: "A", Année: 2007, Tarif: 200 },
        93: { IDtarif: 93, Classe: "A", Année: 2008, Tarif: 200 },
    }

    if (tariffId.value in tariffMap) {
        tariff.value = { ...tariffMap[tariffId.value] }
    }
}

const saveTariff = () => {
    // This is just a dummy function that would save the tariff
    console.log("Saving tariff:", tariff.value)

    // Redirect to the list page
    router.push({ name: "tariff-list" })
}
</script>
