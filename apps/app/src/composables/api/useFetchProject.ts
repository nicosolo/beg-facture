import type { Project } from "@beg/types"
import { idParamSchema, projectResponseSchema, type ProjectResponse } from "@beg/validations"
import { useAPI } from "./useAPI"

export function useFetchProject() {
    return useAPI<typeof idParamSchema, ProjectResponse>(
        "project/:id",
        idParamSchema,
        (data) => data,
        (data) => ({
            ...data,
            startDate: new Date(data.startDate),
            createdAt: data.createdAt ? new Date(data.createdAt) : null,
            updatedAt: data.updatedAt ? new Date(data.updatedAt) : null,
        })
    )
}
