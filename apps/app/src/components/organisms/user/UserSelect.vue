<template>
    <div class="relative">
        <input
            v-model="searchTerm"
            :placeholder="placeholder || $t('common.selectUser')"
            :disabled="disabled"
            :required="required"
            @input="handleInput"
            @focus="handleFocus"
            @blur="handleBlur"
            @keydown="handleKeyDown"
            :ref="(el) => (inputRef = el as HTMLInputElement)"
            :class="[
                'w-full px-3 py-2 border rounded-md outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500',
                disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white',
                className,
            ]"
        />

        <!-- Loading spinner -->
        <div v-if="loading" class="absolute right-2 top-1/2 transform -translate-y-1/2">
            <LoadingSpinner size="md" color="gray" />
        </div>

        <!-- Dropdown -->
        <div
            v-if="showDropdown"
            class="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-md shadow-lg max-h-60 overflow-auto"
        >
            <!-- No results -->
            <div
                v-if="filteredUsers.length === 0 && searchTerm.length > 0"
                class="px-3 py-2 text-gray-500"
            >
                {{ $t("common.noResults") }}
            </div>

            <!-- User options -->
            <button
                v-for="(user, index) in filteredUsers"
                :key="user.id"
                @mousedown.prevent="selectUser(user)"
                @mouseenter="focusedIndex = index"
                :class="[
                    'w-full px-3 py-2 text-left focus:outline-none',
                    focusedIndex === index ? 'bg-gray-100' : 'hover:bg-gray-100',
                ]"
            >
                <div class="font-medium">
                    {{ user.initials }} - {{ user.firstName }} {{ user.lastName }}
                </div>
                <div v-if="user.archived" class="text-sm text-gray-500">
                    {{ $t("common.archived") }}
                </div>
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick } from "vue"
import { useI18n } from "vue-i18n"
import { useFetchUsers } from "../../../composables/api/useUser"
import LoadingSpinner from "@/components/atoms/LoadingSpinner.vue"
import type { UserResponse } from "@beg/validations"

interface UserSelectProps {
    modelValue: number | undefined
    placeholder?: string
    disabled?: boolean
    className?: string
    showArchived?: boolean
    required?: boolean
}

const props = defineProps<UserSelectProps>()

const emit = defineEmits<{
    "update:modelValue": [value: number | undefined]
}>()

const {} = useI18n()
const { loading, data: users, get } = useFetchUsers()

// State
const searchTerm = ref("")
const showDropdown = ref(false)
const selectedUserName = ref("")
const focusedIndex = ref(0)
const inputRef = ref<HTMLInputElement>()

// Filter and sort users based on search term
const filteredUsers = computed<UserResponse[]>(() => {
    if (!users.value) return []

    let filtered = users.value.filter((user) => {
        if (!props.showArchived && user.archived) return false
        return true
    })

    if (searchTerm.value.trim()) {
        const search = searchTerm.value.toLowerCase().trim()

        filtered = filtered.filter((user) => {
            const fullName = `${user.firstName} ${user.lastName}`.toLowerCase()
            const initials = user.initials.toLowerCase()

            return initials.includes(search) || fullName.includes(search)
        })

        // Sort results: initials matches first, then alphabetically
        filtered.sort((a, b) => {
            const search = searchTerm.value.toLowerCase().trim()
            const aInitialsMatch = a.initials.toLowerCase().includes(search)
            const bInitialsMatch = b.initials.toLowerCase().includes(search)

            if (aInitialsMatch && !bInitialsMatch) return -1
            if (!aInitialsMatch && bInitialsMatch) return 1

            // If both match initials or both don't, sort by initials
            return a.initials.localeCompare(b.initials)
        })
    } else {
        // When no search, sort by initials
        filtered.sort((a, b) => a.initials.localeCompare(b.initials))
    }

    return filtered
})

// Handle input
const handleInput = async (e: InputEvent) => {
    selectedUserName.value = ""
    focusedIndex.value = 0
    showDropdown.value = true

    // Clear the modelValue when user starts typing
    if (props.modelValue) {
        emit("update:modelValue", undefined)
        await nextTick()
        searchTerm.value = e.data || ""
    }
}

// Handle focus
const handleFocus = () => {
    showDropdown.value = true
}

// Handle keyboard navigation
const handleKeyDown = (event: KeyboardEvent) => {
    switch (event.key) {
        case "ArrowDown":
            event.preventDefault()
            if (!showDropdown.value) {
                showDropdown.value = true
            } else if (filteredUsers.value.length > 0) {
                focusedIndex.value = Math.min(
                    focusedIndex.value + 1,
                    filteredUsers.value.length - 1
                )
            }
            break
        case "ArrowUp":
            event.preventDefault()
            if (showDropdown.value && filteredUsers.value.length > 0) {
                focusedIndex.value = Math.max(focusedIndex.value - 1, 0)
            }
            break
        case "Enter":
            event.preventDefault()
            if (showDropdown.value && filteredUsers.value[focusedIndex.value]) {
                selectUser(filteredUsers.value[focusedIndex.value])
            }
            break
        case "Escape":
            event.preventDefault()
            if (showDropdown.value) {
                showDropdown.value = false
                focusedIndex.value = 0
            }
            break
    }
}

// Handle blur
const handleBlur = () => {
    // Delay to allow click on dropdown items
    setTimeout(() => {
        showDropdown.value = false
        focusedIndex.value = 0
    }, 200)
}

// Select user
const selectUser = (user: UserResponse) => {
    selectedUserName.value = `${user.initials} - ${user.firstName} ${user.lastName}`
    searchTerm.value = selectedUserName.value
    emit("update:modelValue", user.id)
    inputRef.value?.blur()
    showDropdown.value = false
    focusedIndex.value = 0
}

// Load initial user if modelValue is set
const loadInitialUser = () => {
    if (props.modelValue && users.value) {
        const user = users.value.find((u) => u.id === props.modelValue)
        if (user) {
            selectedUserName.value = `${user.initials} - ${user.firstName} ${user.lastName}`
            searchTerm.value = selectedUserName.value
        }
    }
}

// Watch for modelValue changes
watch(
    () => props.modelValue,
    async (newValue) => {
        if (!newValue) {
            selectedUserName.value = ""
            searchTerm.value = ""
        } else {
            loadInitialUser()
        }
    }
)

// Watch for users data changes
watch(users, () => {
    loadInitialUser()
})

onMounted(() => {
    get()
})
</script>
