import type { Activity, Page, Project } from "@beg/types"
import { projectFilterSchema } from "@beg/validations"
import { useGet } from "./useAPI"

export function useFetchProjectList() {
    return useGet<
        Page<Project>,
        {
            query: typeof projectFilterSchema
        }
    >("project", {
        query: projectFilterSchema,
    })
}
