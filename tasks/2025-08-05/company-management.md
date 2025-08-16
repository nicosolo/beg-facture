# Company Management Implementation Tasks

## Overview

Implement complete CRUD functionality for company management. Companies represent the business entities that projects belong to.

## Dependencies

- [ ] None (base entity)

## Backend Tasks

### API Endpoints (apps/api/src/routes/company.ts) - NEW FILE

- [ ] Create new route file for company endpoints
- [ ] Add GET `/company` endpoint with pagination and search
- [ ] Add GET `/company/:id` endpoint
- [ ] Add POST `/company` endpoint for creating companies
- [ ] Add PUT `/company/:id` endpoint for updating companies
- [ ] Add DELETE `/company/:id` endpoint (check for project references first)

### Validation Schemas (packages/validations/validations/company.ts) - NEW FILE

- [ ] Create `companySchema` with fields:
    - id (number)
    - name (string)
    - createdAt (date)
    - updatedAt (date)
- [ ] Create `companyCreateSchema` (without id and timestamps)
- [ ] Create `companyUpdateSchema` (partial of create schema)
- [ ] Create `companyFilterSchema` with:
    - name (string, optional)
    - page, limit, sortBy, sortOrder
- [ ] Export TypeScript types

### Repository (apps/api/src/db/repositories/company.repository.ts) - NEW FILE

- [ ] Create repository with methods:
    - findAll(filter) - with pagination and search
    - findById(id)
    - create(data)
    - update(id, data)
    - delete(id) - check for project references first
- [ ] Implement search by name (LIKE query)
- [ ] Add method to check if company has projects

### Index Update (apps/api/src/index.ts)

- [ ] Import and register company routes

## Frontend Tasks

### API Composables (apps/app/src/composables/api/useCompany.ts) - NEW FILE

- [ ] Create `useFetchCompany` for single company
- [ ] Create `useFetchCompanyList` for list with filters
- [ ] Create `useCreateCompany`
- [ ] Create `useUpdateCompany`
- [ ] Create `useDeleteCompany`

### Components

#### CompanySelect Component (apps/app/src/components/organisms/company/CompanySelect.vue) - NEW

- [ ] Create async select component similar to UserSelect
- [ ] Implement search functionality
- [ ] Display company name
- [ ] Handle loading and empty states
- [ ] Support v-model binding
- [ ] Mark as required field when used in forms

### Components

#### CompanyEditModal Component (apps/app/src/components/organisms/company/CompanyEditModal.vue) - NEW

- [ ] Create modal component using Dialog
- [ ] Accept v-model for open/close state
- [ ] Accept companyId prop for edit mode (null for create)
- [ ] Form fields:
    - Name (required)
- [ ] Implement form validation
- [ ] Handle create vs update logic
- [ ] Emit 'saved' event after successful save
- [ ] Show loading state during submission

### Views

#### CompanyListView (apps/app/src/views/company/CompanyListView.vue) - NEW

- [ ] Create list view with DataTable (similar to LocationListView)
- [ ] Add filters section in Card:
    - Search by name input
- [ ] Display columns: Name, Created Date, Actions
- [ ] Add "New Company" button (admin only)
- [ ] Implement pagination with Pagination component
- [ ] Add edit and delete actions (admin only)
- [ ] Show delete confirmation dialog
- [ ] Disable delete for companies with projects
- [ ] Use CompanyEditModal for create/edit
- [ ] Use LoadingOverlay for loading states
- [ ] Show success/error alerts using useAlert

### Router Updates (apps/app/src/router/index.ts)

- [ ] Add single route:
    - /company - CompanyListView

### Navigation Update

- [ ] Add Company menu item to main navigation (admin only)

### Translations (apps/app/src/i18n/locales/fr.json)

- [ ] Add company-related translations:
    - company.title / company.titlePlural
    - company.new
    - company.edit
    - company.name
    - company.empty
    - company.deleteConfirm
    - company.deleteError.hasProjects
    - company.projectCount

## Notes

- Companies are required for projects (cannot be null)
- Simple entity with just name field (matching schema)
- Modal-based editing pattern (like LocationListView)
- No separate preview view - all actions from list
- Admin-only permissions for create/edit/delete
- Consider adding additional fields in future: address, contact info, etc.
- Hard delete with project check to prevent orphaned data
- May need to add company-specific settings later
