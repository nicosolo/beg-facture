import { Hono } from "hono"
import { authMiddleware } from "@src/tools/auth-middleware"
import type { Variables } from "@src/types/global"
import {
    contentDispositionInline,
    fileBaseName,
    guessMimeType,
    normalizeStoredPath,
    pathIsWithin,
} from "@src/tools/file-utils"
import { PROJECT_BASE_DIR, PROJECT_HOST_DIR } from "@src/config"
import { throwNotFound } from "@src/tools/error-handler"
import path from "node:path"
import { stat } from "node:fs/promises"
import { createReadStream } from "node:fs"
import { Readable } from "node:stream"
import { zValidator } from "@hono/zod-validator"
import { z } from "zod"

const normalizedBasePrefix = normalizeStoredPath(PROJECT_BASE_DIR)
const baseFolderName = normalizedBasePrefix ? fileBaseName(normalizedBasePrefix).toLowerCase() : ""

const sanitizeRelative = (value: string) => {
    const trimmed = value.replace(/^[\\/]+/, "").trim()
    if (!trimmed) return ""
    if (baseFolderName && trimmed.toLowerCase().startsWith(`${baseFolderName}/`)) {
        return trimmed.slice(baseFolderName.length + 1)
    }
    return trimmed
}

const resolveRequestedFilePath = (requested: string) => {
    let candidate = requested

    if (!pathIsWithin(candidate, PROJECT_BASE_DIR)) {
        return null
    }

    return candidate
}

const fileQuerySchema = z.object({
    path: z.string().min(1),
})

export const fileRoutes = new Hono<{ Variables: Variables }>()
    .use("/*", authMiddleware)
    .get("/", zValidator("query", fileQuerySchema), async (c) => {
        const { path: rawPath } = c.req.valid("query")

        let decodedPath = rawPath
        try {
            decodedPath = decodeURIComponent(rawPath)
        } catch {
            // keep original if decoding fails
        }

        const normalizedRequested = normalizeStoredPath(decodedPath)
        if (!normalizedRequested) {
            throwNotFound("File")
        }

        const targetPath = resolveRequestedFilePath(normalizedRequested)
        if (!targetPath) {
            throwNotFound("File")
        }

        let fileStats: Awaited<ReturnType<typeof stat>>
        try {
            fileStats = await stat(targetPath)
        } catch {
            throwNotFound("File")
        }

        if (!fileStats.isFile()) {
            throwNotFound("File")
        }

        const fileName = fileBaseName(normalizedRequested)
        const nodeStream = createReadStream(targetPath)
        const webStream = Readable.toWeb(nodeStream) as unknown as ReadableStream
        const headers = new Headers({
            "Content-Type": guessMimeType(fileName),
            "Content-Length": fileStats.size.toString(),
            "Content-Disposition": contentDispositionInline(fileName),
        })

        return new Response(webStream, { headers })
    })
