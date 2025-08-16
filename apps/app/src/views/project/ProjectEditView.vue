<template>
    <FormLayout
        :title="isNewProject ? $t('projects.new') : $t('projects.edit')"
        :loading="isSubmitting"
        :error-message="errorMessage"
    >
        <form @submit.prevent="saveProject" id="projectForm">
            <!-- Basic Information -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <FormField :label="$t('projects.mandat')" :error="errors.Mandat">
                    <template #input>
                        <Input type="text" v-model="project.Mandat" required />
                    </template>
                </FormField>

                <FormField :label="$t('projects.date')" :error="errors.Début">
                    <template #input>
                        <Input type="date" v-model="formattedDate" required />
                    </template>
                </FormField>
            </div>

            <!-- Project Designation -->
            <div class="mb-6">
                <FormField :label="$t('projects.designation')" :error="errors.Désignation" required>
                    <template #input>
                        <Input type="text" v-model="project.Désignation" required />
                    </template>
                </FormField>
            </div>

            <!-- Additional Details -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <FormField :label="$t('projects.locality')" :error="errors.IDlocalité">
                    <template #input>
                        <Input type="number" v-model.number="project.IDlocalité" />
                    </template>
                </FormField>

                <FormField :label="$t('projects.client')" :error="errors.IDmandant">
                    <template #input>
                        <Select v-model="project.IDmandant" :options="[]" />
                    </template>
                </FormField>

                <FormField :label="$t('projects.engineer')" :error="errors.IDingénieur">
                    <template #input>
                        <Select v-model="project.IDingénieur" :options="[]" />
                    </template>
                </FormField>
            </div>

            <!-- Billing and Type -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <FormField :label="$t('projects.enterprise')" :error="errors.IDentreprise">
                    <template #input>
                        <Select v-model="project.IDentreprise" :options="[]" />
                    </template>
                </FormField>

                <FormField :label="$t('projects.type')" :error="errors.IDtype">
                    <template #input>
                        <Select v-model="project.IDtype" :options="[]" />
                    </template>
                </FormField>
            </div>

            <!-- Responsable -->
            <div class="mb-6">
                <FormField :label="$t('projects.responsible')" :error="errors.Responsable">
                    <template #input>
                        <Input type="text" v-model="project.Responsable" />
                    </template>
                </FormField>
            </div>

            <!-- Invoice Address -->
            <div class="mb-6">
                <FormField :label="$t('projects.invoice')" :error="errors.Facture">
                    <template #input>
                        <textarea
                            v-model="project.Facture"
                            rows="4"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        ></textarea>
                    </template>
                </FormField>
            </div>

            <!-- Remark -->
            <div class="mb-6">
                <FormField :label="$t('projects.remark')" :error="errors.Remarque">
                    <template #input>
                        <textarea
                            v-model="project.Remarque"
                            rows="3"
                            class="w-full p-2 border border-gray-300 rounded-md"
                        ></textarea>
                    </template>
                </FormField>
            </div>
        </form>

        <template #actions>
            <Button variant="secondary" type="button" :to="{ name: 'project-list' }">
                {{ $t("common.cancel") }}
            </Button>
            <Button variant="primary" type="submit" form="projectForm" :disabled="isSubmitting">
                {{ $t("common.save") }}
            </Button>
        </template>
    </FormLayout>
</template>

<script setup lang="ts">
import { ref, computed } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import Button from "@/components/atoms/Button.vue"
import FormField from "@/components/molecules/FormField.vue"
import FormLayout from "@/components/templates/FormLayout.vue"
import Input from "@/components/atoms/Input.vue"
import Select from "@/components/atoms/Select.vue"

const { t } = useI18n()
const route = useRoute()
const router = useRouter()

// Determine if we're creating a new project or editing an existing one
const projectId = computed(() => (route.params.id ? parseInt(route.params.id as string) : null))
const isNewProject = computed(() => !projectId.value)
const isSubmitting = ref(false)

// Define the project structure based on Mandats.json
interface MandatProject {
    IDmandat?: number
    Mandat?: number
    Début?: string
    Désignation?: string
    IDlocalité?: number
    IDmandant?: number
    Facture?: string
    IDingénieur?: number
    IDentreprise?: number
    IDtype?: number
    Responsable?: string
    Remarque?: string
    Imprimer?: number
    Etat?: string
    "Sous-mandat"?: string
    Note?: string
}

// Form validation errors
const errors = ref<Record<string, string>>({})
const errorMessage = ref<string | null>(null)

// Initialize project with default values
const project = ref<MandatProject>({
    IDmandat: projectId.value || undefined,
    Mandat: 9591,
    Début: "03/10/25 00:00:00",
    Désignation: "Falaise Pont de la Sionne, Sion",
    IDlocalité: 195,
    IDmandant: 163,
    Facture:
        "Commune de Sion, Travaux publics et Environnement, Rue de Lausanne 23, \nCase postale 2272, 1950 Sion 2",
    IDingénieur: 217,
    IDentreprise: 1,
    IDtype: 43,
    Responsable: "md",
    Imprimer: 0,
    Etat: "-",
})

// Handle date formatting
const formattedDate = computed({
    get: () => {
        if (!project.value.Début) return ""
        try {
            // Convert from MM/DD/YY format to YYYY-MM-DD
            const parts = project.value.Début.split(" ")[0].split("/")
            if (parts.length !== 3) return ""
            const month = parts[0].padStart(2, "0")
            const day = parts[1].padStart(2, "0")
            const year = `20${parts[2]}`
            return `${year}-${month}-${day}`
        } catch (e) {
            return ""
        }
    },
    set: (value: string) => {
        if (!value) return
        // Convert from YYYY-MM-DD to MM/DD/YY format
        const date = new Date(value)
        const month = (date.getMonth() + 1).toString().padStart(2, "0")
        const day = date.getDate().toString().padStart(2, "0")
        const year = date.getFullYear().toString().substring(2)
        project.value.Début = `${month}/${day}/${year} 00:00:00`
    },
})

// Computed property for imprimer checkbox
const printValue = computed({
    get: () => !!project.value.Imprimer,
    set: (value: boolean) => {
        project.value.Imprimer = value ? 1 : 0
    },
})

// Save project function
const saveProject = async () => {
    // Reset errors
    errors.value = {}
    errorMessage.value = null

    // Basic validation
    if (!project.value.Désignation) {
        errors.value.Désignation = t("validation.required")
        errorMessage.value = t("validation.pleaseFillRequired")
        return
    }

    try {
        isSubmitting.value = true

        // In a real app, this would be a POST/PUT request to save the project
        console.log("Saving project:", project.value)

        // Simulate API call with a delay
        await new Promise((resolve) => setTimeout(resolve, 800))

        // Redirect to project list after saving
        router.push({ name: "project-list" })
    } catch (error) {
        console.error("Error saving project:", error)
        errorMessage.value = t("errors.general")
    } finally {
        isSubmitting.value = false
    }
}
</script>
