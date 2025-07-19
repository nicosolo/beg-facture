import {
    idParamSchema,
    activityTypeCreateSchema,
    activityTypeUpdateSchema,
    type ActivityTypeResponse,
} from "@beg/validations"
import { useGet, usePost, usePut } from "./useAPI"

export function useFetchActivityType() {
    return useGet<ActivityTypeResponse>("activity-type/:id", {
        params: idParamSchema,
    })
}

export function useFetchActivityTypes() {
    return useGet<ActivityTypeResponse[]>("activity-type")
}

export function useCreateActivityType() {
    return usePost<
        ActivityTypeResponse,
        {
            body: typeof activityTypeCreateSchema
        }
    >("activity-type", {
        body: activityTypeCreateSchema,
    })
}

export function useUpdateActivityType() {
    return usePut<
        ActivityTypeResponse,
        {
            params: typeof idParamSchema
            body: typeof activityTypeUpdateSchema
        }
    >("activity-type/:id", {
        params: idParamSchema,
        body: activityTypeUpdateSchema,
    })
}
