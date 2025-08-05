# Client Management Implementation Tasks

## Overview
Implement complete CRUD functionality for client management. Clients represent the customers who are billed for projects.

## Dependencies
- [ ] None (base entity)

## Backend Tasks

### Existing API Enhancement (apps/api/src/routes/client.ts)
- [ ] Add POST `/client` endpoint for creating clients
- [ ] Add PUT `/client/:id` endpoint for updating clients  
- [ ] Add DELETE `/client/:id` endpoint (soft delete - clients may have invoices)
- [ ] Enhance GET endpoints with better error handling

### Validation Schemas Enhancement (packages/validations/validations/client.ts)
- [ ] Add `clientCreateSchema` with fields:
  - name (string, required)
  - address (string, optional)
  - contactPerson (string, optional)
  - email (string, email format, optional)
  - phone (string, optional)
- [ ] Add `clientUpdateSchema` (partial of create schema)
- [ ] Enhance existing schemas with proper validation rules

### Repository Enhancement (apps/api/src/db/repositories/client.repository.ts)
- [ ] Add `create` method
- [ ] Add `update` method
- [ ] Add `delete` method (soft delete)
- [ ] Add method to check if client has projects/invoices
- [ ] Enhance search to include multiple fields

### Database Schema Update (apps/api/src/db/schema.ts)
- [ ] Add missing fields to clients table:
  - address (text, optional)
  - contactPerson (text, optional)
  - email (text, optional)
  - phone (text, optional)
  - archived (boolean, default false)
- [ ] Create migration for schema changes

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
- [ ] Option to show archived clients

### Views

#### ClientListView (apps/app/src/views/client/ClientListView.vue) - NEW
- [ ] Create list view with DataTable
- [ ] Add search bar for filtering
- [ ] Display columns: Name, Contact Person, Email, Phone, Actions
- [ ] Add "New Client" button
- [ ] Implement pagination
- [ ] Add edit and delete actions
- [ ] Show project/invoice count
- [ ] Filter to show/hide archived clients

#### ClientEditView (apps/app/src/views/client/ClientEditView.vue) - NEW
- [ ] Create form for client create/edit
- [ ] Form fields:
  - Name (required)
  - Address (textarea, optional)
  - Contact Person (optional)
  - Email (optional, validated)
  - Phone (optional)
- [ ] Implement form validation
- [ ] Handle create vs update logic
- [ ] Add cancel and save buttons
- [ ] Show loading state during submission

#### ClientPreviewView (apps/app/src/views/client/ClientPreviewView.vue) - NEW
- [ ] Display client details
- [ ] Show related projects list
- [ ] Show related invoices list
- [ ] Add edit button
- [ ] Add archive/unarchive button
- [ ] Calculate total billed amount

### Router Updates (apps/app/src/router/index.ts)
- [ ] Add routes:
  - /client - ClientListView
  - /client/new - ClientEditView (create mode)
  - /client/:id - ClientPreviewView
  - /client/:id/edit - ClientEditView (edit mode)

### Navigation Update
- [ ] Add Client menu item to main navigation

### Translations (apps/app/src/i18n/locales/fr.json)
- [ ] Add client-related translations:
  - client.title / client.titlePlural
  - client.new
  - client.edit
  - client.preview
  - client.name
  - client.address
  - client.contactPerson
  - client.email
  - client.phone
  - client.empty
  - client.deleteConfirm
  - client.archiveConfirm
  - client.archived
  - client.projects
  - client.invoices
  - client.totalBilled

## Testing Requirements
- [ ] Test client creation with all fields
- [ ] Test email validation
- [ ] Test search across multiple fields
- [ ] Test archive/unarchive functionality
- [ ] Test delete prevention when invoices exist
- [ ] Test ClientSelect component
- [ ] Test client preview with related data

## Data Import Notes
From export-mdb/Mandants.json:
- [ ] Plan data migration from legacy system
- [ ] Field mapping: IDmandant -> id, fields to parse
- [ ] Address parsing from multi-line text
- [ ] Extract contact person where available

## Notes
- Clients are critical for invoicing
- Address format should support multi-line
- Consider adding VAT number field in future
- Soft delete to preserve invoice history
- May need client-specific rate overrides later