<template>
    <div v-if="multiple" class="space-y-2">
        <AutocompleteSelect
            :model-value="undefined"
            :id="id"
            mode="static"
            :options="availableUsers"
            :display-field="formatUserDisplay"
            :filter-function="filterUsers"
            :placeholder="placeholder || $t('common.selectUser')"
            :disabled="disabled"
            :required="required"
            :class-name="className"
            @update:model-value="addUser"
            :clear-on-select="true"
            :fallback="fallback"
        />
        <div class="flex flex-wrap gap-2">
            <span
                v-for="userId in modelValue as number[]"
                :key="userId"
                class="inline-flex items-center gap-1 px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm"
            >
                {{ getUserDisplay(userId) }}
                <Button type="button" @click="removeUser(userId)" variant="ghost" size="xxs">
                    <XMarkIcon class="w-5 h-5" />
                </Button>
            </span>
        </div>
    </div>
    <AutocompleteSelect
        v-else
        :model-value="(modelValue as number | undefined) ?? undefined"
        :id="id"
        mode="static"
        :options="filteredUsersByArchived"
        :display-field="formatUserDisplay"
        :filter-function="filterUsers"
        :placeholder="placeholder || $t('common.selectUser')"
        :disabled="disabled"
        :required="required"
        :class-name="className"
        @update:model-value="$emit('update:modelValue', $event as number | undefined)"
        :fallback="fallback"
    />
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchUsers } from "@/composables/api/useUser"
import AutocompleteSelect from "@/components/atoms/AutocompleteSelect.vue"
import type { UserResponse, UserRole } from "@beg/validations"
import { XMarkIcon } from "@heroicons/vue/24/outline"
import Button from "@/components/atoms/Button.vue"
interface UserSelectProps {
    modelValue: number | number[] | undefined | null
    placeholder?: string
    disabled?: boolean
    className?: string
    showArchived?: boolean
    fallback?: string
    required?: boolean
    multiple?: boolean
    id?: string
    onlyShow?: number[]
    roles?: UserRole[]
}

const props = withDefaults(defineProps<UserSelectProps>(), {
    showArchived: false,
    multiple: false,
    id: undefined,
    onlyShow: undefined,
    roles: undefined,
})

const emit = defineEmits<{
    "update:modelValue": [value: number | number[] | undefined | null]
}>()

const { t } = useI18n()
const { data: users, get } = useFetchUsers()

// Format user display with archived indicator
const formatUserDisplay = (user: UserResponse): string => {
    const base = `${user.initials} - ${user.firstName} ${user.lastName}`
    return user.archived ? `${base} (${t("common.archived")})` : base
}

// Pre-filter users based on archived status and roles
const filteredUsersByArchived = computed(() => {
    if (!users.value) return []

    return users.value.filter((user) => {
        if (props.onlyShow && !props.onlyShow.includes(user.id)) return false
        if (!props.showArchived && user.archived) return false
        if (props.roles && !props.roles.includes(user.role)) return false
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

// For multiple mode, filter out already selected users
const availableUsers = computed(() => {
    if (!props.multiple) return filteredUsersByArchived.value

    const selectedIds = new Set(Array.isArray(props.modelValue) ? props.modelValue : [])
    return filteredUsersByArchived.value.filter((user) => !selectedIds.has(user.id))
})

// Get user display name by ID
const getUserDisplay = (userId: number): string => {
    const user = users.value?.find((u) => u.id === userId)
    return user ? formatUserDisplay(user) : userId.toString()
}

// Add user to selection (multiple mode)
const addUser = (userId: string | number | null | undefined) => {
    if (userId === undefined || userId === null) return

    const currentValue = Array.isArray(props.modelValue) ? props.modelValue : []
    emit("update:modelValue", [...currentValue, parseInt(userId as string)])
}

// Remove user from selection (multiple mode)
const removeUser = (userId: number) => {
    const currentValue = Array.isArray(props.modelValue) ? props.modelValue : []
    emit(
        "update:modelValue",
        currentValue.filter((id) => id !== userId)
    )
}

onMounted(() => {
    get().then(() => {
        sortUsers()
    })
})
</script>
