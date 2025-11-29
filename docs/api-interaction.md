# API Interaction Guide

This document explains how to interact with the API in BEG Facture, from validation schemas to frontend composables.

## Architecture Overview

```
Frontend (Vue)          →  API (Hono)           →  Database (SQLite)
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ useAPI.ts       │     │ routes/*.ts     │     │ repositories/   │
│ composables     │ ──> │ zValidator      │ ──> │ *.repository.ts │
│                 │     │ responseValidator│     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         ↑                       ↑                       ↑
         └───────────────────────┴───────────────────────┘
                    packages/validations/
                    (shared Zod schemas)
```

## Step-by-Step: Adding a New Filter

### 1. Define Validation Schema (`packages/validations/`)

First, add the new field to the validation schema:

```typescript
// packages/validations/validations/project.ts
const projectBaseFilterSchema = z.object({
    name: z.string().optional(),
    // Add new filter - transform comma-separated string to array
    projectTypeIds: z
        .string()
        .optional()
        .transform((val) => (val ? val.split(",").map(Number) : undefined)),
    // ... other fields
})

export const projectFilterSchema = projectBaseFilterSchema.merge(paginationSchema)
export type ProjectFilter = z.infer<typeof projectFilterSchema>
```

### 2. Create API Route (`apps/api/src/routes/`)

Routes use `zValidator` for input validation and `responseValidator` for output validation:

```typescript
// apps/api/src/routes/project.ts
import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import { projectFilterSchema, projectListResponse } from "@beg/validations"
import { projectRepository } from "../db/repositories/project.repository"
import { responseValidator } from "@src/tools/response-validator"

export const projectRoutes = new Hono<{ Variables: Variables }>().use("/*", authMiddleware).get(
    "/",
    zValidator("query", projectFilterSchema), // Validates query params
    responseValidator({ 200: projectListResponse }), // Validates response
    async (c) => {
        const filter = c.req.valid("query") // Type-safe validated input
        const user = c.get("user")
        const result = await projectRepository.findAll(user, filter)
        return c.render(result as ProjectListResponse, 200)
    }
)
```

### 3. Implement Repository (`apps/api/src/db/repositories/`)

Repositories handle database queries using Drizzle ORM:

```typescript
// apps/api/src/db/repositories/project.repository.ts
export const projectRepository = {
    findAll: async (user: Variables["user"], filters?: ProjectFilter) => {
        const { projectTypeIds, ...otherFilters } = filters || {}

        const whereConditions = []

        // Add filter condition using SQL
        if (projectTypeIds && projectTypeIds.length > 0) {
            whereConditions.push(
                sql`EXISTS (
                    SELECT 1 FROM ${projectProjectTypes} ppt
                    WHERE ppt.projectId = ${projects.id}
                    AND ppt.projectTypeId IN (${sql.join(
                        projectTypeIds.map((id) => sql`${id}`),
                        sql`, `
                    )})
                )`
            )
        }

        // Execute query
        const results = await db
            .select({
                /* fields */
            })
            .from(projects)
            .where(and(...whereConditions))
            .execute()

        return { data: results, total: count, page, limit, totalPages }
    },
}
```

### 4. Create Frontend Composable (`apps/app/src/composables/api/`)

Use `useGet`, `usePost`, `usePut`, `useDelete` from `useAPI.ts`:

```typescript
// apps/app/src/composables/api/useProject.ts
import { projectFilterSchema, type ProjectListResponse } from "@beg/validations"
import { useGet } from "./useAPI"

export function useFetchProjectList() {
    return useGet<ProjectListResponse, { query: typeof projectFilterSchema }>("project", {
        query: projectFilterSchema,
    })
}
```

### 5. Use in Component

```vue
<script setup lang="ts">
import { useFetchProjectList } from "@/composables/api/useProject"

const { get: fetchProjects, loading, data } = useFetchProjectList()

const filter = ref({
    projectTypeIds: [], // Array in component state
})

const loadProjects = async () => {
    const { projectTypeIds, ...rest } = filter.value
    await fetchProjects({
        query: {
            ...rest,
            // Convert array to comma-separated string for query param
            projectTypeIds: projectTypeIds?.length ? projectTypeIds.join(",") : undefined,
            page: 1,
            limit: 100,
        },
    })
}
</script>
```

## API Composables Reference

### useGet

```typescript
const { loading, error, data, get } = useGet<ResponseType, { query?, params? }>(
    endpoint,
    { query?: zodSchema, params?: zodSchema }
)

// Usage
await get({ query: { page: 1 }, params: { id: 123 } })
```

### usePost

```typescript
const { loading, error, data, post } = usePost<ResponseType, { body?, params? }>(
    endpoint,
    { body?: zodSchema, params?: zodSchema }
)

// Usage
await post({ body: { name: "New Item" } })
```

### usePut

```typescript
const { loading, error, data, put } = usePut<ResponseType, { body?, params? }>(
    endpoint,
    { body?: zodSchema, params?: zodSchema }
)

// Usage
await put({ params: { id: 123 }, body: { name: "Updated" } })
```

### useDelete

```typescript
const { loading, error, data, delete: del } = useDelete<ResponseType, { params? }>(
    endpoint,
    { params?: zodSchema }
)

// Usage
await del({ params: { id: 123 } })
```

## Key Patterns

### 1. Query Parameter Transformation

When sending arrays as query params, convert to comma-separated strings:

```typescript
// Schema transformation (in validation)
projectTypeIds: z.string()
    .optional()
    .transform((val) => (val ? val.split(",").map(Number) : undefined))

// Frontend conversion (in component)
projectTypeIds: ids?.length ? ids.join(",") : undefined
```

### 2. Response Validation

Always validate API responses for type safety:

```typescript
responseValidator({
    200: projectListResponse, // Success schema
    404: errorSchema, // Error schemas (optional)
})
```

### 3. Authentication

Routes use `authMiddleware` and access user via context:

```typescript
const user = c.get("user") // Get authenticated user
const isAdmin = hasRole(user.role, "admin")
```

### 4. Error Handling

Use standardized error helpers:

```typescript
import { throwNotFound, throwForbidden } from "@src/tools/error-handler"

if (!project) throw throwNotFound("Project not found")
if (!isAdmin) throw throwForbidden("Access denied")
```
