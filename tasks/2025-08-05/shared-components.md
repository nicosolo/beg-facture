# Shared Components Implementation Tasks

## Overview

Create shared select components and utilities that will be used across multiple features.

## Dependencies

- [ ] Individual entity APIs must be implemented first

## Common Select Component Pattern

### AutocompleteSelect Component (apps/app/src/components/atoms/AutocompleteSelect.vue) - NEW

- [ ] Create a unified select component based on UserSelect.vue pattern
- [ ] Support both async API data and static options
- [ ] Features (same as UserSelect):
    - Async data loading with API composable OR static options
    - Search/filter capability with real-time filtering
    - Loading states with spinner (only for async mode)
    - Empty states with "no results" message
    - Keyboard navigation (arrow keys, enter, escape)
    - Click outside to close (blur with delay)
    - Input clears modelValue when typing starts
    - Focused item highlighting
    - Selected item display in input
- [ ] Props:
    - modelValue (number | string | undefined)
    - placeholder (string)
    - disabled (boolean)
    - required (boolean)
    - className (string)
    - mode: 'async' | 'static' (default: 'static')
    - // For async mode:
    - items (array of objects from API)
    - loading (boolean from API composable)
    - fetchFunction (function(searchText: string) => Promise<void>) - receives typed text for API filtering
    - // For static mode:
    - options (array of objects for static data)
    - // Common display props:
    - displayField (function to format display - (item: any) => string)
    - valueField (string, default 'id')
    - searchFields (array of fields to search in - for static mode)
    - filterFunction (optional custom filter function - for static mode)
- [ ] Emit: update:modelValue
- [ ] Key implementation details:
    - In async mode, call fetchFunction with debounced search text
    - In static mode, filter options locally using searchFields
    - Always use displayField function for formatting item display
- [ ] Usage Examples:

```vue
<!-- Example 1: Async mode with API data -->
<script setup>
const { loading, data: users, get } = useFetchUsers()

// Fetch function that receives search text
const fetchUsers = async (searchText: string) => {
  await get({ query: { search: searchText } })
}
</script>
<template>
    <AutocompleteSelect
        v-model="form.userId"
        mode="async"
        :items="users"
        :loading="loading"
        :fetch-function="fetchUsers"
        :display-field="(user) => `${user.firstName} ${user.lastName}`"
        placeholder="Select user"
    />
</template>

<!-- Example 2: Static mode with predefined options -->
<script setup>
import { COUNTRIES } from "@beg/validations"
const countryOptions = Object.entries(COUNTRIES).map(([value, label]) => ({
    id: value,
    name: label,
}))
</script>
<template>
    <AutocompleteSelect
        v-model="form.country"
        mode="static"
        :options="countryOptions"
        :display-field="(country) => country.name"
        value-field="id"
        :search-fields="['name']"
        placeholder="Select country"
    />
</template>

<!-- Example 3: Static mode with complex display -->
<template>
    <AutocompleteSelect
        v-model="form.projectId"
        mode="static"
        :options="projects"
        :display-field="(project) => `${project.projectNumber} - ${project.name}`"
        :search-fields="['projectNumber', 'name']"
        placeholder="Select project"
    />
</template>
```

### Shared Utilities

#### API Error Handling (apps/app/src/utils/api-error.ts) - ENHANCE

- [ ] Add specific error handlers for common scenarios:
    - Entity not found
    - Validation errors with field mapping
    - Reference constraint errors
    - Duplicate entry errors
- [ ] Improve error message formatting for user display

#### Data Table Enhancements

- [ ] Add bulk selection support to DataTable
- [ ] Add export functionality (CSV)
- [ ] Add column visibility toggle

## Specific Select Components

Each select component should use AutocompleteSelect with appropriate mode:

### ProjectTypeSelect (apps/app/src/components/organisms/projectType/ProjectTypeSelect.vue) - NEW

- [ ] Wrapper component using AutocompleteSelect in async mode
- [ ] Use useFetchProjectTypeList composable
- [ ] Pass search text to API: `get({ query: { search: searchText } })`
- [ ] Display function: `(type) => type.name`
- [ ] Required field in project forms

### ProjectSelect (apps/app/src/components/organisms/project/ProjectSelect.vue) - NEW

- [ ] Wrapper component using AutocompleteSelect in async mode
- [ ] Use useFetchProjectList composable
- [ ] Pass search text to API: `get({ query: { name: searchText } })`
- [ ] Display function: `(project) => `${project.projectNumber} - ${project.name}``
- [ ] Support filtering by active/archived in fetch function
- [ ] Used in time entry forms

### CountrySelect (apps/app/src/components/atoms/CountrySelect.vue) - NEW

- [ ] Wrapper component using AutocompleteSelect in static mode
- [ ] Import COUNTRIES from validations package
- [ ] Transform to options array in setup
- [ ] Display function: `(country) => country.name`
- [ ] No API calls needed
- [ ] Used in location forms

### CantonSelect (apps/app/src/components/atoms/CantonSelect.vue) - NEW

- [ ] Wrapper component using AutocompleteSelect in static mode
- [ ] Import SWISS_CANTONS from validations package
- [ ] Transform to options array in setup
- [ ] Display function: `(canton) => canton.name`
- [ ] Props: modelValue, disabled (disable when country !== 'CH')
- [ ] Used in location forms only when Switzerland is selected

## Common List View Features

### FilterPanel Component (apps/app/src/components/molecules/FilterPanel.vue) - NEW

- [ ] Create reusable filter panel component
- [ ] Support different filter types:
    - Text search
    - Select dropdowns
    - Date ranges
    - Boolean toggles
- [ ] Emit filter changes
- [ ] Show active filter count
- [ ] Clear all filters button

### BulkActions Component (apps/app/src/components/molecules/BulkActions.vue) - NEW

- [ ] Create reusable bulk actions bar
- [ ] Show when items are selected
- [ ] Display selection count
- [ ] Support custom action buttons
- [ ] Clear selection button

## Common Form Components

### FormLayout Component (apps/app/src/components/templates/FormLayout.vue) - NEW

- [ ] Create consistent form layout template
- [ ] Header with title
- [ ] Form content area with consistent spacing
- [ ] Footer with action buttons
- [ ] Loading overlay support
- [ ] Error summary display

### ConfirmDialog Component (apps/app/src/components/molecules/ConfirmDialog.vue) - NEW

- [ ] Create reusable confirmation dialog
- [ ] Support different types (delete, archive, etc.)
- [ ] Customizable title and message
- [ ] Danger/warning styling for destructive actions
- [ ] Return promise for action result

## Notes

- All select components should follow the same UX pattern as UserSelect
- Consider performance with large datasets (virtual scrolling)
- Ensure accessibility (ARIA labels, keyboard navigation)
- Mobile-friendly (touch targets, responsive design)
- Consistent error handling across all components
