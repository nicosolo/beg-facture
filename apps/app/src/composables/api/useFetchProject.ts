import type { Page, Project } from "@beg/types"
import { convertProjectFilterToInput, projectFilterSchema } from "@beg/validations"
import { useAPI } from "./useAPI"

export function useFetchProject() {
    return useAPI<typeof projectFilterSchema, Page<Project>>(
        "project",
        projectFilterSchema,
        convertProjectFilterToInput,
        (data) => data
    )
}
