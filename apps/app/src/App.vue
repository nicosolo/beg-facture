<script setup lang="ts">
import { RouterLink, RouterView, useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import { ref, computed, watch, onMounted } from "vue"
import { Bars3Icon, XMarkIcon, ChevronDownIcon, ChevronRightIcon } from "@heroicons/vue/24/outline"
import { useAuthStore } from "./stores/auth"
import { useAlert } from "./composables/utils/useAlert"
import Snackbar from "./components/atoms/Snackbar.vue"
import Button from "./components/atoms/Button.vue"

const { t } = useI18n()
const isSidebarOpen = ref(false)
const { alerts, removeAlert } = useAlert()
const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

// Check if the current route is the login page
const isLoginPage = computed(() => route.name === "login")

const toggleSidebar = () => {
    isSidebarOpen.value = !isSidebarOpen.value
}

// Handle logout with router navigation
const handleLogout = () => {
    // Clear auth data from the store and localStorage
    authStore.logout()

    // Navigate to login
    router.push("/login")
}

// Navigation items with their routes and active states
const navigation = computed(() =>
    [
        {
            name: t("navigation.time"),
            to: { name: "time-list" },
            current: route.name === "time-list",
        },
        {
            name: t("navigation.projects"),
            to: { name: "project-list" },
            current: route.name === "project-list",
        },
        {
            name: t("navigation.invoices"),
            to: { name: "invoice-list" },
            current: route.name === "invoice-list",
        },
        {
            name: t("navigation.settings"),
            visible: authStore.user?.role === "admin",
            children: [
                {
                    name: t("navigation.collaborators"),
                    to: { name: "collaborator-list" },
                    current: route.name === "collaborator-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("navigation.activities"),
                    to: { name: "activity-list" },
                    current: route.name === "activity-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("navigation.tariffs"),
                    to: { name: "tariff-list" },
                    current: route.name === "tariff-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("navigation.projectTypes"),
                    to: { name: "project-type-list" },
                    current: route.name === "project-type-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("navigation.locations"),
                    to: { name: "location-list" },
                    current: route.name === "location-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("navigation.clients"),
                    to: { name: "client-list" },
                    current: route.name === "client-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("navigation.companies"),
                    to: { name: "company-list" },
                    current: route.name === "company-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("navigation.engineers"),
                    to: { name: "engineer-list" },
                    current: route.name === "engineer-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: "Taux TVA",
                    to: { name: "vat-rate-list" },
                    current: route.name === "vat-rate-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: t("monthlyHours.title"),
                    to: { name: "monthly-hours-list" },
                    current: route.name === "monthly-hours-list",
                    visible: authStore.user?.role === "admin",
                },
                {
                    name: "Import DB",
                    to: { name: "database-import" },
                    current: route.name === "database-import",
                    visible: authStore.user?.role === "admin",
                },
            ].filter((item) => item.visible !== false),
            // Mark parent as current if any child is current
            get current() {
                return this.children.some((child) => child.current)
            },
        },
    ].filter((item) => item.visible !== false)
)

const expandedItems = ref<Record<string, boolean>>({})

// Initialize expandedItems based on current route
const initializeExpandedItems = () => {
    navigation.value.forEach((item) => {
        if (item.children && item.current) {
            expandedItems.value[item.name] = true
        }
    })
}

// Watch route changes to update expanded items
watch(
    () => route.name,
    () => {
        initializeExpandedItems()
    }
)

// Initialize on mount (for page reload)
onMounted(() => {
    initializeExpandedItems()
})

const toggleNestedMenu = (itemName: string) => {
    expandedItems.value[itemName] = !expandedItems.value[itemName]
}

const isExpanded = (itemName: string): boolean => {
    return !!expandedItems.value[itemName]
}
</script>

<template>
    <div class="flex flex-col min-h-screen overflow-x-hidden">
        <!-- Header for all viewports with toggle button - hidden on login page -->
        <header
            v-if="!isLoginPage"
            class="flex items-center p-2 border-b border-gray-200 print:hidden"
        >
            <div class="flex justify-between items-center w-full">
                <RouterLink to="/">
                    <div class="flex items-center">
                        <img alt="BEG logo" class="h-7 w-auto mr-4" src="@/assets/logo.png" />

                        <h2 class="text-2xl font-bold">Management</h2>
                    </div>
                </RouterLink>

                <button
                    class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none"
                    @click="toggleSidebar"
                >
                    <span class="sr-only">Toggle sidebar</span>
                    <span class="text-3xl"><Bars3Icon class="h-6 w-6" /></span>
                </button>
            </div>
        </header>

        <div class="flex flex-1 relative overflow-hidden">
            <!-- Main content - no margin adjustment, sidebar will overlay -->
            <main class="flex-1 p-4 w-full">
                <div class="container mx-auto md:max-w-full md:px-4">
                    <RouterView />
                </div>
            </main>

            <!-- Overlay sidebar for all viewports -->
            <aside
                v-if="!isLoginPage"
                class="fixed top-0 right-0 h-screen flex flex-col w-64 transition-all duration-300 ease-in-out z-30"
                :class="[isSidebarOpen ? 'translate-x-0' : 'translate-x-full']"
            >
                <!-- Sidebar component -->
                <div class="flex h-full flex-col border-l border-gray-200 bg-white shadow-lg">
                    <!-- Close button - always visible when sidebar is open -->
                    <div class="flex flex-shrink-0 items-center px-4 pt-5">
                        <button
                            class="ml-auto inline-flex items-center justify-center p-1 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none"
                            @click="toggleSidebar"
                        >
                            <span class="sr-only">Close sidebar</span>
                            <span class="text-xxl"><XMarkIcon class="h-6 w-6" /></span>
                        </button>
                    </div>
                    <!-- Scrollable navigation area -->
                    <div class="flex-1 overflow-y-auto pt-5 pb-4">
                        <nav class="space-y-1 bg-white px-2">
                            <template v-for="item in navigation" :key="item.name">
                                <!-- Parent item with children -->
                                <div v-if="item.children" class="space-y-1">
                                    <button
                                        @click="toggleNestedMenu(item.name)"
                                        :class="[
                                            item.current
                                                ? 'bg-gray-100 text-gray-900'
                                                : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900',
                                            'group flex w-full items-center justify-between px-2 py-2 text-sm font-medium rounded-md cursor-pointer',
                                        ]"
                                    >
                                        <span>{{ item.name }}</span>
                                        <span class="text-gray-500">
                                            <ChevronDownIcon
                                                v-if="isExpanded(item.name)"
                                                class="h-4 w-4"
                                            />
                                            <ChevronRightIcon v-else class="h-4 w-4" />
                                        </span>
                                    </button>
                                    <!-- Nested children -->
                                    <div v-if="isExpanded(item.name)" class="ml-3 space-y-1">
                                        <RouterLink
                                            v-for="child in item.children"
                                            :key="child.name"
                                            :to="child.to"
                                            :class="[
                                                child.current
                                                    ? 'bg-gray-100 text-gray-900'
                                                    : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900',
                                                'group flex items-center px-2 py-2 text-sm font-medium rounded-md',
                                            ]"
                                            @click="toggleSidebar"
                                        >
                                            {{ child.name }}
                                        </RouterLink>
                                    </div>
                                </div>
                                <!-- Regular item without children -->
                                <RouterLink
                                    v-else
                                    :to="item.to"
                                    :class="[
                                        item.current
                                            ? 'bg-gray-100 text-gray-900'
                                            : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900',
                                        'group flex items-center px-2 py-2 text-sm font-medium rounded-md',
                                    ]"
                                    @click="toggleSidebar"
                                >
                                    {{ item.name }}
                                </RouterLink>
                            </template>
                        </nav>
                    </div>
                    <!-- User info section - fixed at bottom -->
                    <div class="flex-shrink-0 border-t border-gray-200 p-4">
                        <div class="group block w-full flex-shrink-0">
                            <div class="items-center">
                                <div class="ml-3 flex-grow">
                                    <p
                                        class="text-sm font-medium text-gray-700 group-hover:text-gray-900"
                                    >
                                        {{ authStore.user?.firstName }}
                                        {{ authStore.user?.lastName }}
                                    </p>
                                    <p
                                        class="text-xs font-medium text-gray-500 group-hover:text-gray-700"
                                    >
                                        {{ authStore.user?.email }}
                                    </p>
                                </div>
                                <Button @click="handleLogout" variant="ghost-danger" class="mt-2">
                                    {{ t("navigation.logout") }}
                                </Button>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>
        </div>

        <!-- Sidebar overlay - covers entire screen when sidebar is open -->
        <div
            v-if="!isLoginPage && isSidebarOpen"
            @click="toggleSidebar"
            class="fixed inset-0 bg-black/30 z-20"
        ></div>

        <!-- Global Snackbar Container -->
        <div
            aria-live="assertive"
            class="pointer-events-none fixed inset-0 flex items-end px-4 py-6 sm:items-start sm:p-6 z-50"
        >
            <div class="flex w-full flex-col items-center space-y-4 sm:items-end">
                <Snackbar
                    v-for="alert in alerts"
                    :key="alert.id"
                    :visible="alert.visible"
                    :message="alert.message"
                    :type="alert.type"
                    @close="removeAlert(alert.id)"
                />
            </div>
        </div>
    </div>
</template>
