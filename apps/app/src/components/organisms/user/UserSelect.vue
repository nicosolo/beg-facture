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
import type { User } from "@beg/types"
import Select from "../../atoms/Select.vue"
import { useFetchUser } from "../../../composables/api/useFetchUser"
import LoadingOverlay from "@/components/atoms/LoadingOverlay.vue"
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
const { loading, data: users, get } = useFetchUser()

const selectedUser = computed({
    get: () => {
        return modelValue !== undefined ? modelValue : ""
    },
    set: (value: string | number | boolean) => {
        emit("update:modelValue", value === "" ? undefined : Number(value))
    },
})

// Filter users based on showArchived prop
const filteredUsers = computed<User[]>(() => {
    return users.value ? users.value?.filter(() => true) : []
})

// Transform users into select options for mobile view
const userOptions = computed(() => {
    return [
        { label: placeholder || t("common.selectUser"), value: "" },
        ...filteredUsers.value.map((user: User) => ({
            label: `${user.initials}`,
            value: user.id,
        })),
    ]
})

onMounted(() => {
    get({ active: true })
})
</script>
