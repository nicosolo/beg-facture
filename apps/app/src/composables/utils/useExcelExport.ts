import { useTauri } from "@/composables/useTauri"
import { useAlert } from "@/composables/utils/useAlert"

/**
 * Composable for exporting data to Excel with Tauri support
 */
export function useExcelExport() {
    const { isTauri, openFile } = useTauri()
    const { successAlert, errorAlert } = useAlert()

    /**
     * Export data to Excel file
     * @param arrayBuffer - The Excel file data as ArrayBuffer
     * @param filename - The filename for the export (without path)
     * @returns Promise<void>
     */
    const exportToExcel = async (arrayBuffer: ArrayBuffer | null, filename: string): Promise<void> => {
        try {
            if (!arrayBuffer) {
                errorAlert("Échec de l'export")
                return
            }

            const blob = new Blob([arrayBuffer], {
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            })

            if (isTauri.value) {
                // In Tauri: save file and open it
                const { save } = await import("@tauri-apps/plugin-dialog")
                const { writeFile } = await import("@tauri-apps/plugin-fs")

                const filePath = await save({
                    defaultPath: filename,
                    filters: [
                        {
                            name: "Excel",
                            extensions: ["xlsx"],
                        },
                    ],
                })

                if (filePath) {
                    // Convert blob to Uint8Array
                    const buffer = await blob.arrayBuffer()
                    await writeFile(filePath, new Uint8Array(buffer))

                    successAlert("Export réussi")

                    // Open the file
                    await openFile(filePath)
                }
            } else {
                // Browser: standard download
                const url = URL.createObjectURL(blob)
                const link = document.createElement("a")
                link.href = url
                link.download = filename
                document.body.appendChild(link)
                link.click()
                document.body.removeChild(link)
                URL.revokeObjectURL(url)

                successAlert("Export téléchargé")
            }
        } catch (error) {
            console.error("Failed to export to Excel:", error)
            errorAlert("Erreur lors de l'export")
        }
    }

    return {
        exportToExcel,
    }
}
