# Client Management Implementation Tasks

## Overview

Implement complete CRUD functionality for client management. Clients represent the customers who are billed for projects.

## Dependencies

- [ ] None (base entity)

## Backend Tasks

### Existing API Enhancement (apps/api/src/routes/client.ts)

- [ ] Add POST `/client` endpoint for creating clients
- [ ] Add PUT `/client/:id` endpoint for updating clients
- [ ] Add DELETE `/client/:id` endpoint (check for related invoices first)
- [ ] Enhance GET endpoints with better error handling

### Validation Schemas Enhancement (packages/validations/validations/client.ts)

- [ ] Add `clientCreateSchema` with fields:
    - name (string, required)
- [ ] Add `clientUpdateSchema` (partial of create schema)
- [ ] Enhance existing schemas with proper validation rules

### Repository Enhancement (apps/api/src/db/repositories/client.repository.ts)

- [ ] Add `create` method
- [ ] Add `update` method
- [ ] Add `delete` method
- [ ] Add method to check if client has projects/invoices before deletion
- [ ] Enhance search by name

### Database Schema (apps/api/src/db/schema.ts)

- [ ] No schema changes needed - clients table already has:
    - id (integer, primary key)
    - name (text, required)
    - timestamps (createdAt, updatedAt)

## Frontend Tasks

### API Composables (apps/app/src/composables/api/useClient.ts) - NEW FILE

- [ ] Create `useFetchClient` for single client
- [ ] Create `useFetchClientList` for list with filters
- [ ] Create `useCreateClient`
- [ ] Create `useUpdateClient`
- [ ] Create `useDeleteClient`

### Components

#### ClientSelect Component (apps/app/src/components/organisms/client/ClientSelect.vue) - NEW

- [ ] Create async select component similar to UserSelect
- [ ] Implement search functionality
- [ ] Display client name
- [ ] Handle loading and empty states
- [ ] Support v-model binding

### Components

#### ClientEditModal Component (apps/app/src/components/organisms/client/ClientEditModal.vue) - NEW

- [ ] Create modal component using Dialog
- [ ] Accept v-model for open/close state
- [ ] Accept clientId prop for edit mode (null for create)
- [ ] Form fields:
    - Name (required)
- [ ] Implement form validation
- [ ] Handle create vs update logic
- [ ] Emit 'saved' event after successful save
- [ ] Show loading state during submission
- [ ] Use FormLayout for consistent styling

### Views

#### ClientListView (apps/app/src/views/client/ClientListView.vue) - NEW

- [ ] Create list view with DataTable (similar to LocationListView)
- [ ] Add filters section in Card:
    - Search by name input
- [ ] Display columns: Name, Created Date, Actions
- [ ] Add "New Client" button (admin only)
- [ ] Implement pagination with Pagination component
- [ ] Add edit and delete actions (admin only)
- [ ] Show delete confirmation dialog
- [ ] Use ClientEditModal for create/edit
- [ ] Use LoadingOverlay for loading states
- [ ] Show success/error alerts using useAlert

### Router Updates (apps/app/src/router/index.ts)

- [ ] Add single route:
    - /client - ClientListView

### Navigation Update

- [ ] Add Client menu item to main navigation

### Translations (apps/app/src/i18n/locales/fr.json)

- [ ] Add client-related translations:
    - client.title / client.titlePlural
    - client.new
    - client.edit
    - client.name
    - client.empty
    - client.deleteConfirm
    - client.selectClient
    - client.searchByName

## Notes

- Clients are critical for invoicing
- Simple entity with just name field
- Modal-based editing pattern (like LocationListView)
- No separate preview view - all actions from list
- Admin-only permissions for create/edit/delete
- Consider adding more fields (address, email, etc.) in future
- Hard delete with invoice check to prevent orphaned data
- May need client-specific rate overrides later
