import { Hono } from "hono"
import type { Context } from "hono"
import { zValidator } from "@hono/zod-validator"
import {
    invoiceFilterSchema,
    invoiceResponseSchema,
    invoiceCreateSchema,
    invoiceUpdateSchema,
    idParamSchema,
    invoiceListResponse,
    type InvoiceCreateInput,
    type InvoiceUpdateInput,
} from "@beg/validations"
import { invoiceRepository } from "../db/repositories/invoice.repository"
import { projectRepository } from "../db/repositories/project.repository"
import { authMiddleware } from "@src/tools/auth-middleware"
import { responseValidator } from "@src/tools/response-validator"
import { throwNotFound, throwValidationError, parseZodError } from "@src/tools/error-handler"
import type { Variables } from "@src/types/global"
import { roleMiddleware } from "@src/tools/role-middleware"
import { findProjectInvoiceFolder } from "@src/tools/project-folder-finder"
import { ZodError } from "zod"
import path from "node:path"
import { mkdir } from "node:fs/promises"
import { createWriteStream } from "node:fs"
import { Readable } from "node:stream"
import { pipeline } from "node:stream/promises"

type UploadedInvoiceFiles = {
    invoiceDocument?: File
    offers: Record<number, File>
    adjudications: Record<number, File>
}

const isMultipartRequest = (contentType: string | undefined) =>
    Boolean(contentType && contentType.includes("multipart/form-data"))

const collectUploadedFiles = (formData: FormData): UploadedInvoiceFiles => {
    const files: UploadedInvoiceFiles = {
        offers: {},
        adjudications: {},
    }

    const invoiceDocument = formData.get("invoiceDocument")
    if (invoiceDocument instanceof File) {
        files.invoiceDocument = invoiceDocument
    }

    formData.forEach((value, key) => {
        if (!(value instanceof File)) return

        const offerMatch = key.match(/^offerFiles\[(\d+)\]$/)
        if (offerMatch) {
            files.offers[Number(offerMatch[1])] = value
            return
        }

        const adjudicationMatch = key.match(/^adjudicationFiles\[(\d+)\]$/)
        if (adjudicationMatch) {
            files.adjudications[Number(adjudicationMatch[1])] = value
        }
    })

    return files
}

const parseInvoicePayload = async (
    payload: unknown,
    mode: "create" | "update"
): Promise<InvoiceCreateInput | InvoiceUpdateInput> => {
    try {
        return mode === "create"
            ? invoiceCreateSchema.parse(payload)
            : invoiceUpdateSchema.parse(payload)
    } catch (error) {
        if (error instanceof ZodError) {
            throwValidationError("Invalid invoice payload", parseZodError(error))
        }
        throw error
    }
}

const parseInvoiceRequestBody = async (
    c: Context<{ Variables: Variables }>,
    mode: "create" | "update"
): Promise<{
    invoiceData: InvoiceCreateInput | InvoiceUpdateInput
    uploadedFiles: UploadedInvoiceFiles
}> => {
    const contentType = c.req.header("content-type")

    if (isMultipartRequest(contentType)) {
        const formData = await c.req.formData()
        const payloadRaw = formData.get("payload")
        if (typeof payloadRaw !== "string") {
            throwValidationError("Missing invoice payload")
        }

        let parsedPayload: unknown
        try {
            parsedPayload = JSON.parse(payloadRaw)
        } catch (error) {
            throwValidationError("Invalid invoice payload format")
        }

        const invoiceData = await parseInvoicePayload(parsedPayload, mode)
        const uploadedFiles = collectUploadedFiles(formData)

        return { invoiceData, uploadedFiles }
    }

    try {
        const jsonPayload = await c.req.json()
        const invoiceData = await parseInvoicePayload(jsonPayload, mode)
        return { invoiceData, uploadedFiles: { offers: {}, adjudications: {} } }
    } catch (error) {
        if (error instanceof SyntaxError) {
            throwValidationError("Invalid invoice payload")
        }
        throw error
    }
}

const hasUploadedFiles = (files: UploadedInvoiceFiles) => {
    return (
        Boolean(files.invoiceDocument) ||
        Object.keys(files.offers).length > 0 ||
        Object.keys(files.adjudications).length > 0
    )
}

const sanitizeFileName = (filename: string) => {
    const base = path.basename(filename)
    const sanitized = base.replace(/[\\/:*?"<>|]/g, "_").trim()
    return sanitized.length > 0 ? sanitized : `document-${Date.now()}`
}

const writeUploadedFile = async (file: File, destinationPath: string) => {
    await mkdir(path.dirname(destinationPath), { recursive: true })
    const readable = Readable.fromWeb(file.stream())
    const writable = createWriteStream(destinationPath)
    await pipeline(readable, writable)
}

const persistUploadedFiles = async (
    invoiceData: InvoiceCreateInput | InvoiceUpdateInput,
    files: UploadedInvoiceFiles,
    destinationFolder: string
) => {
    if (!hasUploadedFiles(files)) {
        return
    }

    await mkdir(destinationFolder, { recursive: true })

    if (files.invoiceDocument) {
        const safeName = sanitizeFileName(files.invoiceDocument.name)
        const destinationPath = path.join(destinationFolder, safeName)
        await writeUploadedFile(files.invoiceDocument, destinationPath)
        ;(invoiceData as any).invoiceDocument = safeName
    }

    if (files.offers) {
        const offers = Array.isArray(invoiceData.offers) ? [...invoiceData.offers] : []
        for (const [indexKey, file] of Object.entries(files.offers)) {
            const index = Number(indexKey)
            if (!file) continue
            const safeName = sanitizeFileName(file.name)
            const destinationPath = path.join(destinationFolder, safeName)
            await writeUploadedFile(file, destinationPath)

            if (offers[index]) {
                offers[index] = { ...offers[index], file: safeName }
            } else {
                offers[index] = { file: safeName } as any
            }
        }
        invoiceData.offers = offers as any
    }

    if (files.adjudications) {
        const adjudications = Array.isArray(invoiceData.adjudications)
            ? [...invoiceData.adjudications]
            : []

        for (const [indexKey, file] of Object.entries(files.adjudications)) {
            const index = Number(indexKey)
            if (!file) continue
            const safeName = sanitizeFileName(file.name)
            const destinationPath = path.join(destinationFolder, safeName)
            await writeUploadedFile(file, destinationPath)

            if (adjudications[index]) {
                adjudications[index] = { ...adjudications[index], file: safeName }
            } else {
                adjudications[index] = { file: safeName } as any
            }
        }

        invoiceData.adjudications = adjudications as any
    }
}

const handleInvoiceUploads = async (
    invoiceData: InvoiceCreateInput | InvoiceUpdateInput,
    files: UploadedInvoiceFiles,
    user: Variables["user"]
) => {
    if (!hasUploadedFiles(files)) {
        return
    }

    const projectId = invoiceData.projectId

    if (!projectId) {
        throwValidationError("Project ID is required to upload invoice documents")
    }

    const project = await projectRepository.findById(projectId, user)
    if (!project) {
        throwValidationError("Project not found for invoice", [
            { field: "projectId", message: "Project could not be found" },
        ])
    }

    const invoiceFolder = await findProjectInvoiceFolder(project.projectNumber)
    if (!invoiceFolder) {
        throwValidationError("Invoice folder not found", [
            {
                field: "projectId",
                message: "No folder starting with '9' found for this project",
            },
        ])
    }

    await persistUploadedFiles(invoiceData, files, invoiceFolder.fullPath)
}

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
        responseValidator({
            201: invoiceResponseSchema,
        }),
        async (c) => {
            const user = c.get("user")
            const { invoiceData: parsedInvoice, uploadedFiles } = await parseInvoiceRequestBody(
                c,
                "create"
            )
            const invoiceData = parsedInvoice as InvoiceCreateInput

            if (!invoiceData.projectId) {
                throwValidationError("Project ID is required for invoice creation", [
                    { field: "projectId", message: "Missing project reference" },
                ])
            }

            await handleInvoiceUploads(invoiceData, uploadedFiles, user)
            const newInvoice = await invoiceRepository.create(invoiceData, user)
            return c.render(newInvoice, 201)
        }
    )
    .put(
        "/:id",
        zValidator("param", idParamSchema),
        responseValidator({
            200: invoiceResponseSchema,
        }),
        async (c) => {
            const { id } = c.req.valid("param")
            const user = c.get("user")
            const { invoiceData: parsedInvoice, uploadedFiles } = await parseInvoiceRequestBody(
                c,
                "update"
            )
            const invoiceData = parsedInvoice as InvoiceUpdateInput

            await handleInvoiceUploads(invoiceData, uploadedFiles, user)
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
