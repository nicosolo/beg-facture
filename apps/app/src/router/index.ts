import { createRouter, createWebHistory } from "vue-router"
import ProjectListView from "@/views/project/ProjectListView.vue"
import InvoiceListView from "@/views/invoice/InvoiceListView.vue"
import EditInvoiceView from "@/views/invoice/EditInvoiceView.vue"
import PreviewInvoiceView from "@/views/invoice/PreviewInvoiceView.vue"
import CollaboratorListView from "../views/collaborator/CollaboratorListView.vue"
import CollaboratorEditView from "../views/collaborator/CollaboratorEditView.vue"
import ActivityListView from "../views/activity/ActivityListView.vue"
import ActivityEditView from "../views/activity/ActivityEditView.vue"
import TimeListView from "../views/time/TimeListView.vue"
import TimeEditView from "../views/time/TimeEditView.vue"
import TariffListView from "../views/tariff/TariffListView.vue"
import TariffEditView from "../views/tariff/TariffEditView.vue"
import ProjectEditView from "../views/project/ProjectEditView.vue"
import ProjectTypeListView from "../views/projectType/ProjectTypeListView.vue"
import ProjectPreviewView from "../views/project/ProjectPreviewView.vue"
const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: "/",
            name: "home",
            component: ProjectListView,
        },
        {
            path: "/project",
            name: "project-list",
            component: ProjectListView,
        },
        {
            path: "/project/:id/edit",
            name: "project-edit",
            component: ProjectEditView,
        },
        {
            path: "/project/:id/view",
            name: "project-view",
            component: ProjectPreviewView,
        },
        // Project Type routes
        {
            path: "/project-type",
            name: "project-type-list",
            component: ProjectTypeListView,
        },
        // Invoice routes
        {
            path: "/invoice/new",
            name: "invoice-new",
            component: EditInvoiceView,
        },
        {
            path: "/invoice/:id/edit",
            name: "invoice-edit",
            component: EditInvoiceView,
        },
        {
            path: "/invoice",
            name: "invoice-list",
            component: InvoiceListView,
        },
        {
            path: "/invoice/:id/preview",
            name: "invoice-preview",
            component: PreviewInvoiceView,
        },
        // Collaborator routes
        {
            path: "/collaborator/new",
            name: "collaborator-new",
            component: CollaboratorEditView,
        },
        {
            path: "/collaborator/:id/edit",
            name: "collaborator-edit",
            component: CollaboratorEditView,
        },
        {
            path: "/collaborator",
            name: "collaborator-list",
            component: CollaboratorListView,
        },
        // Activity routes
        {
            path: "/activity/new",
            name: "activity-new",
            component: ActivityEditView,
        },
        {
            path: "/activity/:id/edit",
            name: "activity-edit",
            component: ActivityEditView,
        },
        {
            path: "/activity",
            name: "activity-list",
            component: ActivityListView,
        },
        // Time entry routes
        {
            path: "/time/new",
            name: "time-new",
            component: TimeEditView,
        },
        {
            path: "/time/:id/edit",
            name: "time-edit",
            component: TimeEditView,
        },
        {
            path: "/time",
            name: "time-list",
            component: TimeListView,
        },
        // Tariff routes
        {
            path: "/tariff/new",
            name: "tariff-new",
            component: TariffEditView,
        },
        {
            path: "/tariff/:id/edit",
            name: "tariff-edit",
            component: TariffEditView,
        },
        {
            path: "/tariff",
            name: "tariff-list",
            component: TariffListView,
        },
    ],
})

export default router
