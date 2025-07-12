import {
    idParamSchema,
    projectTypeCreateSchema,
    projectTypeUpdateSchema,
    type ProjectTypeSchema,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

export function useFetchProjectType() {
    return useGet<ProjectTypeSchema>("project-type/:id", {
        params: idParamSchema,
    })
}

export function useFetchProjectTypes() {
    return useGet<ProjectTypeSchema[]>("project-type")
}

export function useCreateProjectType() {
    return usePost<
        ProjectTypeSchema,
        {
            body: typeof projectTypeCreateSchema
        }
    >("project-type", {
        body: projectTypeCreateSchema,
    })
}

export function useUpdateProjectType() {
    return usePut<
        ProjectTypeSchema,
        {
            params: typeof idParamSchema
            body: typeof projectTypeUpdateSchema
        }
    >("project-type/:id", {
        params: idParamSchema,
        body: projectTypeUpdateSchema,
    })
}

export function useDeleteProjectType() {
    return useDelete<
        { message: string },
        {
            params: typeof idParamSchema
        }
    >("project-type/:id", {
        params: idParamSchema,
    })
}