<template>
    <form @submit.prevent="handleSubmit" class="space-y-4">
        <div>
            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                Nom du type de mandat
            </label>
            <input
                id="name"
                v-model="formData.name"
                type="text"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Ex: Construction, Rénovation, Expertise..."
            />
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
import type { ProjectTypeSchema } from "@beg/validations"

interface Props {
    projectType?: ProjectTypeSchema | null
    loading?: boolean
}

const props = defineProps<Props>()

const emit = defineEmits<{
    submit: [data: { name: string }]
    cancel: []
}>()

const formData = ref({
    name: "",
})

const isFormValid = computed(() => {
    return formData.value.name.trim() !== ""
})

const handleSubmit = () => {
    if (isFormValid.value) {
        emit("submit", {
            name: formData.value.name.trim(),
        })
    }
}

// Initialize form data when projectType prop changes
watch(
    () => props.projectType,
    (newProjectType) => {
        if (newProjectType) {
            formData.value = {
                name: newProjectType.name || "",
            }
        } else {
            // Reset form for new project type
            formData.value = {
                name: "",
            }
        }
    },
    { immediate: true }
)
</script>
