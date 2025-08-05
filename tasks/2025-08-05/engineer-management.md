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
- [ ] Add DELETE `/engineer/:id` endpoint (soft delete if referenced)

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

### Views

#### EngineerListView (apps/app/src/views/engineer/EngineerListView.vue) - NEW
- [ ] Create list view with DataTable
- [ ] Add search bar for filtering by name
- [ ] Display columns: Name, Project Count, Created Date, Actions
- [ ] Add "New Engineer" button
- [ ] Implement pagination
- [ ] Add edit and delete actions
- [ ] Show count of associated projects
- [ ] Disable delete for engineers with projects

#### EngineerEditView (apps/app/src/views/engineer/EngineerEditView.vue) - NEW
- [ ] Create simple form for engineer create/edit
- [ ] Form fields:
  - Name (required)
  - Company (optional text field)
  - Email (optional, validated)
  - Phone (optional)
- [ ] Implement form validation
- [ ] Handle create vs update logic
- [ ] Add cancel and save buttons
- [ ] Show loading state during submission

### Database Schema Update (apps/api/src/db/schema.ts)
- [ ] Add fields to engineers table:
  - company (text, optional)
  - email (text, optional)
  - phone (text, optional)
- [ ] Create migration for schema changes

### Router Updates (apps/app/src/router/index.ts)
- [ ] Add routes:
  - /engineer - EngineerListView
  - /engineer/new - EngineerEditView (create mode)
  - /engineer/:id/edit - EngineerEditView (edit mode)

### Navigation Update
- [ ] Add Engineer menu item to settings/admin section

### Translations (apps/app/src/i18n/locales/fr.json)
- [ ] Add engineer-related translations:
  - engineer.title / engineer.titlePlural
  - engineer.new
  - engineer.edit
  - engineer.name
  - engineer.company
  - engineer.email
  - engineer.phone
  - engineer.empty
  - engineer.deleteConfirm
  - engineer.deleteError.hasProjects
  - engineer.projectCount

## Testing Requirements
- [ ] Test engineer creation with all fields
- [ ] Test email validation
- [ ] Test search functionality
- [ ] Test delete prevention when projects exist
- [ ] Test EngineerSelect component in forms
- [ ] Test pagination

## Data Import Notes
From export-mdb/Ingénieurs.json:
- [ ] Plan data migration from legacy system
- [ ] Field mapping: IDingénieur -> id, Ingénieur -> name
- [ ] Parse additional contact info if available
- [ ] Consider extracting company from name field

## Notes
- Engineers are optional on projects
- Consider if engineers should be linked to specific companies
- May need to add professional credentials/certifications later
- Simple entity but helps track external collaborators