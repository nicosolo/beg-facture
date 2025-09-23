<template>
    <Dialog
        v-model="isOpen"
        :title="isNewMonthlyHours ? $t('monthlyHours.new') : $t('monthlyHours.edit')"
    >
        <form @submit.prevent="saveMonthlyHours" class="space-y-6">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label for="year" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t("monthlyHours.year") }} *
                    </label>
                    <Input
                        id="year"
                        :model-value="monthlyHours.year?.toString()"
                        @update:model-value="monthlyHours.year = parseInt($event) || 0"
                        type="number"
                        required
                        min="2000"
                        max="2100"
                        :placeholder="new Date().getFullYear().toString()"
                    />
                </div>
                <div>
                    <label for="month" class="block text-sm font-medium text-gray-700 mb-1">
                        {{ $t("monthlyHours.month") }} *
                    </label>
                    <Select v-model="monthlyHours.month" :options="monthOptions" required />
                </div>
            </div>
            <div>
                <label for="amountOfHours" class="block text-sm font-medium text-gray-700 mb-1">
                    {{ $t("monthlyHours.hours") }} *
                </label>
                <Input
                    id="amountOfHours"
                    :model-value="monthlyHours.amountOfHours?.toString()"
                    @update:model-value="monthlyHours.amountOfHours = parseFloat($event) || 0"
                    type="number"
                    step="0.1"
                    required
                    min="0"
                    :placeholder="$t('monthlyHours.hoursPlaceholder')"
                />
            </div>
        </form>

        <template #footer>
            <Button variant="secondary" @click="closeModal" :disabled="saving">
                {{ $t("common.cancel") }}
            </Button>
            <Button
                variant="primary"
                @click="saveMonthlyHours"
                :disabled="!isFormValid"
                :loading="saving"
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
import Select from "@/components/atoms/Select.vue"
import {
    useFetchMonthlyHours,
    useCreateMonthlyHours,
    useUpdateMonthlyHours,
} from "@/composables/api/useMonthlyHours"
import { useAlert } from "@/composables/utils/useAlert"
import type { MonthlyHoursCreateInput, MonthlyHoursUpdateInput } from "@beg/validations"

interface Props {
    modelValue: boolean
    monthlyHoursId?: number | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
    "update:modelValue": [value: boolean]
    saved: []
}>()

const { t } = useI18n()
const { successAlert, errorAlert } = useAlert()

// Month options
const monthOptions = computed(() => {
    return Array.from({ length: 12 }, (_, i) => ({
        value: i + 1,
        label: t(`common.months.${i + 1}`),
    }))
})

// Computed
const isOpen = computed({
    get: () => props.modelValue,
    set: (value) => emit("update:modelValue", value),
})
const isNewMonthlyHours = computed(() => !props.monthlyHoursId)

// Form validation
const isFormValid = computed(() => {
    return (
        monthlyHours.value.year &&
        monthlyHours.value.year >= 2000 &&
        monthlyHours.value.year <= 2100 &&
        monthlyHours.value.month &&
        monthlyHours.value.month >= 1 &&
        monthlyHours.value.month <= 12 &&
        monthlyHours.value.amountOfHours &&
        monthlyHours.value.amountOfHours > 0
    )
})

// API composables
const { get: fetchMonthlyHours, loading: fetching } = useFetchMonthlyHours()
const { post: createMonthlyHours, loading: creating } = useCreateMonthlyHours()
const { put: updateMonthlyHours, loading: updating } = useUpdateMonthlyHours()

// State
const saving = computed(() => creating.value || updating.value || fetching.value)
const monthlyHours = ref<MonthlyHoursCreateInput>({
    year: new Date().getFullYear(),
    month: new Date().getMonth() + 1,
    amountOfHours: 160,
})

// Load monthly hours data if editing
const loadMonthlyHoursData = async () => {
    if (!props.monthlyHoursId) {
        // Reset form for new monthly hours
        monthlyHours.value = {
            year: new Date().getFullYear(),
            month: new Date().getMonth() + 1,
            amountOfHours: 160,
        }
        return
    }

    try {
        const data = await fetchMonthlyHours({ params: { id: props.monthlyHoursId } })
        if (data) {
            monthlyHours.value = {
                year: data.year,
                month: data.month,
                amountOfHours: data.amountOfHours,
            }
        }
    } catch (error) {
        console.error("Error loading monthly hours:", error)
        closeModal()
    }
}

// Save monthly hours
const saveMonthlyHours = async () => {
    if (!isFormValid.value) {
        errorAlert(t("validation.invalidForm"))
        return
    }

    if (isNewMonthlyHours.value) {
        await createMonthlyHours({ body: monthlyHours.value })
        successAlert(t("monthlyHours.createSuccess"))
    } else if (props.monthlyHoursId) {
        await updateMonthlyHours({
            params: { id: props.monthlyHoursId },
            body: monthlyHours.value as MonthlyHoursUpdateInput,
        })
        successAlert(t("monthlyHours.updateSuccess"))
    }

    emit("saved")
    closeModal()
}

// Close modal
const closeModal = () => {
    isOpen.value = false
}

// Watch for modal open/close
watch(isOpen, (newValue) => {
    if (newValue) {
        loadMonthlyHoursData()
    }
})
</script>
