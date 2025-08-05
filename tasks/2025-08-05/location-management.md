# Location Management Implementation Tasks

## Overview

Implement complete CRUD functionality for location management including list, create, edit, and delete views.

## Dependencies

- [ ] None (base entity)

## Backend Tasks

### API Endpoints (apps/api/src/routes/location.ts) - NEW FILE

- [ ] Create new route file for location endpoints
- [ ] Add GET `/location` endpoint with pagination and search (no auth required)
- [ ] Add GET `/location/:id` endpoint (no auth required)
- [ ] Add POST `/location` endpoint for creating locations (admin only)
- [ ] Add PUT `/location/:id` endpoint for updating locations (admin only)
- [ ] Add DELETE `/location/:id` endpoint (hard delete, admin only)
- [ ] Add admin role middleware for create/update/delete endpoints

- [ ] Create `locationSchema` with fields:
    - id (number)
    - name (string)
    - country (z.enum(['CH', 'FR', 'IT', 'DE']))
    - canton (z.enum([...Object.keys(SWISS_CANTONS)]).optional())
    - region (string, optional)
    - address (string, optional)
    - createdAt (date)
    - updatedAt (date)
- [ ] Create `locationCreateSchema` (without id and timestamps)
    - Validate canton only required when country is 'CH'
- [ ] Create `locationUpdateSchema` (partial of create schema)
- [ ] Create `locationFilterSchema` with:
    - name (string, optional)
    - country (string, optional)
    - canton (string, optional)
    - page, limit, sortBy, sortOrder
- [ ] Export TypeScript types

### Repository (apps/api/src/db/repositories/location.repository.ts) - NEW FILE

- [ ] Create repository with methods:
    - findAll(filter) - with pagination and search
    - findById(id)
    - create(data)
    - update(id, data)
    - delete(id)
- [ ] Implement search by name (LIKE query)
- [ ] Add proper sorting support

### Index Update (apps/api/src/index.ts)

- [ ] Import and register location routes

## Frontend Tasks

### API Composables (apps/app/src/composables/api/useLocation.ts) - NEW FILE

- [ ] Create `useFetchLocation` for single location
- [ ] Create `useFetchLocationList` for list with filters
- [ ] Create `useCreateLocation`
- [ ] Create `useUpdateLocation`
- [ ] Create `useDeleteLocation`
- [ ] Import COUNTRIES and SWISS_CANTONS from validations package for use in UI

### Components

#### LocationSelect Component (apps/app/src/components/organisms/location/LocationSelect.vue) - NEW

- [ ] Create async select component similar to UserSelect, use the AutocompleteSelect component
- [ ] Implement search functionality
- [ ] Display location with country/canton
- [ ] Handle loading and empty states
- [ ] Support v-model binding

### Views

#### LocationListView (apps/app/src/views/location/LocationListView.vue) - NEW

- [ ] Create list view with DataTable
- [ ] Add search bar for filtering by name
- [ ] Add country/canton filter dropdowns using the constants
- [ ] Display columns: Name, Country, Canton, Region, Actions
- [ ] Add "New Location" button (only visible for admin users)
- [ ] Implement pagination using the Pagination component
- [ ] Add edit and delete actions (only visible for admin users)
- [ ] Check user role from auth store before showing admin actions

#### LocationEditView (apps/app/src/views/location/LocationEditView.vue) - NEW

- [ ] Use FormLayout component for create/edit forms
- [ ] Check user role on mount - redirect if not admin
- [ ] Create form for location create/edit
- [ ] Form fields:
    - Name (required)
    - Country (required, Select component with COUNTRIES options)
    - Canton (Select component with SWISS_CANTONS options, only show when country is 'CH')
    - Region (optional)
    - Address (optional, textarea)
- [ ] Implement form validation
- [ ] Handle create vs update logic
- [ ] Add cancel and save buttons
- [ ] Show loading state during submission
- [ ] Clear canton value when country changes from 'CH' to another

### Router Updates (apps/app/src/router/index.ts)

- [ ] Add routes:
    - /location - LocationListView (public)
    - /location/new - LocationEditView (create mode, admin only)
    - /location/:id/edit - LocationEditView (edit mode, admin only)
- [ ] Add route guards to check admin role for create/edit routes

### Navigation Update

- [ ] Add Location menu item to main navigation (only visible to admin users)

### Translations (apps/app/src/i18n/locales/fr.json)

- [ ] Add location-related translations:
    - location.title
    - location.new
    - location.edit
    - location.name
    - location.country
    - location.canton
    - location.region
    - location.address
    - location.empty
    - location.deleteConfirm
    - location.selectCountry
    - location.selectCanton

## Notes

- Country codes use ISO 3166-1 alpha-2 standard (CH, FR, IT, DE)
- All Swiss cantons are included with official two-letter codes
- Canton selection is only available when Switzerland (CH) is selected
- Only users with admin role can create, update, or delete locations
- Regular users can view and select locations in forms
- Address field can be multiline
- Country and canton lists are shared constants in the validations package
