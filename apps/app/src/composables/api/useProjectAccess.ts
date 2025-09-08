import {
    idParamSchema,
    projectAccessCreateSchema,
    projectAccessUpdateSchema,
    type ProjectAccessResponse,
    type ProjectAccessListResponse,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"
import { z } from "zod"

// Schema for project ID parameter
const projectIdParamSchema = z.object({
    projectId: z.coerce.number().int().positive(),
})

// Schema for user ID parameter
const userIdParamSchema = z.object({
    userId: z.coerce.number().int().positive(),
})

// Schema for user and project ID parameters
const userProjectParamSchema = z.object({
    userId: z.coerce.number().int().positive(),
    projectId: z.coerce.number().int().positive(),
})

// Get project accesses for a specific project
export function useFetchProjectAccesses() {
    return useGet<
        ProjectAccessListResponse,
        {
            params: typeof projectIdParamSchema
        }
    >("project-access/project/:projectId", {
        params: projectIdParamSchema,
    })
}

// Get project accesses for a specific user
export function useFetchUserProjectAccesses() {
    return useGet<
        ProjectAccessListResponse,
        {
            params: typeof userIdParamSchema
        }
    >("project-access/user/:userId", {
        params: userIdParamSchema,
    })
}

// Get a specific project access by ID
export function useFetchProjectAccess() {
    return useGet<
        ProjectAccessResponse,
        {
            params: typeof idParamSchema
        }
    >("project-access/:id", {
        params: idParamSchema,
    })
}

// Create or update project access (upsert)
export function useCreateProjectAccess() {
    return usePost<
        ProjectAccessResponse,
        {
            body: typeof projectAccessCreateSchema
        }
    >("project-access", {
        body: projectAccessCreateSchema,
    })
}

// Update project access
export function useUpdateProjectAccess() {
    return usePut<
        ProjectAccessResponse,
        {
            params: typeof idParamSchema
            body: typeof projectAccessUpdateSchema
        }
    >("project-access/:id", {
        params: idParamSchema,
        body: projectAccessUpdateSchema,
    })
}

// Delete project access
export function useDeleteProjectAccess() {
    return useDelete<
        { message: string },
        {
            params: typeof idParamSchema
        }
    >("project-access/:id", {
        params: idParamSchema,
    })
}

// Delete project access by user and project
export function useDeleteUserProjectAccess() {
    return useDelete<
        { message: string },
        {
            params: typeof userProjectParamSchema
        }
    >("project-access/user/:userId/project/:projectId", {
        params: userProjectParamSchema,
    })
}
