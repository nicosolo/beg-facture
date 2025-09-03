import { z } from "zod"
import { useGet } from "./useAPI"
import {
    unbilledParamsSchema,
    unbilledQuerySchema,
    type UnbilledActivitiesResponse,
} from "@beg/validations"

export function useFetchUnbilledActivities() {
    return useGet<
        UnbilledActivitiesResponse,
        {
            params: typeof unbilledParamsSchema
            query: typeof unbilledQuerySchema
        }
    >("unbilled/project/:projectId", {
        params: unbilledParamsSchema,
        query: unbilledQuerySchema,
    })
}
