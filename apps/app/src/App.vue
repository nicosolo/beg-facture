<script setup lang="ts">
import { RouterLink, RouterView, useRoute, useRouter } from "vue-router"
import { useI18n } from "vue-i18n"
import { ref, computed, watch, onMounted } from "vue"
import { Bars3Icon, XMarkIcon, ChevronDownIcon, ChevronRightIcon } from "@heroicons/vue/24/outline"
import { useAuthStore } from "./stores/auth"
import { useAlert } from "./composables/utils/useAlert"
import Snackbar from "./components/atoms/Snackbar.vue"

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
        <header v-if="!isLoginPage" class="flex items-center p-2 border-b border-gray-200">
            <div class="flex justify-between items-center w-full">
                <RouterLink to="/">
                    <img alt="BEG logo" class="h-7 w-auto mr-4" src="@/assets/logo.png" />
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
            <!-- Main content - adjust margin on desktop when sidebar is open -->
            <main
                class="flex-1 transition-all duration-300 p-4 w-full"
                :class="{ 'lg:mr-64': isSidebarOpen && !isLoginPage }"
            >
                <div class="container mx-auto md:max-w-full md:px-4">
                    <RouterView />
                </div>
            </main>

            <!-- Mobile: Overlay sidebar; Desktop: Fixed position sidebar that doesn't overlay content -->
            <aside
                v-if="!isLoginPage"
                class="fixed top-0 right-0 h-screen flex flex-col w-64 transition-all duration-300 ease-in-out z-20"
                :class="[isSidebarOpen ? 'translate-x-0' : 'translate-x-full']"
            >
                <!-- Sidebar component -->
                <div class="flex h-full flex-col border-l border-gray-200 bg-white shadow-lg">
                    <!-- Close button for mobile -->
                    <div class="flex flex-shrink-0 items-center px-4 pt-5 lg:hidden">
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
                                >
                                    {{ item.name }}
                                </RouterLink>
                            </template>
                        </nav>
                    </div>
                    <!-- User info section - fixed at bottom -->
                    <div class="flex-shrink-0 border-t border-gray-200 p-4">
                        <div class="group block w-full flex-shrink-0">
                            <div class="flex items-center">
                                <div
                                    class="h-10 min-w-10 rounded-full bg-gray-200 flex items-center justify-center"
                                >
                                    <span class="text-gray-600 text-sm font-medium uppercase">
                                        {{ authStore.user?.initials }}
                                    </span>
                                </div>
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
                                <button
                                    @click="handleLogout"
                                    class="ml-2 text-sm text-red-600 hover:text-red-800"
                                >
                                    {{ t("navigation.logout") }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>
        </div>

        <!-- Sidebar overlay for mobile - only covers main content -->
        <div
            v-if="!isLoginPage && isSidebarOpen"
            @click="toggleSidebar"
            class="fixed inset-y-0 left-0 right-64 z-10 lg:hidden"
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
