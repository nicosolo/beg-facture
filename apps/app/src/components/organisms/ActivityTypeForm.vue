<template>
    <form @submit.prevent="handleSubmit" class="space-y-4">
        <div>
            <label for="name" class="block text-sm font-medium text-gray-700 mb-1"> Nom </label>
            <input
                id="name"
                v-model="formData.name"
                type="text"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Ex: Développement, Support, Formation..."
            />
        </div>

        <div>
            <label for="code" class="block text-sm font-medium text-gray-700 mb-1"> Code </label>
            <input
                id="code"
                v-model="formData.code"
                type="text"
                required
                maxlength="10"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Ex: DEV, SUP, FORM..."
            />
        </div>

        <div>
            <label class="flex items-center">
                <input
                    v-model="formData.billable"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <span class="ml-2 text-sm font-medium text-gray-700"> Facturable </span>
            </label>
            <p class="text-xs text-gray-500 mt-1">
                Cochez si ce type d'activité peut être facturé aux clients
            </p>
        </div>

        <div class="flex justify-end gap-2 pt-4">
            <Button type="button" variant="secondary" @click="$emit('cancel')" :disabled="loading">
                Annuler
            </Button>
            <Button
                type="submit"
                variant="primary"
                :disabled="loading || !isFormValid"
                :loading="loading"
            >
                {{ $t("common.save") }}
            </Button>
        </div>
    </form>
</template>

<script setup lang="ts">
import { ref, computed, watch } from "vue"
import Button from "@/components/atoms/Button.vue"
import type { ActivityTypeResponse } from "@beg/validations"

interface Props {
    activityType?: ActivityTypeResponse | null
    loading?: boolean
}

const props = defineProps<Props>()

const emit = defineEmits<{
    submit: [data: { name: string; code: string; billable: boolean }]
    cancel: []
}>()

const formData = ref({
    name: "",
    code: "",
    billable: false,
})

const isFormValid = computed(() => {
    return formData.value.name.trim() !== "" && formData.value.code.trim() !== ""
})

const handleSubmit = () => {
    if (isFormValid.value) {
        emit("submit", {
            name: formData.value.name.trim(),
            code: formData.value.code.trim().toUpperCase(),
            billable: formData.value.billable,
        })
    }
}

// Initialize form data when activityType prop changes
watch(
    () => props.activityType,
    (newActivityType) => {
        if (newActivityType) {
            formData.value = {
                name: newActivityType.name || "",
                code: newActivityType.code || "",
                billable: newActivityType.billable || false,
            }
        } else {
            // Reset form for new activity type
            formData.value = {
                name: "",
                code: "",
                billable: false,
            }
        }
    },
    { immediate: true }
)
</script>
