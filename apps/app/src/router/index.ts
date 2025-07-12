import { createRouter, createWebHistory } from "vue-router"
import ProjectListView from "@/views/project/ProjectListView.vue"
import InvoiceListView from "@/views/invoice/InvoiceListView.vue"
import EditInvoiceView from "@/views/invoice/EditInvoiceView.vue"
import PreviewInvoiceView from "@/views/invoice/PreviewInvoiceView.vue"
import CollaboratorListView from "../views/collaborator/CollaboratorListView.vue"
import CollaboratorEditView from "../views/collaborator/CollaboratorEditView.vue"
import TimeListView from "../views/time/TimeListView.vue"
import TimeEditView from "../views/time/TimeEditView.vue"
import TariffListView from "../views/tariff/TariffListView.vue"
import TariffEditView from "../views/tariff/TariffEditView.vue"
import ProjectEditView from "../views/project/ProjectEditView.vue"
import ProjectTypeListView from "../views/projectType/ProjectTypeListView.vue"
import ProjectTypeEditView from "../views/projectType/ProjectTypeEditView.vue"
import ProjectPreviewView from "../views/project/ProjectPreviewView.vue"
import ActivityTypeListView from "../views/activityType/ActivityTypeListView.vue"
import ActivityTypeEditView from "../views/activityType/ActivityTypeEditView.vue"
import LoginView from "../views/LoginView.vue"
import { useAuthStore } from "../stores/auth"

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: "/login",
            name: "login",
            component: LoginView,
            meta: { requiresAuth: false },
        },
        {
            path: "/",
            name: "home",
            component: ProjectListView,
            meta: { requiresAuth: true },
        },
        {
            path: "/project",
            name: "project-list",
            component: ProjectListView,
            meta: { requiresAuth: true },
        },
        {
            path: "/project/:id/edit",
            name: "project-edit",
            component: ProjectEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/project/:id/view",
            name: "project-view",
            component: ProjectPreviewView,
            meta: { requiresAuth: true },
        },
        // Project Type routes
        {
            path: "/project-type/new",
            name: "project-type-new",
            component: ProjectTypeEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/project-type/:id/edit",
            name: "project-type-edit",
            component: ProjectTypeEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/project-type",
            name: "project-type-list",
            component: ProjectTypeListView,
            meta: { requiresAuth: true },
        },
        // Invoice routes
        {
            path: "/invoice/new",
            name: "invoice-new",
            component: EditInvoiceView,
            meta: { requiresAuth: true },
        },
        {
            path: "/invoice/:id/edit",
            name: "invoice-edit",
            component: EditInvoiceView,
            meta: { requiresAuth: true },
        },
        {
            path: "/invoice",
            name: "invoice-list",
            component: InvoiceListView,
            meta: { requiresAuth: true },
        },
        {
            path: "/invoice/:id/preview",
            name: "invoice-preview",
            component: PreviewInvoiceView,
            meta: { requiresAuth: true },
        },
        // Collaborator routes
        {
            path: "/collaborator/new",
            name: "collaborator-new",
            component: CollaboratorEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/collaborator/:id/edit",
            name: "collaborator-edit",
            component: CollaboratorEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/collaborator",
            name: "collaborator-list",
            component: CollaboratorListView,
            meta: { requiresAuth: true },
        },
        // Activity routes
        {
            path: "/activity/new",
            name: "activity-new",
            component: ActivityTypeEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/activity/:id/edit",
            name: "activity-edit",
            component: ActivityTypeEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/activity",
            name: "activity-list",
            component: ActivityTypeListView,
            meta: { requiresAuth: true },
        },

        // Time entry routes
        {
            path: "/time/new",
            name: "time-new",
            component: TimeEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/time/:id/edit",
            name: "time-edit",
            component: TimeEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/time",
            name: "time-list",
            component: TimeListView,
            meta: { requiresAuth: true },
        },
        // Tariff routes
        {
            path: "/tariff/new",
            name: "tariff-new",
            component: TariffEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/tariff/:id/edit",
            name: "tariff-edit",
            component: TariffEditView,
            meta: { requiresAuth: true },
        },
        {
            path: "/tariff",
            name: "tariff-list",
            component: TariffListView,
            meta: { requiresAuth: true },
        },
    ],
})

// Navigation guard
router.beforeEach((to, from, next) => {
    const authStore = useAuthStore()
    const requiresAuth = to.meta.requiresAuth !== false // Default to requiring auth

    if (requiresAuth && !authStore.isAuthenticated) {
        // Redirect to login if authentication is required but user is not authenticated
        next({ name: "login" })
    } else {
        // Continue to the requested route
        next()
    }
})

export default router
