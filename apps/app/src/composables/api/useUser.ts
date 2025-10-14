import {
    idParamSchema,
    userFilterSchema,
    userCreateSchema,
    userUpdateSchema,
    type UserResponse,
    type UserDetailResponse,
} from "@beg/validations"
import { useGet, usePost, usePut } from "./useAPI"

export function useFetchUser() {
    return useGet<UserDetailResponse>("user/:id", {
        params: idParamSchema,
    })
}

export function useFetchUsers() {
    return useGet<
        UserResponse[],
        {
            query: typeof userFilterSchema
        }
    >("user", {
        query: userFilterSchema,
    })
}

export function useCreateUser() {
    return usePost<
        UserResponse,
        {
            body: typeof userCreateSchema
        }
    >("user", {
        body: userCreateSchema,
    })
}

export function useUpdateUser() {
    return usePut<
        UserResponse,
        {
            params: typeof idParamSchema
            body: typeof userUpdateSchema
        }
    >("user/:id", {
        params: idParamSchema,
        body: userUpdateSchema,
    })
}
