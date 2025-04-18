<template>
    <div class="bg-white p-4 border border-gray-200 rounded-lg mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <!-- Collaborateur Filter -->
            <div class="form-group">
                <Label>Collaborateur</Label>
                <Select
                    v-model="collaborateur"
                    :options="[
                        { label: 'Tous les collaborateurs', value: '' },
                        { label: 'Michael Digout', value: '9' },
                        { label: 'Jérémie Pralong', value: '22' },
                        { label: 'Jacques Bechet', value: '25' },
                    ]"
                ></Select>
            </div>

            <!-- Project Filter -->
            <div class="form-group">
                <Label>Projet</Label>
                <Select
                    v-model="project"
                    :options="[
                        { label: 'Tous les projets', value: '' },
                        { label: 'Projet BEG', value: '1502' },
                        { label: 'Jaugeage fluo', value: '3485' },
                        { label: 'Carte intensité', value: '3701' },
                        { label: 'Carte phénomènes', value: '3875' },
                        { label: 'Trajectographie', value: '4205' },
                    ]"
                ></Select>
            </div>

            <!-- Activity Filter -->
            <div class="form-group">
                <Label>Activité</Label>
                <Select
                    v-model="activity"
                    :options="[
                        { label: 'Toutes les activités', value: '' },
                        { label: 'Rapport', value: '2' },
                        { label: 'Traitement de données', value: '4' },
                        { label: 'Réunion, séance', value: '6' },
                        { label: 'Autre activité', value: '12' },
                    ]"
                ></Select>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
            <!-- Date From -->
            <DateField label="Date de début" v-model="dateFrom" />

            <!-- Date To -->
            <DateField label="Date de fin" v-model="dateTo" />

            <!-- Invoice Status -->
            <div class="form-group">
                <Label>Statut de facturation</Label>
                <Select
                    v-model="status"
                    :options="[
                        { label: 'Tous', value: '' },
                        { label: 'Facturé', value: '1' },
                        { label: 'Non facturé', value: '0' },
                    ]"
                ></Select>
            </div>
        </div>

        <div class="flex mt-4">
            <Button @click="resetFilters" variant="secondary"> Réinitialiser les filtres </Button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from "vue"
import Label from "../atoms/Label.vue"
import Select from "../atoms/Select.vue"
import Button from "../atoms/Button.vue"
import DateField from "../molecules/DateField.vue"

export interface TimeFilters {
    collaborateur: string
    project: string
    activity: string
    dateFrom?: Date
    dateTo?: Date
    status: string
}

interface Props {
    modelValue?: TimeFilters
}

const props = defineProps<Props>()

const emit = defineEmits<{
    (e: "update:modelValue", value: TimeFilters): void
    (e: "reset"): void
}>()

// Internal state for filters
const collaborateur = ref(props.modelValue?.collaborateur || "")
const project = ref(props.modelValue?.project || "")
const activity = ref(props.modelValue?.activity || "")
const dateFrom = ref<Date | undefined>(props.modelValue?.dateFrom)
const dateTo = ref<Date | undefined>(props.modelValue?.dateTo)
const status = ref(props.modelValue?.status || "")

// Watch for changes in filters and emit update
watch([collaborateur, project, activity, dateFrom, dateTo, status], () => {
    const filters: TimeFilters = {
        collaborateur: collaborateur.value,
        project: project.value,
        activity: activity.value,
        dateFrom: dateFrom.value,
        dateTo: dateTo.value,
        status: status.value,
    }
    emit("update:modelValue", filters)
})

// Reset filters function
const resetFilters = () => {
    collaborateur.value = ""
    project.value = ""
    activity.value = ""
    dateFrom.value = undefined
    dateTo.value = undefined
    status.value = ""
    emit("reset")
}
</script>
