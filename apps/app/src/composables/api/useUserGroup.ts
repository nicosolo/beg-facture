import {
    idParamSchema,
    userGroupFilterSchema,
    userGroupCreateSchema,
    userGroupUpdateSchema,
    type UserGroupResponse,
    type PageResponse,
    type SuccessResponse,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

export function useFetchUserGroup() {
    return useGet<
        UserGroupResponse,
        {
            params: typeof idParamSchema
        }
    >("user-group/:id", {
        params: idParamSchema,
    })
}

export function useFetchUserGroupList() {
    return useGet<
        PageResponse<UserGroupResponse>,
        {
            query: typeof userGroupFilterSchema
        }
    >("user-group", {
        query: userGroupFilterSchema,
    })
}

export function useFetchUserGroups() {
    const { data, get, loading, error } = useFetchUserGroupList()

    return {
        data,
        get: async () => {
            await get({ query: { limit: 1000 } })
        },
        loading,
        error,
    }
}

export function useCreateUserGroup() {
    return usePost<
        UserGroupResponse,
        {
            body: typeof userGroupCreateSchema
        }
    >("user-group", {
        body: userGroupCreateSchema,
    })
}

export function useUpdateUserGroup() {
    return usePut<
        UserGroupResponse,
        {
            params: typeof idParamSchema
            body: typeof userGroupUpdateSchema
        }
    >("user-group/:id", {
        params: idParamSchema,
        body: userGroupUpdateSchema,
    })
}

export function useDeleteUserGroup() {
    return useDelete<
        SuccessResponse,
        {
            params: typeof idParamSchema
        }
    >("user-group/:id", {
        params: idParamSchema,
    })
}
