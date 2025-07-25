import {
    idParamSchema,
    activityFilterSchema,
    activityCreateSchema,
    activityUpdateSchema,
    type ActivityListResponse,
    type ActivityResponse,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

export function useFetchActivity() {
    return useGet<
        ActivityResponse,
        {
            params: typeof idParamSchema
        }
    >("activity/:id", {
        params: idParamSchema,
    })
}

export function useFetchActivityList() {
    return useGet<
        ActivityListResponse,
        {
            query: typeof activityFilterSchema
        }
    >("activity", {
        query: activityFilterSchema,
    })
}

export function useCreateActivity() {
    return usePost<
        ActivityResponse,
        {
            body: typeof activityCreateSchema
        }
    >("activity", {
        body: activityCreateSchema,
    })
}

export function useUpdateActivity() {
    return usePut<
        ActivityResponse,
        {
            params: typeof idParamSchema
            body: typeof activityUpdateSchema
        }
    >("activity/:id", {
        params: idParamSchema,
        body: activityUpdateSchema,
    })
}

export function useDeleteActivity() {
    return useDelete<
        void,
        {
            params: typeof idParamSchema
        }
    >("activity/:id", {
        params: idParamSchema,
    })
}
