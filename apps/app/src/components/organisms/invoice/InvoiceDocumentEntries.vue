<template>
    <div class="mb-4">
        <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-gray-700">
                {{ title }}
            </h3>
            <button
                type="button"
                class="px-2 py-1 text-sm font-medium text-white bg-blue-600 rounded hover:bg-blue-700"
                @click="addEntry"
            >
                + {{ addButtonLabel }}
            </button>
        </div>

        <div class="border border-gray-300 rounded">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">
                            {{ t("invoice.documents.headers.file") }}
                        </th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">
                            {{ t("invoice.documents.headers.date") }}
                        </th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">
                            {{ t("invoice.documents.headers.amount") }}
                        </th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">
                            {{ t("invoice.documents.headers.remark") }}
                        </th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">
                            {{ t("common.actions") }}
                        </th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <tr v-if="!entries.length">
                        <td class="px-4 py-3 text-sm text-gray-500" colspan="5">
                            {{ emptyStateLabel }}
                        </td>
                    </tr>
                    <tr v-for="(entry, index) in entries" :key="index">
                        <td class="px-4 py-2 text-sm text-gray-900">
                            <div class="flex items-center gap-2">
                                <button
                                    type="button"
                                    class="px-2 py-1 text-xs font-medium text-blue-600 border border-blue-200 rounded hover:bg-blue-50"
                                    @click="triggerFileInput(index)"
                                >
                                    <span v-if="entry.file">
                                        {{ t("invoice.documents.actions.replace") }}
                                    </span>
                                    <span v-else>
                                        {{ t("invoice.documents.actions.upload") }}
                                    </span>
                                </button>
                                <span v-if="entry.file" class="text-xs text-gray-700 truncate max-w-[160px]">
                                    {{ entry.file }}
                                </span>
                                <button
                                    v-if="entry.file"
                                    type="button"
                                    class="text-xs text-red-600 hover:text-red-700"
                                    @click="clearFile(index)"
                                >
                                    {{ t("common.remove") }}
                                </button>
                            </div>
                            <input
                                type="file"
                                class="hidden"
                                :accept="accept"
                                :ref="(el) => setFileInputRef(el, index)"
                                @change="(event) => onFileChange(index, event)"
                            />
                        </td>
                        <td class="px-4 py-2 text-sm text-gray-900">
                            <Input
                                type="date"
                                :modelValue="formatDateValue(entry.date)"
                                @update:modelValue="(value) => updateEntry(index, 'date', value)"
                            />
                        </td>
                        <td class="px-4 py-2 text-sm text-gray-900">
                            <Input
                                type="number"
                                :modelValue="formatAmount(entry.amount)"
                                @update:modelValue="(value) => updateEntry(index, 'amount', value)"
                            />
                        </td>
                        <td class="px-4 py-2 text-sm text-gray-900">
                            <Input
                                type="text"
                                :modelValue="entry.remark || ''"
                                @update:modelValue="(value) => updateEntry(index, 'remark', value)"
                            />
                        </td>
                        <td class="px-4 py-2 text-sm text-gray-900">
                            <button
                                type="button"
                                class="text-xs text-red-600 hover:text-red-700"
                                @click="removeEntry(index)"
                            >
                                {{ t("invoice.documents.actions.delete") }}
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue"
import { useI18n } from "vue-i18n"
import Input from "@/components/atoms/Input.vue"

export interface InvoiceDocumentEntry {
    file: string
    date?: string | Date | null
    amount?: number | null
    remark?: string | null
}

const props = defineProps<{
    title: string
    addButtonLabel: string
    emptyStateLabel: string
    entryType: "offer" | "adjudication"
    modelValue: InvoiceDocumentEntry[]
    accept?: string
}>()

const emit = defineEmits<{
    (e: "update:modelValue", value: InvoiceDocumentEntry[]): void
    (e: "file-change", value: { index: number; file: File | null }): void
    (e: "entry-removed", value: { index: number }): void
}>()

const { t } = useI18n()

const entries = computed({
    get: () => props.modelValue || [],
    set: (value: InvoiceDocumentEntry[]) => emit("update:modelValue", value),
})

const fileInputs = ref<HTMLInputElement[]>([])

const accept = computed(() => props.accept || ".pdf,.doc,.docx,.xls,.xlsx")

const addEntry = () => {
    entries.value = [
        ...entries.value,
        {
            file: "",
            date: "",
            amount: null,
            remark: "",
        },
    ]
}

const removeEntry = (index: number) => {
    const updated = [...entries.value]
    updated.splice(index, 1)
    entries.value = updated
    emit("file-change", { index, file: null })
    emit("entry-removed", { index })
}

const updateEntry = (index: number, field: keyof InvoiceDocumentEntry, value: unknown) => {
    const updated = [...entries.value]
    const entry = { ...updated[index] }

    if (field === "amount") {
        const parsed = typeof value === "string" ? parseFloat(value) : Number(value)
        entry.amount = Number.isFinite(parsed) ? parsed : null
    } else if (field === "date") {
        entry.date = value as string
    } else if (field === "file") {
        entry.file = (value as string) || ""
    } else if (field === "remark") {
        entry.remark = (value as string) || ""
    }

    updated[index] = entry
    entries.value = updated
}

const setFileInputRef = (element: HTMLInputElement | null, index: number) => {
    if (element) {
        fileInputs.value[index] = element
    }
}

const triggerFileInput = (index: number) => {
    const input = fileInputs.value[index]
    if (input) {
        input.click()
    }
}

const clearFile = (index: number) => {
    updateEntry(index, "file", "")
    emit("file-change", { index, file: null })
    const input = fileInputs.value[index]
    if (input) {
        input.value = ""
    }
}

const formatDateValue = (value: InvoiceDocumentEntry["date"]) => {
    if (!value) return ""
    if (value instanceof Date) {
        return value.toISOString().split("T")[0]
    }
    return value
}

const formatAmount = (value: InvoiceDocumentEntry["amount"]) => {
    if (value === null || value === undefined) return ""
    return String(value)
}

const onFileChange = (index: number, event: Event) => {
    const input = event.target as HTMLInputElement
    const file = input.files?.[0] || null

    updateEntry(index, "file", file ? file.name : "")
    emit("file-change", { index, file })

    input.value = ""
}
</script>
