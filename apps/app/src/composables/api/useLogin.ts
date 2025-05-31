import { loginSchema, type UserResponse } from "@beg/validations"
import { useAPI } from "./useAPI"

export const useLogin = () => {
    return useAPI<typeof loginSchema, { token: string; user: UserResponse }>(
        "user/login",
        loginSchema
    )
}
