<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router"
import { useI18n } from "vue-i18n"
import { ref, computed } from "vue"
import { Bars3Icon, XMarkIcon } from "@heroicons/vue/24/outline"
const { t } = useI18n()
const isSidebarOpen = ref(false)

const toggleSidebar = () => {
    isSidebarOpen.value = !isSidebarOpen.value
}

// Navigation items with their routes and active states
const navigation = computed(() => [
    {
        name: t("navigation.projects"),
        to: "/",
        current: window.location.pathname === "/",
    },
    {
        name: t("navigation.invoices"),
        to: { name: "invoice-new" },
        current: window.location.pathname === "/invoice",
    },
    {
        name: "Projects",
        to: "/projects",
        current: window.location.pathname === "/projects",
    },
    {
        name: "File Browser",
        to: "/files",
        current: window.location.pathname === "/files",
    },
    {
        name: "Settings",
        to: "/settings",
        current: window.location.pathname === "/settings",
    },
])
</script>

<template>
    <div class="flex flex-col min-h-screen overflow-x-hidden">
        <!-- Header for all viewports with toggle button -->
        <header class="flex items-center p-2 border-b border-gray-200">
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
                :class="{ 'lg:mr-64': isSidebarOpen }"
            >
                <div class="container mx-auto">
                    <RouterView />
                </div>
            </main>

            <!-- Mobile: Overlay sidebar; Desktop: Fixed position sidebar that doesn't overlay content -->
            <aside
                class="fixed lg:absolute inset-y-0 right-0 flex flex-col w-64 transition-all duration-300 ease-in-out z-20"
                :class="[isSidebarOpen ? 'translate-x-0' : 'translate-x-full']"
            >
                <!-- Sidebar component -->
                <div
                    class="flex min-h-0 flex-1 flex-col border-l border-gray-200 bg-white shadow-lg"
                >
                    <div class="flex flex-1 flex-col overflow-y-auto pt-5 pb-4">
                        <div class="flex flex-shrink-0 items-center px-4 lg:hidden">
                            <button
                                class="ml-auto inline-flex items-center justify-center p-1 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none"
                                @click="toggleSidebar"
                            >
                                <span class="sr-only">Close sidebar</span>
                                <span class="text-xxl"><XMarkIcon class="h-6 w-6" /></span>
                            </button>
                        </div>
                        <nav class="mt-5 flex-1 space-y-1 bg-white px-2">
                            <RouterLink
                                v-for="item in navigation"
                                :key="item.name"
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
                        </nav>
                    </div>
                    <div class="flex flex-shrink-0 border-t border-gray-200 p-4">
                        <div class="group block w-full flex-shrink-0">
                            <div class="flex items-center">
                                <div
                                    class="h-9 w-9 rounded-full bg-gray-200 flex items-center justify-center"
                                >
                                    <span class="text-gray-600 text-xs font-medium">User</span>
                                </div>
                                <div class="ml-3">
                                    <p
                                        class="text-sm font-medium text-gray-700 group-hover:text-gray-900"
                                    >
                                        Example User
                                    </p>
                                    <p
                                        class="text-xs font-medium text-gray-500 group-hover:text-gray-700"
                                    >
                                        View profile
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>
        </div>

        <!-- Sidebar overlay for mobile - only covers main content -->
        <div
            v-show="isSidebarOpen"
            @click="toggleSidebar"
            class="fixed inset-y-0 left-0 right-64 z-10 lg:hidden"
        ></div>
    </div>
</template>
