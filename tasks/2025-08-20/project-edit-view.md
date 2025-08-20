# Project Edit View - Implementation Tasks

## Overview
Fix and implement the ProjectEditView component to connect with real API endpoints and provide full CRUD functionality for project management.

## Current Issues
- ❌ Using hardcoded/mock data instead of real API data
- ❌ Select dropdowns have empty options arrays
- ❌ No API endpoints for create/update operations
- ❌ Form uses legacy field names (French) instead of current schema
- ❌ No proper validation or error handling
- ❌ Missing loading states for data fetching

## Task 1: Backend API Implementation

### 1.1 Create Validation Schemas
**File:** `packages/validations/validations/project.ts`
- [ ] Add `projectCreateSchema` with proper field validation
- [ ] Add `projectUpdateSchema` with partial fields
- [ ] Export input/output types for both schemas

```typescript
export const projectCreateSchema = z.object({
    projectNumber: z.string().min(1),
    name: z.string().min(1),
    startDate: dateSchema,
    typeId: z.number().positive(),
    locationId: z.number().positive().optional(),
    clientId: z.number().positive().optional(),
    engineerId: z.number().positive().optional(),
    companyId: z.number().positive().optional(),
    projectManagerId: z.number().positive().optional(),
    invoiceAddress: z.string().optional(),
    remark: z.string().optional(),
    printFlag: z.boolean().optional().default(false),
})

export const projectUpdateSchema = projectCreateSchema.partial()
```

### 1.2 Repository Methods
**File:** `apps/api/src/db/repositories/project.repository.ts`
- [ ] Implement `create` method with proper field mapping
- [ ] Implement `update` method with partial updates
- [ ] Add validation for duplicate project numbers
- [ ] Add proper error handling and transaction support

### 1.3 API Routes
**File:** `apps/api/src/routes/project.ts`
- [ ] Add POST `/project` endpoint for creation
- [ ] Add PUT `/project/:id` endpoint for updates
- [ ] Add proper request validation with zValidator
- [ ] Add authorization checks for user permissions
- [ ] Implement proper error responses

## Task 2: Frontend Composables

### 2.1 Create CRUD Composables
**File:** `apps/app/src/composables/api/useProject.ts`

- [ ] Add `useCreateProject` composable
```typescript
export function useCreateProject() {
    return usePost<ProjectResponse, ProjectCreateInput>('project', {
        body: projectCreateSchema,
    })
}
```

- [ ] Add `useUpdateProject` composable
```typescript
export function useUpdateProject() {
    return usePut<ProjectResponse, ProjectUpdateInput>('project/:id', {
        params: idParamSchema,
        body: projectUpdateSchema,
    })
}
```

### 2.2 Create Select Options Composables
- [ ] Create `apps/app/src/composables/api/useClient.ts`
- [ ] Create `apps/app/src/composables/api/useEngineer.ts`
- [ ] Create `apps/app/src/composables/api/useCompany.ts`
- [ ] Create `apps/app/src/composables/api/useLocation.ts`
- [ ] Update existing `useProjectType.ts` if needed
- [ ] Create `apps/app/src/composables/api/useUser.ts` for project managers

## Task 3: Fix ProjectEditView Component

### 3.1 Update Data Structure
**File:** `apps/app/src/views/project/ProjectEditView.vue`

- [ ] Replace legacy `MandatProject` interface with proper types
- [ ] Update field names to match current schema:
  - `Mandat` → `projectNumber`
  - `Début` → `startDate`
  - `Désignation` → `name`
  - `IDlocalité` → `locationId`
  - `IDmandant` → `clientId`
  - `IDingénieur` → `engineerId`
  - `IDentreprise` → `companyId`
  - `IDtype` → `typeId`
  - `Responsable` → `projectManagerId`
  - `Facture` → `invoiceAddress`
  - `Remarque` → `remark`
  - `Imprimer` → `printFlag`

### 3.2 Connect to Real Data
- [ ] Import and use composables for fetching select options
- [ ] Load existing project data when editing
- [ ] Remove all hardcoded/mock data
- [ ] Implement proper loading states

### 3.3 Implement Form Functionality
- [ ] Connect save function to real API endpoints
- [ ] Add proper form validation
- [ ] Implement error handling with user feedback
- [ ] Add unsaved changes detection
- [ ] Add loading overlays during save

### 3.4 Update Select Components
- [ ] Replace Input with Select for project manager field
- [ ] Populate all Select components with real options:
  - Location select with locations list
  - Client select with clients list
  - Engineer select with engineers list
  - Company select with companies list
  - Project Type select with types list
  - Project Manager select with users list

## Task 4: Enhanced Features

### 4.1 Form Improvements
- [ ] Add project number auto-generation for new projects
- [ ] Add project number uniqueness validation
- [ ] Add date picker component for better UX
- [ ] Add rich text editor for remarks if needed
- [ ] Add invoice address autocomplete from client

### 4.2 User Experience
- [ ] Add form dirty state tracking
- [ ] Add confirmation dialog for unsaved changes
- [ ] Add success toast after saving
- [ ] Add keyboard shortcuts (Ctrl+S to save)
- [ ] Add breadcrumb navigation

### 4.3 Validation
- [ ] Client-side validation with immediate feedback
- [ ] Server-side validation with clear error messages
- [ ] Field-level error display
- [ ] Summary error display at top of form

## Implementation Example

```vue
<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import { 
    useFetchProject, 
    useCreateProject, 
    useUpdateProject 
} from "@/composables/api/useProject"
import { useFetchClientList } from "@/composables/api/useClient"
import { useFetchEngineerList } from "@/composables/api/useEngineer"
import { useFetchCompanyList } from "@/composables/api/useCompany"
import { useFetchLocationList } from "@/composables/api/useLocation"
import { useFetchProjectTypeList } from "@/composables/api/useProjectType"
import { useFetchUserList } from "@/composables/api/useUser"
import type { ProjectCreateInput, ProjectUpdateInput } from "@beg/validations"

const route = useRoute()
const router = useRouter()
const { t } = useI18n()

// Get project ID from route
const projectId = computed(() => 
    route.params.id ? parseInt(route.params.id as string) : null
)
const isNewProject = computed(() => !projectId.value)

// API composables
const { get: fetchProject, loading: loadingProject } = useFetchProject()
const { post: createProject, loading: creating } = useCreateProject()
const { put: updateProject, loading: updating } = useUpdateProject()

// Select options composables
const { get: fetchClients, data: clients } = useFetchClientList()
const { get: fetchEngineers, data: engineers } = useFetchEngineerList()
const { get: fetchCompanies, data: companies } = useFetchCompanyList()
const { get: fetchLocations, data: locations } = useFetchLocationList()
const { get: fetchProjectTypes, data: projectTypes } = useFetchProjectTypeList()
const { get: fetchUsers, data: users } = useFetchUserList()

// Form state
const form = ref<ProjectCreateInput>({
    projectNumber: '',
    name: '',
    startDate: new Date(),
    typeId: undefined,
    locationId: undefined,
    clientId: undefined,
    engineerId: undefined,
    companyId: undefined,
    projectManagerId: undefined,
    invoiceAddress: '',
    remark: '',
    printFlag: false,
})

// Load data on mount
onMounted(async () => {
    // Load select options
    await Promise.all([
        fetchClients(),
        fetchEngineers(),
        fetchCompanies(),
        fetchLocations(),
        fetchProjectTypes(),
        fetchUsers(),
    ])
    
    // Load existing project if editing
    if (projectId.value) {
        const project = await fetchProject({ id: projectId.value })
        if (project) {
            // Map API response to form
            form.value = {
                projectNumber: project.projectNumber,
                name: project.name,
                startDate: project.startDate,
                typeId: project.type?.id,
                locationId: project.location?.id,
                clientId: project.client?.id,
                engineerId: project.engineer?.id,
                companyId: project.company?.id,
                projectManagerId: project.projectManager?.id,
                invoiceAddress: project.invoiceAddress || '',
                remark: project.remark || '',
                printFlag: project.printFlag || false,
            }
        }
    }
})

// Save function
const saveProject = async () => {
    try {
        if (isNewProject.value) {
            await createProject({ body: form.value })
        } else {
            await updateProject({ 
                id: projectId.value!, 
                body: form.value 
            })
        }
        
        // Show success message
        // Navigate back to list
        router.push({ name: 'project-list' })
    } catch (error) {
        // Handle error
        console.error('Failed to save project:', error)
    }
}
</script>
```

## Testing Requirements

- [ ] Test create new project flow
- [ ] Test edit existing project flow
- [ ] Test form validation
- [ ] Test error handling
- [ ] Test select options loading
- [ ] Test unsaved changes warning
- [ ] Test keyboard shortcuts
- [ ] Test responsive layout

## Notes

- Ensure backward compatibility with existing data
- Follow existing FormLayout pattern from other edit views
- Use existing validation message translations
- Maintain consistent error handling across the app
- Consider adding autosave functionality in future