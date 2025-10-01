import { Hono } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    invoiceFilterSchema,
    invoiceResponseSchema,
    invoiceCreateSchema,
    invoiceUpdateSchema,
    idParamSchema,
    invoiceListResponse,
} from "@beg/validations"
import { invoiceRepository } from "../db/repositories/invoice.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import { throwNotFound } from "@src/tools/error-handler"
import type { Variables } from "@src/types/global"
import { roleMiddleware } from "@src/tools/role-middleware"

export const invoiceRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)
    .get(
        "/",
        zValidator("query", invoiceFilterSchema),
        responseValidator({
            200: invoiceListResponse,
        }),
        async (c) => {
            const filter = c.req.valid("query")
            const user = c.get("user")
            const result = await invoiceRepository.findAll(user, filter)
            return c.render(result, 200)
        }
    )
    .get(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: invoiceResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const user = c.get("user")
            const invoice = await invoiceRepository.findById(id, user)
            if (!invoice) {
                throwNotFound("Invoice")
            }
            return c.render(invoice, 200)
        }
    )
    .post(
        "/",
        zValidator("json", invoiceCreateSchema),
        responseValidator({
            201: invoiceResponseSchema,
        }),
        async (c) => {
            const invoiceData = c.req.valid("json")
            const user = c.get("user")
            const newInvoice = await invoiceRepository.create(invoiceData, user)
            return c.render(newInvoice, 201)
        }
    )
    .put(
        "/:id",
        zValidator("param", idParamSchema),
        zValidator("json", invoiceUpdateSchema),
        responseValidator({
            200: invoiceResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const invoiceData = c.req.valid("json")
            const user = c.get("user")
            const updatedInvoice = await invoiceRepository.update(id, invoiceData, user)
            if (!updatedInvoice) {
                throwNotFound("Invoice")
            }
            return c.render(updatedInvoice, 200)
        }
    )
    .post(
        "/:id/visa",
        roleMiddleware("super_admin"),
        zValidator("param", idParamSchema),
        responseValidator({
            200: invoiceResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const user = c.get("user")
            const updatedInvoice = await invoiceRepository.setVisa(id, user)
            if (!updatedInvoice) {
                throwNotFound("Invoice")
            }
            return c.render(updatedInvoice, 200)
        }
    )
    .delete("/:id", zValidator("param", idParamSchema), async (c) => {
        const { id } = c.req.valid("param")
        const user = c.get("user")
        const deleted = await invoiceRepository.delete(id, user)
        if (!deleted) {
            throwNotFound("Invoice")
        }
        return c.json({ message: "Invoice deleted successfully" }, 200)
    })
