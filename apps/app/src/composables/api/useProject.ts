import type { Page, Project } from "@beg/types"
import {
    idParamSchema,
    projectFilterSchema,
    type ProjectListResponse,
    type ProjectResponse,
} from "@beg/validations"
import { useGet } from "./useAPI"

export function useFetchProject() {
    return useGet<
        ProjectResponse,
        {
            params: typeof idParamSchema
        }
    >("project/:id")
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
