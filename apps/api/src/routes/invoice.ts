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
import {
    throwNotFound,
    throwValidationError,
    parseZodError,
    throwNoProjectFolderError,
} from "@src/tools/error-handler"
import type { Variables } from "@src/types/global"
import { roleMiddleware } from "@src/tools/role-middleware"
import { findProjectInvoiceFolder } from "@src/tools/project-folder-finder"
import { PROJECT_BASE_DIR } from "@src/config"
import { z, ZodError } from "zod"
import path from "node:path"
import { mkdir, stat } from "node:fs/promises"
import { createReadStream, createWriteStream } from "node:fs"
import { Readable } from "node:stream"
import { pipeline } from "node:stream/promises"
import {
    guessMimeType,
    contentDispositionInline,
    normalizeStoredPath,
    fileBaseName,
    matchesStoredPath,
    pathIsWithin,
} from "@src/tools/file-utils"

type UploadedInvoiceFiles = {
    invoiceDocument?: File
    offers: Record<number, File>
    adjudications: Record<number, File>
    situations: Record<number, File>
    documents: Record<number, File>
}

const isMultipartRequest = (contentType: string | undefined) =>
    Boolean(contentType && contentType.includes("multipart/form-data"))

const collectUploadedFiles = (formData: FormData): UploadedInvoiceFiles => {
    const files: UploadedInvoiceFiles = {
        offers: {},
        adjudications: {},
        situations: {},
        documents: {},
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
            return
        }

        const situationMatch = key.match(/^situationFiles\[(\d+)\]$/)
        if (situationMatch) {
            files.situations[Number(situationMatch[1])] = value
            return
        }

        const documentMatch = key.match(/^documentFiles\[(\d+)\]$/)
        if (documentMatch) {
            files.documents[Number(documentMatch[1])] = value
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
        return {
            invoiceData,
            uploadedFiles: { offers: {}, adjudications: {}, situations: {}, documents: {} },
        }
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
        Object.keys(files.adjudications).length > 0 ||
        Object.keys(files.situations).length > 0 ||
        Object.keys(files.documents).length > 0
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

// Check if a relative file path exists under PROJECT_BASE_DIR
const fileExistsInMandats = async (filePath: string | undefined | null): Promise<boolean> => {
    if (!filePath) return false
    if (path.isAbsolute(filePath)) return false
    if (!filePath.includes("/")) return false
    const fullPath = path.resolve(PROJECT_BASE_DIR, filePath)
    // Security: ensure resolved path is within PROJECT_BASE_DIR
    if (!fullPath.startsWith(path.resolve(PROJECT_BASE_DIR))) return false
    try {
        const stats = await stat(fullPath)
        return stats.isFile()
    } catch {
        return false
    }
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
        const existingPath = (invoiceData as any).invoiceDocument
        if (!(await fileExistsInMandats(existingPath))) {
            const safeName = sanitizeFileName(files.invoiceDocument.name)
            const destinationPath = path.join(destinationFolder, safeName)
            await writeUploadedFile(files.invoiceDocument, destinationPath)
            ;(invoiceData as any).invoiceDocument = destinationPath.replace(/\\/g, "/")
        }
    }

    if (files.offers) {
        const offers = Array.isArray(invoiceData.offers) ? [...invoiceData.offers] : []
        for (const [indexKey, file] of Object.entries(files.offers)) {
            const index = Number(indexKey)
            if (!file) continue
            const existing = offers[index] ? { ...offers[index] } : ({} as any)
            if (await fileExistsInMandats(existing.file)) {
                offers[index] = existing
                continue
            }
            const safeName = sanitizeFileName(file.name)
            const destinationPath = path.join(destinationFolder, safeName)
            await writeUploadedFile(file, destinationPath)
            existing.file = destinationPath.replace(/\\/g, "/")
            offers[index] = existing
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
            const existing = adjudications[index] ? { ...adjudications[index] } : ({} as any)
            if (await fileExistsInMandats(existing.file)) {
                adjudications[index] = existing
                continue
            }
            const safeName = sanitizeFileName(file.name)
            const destinationPath = path.join(destinationFolder, safeName)
            await writeUploadedFile(file, destinationPath)
            existing.file = destinationPath.replace(/\\/g, "/")
            adjudications[index] = existing
        }

        invoiceData.adjudications = adjudications as any
    }

    if (files.situations) {
        const situations = Array.isArray(invoiceData.situations) ? [...invoiceData.situations] : []

        for (const [indexKey, file] of Object.entries(files.situations)) {
            const index = Number(indexKey)
            if (!file) continue
            const existing = situations[index] ? { ...situations[index] } : ({} as any)
            if (await fileExistsInMandats(existing.file)) {
                situations[index] = existing
                continue
            }
            const safeName = sanitizeFileName(file.name)
            const destinationPath = path.join(destinationFolder, safeName)
            await writeUploadedFile(file, destinationPath)
            existing.file = destinationPath.replace(/\\/g, "/")
            situations[index] = existing
        }

        invoiceData.situations = situations as any
    }

    if (files.documents) {
        const documents = Array.isArray(invoiceData.documents) ? [...invoiceData.documents] : []

        for (const [indexKey, file] of Object.entries(files.documents)) {
            const index = Number(indexKey)
            if (!file) continue
            const existing = documents[index] ? { ...documents[index] } : ({} as any)
            if (await fileExistsInMandats(existing.file)) {
                documents[index] = existing
                continue
            }
            const safeName = sanitizeFileName(file.name)
            const destinationPath = path.join(destinationFolder, safeName)
            await writeUploadedFile(file, destinationPath)
            existing.file = destinationPath.replace(/\\/g, "/")
            documents[index] = existing
        }

        invoiceData.documents = documents as any
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

    const project = await projectRepository.findById(projectId)
    if (!project) {
        throwNoProjectFolderError("Project not found for invoice", [
            { field: "projectId", message: "Project could not be found" },
        ])
    }

    const invoiceFolder = await findProjectInvoiceFolder(project.projectNumber || "undefined")
    if (!invoiceFolder) {
        throwNoProjectFolderError("Invoice folder not found", [
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
    .get(
        "/:id/files",
        zValidator("param", idParamSchema),
        zValidator(
            "query",
            z.object({
                path: z.string(),
            })
        ),
        async (c) => {
            const { id } = c.req.valid("param")
            const { path: requestedPath } = c.req.valid("query")
            const user = c.get("user")
            const invoice = await invoiceRepository.findById(id, user)
            if (!invoice) {
                throwNotFound("Invoice")
            }

            let decodedPath = requestedPath
            try {
                decodedPath = decodeURIComponent(requestedPath)
            } catch {
                // keep original if decoding fails
            }
            const normalizedRequested = normalizeStoredPath(decodedPath)
            if (!normalizedRequested) {
                throwNotFound("Invoice document")
            }

            // Collect all file paths from the invoice
            const invoiceFiles: string[] = []
            if (invoice.invoiceDocument) invoiceFiles.push(invoice.invoiceDocument)
            if (invoice.legacyInvoicePath) {
                invoiceFiles.push(invoice.legacyInvoicePath)
                invoiceFiles.push(invoice.legacyInvoicePath.replace("fab", "html"))
            }
            invoice.offers?.forEach((o: any) => o.file && invoiceFiles.push(o.file))
            invoice.adjudications?.forEach((a: any) => a.file && invoiceFiles.push(a.file))
            invoice.situations?.forEach((s: any) => s.file && invoiceFiles.push(s.file))
            invoice.documents?.forEach((d: any) => d.file && invoiceFiles.push(d.file))

            // Find matching file path
            const matchedFile = invoiceFiles.find((f) => matchesStoredPath(f, normalizedRequested))
            if (!matchedFile) {
                throwNotFound("Invoice document")
            }

            const projectNumber = invoice.project?.projectNumber
            if (!projectNumber) {
                throwValidationError("Project folder not found for invoice")
            }
            const invoiceFolder = await findProjectInvoiceFolder(projectNumber)
            if (!invoiceFolder) {
                throwValidationError("Invoice folder not found", [
                    {
                        field: "projectId",
                        message: "No folder starting with '9' found for this project",
                    },
                ])
            }

            const projectBase = path.resolve(
                invoiceFolder.project.fullPath || path.dirname(invoiceFolder.fullPath)
            )

            // Build candidate paths from the requested file path
            const candidatePaths = new Set<string>()
            const requestedBaseName = fileBaseName(normalizedRequested)

            // Try the requested path first (for .html variant of .fab files)
            if (path.isAbsolute(normalizedRequested)) {
                candidatePaths.add(path.normalize(normalizedRequested))
            } else {
                candidatePaths.add(path.resolve(invoiceFolder.fullPath, normalizedRequested))
                candidatePaths.add(path.resolve(projectBase, normalizedRequested))
            }
            candidatePaths.add(path.resolve(invoiceFolder.fullPath, requestedBaseName))

            // Also try the stored file path as fallback
            const normalizedStored = normalizeStoredPath(matchedFile)
            if (path.isAbsolute(normalizedStored)) {
                candidatePaths.add(path.normalize(normalizedStored))
            } else {
                candidatePaths.add(path.resolve(projectBase, normalizedStored))
                candidatePaths.add(path.resolve(invoiceFolder.fullPath, normalizedStored))
            }
            candidatePaths.add(path.resolve(invoiceFolder.fullPath, fileBaseName(normalizedStored)))

            let targetPath: string | null = null
            let fileStats: Awaited<ReturnType<typeof stat>> | null = null

            for (const candidate of candidatePaths) {
                const normalizedCandidate = path.normalize(candidate)
                if (!pathIsWithin(normalizedCandidate, projectBase)) {
                    continue
                }
                try {
                    const stats = await stat(normalizedCandidate)
                    if (stats.isFile()) {
                        targetPath = normalizedCandidate
                        fileStats = stats
                        break
                    }
                } catch {
                    // ignore missing candidate
                }
            }

            if (!targetPath || !fileStats) {
                throwNotFound("Invoice document")
            }

            // Use the requested filename for Content-Disposition
            const responseFileName = requestedBaseName
            const nodeStream = createReadStream(targetPath)
            const webStream = Readable.toWeb(nodeStream) as unknown as ReadableStream
            const headers = new Headers({
                "Content-Type": guessMimeType(responseFileName),
                "Content-Length": fileStats.size.toString(),
                "Content-Disposition": contentDispositionInline(responseFileName),
            })
            return new Response(webStream, { headers })
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
        try {
            const deleted = await invoiceRepository.delete(id, user)
            if (!deleted) {
                throwNotFound("Invoice")
            }
            return c.json({ message: "Invoice deleted successfully" }, 200)
        } catch (error) {
            if (error instanceof Error && error.message === "Cannot delete sent invoices") {
                return c.json({ error: "Cannot delete sent invoices" }, 400)
            }
            throw error
        }
    })
