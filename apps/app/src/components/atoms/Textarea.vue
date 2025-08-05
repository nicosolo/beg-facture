<template>
    <textarea
        :value="modelValue"
        :disabled="disabled"
        :required="required"
        :placeholder="placeholder"
        :rows="rows"
        :class="[
            'w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
            disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
            className,
        ]"
        @input="handleInput"
    />
</template>

<script setup lang="ts">
interface TextareaProps {
    modelValue?: string
    disabled?: boolean
    required?: boolean
    placeholder?: string
    rows?: number
    className?: string
}

withDefaults(defineProps<TextareaProps>(), {
    rows: 3,
})

const emit = defineEmits<{
    (e: "update:modelValue", value: string): void
}>()

const handleInput = (event: Event) => {
    const target = event.target as HTMLTextAreaElement
    emit("update:modelValue", target.value)
}
</script>