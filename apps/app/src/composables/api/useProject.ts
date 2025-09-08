import {
    idParamSchema,
    projectFilterSchema,
    projectCreateSchema,
    projectUpdateSchema,
    type ProjectListResponse,
    type ProjectResponse,
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

export function useFetchParentProjects() {
    return useGet<ProjectListResponse>("project/parent-projects")
}

export function useProjectFolder(projectNumber: string | number) {
    return useGet<{
        projectNumber: string
        found: boolean
        result: {
            projectNumber: string
            fullPath: string
            folderName: string
            parentFolder: string
        } | null
    }>(`project-folder/search`, {
        query: {
            projectNumber: projectNumber.toString()
        }
    })
}

export function useProjectFolders(projectNumbers: (string | number)[]) {
    return usePost<{
        count: number
        results: Record<string, {
            found: boolean
            result: {
                projectNumber: string
                fullPath: string
                folderName: string
                parentFolder: string
            } | null
        }>
    }>(`project-folder/search/batch`, {
        body: {
            projectNumbers: projectNumbers.map(n => n.toString())
        }
    })
}
