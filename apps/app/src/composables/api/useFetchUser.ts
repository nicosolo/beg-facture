import type { User } from "@beg/types"
import { convertUserFilterToInput, userFilterSchema } from "@beg/validations"
import { useAPI } from "./useAPI"

export function useFetchUser() {
    return useAPI<typeof userFilterSchema, User[]>(
        "user",
        userFilterSchema,
        convertUserFilterToInput
    )
}
