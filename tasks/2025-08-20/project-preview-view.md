# Project Preview View - Implementation Tasks

## Overview

Enhance the ProjectPreviewView component to display comprehensive project information including latest time entries, billing summary, and related activities.

## Current State

- ✅ Basic project details display
- ✅ Layout structure with responsive grid
- ⚠️ Time entries section present but not connected
- ❌ Missing invoice address from client data
- ❌ Missing latest time entries
- ❌ Missing billing/unbilled hours summary
- ❌ Missing activity statistics
- ❌ Missing document management
- ❌ Missing quick actions

## Task 1: Backend API Enhancements

### 1.1 Extend Project Response

**File:** `packages/validations/validations/project.ts`

- [ ] Add billing summary fields to project response
- [ ] Add activity statistics to response

```typescript
export const projectDetailResponseSchema = projectResponseSchema.extend({
    // Billing summary
    totalBilledAmount: z.number().nullable(),
    totalUnbilledAmount: z.number().nullable(),
    lastInvoiceDate: z.coerce.date().nullable(),
    lastInvoiceNumber: z.string().nullable(),

    // Activity summary
    totalActivities: z.number(),
    activeCollaborators: z.array(
        z.object({
            id: z.number(),
            name: z.string(),
            totalHours: z.number(),
        })
    ),
})
```

### 1.2 Create Time Entries Endpoint for Project

**File:** `apps/api/src/routes/project.ts`

- [ ] Add GET `/project/:id/time-entries` endpoint
- [ ] Add pagination support
- [ ] Add date range filtering
- [ ] Add sorting by date

### 1.3 Create Activity Summary Endpoint

**File:** `apps/api/src/routes/project.ts`

- [ ] Add GET `/project/:id/activity-summary` endpoint
- [ ] Return aggregated data by activity type
- [ ] Include unbilled hours per activity
- [ ] Include last activity date

### 1.4 Repository Methods

**File:** `apps/api/src/db/repositories/project.repository.ts`

- [ ] Add `findTimeEntriesByProjectId` method
- [ ] Add `getActivitySummary` method
- [ ] Add `getBillingSummary` method

## Task 2: Frontend API Integration

### 2.1 Create Time Entries Composable

**File:** `apps/app/src/composables/api/useProjectTimeEntries.ts`

```typescript
export function useFetchProjectTimeEntries() {
    return useGet<TimeEntriesResponse>("project/:id/time-entries", {
        params: idParamSchema,
        query: timeEntriesFilterSchema,
    })
}
```

### 2.2 Create Activity Summary Composable

**File:** `apps/app/src/composables/api/useProjectActivity.ts`

```typescript
export function useFetchProjectActivitySummary() {
    return useGet<ActivitySummaryResponse>("project/:id/activity-summary", {
        params: idParamSchema,
    })
}
```

## Task 3: Enhanced Preview Components

### 3.1 Project Information Card

**Current:** Basic project details
**Enhanced:**

- [ ] Add project status badge (active/ended/archived)
- [ ] Add progress indicator for project completion
- [ ] Add last updated timestamp
- [ ] Display full invoice address from client
- [ ] Add project duration (from start to now/end)
- [ ] Add total budget vs spent (if applicable)

### 3.2 Time Entries Section

**Current:** Empty placeholder
**Enhanced:**

- [ ] Connect to real time entries API
- [ ] Display latest 10 time entries by default
- [ ] Add pagination for viewing more
- [ ] Add inline editing capability
- [ ] Add quick time entry button
- [ ] Group by date with daily totals
- [ ] Add export to Excel/CSV

### 3.3 Billing Summary Card

**New Component:** Create billing overview

- [ ] Total billed hours
- [ ] Total unbilled hours
- [ ] Unbilled amount estimate
- [ ] Last invoice date and number
- [ ] Quick invoice generation button
- [ ] Billing rate information

### 3.4 Activity Statistics Card

**New Component:** Create activity overview

- [ ] Chart showing hours by activity type
- [ ] Top 5 activities by hours
- [ ] Activity trend over time
- [ ] Active vs inactive periods
- [ ] Collaborator contribution chart

### 3.5 Team Members Card

**New Component:** Display project team

- [ ] List of collaborators with hours
- [ ] Project manager highlight
- [ ] Access level indicators
- [ ] Add/remove team members
- [ ] Contact information

## Task 4: Interactive Features

### 4.1 Quick Actions Toolbar

- [ ] Add time entry button
- [ ] Generate invoice button
- [ ] Export project report
- [ ] Archive/unarchive project
- [ ] Duplicate project
- [ ] Print project summary

### 4.2 Inline Editing

- [ ] Enable inline edit for remarks
- [ ] Enable inline edit for project manager
- [ ] Enable inline edit for status
- [ ] Add save/cancel controls
- [ ] Add validation feedback

### 4.3 Tab Navigation

- [ ] Overview tab (current view)
- [ ] Time entries tab (detailed list)
- [ ] Documents tab (future feature)
- [ ] Invoices tab (billing history)
- [ ] Activity log tab (audit trail)

## Task 5: Update ProjectPreviewView Component

### 5.1 Component Structure

```vue
<template>
    <div class="project-preview">
        <!-- Header with actions -->
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-2xl font-bold">{{ project.projectNumber }} - {{ project.name }}</h1>
                <StatusBadge :status="project.status" />
            </div>
            <QuickActions :project="project" />
        </div>

        <!-- Tab navigation -->
        <TabNavigation v-model="activeTab" :tabs="tabs" />

        <!-- Tab content -->
        <div v-if="activeTab === 'overview'">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Project Details Card -->
                <ProjectDetailsCard :project="project" />

                <!-- Billing Summary Card -->
                <BillingSummaryCard :project="project" />

                <!-- Activity Statistics Card -->
                <ActivityStatsCard :project="project" />

                <!-- Recent Time Entries -->
                <div class="lg:col-span-2">
                    <RecentTimeEntries :projectId="project.id" :limit="10" />
                </div>

                <!-- Team Members -->
                <TeamMembersCard :project="project" />
            </div>
        </div>

        <!-- Other tabs content -->
        <TimeEntriesTab v-if="activeTab === 'time'" :project="project" />
        <InvoicesTab v-if="activeTab === 'invoices'" :project="project" />
        <ActivityLogTab v-if="activeTab === 'activity'" :project="project" />
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from "vue"
import { useRoute } from "vue-router"
import { useFetchProject } from "@/composables/api/useProject"
import { useFetchProjectTimeEntries } from "@/composables/api/useProjectTimeEntries"
import { useFetchProjectActivitySummary } from "@/composables/api/useProjectActivity"

const route = useRoute()
const projectId = computed(() => parseInt(route.params.id as string))

// Tabs
const activeTab = ref("overview")
const tabs = [
    { key: "overview", label: "Overview", icon: "dashboard" },
    { key: "time", label: "Time Entries", icon: "clock" },
    { key: "invoices", label: "Invoices", icon: "receipt" },
    { key: "activity", label: "Activity Log", icon: "history" },
]

// Fetch project data
const { get: fetchProject, data: project, loading } = useFetchProject()
const { get: fetchTimeEntries, data: timeEntries } = useFetchProjectTimeEntries()
const { get: fetchActivitySummary, data: activitySummary } = useFetchProjectActivitySummary()

onMounted(async () => {
    if (projectId.value) {
        // Fetch all data in parallel
        await Promise.all([
            fetchProject({ id: projectId.value }),
            fetchTimeEntries({
                id: projectId.value,
                query: { limit: 10, sortBy: "date", sortOrder: "desc" },
            }),
            fetchActivitySummary({ id: projectId.value }),
        ])
    }
})
</script>
```

## Task 6: Data Visualization

### 6.1 Charts Integration

- [ ] Install chart library (Chart.js or similar)
- [ ] Create activity distribution pie chart
- [ ] Create time trend line chart
- [ ] Create team contribution bar chart
- [ ] Add chart export functionality

### 6.2 Statistics Components

- [ ] Create StatCard component for metrics
- [ ] Create ProgressBar component for completion
- [ ] Create Timeline component for activity history
- [ ] Create Sparkline component for trends

## Task 7: Real-time Updates

### 7.1 Auto-refresh

- [ ] Implement polling for time entries
- [ ] Update billing summary on changes
- [ ] Refresh activity statistics
- [ ] Show notification for new entries

### 7.2 Optimistic Updates

- [ ] Update UI immediately on actions
- [ ] Rollback on error
- [ ] Show sync status indicator

## Testing Requirements

- [ ] Test with projects with no time entries
- [ ] Test with projects with many time entries
- [ ] Test pagination functionality
- [ ] Test inline editing
- [ ] Test quick actions
- [ ] Test responsive layout
- [ ] Test chart rendering
- [ ] Test data export

## Performance Considerations

- [ ] Lazy load tabs content
- [ ] Implement virtual scrolling for long lists
- [ ] Cache API responses
- [ ] Debounce search/filter inputs
- [ ] Optimize chart rendering

## Future Enhancements

- [ ] Document management integration
- [ ] Project timeline/Gantt view
- [ ] Budget tracking
- [ ] Risk assessment
- [ ] Client portal access
- [ ] Email notifications
- [ ] Project templates
- [ ] Recurring projects

## Notes

- Keep consistent with existing UI patterns
- Ensure all text is translatable
- Follow accessibility best practices
- Consider mobile responsiveness
- Implement proper error boundaries
- Add loading skeletons for better UX
