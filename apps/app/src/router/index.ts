import { createRouter, createWebHistory } from "vue-router"
import ProjectListView from "@/views/ProjectListView.vue"
import InvoiceListView from "@/views/invoice/InvoiceListView.vue"
import EditInvoiceView from "@/views/invoice/EditInvoiceView.vue"
import PreviewInvoiceView from "@/views/invoice/PreviewInvoiceView.vue"

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
            name: "project",
            component: ProjectListView,
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
            name: "invoice",
            component: InvoiceListView,
        },
        {
            path: "/invoice/:id/preview",
            name: "invoice-preview",
            component: PreviewInvoiceView,
        },
    ],
})

export default router
