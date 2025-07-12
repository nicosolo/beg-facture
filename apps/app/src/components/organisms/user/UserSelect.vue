<template>
    <div>
        <LoadingOverlay :loading="loading">
            <Select
                v-model="selectedUser"
                :options="userOptions"
                :disabled="disabled"
                :className="className"
            ></Select>
        </LoadingOverlay>
    </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import Select from "../../atoms/Select.vue"
import { useFetchUsers } from "../../../composables/api/useUser"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
import type { UserResponse } from "@beg/validations"
interface UserSelectProps {
    modelValue: number | undefined
    placeholder?: string
    disabled?: boolean
    className?: string
    showArchived?: boolean
}

const { modelValue, disabled, className, placeholder } = defineProps<UserSelectProps>()

const emit = defineEmits<{
    (e: "update:modelValue", value: number | undefined): void
}>()

const { t } = useI18n()
const { loading, data: users, get } = useFetchUsers()

const selectedUser = computed({
    get: () => {
        return modelValue !== undefined ? modelValue : ""
    },
    set: (value: string | number | boolean) => {
        emit("update:modelValue", value === "" ? undefined : Number(value))
    },
})

// Filter users based on showArchived prop
const filteredUsers = computed<UserResponse[]>(() => {
    return users.value ? users.value?.filter(() => true) : []
})

// Transform users into select options for mobile view
const userOptions = computed(() => {
    return [
        { label: placeholder || t("common.selectUser"), value: "" },
        ...filteredUsers.value.map((user: UserResponse) => ({
            label: `${user.initials}`,
            value: user.id,
        })),
    ]
})

onMounted(() => {
    get({ active: true })
})
</script>
