import { loginSchema, type UserResponseSchema } from "@beg/validations"
import { useAPI } from "./useAPI"
export const useLogin = () => {
    return useAPI<typeof loginSchema, { token: string; user: UserResponseSchema }>(
        "user/login",
        loginSchema
    )
}
