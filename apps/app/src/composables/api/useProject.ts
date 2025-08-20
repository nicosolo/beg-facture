import {
    idParamSchema,
    projectFilterSchema,
    projectCreateSchema,
    projectUpdateSchema,
    type ProjectListResponse,
    type ProjectResponse,
    type ProjectCreateInput,
    type ProjectUpdateInput,
} from "@beg/validations"
import { useGet, usePost, usePut } from "./useAPI"

export function useFetchProject() {
    return useGet<
        ProjectResponse,
        {
            params: typeof idParamSchema
        }
    >("project/:id", {
        params: idParamSchema,
    })
}

export function useFetchProjectList() {
    return useGet<
        ProjectListResponse,
        {
            query: typeof projectFilterSchema
        }
    >("project", {
        query: projectFilterSchema,
    })
}

export function useCreateProject() {
    return usePost<
        ProjectResponse,
        {
            body: typeof projectCreateSchema
        }
    >("project", {
        body: projectCreateSchema,
    })
}

export function useUpdateProject() {
    return usePut<
        ProjectResponse,
        {
            params: typeof idParamSchema
            body: typeof projectUpdateSchema
        }
    >("project/:id", {
        params: idParamSchema,
        body: projectUpdateSchema,
    })
}
