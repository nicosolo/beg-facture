# Project Management Implementation Tasks

## Overview
Implement complete project management functionality including create, edit, and preview views with API integration.

## Dependencies
- [ ] Shared components (select components for related entities)
- [ ] Client, Company, Location, Engineer management APIs must be available

## Backend Tasks

### API Endpoints (apps/api/src/routes/project.ts)
- [ ] Add POST endpoint for creating projects
- [ ] Add PUT endpoint for updating projects
- [ ] Add DELETE endpoint for archiving projects (soft delete)
- [ ] Add GET endpoint for fetching project activities `/project/:id/activities`

### Validation Schemas (packages/validations/validations/project.ts)
- [ ] Create `projectCreateSchema` with required fields:
  - projectNumber (string, required)
  - name (string, required)
  - startDate (date, required)
  - locationId (number, optional)
  - clientId (number, optional)
  - engineerId (number, optional)
  - companyId (number, required)
  - typeId (number, required)
  - projectManagerId (number, optional)
  - remark (string, optional)
  - invoiceAddress (string, optional)
- [ ] Create `projectUpdateSchema` (partial of create schema)
- [ ] Export TypeScript types for inputs

### Repository Updates (apps/api/src/db/repositories/project.repository.ts)
- [ ] Add `create` method
- [ ] Add `update` method
- [ ] Add `delete` method (soft delete - set archived flag)
- [ ] Add `findActivitiesByProjectId` method

## Frontend Tasks

### API Composables (apps/app/src/composables/api/useProject.ts)
- [ ] Add `useCreateProject` composable using `usePost`
- [ ] Add `useUpdateProject` composable using `usePut`
- [ ] Add `useDeleteProject` composable using `useDelete`
- [ ] Add `useFetchProjectActivities` composable

### Components

#### ProjectSummary Component (apps/app/src/components/organisms/project/ProjectSummary.vue)
- [ ] Create component to display project statistics:
  - Total duration
  - Unbilled duration
  - Unbilled disbursement duration
  - First/Last activity dates
  - Number of activities
  - Project status (active/ended/archived)
- [ ] Use Card component for layout
- [ ] Format durations and dates properly

### View Updates

#### ProjectEditView (apps/app/src/views/project/ProjectEditView.vue)
- [ ] Replace dummy Select components with actual entity select components:
  - ClientSelect for IDmandant
  - LocationSelect for IDlocalité
  - EngineerSelect for IDingénieur
  - CompanySelect for IDentreprise
  - ProjectTypeSelect for IDtype
  - UserSelect for Responsable (projectManagerId)
- [ ] Implement form submission:
  - Create new project when no ID
  - Update existing project when ID present
  - Handle API errors with proper messages
  - Show loading state during submission
- [ ] Add validation for required fields
- [ ] Handle date conversion (MM/DD/YY format to ISO date)
- [ ] Fetch existing project data when editing
- [ ] Add success notification and redirect after save

#### ProjectPreviewView (apps/app/src/views/project/ProjectPreviewView.vue)
- [ ] Add ProjectSummary component above existing content
- [ ] Fetch project activities using new API endpoint
- [ ] Pass activities to TimeEntriesList component
- [ ] Add loading state for activities
- [ ] Format invoice address from client data
- [ ] Add delete/archive button with confirmation
- [ ] Handle empty states properly

## Testing Requirements
- [ ] Test project creation with all fields
- [ ] Test project update with partial data
- [ ] Test validation errors
- [ ] Test date format conversions
- [ ] Test project activities loading
- [ ] Test summary calculations
- [ ] Test soft delete functionality

## Notes
- Invoice address field needs special handling - it's stored on the project but should default from client
- Date format conversion is critical (MM/DD/YY vs ISO)
- Ensure proper access control - users can only see/edit their projects
- Consider adding project duplication feature in the future