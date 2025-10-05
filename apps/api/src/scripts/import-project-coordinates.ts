import { db } from "../db"
import { projects } from "../db/schema"
import { and, eq, sql } from "drizzle-orm"

interface CsvRow {
    projectNumber: string
    subProjectName: string | null
    easting: number | null
    northing: number | null
    commune?: string
    info?: string
}

function parseCsv(input: string): CsvRow[] {
    const lines = input
        .split(/\r?\n/)
        .map((line) => line.trim())
        .filter(Boolean)

    if (lines.length <= 1) {
        return []
    }

    const [, ...dataLines] = lines

    return dataLines.map((line) => {
        const columns = line.split(",")

        const projectNumber = columns[0]?.trim() ?? ""
        const subProjectName = columns[1]?.trim() || null
        const easting = columns[2] ? Number(columns[2]) : null
        const northing = columns[3] ? Number(columns[3]) : null

        return {
            projectNumber,
            subProjectName,
            easting: Number.isFinite(easting) ? easting : null,
            northing: Number.isFinite(northing) ? northing : null,
            commune: columns[4]?.trim(),
            info: columns[5]?.trim(),
        }
    })
}

async function updateProjectCoordinates(row: CsvRow) {
    if (!row.projectNumber) {
        console.warn("Skipping row without project number", row)
        return
    }

    let easting = row.easting
    let northing = row.northing

    if ((easting === null || northing === null) && row.subProjectName) {
        const parentProject = await db
            .select({ latitude: projects.latitude, longitude: projects.longitude })
            .from(projects)
            .where(
                and(
                    eq(projects.projectNumber, row.projectNumber),
                    sql`${projects.subProjectName} IS NULL`
                )
            )
            .limit(1)
            .execute()

        if (
            parentProject.length > 0 &&
            parentProject[0].latitude !== null &&
            parentProject[0].longitude !== null
        ) {
            easting = parentProject[0].latitude
            northing = parentProject[0].longitude
            console.log(
                `Inherited parent coordinates for ${row.projectNumber}/${row.subProjectName}: E=${easting}, N=${northing}`
            )
        }
    }

    if (easting === null || northing === null) {
        console.warn(
            `Skipping project ${row.projectNumber}${row.subProjectName ? `/${row.subProjectName}` : ""} (missing coordinates)`
        )
        return
    }

    const matchConditions = [eq(projects.projectNumber, row.projectNumber)]

    if (row.subProjectName) {
        matchConditions.push(eq(projects.subProjectName, row.subProjectName))
    } else {
        matchConditions.push(sql`${projects.subProjectName} IS NULL`)
    }

    const project = await db
        .select({ id: projects.id })
        .from(projects)
        .where(and(...matchConditions))
        .limit(1)
        .execute()

    if (project.length === 0) {
        console.warn(
            `Project not found: ${row.projectNumber}${row.subProjectName ? `/${row.subProjectName}` : ""}`
        )
        return
    }

    await db
        .update(projects)
        .set({
            latitude: easting,
            longitude: northing,
            updatedAt: new Date(),
        })
        .where(eq(projects.id, project[0].id))

    console.log(
        `Updated project ${row.projectNumber}${row.subProjectName ? `/${row.subProjectName}` : ""} with LV95 E=${easting}, N=${northing}`
    )
}

export async function importProjectCoordinatesFromCsv(csvInput: string) {
    const rows = parseCsv(csvInput)

    for (const row of rows) {
        await updateProjectCoordinates(row)
    }
}

async function main() {
    const stdin = await new Response(Bun.stdin.stream()).text()

    await importProjectCoordinatesFromCsv(stdin)
}

if (import.meta.main) {
    main()
        .then(() => {
            console.log("Coordinate import completed")
            process.exit(0)
        })
        .catch((error) => {
            console.error("Failed to import coordinates", error)
            process.exit(1)
        })
}
