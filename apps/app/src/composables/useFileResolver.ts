import { useAppSettingsStore } from "@/stores/appSettings"

export type ResolvedFile =
    | { relativePath: string }
    | { relativePath: string; file: File }

/**
 * Resolve an absolute file path: if within basePath, return a relative path
 * prefixed with /mandats. Otherwise, read the file for upload.
 */
export async function resolveFilePath(filePath: string): Promise<ResolvedFile> {
    const appSettings = useAppSettingsStore()
    const normalizedBase = appSettings.basePath.replace(/[\\/]+$/, "").replace(/[\\/]/g, "/").toLowerCase()
    const normalizedPath = filePath.replace(/[\\/]/g, "/").toLowerCase()

    if (normalizedPath.startsWith(normalizedBase)) {
        const relativePath = filePath
            .replace(appSettings.basePath.replace(/[\\/]+$/, ""), "/mandats")
            .replace(/\\/g, "/")
        return { relativePath }
    }

    const { readFile } = await import("@tauri-apps/plugin-fs")
    const contents = await readFile(filePath)
    const fileName = filePath.split(/[/\\]/).pop() || "file"
    const file = new File([contents], fileName)
    return { relativePath: filePath, file }
}
