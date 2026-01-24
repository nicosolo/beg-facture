import type { ActivityResponse } from "@beg/validations"
import { useAuthStore } from "@/stores/auth"

export function useActivityLock() {
    const authStore = useAuthStore()

    const isActivityLocked = (activity: ActivityResponse | { date: Date | string }): boolean => {
        // Admin and super_admin users can always edit/delete
        if (authStore.user?.role === "admin" || authStore.user?.role === "super_admin") {
            return false
        }

        const activityDate = new Date(activity.date)
        const daysDifference = Math.floor(
            (Date.now() - activityDate.getTime()) / (1000 * 60 * 60 * 24)
        )
        return daysDifference > 60
    }

    const canEditActivity = (activity: ActivityResponse | { date: Date | string }): boolean => {
        return !isActivityLocked(activity)
    }

    const canDeleteActivity = (activity: ActivityResponse | { date: Date | string }): boolean => {
        return !isActivityLocked(activity)
    }

    const canToggleBilled = (activity: ActivityResponse): boolean => {
        if (authStore.user?.role === "admin" || authStore.user?.role === "super_admin") {
            return true
        }
        return activity.userProjectRole === "manager"
    }

    return {
        isActivityLocked,
        canEditActivity,
        canDeleteActivity,
        canToggleBilled,
    }
}
