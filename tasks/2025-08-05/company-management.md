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
- [ ] Add DELETE `/company/:id` endpoint (consider soft delete if referenced)

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

### Views

#### CompanyListView (apps/app/src/views/company/CompanyListView.vue) - NEW
- [ ] Create list view with DataTable
- [ ] Add search bar for filtering by name
- [ ] Display columns: Name, Created Date, Actions
- [ ] Add "New Company" button
- [ ] Implement pagination
- [ ] Add edit and delete actions
- [ ] Show project count for each company
- [ ] Disable delete for companies with projects

#### CompanyEditView (apps/app/src/views/company/CompanyEditView.vue) - NEW
- [ ] Create simple form for company create/edit
- [ ] Form fields:
  - Name (required)
- [ ] Implement form validation
- [ ] Handle create vs update logic
- [ ] Add cancel and save buttons
- [ ] Show loading state during submission
- [ ] Redirect to list after save

### Router Updates (apps/app/src/router/index.ts)
- [ ] Add routes:
  - /company - CompanyListView
  - /company/new - CompanyEditView (create mode)
  - /company/:id/edit - CompanyEditView (edit mode)

### Navigation Update
- [ ] Add Company menu item to settings/admin section

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

## Testing Requirements
- [ ] Test company creation
- [ ] Test company name validation (required)
- [ ] Test search functionality
- [ ] Test delete prevention when projects exist
- [ ] Test CompanySelect component in forms
- [ ] Test pagination

## Data Import Notes
From export-mdb/Entreprises.json:
- [ ] Plan data migration from legacy system
- [ ] Field mapping: IDentreprise -> id, Entreprise -> name
- [ ] Total records to import: 331
- [ ] Consider creating import script

## Notes
- Companies are required for projects (cannot be null)
- Consider adding additional fields in future: address, contact info, etc.
- Simple entity but critical for project organization
- May need to add company-specific settings later