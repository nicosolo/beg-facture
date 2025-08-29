import {
    idParamSchema,
    workloadFilterSchema,
    workloadCreateSchema,
    workloadUpdateSchema,
    type WorkloadResponse,
    type WorkloadArrayResponse,
    type SuccessResponse,
} from "@beg/validations"
import { z } from "zod"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

export function useFetchWorkload() {
    return useGet<
        WorkloadResponse,
        {
            params: typeof idParamSchema
        }
    >("workloads/:id", {
        params: idParamSchema,
    })
}

export function useFetchWorkloadList() {
    return useGet<
        WorkloadArrayResponse,
        {
            query: typeof workloadFilterSchema
        }
    >("workloads", {
        query: workloadFilterSchema,
    })
}

export function useCreateWorkload() {
    return usePost<
        WorkloadResponse,
        {
            body: typeof workloadCreateSchema
        }
    >("workloads", {
        body: workloadCreateSchema,
    })
}

export function useUpdateWorkload() {
    return usePut<
        WorkloadResponse,
        {
            params: typeof idParamSchema
            body: typeof workloadUpdateSchema
        }
    >("workloads/:id", {
        params: idParamSchema,
        body: workloadUpdateSchema,
    })
}

export function useDeleteWorkload() {
    return useDelete<
        SuccessResponse,
        {
            params: typeof idParamSchema
        }
    >("workloads/:id", {
        params: idParamSchema,
    })
}

export function useBulkCreateWorkloads() {
    return usePost<
        WorkloadArrayResponse,
        {
            body: z.ZodArray<typeof workloadCreateSchema>
        }
    >("workloads/bulk", {
        body: z.array(workloadCreateSchema),
    })
}
