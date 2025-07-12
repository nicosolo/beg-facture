import type { User } from "@beg/types"
import { userFilterSchema, userResponseSchema, type IdParamSchema } from "@beg/validations"
import { useAPI } from "./useAPI"
import { z } from "zod"

const usersResponseSchema = z.array(userResponseSchema)

export function useFetchUsers() {
    return useAPI<typeof userFilterSchema, User[]>(
        "user",
        userFilterSchema,
        (data) => data,
        (data) =>
            data.map((user: any) => ({
                ...user,
                createdAt: user.createdAt ? new Date(user.createdAt) : null,
                updatedAt: user.updatedAt ? new Date(user.updatedAt) : null,
            }))
    )
}
