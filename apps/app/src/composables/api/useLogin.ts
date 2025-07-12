import { loginSchema, type UserResponse } from "@beg/validations"
import { usePost } from "./useAPI"

export const useLogin = () => {
    return usePost<
        { token: string; user: UserResponse },
        {
            body: typeof loginSchema
        }
    >("user/login", {
        body: loginSchema,
    })
}
