# Engineer Management Implementation Tasks

## Overview

Implement complete CRUD functionality for engineer management. Engineers are external contacts associated with projects.

## Dependencies

- [ ] None (base entity)

## Backend Tasks

### API Endpoints (apps/api/src/routes/engineer.ts) - NEW FILE

- [ ] Create new route file for engineer endpoints
- [ ] Add GET `/engineer` endpoint with pagination and search
- [ ] Add GET `/engineer/:id` endpoint
- [ ] Add POST `/engineer` endpoint for creating engineers
- [ ] Add PUT `/engineer/:id` endpoint for updating engineers
- [ ] Add DELETE `/engineer/:id` endpoint (check for project references first)

### Validation Schemas (packages/validations/validations/engineer.ts) - NEW FILE

- [ ] Create `engineerSchema` with fields:
    - id (number)
    - name (string)
    - createdAt (date)
    - updatedAt (date)
- [ ] Create `engineerCreateSchema` (without id and timestamps)
- [ ] Create `engineerUpdateSchema` (partial of create schema)
- [ ] Create `engineerFilterSchema` with:
    - name (string, optional)
    - page, limit, sortBy, sortOrder
- [ ] Export TypeScript types

### Repository (apps/api/src/db/repositories/engineer.repository.ts) - NEW FILE

- [ ] Create repository with methods:
    - findAll(filter) - with pagination and search
    - findById(id)
    - create(data)
    - update(id, data)
    - delete(id) - check for project references
- [ ] Implement search by name (LIKE query)
- [ ] Add method to check if engineer has projects

### Index Update (apps/api/src/index.ts)

- [ ] Import and register engineer routes

## Frontend Tasks

### API Composables (apps/app/src/composables/api/useEngineer.ts) - NEW FILE

- [ ] Create `useFetchEngineer` for single engineer
- [ ] Create `useFetchEngineerList` for list with filters
- [ ] Create `useCreateEngineer`
- [ ] Create `useUpdateEngineer`
- [ ] Create `useDeleteEngineer`

### Components

#### EngineerSelect Component (apps/app/src/components/organisms/engineer/EngineerSelect.vue) - NEW

- [ ] Create async select component similar to UserSelect
- [ ] Implement search functionality
- [ ] Display engineer name
- [ ] Handle loading and empty states
- [ ] Support v-model binding
- [ ] Optional field in most forms

### Components

#### EngineerEditModal Component (apps/app/src/components/organisms/engineer/EngineerEditModal.vue) - NEW

- [ ] Create modal component using Dialog
- [ ] Accept v-model for open/close state
- [ ] Accept engineerId prop for edit mode (null for create)
- [ ] Form fields:
    - Name (required)
- [ ] Implement form validation
- [ ] Handle create vs update logic
- [ ] Emit 'saved' event after successful save
- [ ] Show loading state during submission

### Views

#### EngineerListView (apps/app/src/views/engineer/EngineerListView.vue) - NEW

- [ ] Create list view with DataTable (similar to LocationListView)
- [ ] Add filters section in Card:
    - Search by name input
- [ ] Display columns: Name, Created Date, Actions
- [ ] Add "New Engineer" button (admin only)
- [ ] Implement pagination with Pagination component
- [ ] Add edit and delete actions (admin only)
- [ ] Show delete confirmation dialog
- [ ] Disable delete for engineers with projects
- [ ] Use EngineerEditModal for create/edit
- [ ] Use LoadingOverlay for loading states
- [ ] Show success/error alerts using useAlert

### Database Schema (apps/api/src/db/schema.ts)

- [ ] No schema changes needed - engineers table already has:
    - id (integer, primary key)
    - name (text, required)
    - timestamps (createdAt, updatedAt)

### Router Updates (apps/app/src/router/index.ts)

- [ ] Add single route:
    - /engineer - EngineerListView

### Navigation Update

- [ ] Add Engineer menu item to main navigation (admin only)

### Translations (apps/app/src/i18n/locales/fr.json)

- [ ] Add engineer-related translations:
    - engineer.title / engineer.titlePlural
    - engineer.new
    - engineer.edit
    - engineer.name
    - engineer.empty
    - engineer.deleteConfirm
    - engineer.deleteError.hasProjects
    - engineer.selectEngineer
    - engineer.searchByName

## Notes

- Engineers are optional on projects
- Simple entity with just name field (matching schema)
- Modal-based editing pattern (like LocationListView)
- No separate preview view - all actions from list
- Admin-only permissions for create/edit/delete
- Consider adding more fields (company, email, etc.) in future
- Hard delete with project check to prevent orphaned data
- May need to add professional credentials/certifications later
