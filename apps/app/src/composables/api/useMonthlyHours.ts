import {
    idParamSchema,
    monthlyHoursFilterSchema,
    monthlyHoursCreateSchema,
    monthlyHoursUpdateSchema,
    type MonthlyHoursResponse,
    type PageResponse,
    type MonthlyHours,
    type SuccessResponse,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

export function useFetchMonthlyHours() {
    return useGet<
        MonthlyHoursResponse,
        {
            params: typeof idParamSchema
        }
    >("monthly-hours/:id", {
        params: idParamSchema,
    })
}

export function useFetchMonthlyHoursList() {
    return useGet<
        PageResponse<MonthlyHours>,
        {
            query: typeof monthlyHoursFilterSchema
        }
    >("monthly-hours", {
        query: monthlyHoursFilterSchema,
    })
}

export function useCreateMonthlyHours() {
    return usePost<
        MonthlyHoursResponse,
        {
            body: typeof monthlyHoursCreateSchema
        }
    >("monthly-hours", {
        body: monthlyHoursCreateSchema,
    })
}

export function useUpdateMonthlyHours() {
    return usePut<
        MonthlyHoursResponse,
        {
            params: typeof idParamSchema
            body: typeof monthlyHoursUpdateSchema
        }
    >("monthly-hours/:id", {
        params: idParamSchema,
        body: monthlyHoursUpdateSchema,
    })
}

export function useDeleteMonthlyHours() {
    return useDelete<
        SuccessResponse,
        {
            params: typeof idParamSchema
        }
    >("monthly-hours/:id", {
        params: idParamSchema,
    })
}
