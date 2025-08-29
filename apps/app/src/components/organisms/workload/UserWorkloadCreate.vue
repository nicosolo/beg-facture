<template>
    <div class="p-3 bg-blue-50 rounded-md border border-blue-200">
        <h3 class="text-sm font-medium text-gray-700 mb-3">Nouvelle charge de travail</h3>
        <form @submit.prevent="createWorkload" class="space-y-3">
            <div class="grid grid-cols-3 gap-2">
                <div>
                    <label class="block text-xs text-gray-600 mb-1">Année</label>
                    <input
                        type="number"
                        v-model.number="newWorkload.year"
                        min="2000"
                        max="2100"
                        class="w-full px-2 py-1 border border-gray-300 rounded-md text-sm"
                        required
                    />
                </div>
                <div>
                    <label class="block text-xs text-gray-600 mb-1">Mois</label>
                    <select
                        v-model.number="newWorkload.month"
                        class="w-full px-2 py-1 border border-gray-300 rounded-md text-sm"
                        required
                    >
                        <option v-for="(name, index) in monthNames" :key="index" :value="index + 1">
                            {{ name }}
                        </option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs text-gray-600 mb-1">Charge (%)</label>
                    <input
                        type="number"
                        v-model.number="newWorkload.workload"
                        min="0"
                        max="100"
                        class="w-full px-2 py-1 border border-gray-300 rounded-md text-sm"
                        placeholder="Ex: 80"
                        required
                    />
                </div>
            </div>

            <div class="flex justify-end space-x-2">
                <Button type="button" variant="secondary" size="sm" @click="$emit('cancel')">
                    Annuler
                </Button>
                <Button
                    type="submit"
                    variant="primary"
                    size="sm"
                    :disabled="loading || !isValid"
                    :loading="loading"
                >
                    {{ $t("common.save") }}
                </Button>
            </div>
        </form>

        <div v-if="error" class="mt-2 text-sm text-red-600">
            {{ error }}
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from "vue"
import Button from "@/components/atoms/Button.vue"
import { useCreateWorkload } from "@/composables/api/useWorkload"
import type { WorkloadCreate, WorkloadResponse } from "@beg/validations"

const props = defineProps<{
    userId: number
}>()

const emit = defineEmits<{
    created: [workload: WorkloadResponse]
    cancel: []
}>()

const { post: postWorkload, loading } = useCreateWorkload()

const monthNames = [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre",
]

const currentDate = new Date()
const newWorkload = reactive<Omit<WorkloadCreate, "userId">>({
    year: currentDate.getFullYear(),
    month: currentDate.getMonth() + 1,
    workload: 100,
})

const error = ref<string | null>(null)

const isValid = computed(() => {
    return (
        newWorkload.year >= 2000 &&
        newWorkload.year <= 2100 &&
        newWorkload.month >= 1 &&
        newWorkload.month <= 12 &&
        newWorkload.workload >= 0 &&
        newWorkload.workload <= 100
    )
})

const createWorkload = async () => {
    error.value = null

    try {
        const result = await postWorkload({
            body: {
                ...newWorkload,
                userId: props.userId,
            },
        })

        if (result) {
            emit("created", result)
            // Reset form with next month
            const nextMonth = newWorkload.month === 12 ? 1 : newWorkload.month + 1
            const nextYear = newWorkload.month === 12 ? newWorkload.year + 1 : newWorkload.year
            newWorkload.year = nextYear
            newWorkload.month = nextMonth
            newWorkload.workload = 100
        }
    } catch (err: any) {
        error.value = err.message || "Erreur lors de la création de la charge de travail"
        console.error("Error creating workload:", err)
    }
}
</script>
