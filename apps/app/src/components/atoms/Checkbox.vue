<template>
    <div class="flex items-center">
        <input
            type="checkbox"
            :id="id"
            :checked="modelValue"
            :disabled="disabled"
            @change="handleChange"
            class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
        />
        <label v-if="label" :for="id" class="ml-2 text-sm text-gray-700">
            {{ label }}
        </label>
    </div>
</template>

<script setup lang="ts">
interface CheckboxProps {
    modelValue: boolean
    label?: string
    id?: string
    disabled?: boolean
}

const { modelValue, label, id, disabled } = defineProps<CheckboxProps>()
const emit = defineEmits<{
    "update:modelValue": [value: boolean]
}>()

const handleChange = (event: Event) => {
    const target = event.target as HTMLInputElement
    emit("update:modelValue", target.checked)
}
</script>
