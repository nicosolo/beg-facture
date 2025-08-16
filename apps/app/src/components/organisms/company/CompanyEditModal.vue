<template>
    <Dialog v-model="isOpen" :title="isNewCompany ? $t('company.new') : $t('company.edit')">
        <form @submit.prevent="saveCompany" class="space-y-6">
            <div>
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                    {{ $t("company.name") }} *
                </label>
                <Input
                    id="name"
                    v-model="company.name"
                    type="text"
                    required
                    :placeholder="$t('company.namePlaceholder')"
                />
            </div>
        </form>

        <template #footer>
            <Button
                variant="primary"
                @click="saveCompany"
                :disabled="saving || !company.name"
            >
                {{ saving ? $t("common.saving") : $t("common.save") }}
            </Button>
            <Button
                variant="secondary"
                @click="closeModal"
                :disabled="saving"
            >
                {{ $t("common.cancel") }}
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
import { useFetchCompany, useCreateCompany, useUpdateCompany } from "@/composables/api/useCompany"
import { useAlert } from "@/composables/utils/useAlert"
import type { CompanyCreateInput, CompanyUpdateInput } from "@beg/validations"

interface Props {
    modelValue: boolean
    companyId?: number | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
    "update:modelValue": [value: boolean]
    saved: []
}>()

const { t } = useI18n()
const { successAlert, errorAlert } = useAlert()

// Computed
const isOpen = computed({
    get: () => props.modelValue,
    set: (value) => emit("update:modelValue", value),
})
const isNewCompany = computed(() => !props.companyId)

// API composables
const { get: fetchCompany } = useFetchCompany()
const { post: createCompany } = useCreateCompany()
const { put: updateCompany } = useUpdateCompany()

// State
const saving = ref(false)
const company = ref<CompanyCreateInput>({
    name: "",
})

// Load company data if editing
const loadCompanyData = async () => {
    if (!props.companyId) {
        // Reset form for new company
        company.value = {
            name: "",
        }
        return
    }

    try {
        const data = await fetchCompany({ params: { id: props.companyId } })
        if (data) {
            company.value = {
                name: data.name,
            }
        }
    } catch (error) {
        console.error("Error loading company:", error)
        errorAlert(t("errors.loadFailed"))
        closeModal()
    }
}

// Save company
const saveCompany = async () => {
    if (!company.value.name) {
        errorAlert(t("validation.required", { field: t("company.name") }))
        return
    }

    saving.value = true

    try {
        if (isNewCompany.value) {
            await createCompany({ body: company.value })
            successAlert(t("company.createSuccess"))
        } else if (props.companyId) {
            await updateCompany({
                params: { id: props.companyId },
                body: company.value as CompanyUpdateInput,
            })
            successAlert(t("company.updateSuccess"))
        }

        emit("saved")
        closeModal()
    } catch (error: any) {
        console.error("Error saving company:", error)
        errorAlert(error.message || t("errors.saveFailed"))
    } finally {
        saving.value = false
    }
}

// Close modal
const closeModal = () => {
    isOpen.value = false
}

// Watch for modal open/close
watch(isOpen, (newValue) => {
    if (newValue) {
        loadCompanyData()
    }
})</script>