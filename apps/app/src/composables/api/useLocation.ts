import {
    idParamSchema,
    locationFilterSchema,
    locationCreateSchema,
    locationUpdateSchema,
    type Location,
    type PageResponse,
    type SuccessResponse,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

// Type for paginated location response
export type LocationListResponse = PageResponse<Location>

export function useFetchLocation() {
    return useGet<
        Location,
        {
            params: typeof idParamSchema
        }
    >("location/:id", {
        params: idParamSchema,
    })
}

export function useFetchLocationList() {
    return useGet<
        LocationListResponse,
        {
            query: typeof locationFilterSchema
        }
    >("location", {
        query: locationFilterSchema,
    })
}

export function useCreateLocation() {
    return usePost<
        Location,
        {
            body: typeof locationCreateSchema
        }
    >("location", {
        body: locationCreateSchema,
    })
}

export function useUpdateLocation() {
    return usePut<
        Location,
        {
            params: typeof idParamSchema
            body: typeof locationUpdateSchema
        }
    >("location/:id", {
        params: idParamSchema,
        body: locationUpdateSchema,
    })
}

export function useDeleteLocation() {
    return useDelete<
        SuccessResponse,
        {
            params: typeof idParamSchema
        }
    >("location/:id", {
        params: idParamSchema,
    })
}
