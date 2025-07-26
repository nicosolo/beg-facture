<template>
    <select
        :value="modelValue ?? ''"
        :disabled="disabled"
        :class="[
            'w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
            disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
            className,
        ]"
        @change="handleChange"
    >
        <option v-for="option in options" :key="String(option.value)" :value="option.value ?? ''">
            {{ option.label }}
        </option>
    </select>
</template>

<script setup lang="ts">
export interface SelectOption {
    label: string
    value: string | number | boolean | null
}

interface SelectProps {
    modelValue?: string | number | boolean | null
    disabled?: boolean
    className?: string
    options: SelectOption[]
}

const { modelValue, disabled, className, options } = defineProps<SelectProps>()

const emit = defineEmits<{
    (e: "update:modelValue", value: string | number | boolean | null): void
}>()

const handleChange = (event: Event) => {
    const target = event.target as HTMLSelectElement
    const value = target.value

    // Find the option to get its actual value (could be null)
    const selectedOption = options.find((opt) => String(opt.value ?? "") === value)
    if (selectedOption) {
        emit("update:modelValue", selectedOption.value)
    }
}
</script>
