<template>
    <AutocompleteSelect
        :model-value="modelValue"
        mode="static"
        :options="filteredUsersByArchived"
        :display-field="formatUserDisplay"
        :filter-function="filterUsers"
        :placeholder="placeholder || $t('common.selectUser')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event as number | undefined)"
    />
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchUsers } from "@/composables/api/useUser"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import type { UserResponse } from "@beg/validations"

interface UserSelectProps {
    modelValue: number | undefined
    placeholder?: string
    disabled?: boolean
    className?: string
    showArchived?: boolean
    required?: boolean
}

const props = withDefaults(defineProps<UserSelectProps>(), {
    showArchived: false,
})

defineEmits<{
    "update:modelValue": [value: number | undefined]
}>()

const {} = useI18n()
const { data: users, get } = useFetchUsers()

// Format user display with archived indicator
const formatUserDisplay = (user: UserResponse): string => {
    const base = `${user.initials} - ${user.firstName} ${user.lastName}`
    return user.archived ? `${base} (${useI18n().t("common.archived")})` : base
}

// Pre-filter users based on archived status
const filteredUsersByArchived = computed(() => {
    if (!users.value) return []

    return users.value.filter((user) => {
        if (!props.showArchived && user.archived) return false
        return true
    })
})

// Custom filter function that searches in initials and full name
const filterUsers = (user: UserResponse, searchText: string): boolean => {
    const search = searchText.toLowerCase()
    const fullName = `${user.firstName} ${user.lastName}`.toLowerCase()
    const initials = user.initials.toLowerCase()

    // Check if search matches initials or full name
    const matches = initials.includes(search) || fullName.includes(search)

    if (!matches) return false

    // For sorting, we'll rely on the array order which is set when data is loaded
    return true
}

// Sort users when data is loaded
const sortUsers = () => {
    if (users.value) {
        users.value.sort((a, b) => a.initials.localeCompare(b.initials))
    }
}

onMounted(() => {
    get().then(() => {
        sortUsers()
    })
})
</script>
