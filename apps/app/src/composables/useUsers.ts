import { ref } from "vue"
import type { BaseUser } from "@beg/types"

export function useUsers() {
    const users = ref<BaseUser[]>([])
    const loading = ref(false)
    const error = ref<string | null>(null)

    async function fetchUsers() {}

    async function createUser(userData: BaseUser) {}

    return {
        users,
        loading,
        error,
        fetchUsers,
        createUser,
    }
}
