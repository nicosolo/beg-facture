import { projectMapFilterSchema, type ProjectMapArrayResponse } from "@beg/validations"
import { useGet } from "./useAPI"

export function useFetchProjectMap() {
    return useGet<
        ProjectMapArrayResponse,
        {
            query: typeof projectMapFilterSchema
        }
    >("project/map", {
        query: projectMapFilterSchema,
    })
}
