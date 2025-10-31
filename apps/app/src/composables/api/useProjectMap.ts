import { type ProjectMapArrayResponse } from "@beg/validations"
import { useGet } from "./useAPI"

export function useFetchProjectMap() {
    return useGet<ProjectMapArrayResponse>("project/map")
}
