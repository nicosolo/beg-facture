import { db } from "./index"
import {
    users,
    locations,
    projectAccess,
    companies,
    clients,
    projectTypes,
    engineers,
    rateClasses,
    projects,
    activityTypes,
    activities,
    invoices,
} from "./schema"
import bcrypt from "bcrypt"
import { eq, and } from "drizzle-orm"
import fs from "fs/promises"
import path from "path"
import { hashPassword } from "@src/tools/auth"
import type {
    ActivityRateUser,
    ClassSchema,
    CompanySchema,
    ProjectAccessLevel,
    UserRole,
} from "@beg/validations"
import { updateProjectActivityDates } from "./repositories/activity.repository"

const exportDir = "/app/export-mdb"

// Parse date in format "MM/DD/YY HH:mm:ss"
// The dates from Access are in local time (UTC+1 or UTC+2 depending on DST)
// We need to store them as UTC to avoid date shifting issues
function parseAccessDate(dateString: string): Date {
    if (!dateString) return new Date()

    // Parse "MM/DD/YY HH:mm:ss" format
    const parts = dateString.split(" ")
    if (parts.length !== 2) return new Date()

    const [datePart, timePart] = parts
    const [month, day, year] = datePart.split("/")
    const [hours, minutes, seconds] = timePart.split(":")

    // Convert 2-digit year to 4-digit year (assume 20xx for years 00-30, 19xx for years 31-99)
    const fullYear = parseInt(year) <= 30 ? 2000 + parseInt(year) : 1900 + parseInt(year)

    // Create date in local time (this interprets the string as local time)
    const utcDate = new Date(
        fullYear,
        parseInt(month) - 1, // Month is 0-indexed
        parseInt(day),
        parseInt(hours) + 2,
        parseInt(minutes),
        parseInt(seconds)
    )

    return utcDate
}

// Drop all existing data before import
async function resetDatabase() {
    console.log("Dropping all existing data...")

    await db.delete(activities)
    await db.delete(projectAccess)
    await db.delete(projects)
    await db.delete(activityTypes)
    await db.delete(rateClasses)
    await db.delete(engineers)
    await db.delete(projectTypes)
    await db.delete(clients)
    await db.delete(companies)
    await db.delete(locations)
    await db.delete(users)
    await db.delete(invoices)

    console.log("Database reset complete")
}

async function readJsonFile(filename: string) {
    try {
        const filePath = path.join(exportDir, `${filename}.json`)
        const data = await fs.readFile(filePath, "utf8")
        // Handle JSONL format (one JSON object per line)
        return data
            .split("\n")
            .filter((line) => line.trim() !== "")
            .map((line) => JSON.parse(line))
    } catch (error) {
        console.error(`Error reading ${filename}.json:`, error)
        return []
    }
}

// Map French names to DB table structure
function mapUserData(data: any): typeof users.$inferInsert {
    // Use original ID if available
    return {
        id: data.IDcollaborateur || undefined, // Use original ID if available
        email: `${data.Initiales.toLowerCase()}@beg-geol.ch`,
        firstName: data.Prénom,
        lastName: data.Nom,
        initials: data.Initiales,
        password: data["Mot de passe"] || "password123", // Default password
        role: (data.Initiales === "fp" ? "admin" : "user") as UserRole, // Properly typed as UserRole
        archived: false,
        createdAt: new Date(),
        updatedAt: new Date(),
        activityRates: [] as ActivityRateUser[],
    }
}

async function importLocations() {
    // Use both TreeTable and Localités for complete mapping
    const treeData = await readJsonFile("TreeTable")
    const locationData = await readJsonFile("Localités")

    if (locationData.length === 0) return

    // Swiss canton mapping
    const cantonMap = new Map([
        ["Valais", "VS"],
        ["Vaud", "VD"],
        ["Genève", "GE"],
        ["Neuchâtel", "NE"],
        ["Fribourg", "FR"],
        ["Jura", "JU"],
        ["Berne", "BE"],
        ["Zürich", "ZH"],
        ["Lucerne", "LU"],
        ["Uri", "UR"],
        ["Schwyz", "SZ"],
        ["Obwald", "OW"],
        ["Nidwald", "NW"],
        ["Glarus", "GL"],
        ["Zug", "ZG"],
        ["Soleure", "SO"],
        ["Bâle-Ville", "BS"],
        ["Bâle-Campagne", "BL"],
        ["Schaffhouse", "SH"],
        ["Appenzell Rhodes-Extérieures", "AR"],
        ["Appenzell Rhodes-Intérieures", "AI"],
        ["Saint-Gall", "SG"],
        ["Grisons", "GR"],
        ["Argovie", "AG"],
        ["Thurgovie", "TG"],
        ["Tessin", "TI"],
    ])

    // Create a mapping from TreeTable for location details by ID
    const treeLocationMap = new Map<number, any>()
    treeData.forEach((item: any) => {
        treeLocationMap.set(item.ID, {
            l0: item.L0, // L0 is the country
            l1: item.L1, // L1 is the region (like Valais, Vaud)
            l2: item.L2, // L2 is often the Swiss canton
            l3: item.L3, // L3 is the locality (if exists)
        })
    })

    for (const rawLocation of locationData) {
        // Get location details from TreeTable using IDrégion
        const treeDetails = treeLocationMap.get(rawLocation.IDrégion)

        if (treeDetails) {
            let country = "CH" // Default
            let canton = null
            let region = null
            let address = null

            // Handle country mapping
            if (treeDetails.l0) {
                country =
                    treeDetails.l0 === "Suisse"
                        ? "CH"
                        : treeDetails.l0 === "France"
                          ? "FR"
                          : treeDetails.l0 === "Italie"
                            ? "IT"
                            : "CH"
            }

            // Handle L1 - check if it's a Swiss canton or region
            if (treeDetails.l1) {
                const cantonCode = cantonMap.get(treeDetails.l1)
                if (cantonCode) {
                    canton = cantonCode
                } else {
                    region = treeDetails.l1
                }
            }

            // Handle L2 and L3 for address (with line breaks)
            const addressParts = []
            if (treeDetails.l2) addressParts.push(treeDetails.l2)
            if (treeDetails.l3) addressParts.push(treeDetails.l3)
            if (addressParts.length > 0) {
                address = addressParts.join("\n")
            }

            const location = {
                id: rawLocation.IDlocalité,
                name: rawLocation.Localité,
                country,
                canton,
                region,
                address,
                createdAt: new Date(),
                updatedAt: new Date(),
            } satisfies typeof locations.$inferInsert

            await db.insert(locations).values(location)
        } else {
            // If no tree details found, create a simple location with just the name
            const location = {
                id: rawLocation.IDlocalité,
                name: rawLocation.Localité,
                country: "CH" as const, // Default to Switzerland
                canton: undefined,
                region: undefined,
                address: undefined,
                createdAt: new Date(),
                updatedAt: new Date(),
            } satisfies typeof locations.$inferInsert

            await db.insert(locations).values(location)
            console.warn(
                `Could not find tree details for location ${rawLocation.Localité} with region ID ${rawLocation.IDrégion}`
            )
        }
    }

    const importedLocations = await db.select().from(locations)
    console.log(`Imported ${importedLocations.length} locations`)
}

async function importCompanies() {
    const companyData = await readJsonFile("Entreprises")
    if (companyData.length === 0) return

    for (const rawCompany of companyData) {
        const company = {
            id: rawCompany.IDentreprise,
            name: rawCompany.Entreprise,
            createdAt: new Date(),
            updatedAt: new Date(),
        } as CompanySchema

        await db.insert(companies).values(company)
    }

    const importedCompanies = await db.select().from(companies)
    console.log(`Imported ${importedCompanies.length} companies`)
}

async function importClients() {
    const clientData = await readJsonFile("Mandants")
    if (clientData.length === 0) return

    for (const rawClient of clientData) {
        const client = {
            id: rawClient.IDmandant,
            name: rawClient.Mandant,
            createdAt: new Date(),
            updatedAt: new Date(),
        } satisfies typeof clients.$inferInsert

        await db.insert(clients).values(client)
    }

    const importedClients = await db.select().from(clients)
    console.log(`Imported ${importedClients.length} clients`)
}

async function importProjectTypes() {
    const projectTypeData = await readJsonFile("Types")
    if (projectTypeData.length === 0) return

    for (const rawType of projectTypeData) {
        const projectType = {
            id: rawType.IDtype,
            name: rawType.Type,
            createdAt: new Date(),
            updatedAt: new Date(),
        } satisfies typeof projectTypes.$inferInsert

        await db.insert(projectTypes).values(projectType)
    }

    const importedProjectTypes = await db.select().from(projectTypes)
    console.log(`Imported ${importedProjectTypes.length} project types`)
}

async function importEngineers() {
    const engineerData = await readJsonFile("Ingénieurs")
    if (engineerData.length === 0) return

    for (const rawEngineer of engineerData) {
        const engineer = {
            id: rawEngineer.IDingénieur,
            name: rawEngineer.Ingénieur,
            createdAt: new Date(),
            updatedAt: new Date(),
        } satisfies typeof engineers.$inferInsert

        await db.insert(engineers).values(engineer)
    }

    const importedEngineers = await db.select().from(engineers)
    console.log(`Imported ${importedEngineers.length} engineers`)
}

async function importRateClasses() {
    const rateClassData = await readJsonFile("Classes")
    if (rateClassData.length === 0) return

    // Format: { Classe: "A", ... }
    for (const rawClass of rateClassData) {
        const className = rawClass.Classe

        // For each class, get rates from Tarifs file
        const tarifData = await readJsonFile("Tarifs")

        for (const tarif of tarifData) {
            if (tarif.Classe === className) {
                const rateClass = {
                    id: tarif.IDtarif,
                    class: className as ClassSchema, // Properly typed as Class enum
                    year: tarif.Année || new Date().getFullYear(),
                    amount: parseFloat(tarif.Tarif) || 0,
                } satisfies typeof rateClasses.$inferInsert

                await db.insert(rateClasses).values(rateClass)
            }
        }
    }

    const importedRateClasses = await db.select().from(rateClasses)
    console.log(`Imported ${importedRateClasses.length} rate classes`)
}

// Similar mapping functions for other tables...

async function importUsers() {
    const userData = await readJsonFile("Collaborateurs")
    const activityRateData = await readJsonFile("LinkACC")
    if (userData.length === 0) return

    for (const rawUser of userData) {
        const user = mapUserData(rawUser)

        // Hash password if it's not already hashed
        user.activityRates = activityRateData
            .filter((rate) => rate.IDcollaborateur.toString() === user?.id?.toString())
            .map((rate) => ({
                activityId: rate.IDactivité,
                class: rate.Classe as ClassSchema,
            }))
        if (!user.password.startsWith("$2")) {
            user.password = await hashPassword(user.password)
        }

        await db.insert(users).values(user)
    }

    const importedUsers = await db.select().from(users)
    console.log(`Imported ${importedUsers.length} users`)
}

async function importProjects() {
    const projectData = await readJsonFile("Mandats")
    if (projectData.length === 0) return

    // Get references to related entities by their original IDs
    const allClients = await db.select().from(clients)
    const clientMap = new Map(allClients.map((c) => [c.name, c.id]))

    const allTypes = await db.select().from(projectTypes)
    const typeMap = new Map(allTypes.map((t) => [t.name, t.id]))

    const allEngineers = await db.select().from(engineers)
    const engineerMap = new Map(allEngineers.map((e) => [e.name, e.id]))

    const allCompanies = await db.select().from(companies)
    const companyMap = new Map(allCompanies.map((c) => [c.name, c.id]))

    const allLocations = await db.select().from(locations)
    const locationMap = new Map(allLocations.map((l) => [l.name, l.id]))
    const allUsers = await db.select().from(users)
    const userMap = new Map(allUsers.map((u) => [u.initials, u.id]))

    for (const rawProject of projectData) {
        const project = {
            id: rawProject.IDmandat,
            projectNumber: rawProject.Mandat,
            name: rawProject["Désignation"],
            projectManagerId: userMap.get(rawProject.Responsable) || null,
            startDate: rawProject.Début ? parseAccessDate(rawProject.Début) : new Date(),
            clientId: rawProject.MandantID || clientMap.get(rawProject.Mandant),
            locationId: rawProject.LocalitéID || locationMap.get(rawProject.Localité),
            engineerId: rawProject.IngénieurID || engineerMap.get(rawProject.Ingénieur),
            companyId: rawProject.EntrepriseID || companyMap.get(rawProject.Entreprise),
            typeId: rawProject.TypeID || typeMap.get(rawProject.Type) || allTypes[0]?.id, // Default to first type
            remark: rawProject.Remarque,
            printFlag: rawProject.FlagImpression === "Oui",
            createdAt: rawProject.Début ? parseAccessDate(rawProject.Début) : new Date(),
            updatedAt: new Date(),
            ended: rawProject.Etat === "Terminé",
        } satisfies typeof projects.$inferInsert

        await db.insert(projects).values(project)
    }

    const importedProjects = await db.select().from(projects)
    console.log(`Imported ${importedProjects.length} projects`)
}

async function importActivityTypes() {
    const activityTypeData = await readJsonFile("Activités")
    if (activityTypeData.length === 0) return

    for (const rawActivityType of activityTypeData) {
        const activityType = {
            id: rawActivityType.IDactivité,
            name: rawActivityType.Activité,
            code: rawActivityType.Code || rawActivityType.Activité.substring(0, 3).toUpperCase(),
            billable: rawActivityType.Activité === "Non facturable" ? false : true,
            createdAt: new Date(),
            updatedAt: new Date(),
        } satisfies typeof activityTypes.$inferInsert

        await db.insert(activityTypes).values(activityType)
    }

    const importedActivityTypes = await db.select().from(activityTypes)
    console.log(`Imported ${importedActivityTypes.length} activity types`)
}

async function importActivities() {
    const activityData = await readJsonFile("Heures")
    if (activityData.length === 0) return

    // Process in chunks due to potentially large size
    const chunkSize = 1000
    let imported = 0

    for (let i = 0; i < activityData.length; i += chunkSize) {
        const chunk = activityData.slice(i, i + chunkSize)
        const chunkActivities = []
        for (const rawActivity of chunk) {
            // Prefer original IDs when available
            const userId = rawActivity.IDcollaborateur
            const projectId = rawActivity.IDmandat
            const activityTypeId = rawActivity.IDactivité
            if (!userId || !projectId || !activityTypeId) continue

            // Parse date in format "08/07/12 00:00:00" (DD/MM/YY HH:MM:SS)
            let activityDate = new Date()
            if (rawActivity.Date) {
                activityDate = parseAccessDate(rawActivity.Date)
            }

            const activity = {
                // id: rawActivity.IDHeure,
                userId,
                projectId,
                activityTypeId,
                date: activityDate,
                duration: Math.round((parseFloat(rawActivity.Heures) || 0) * 60),
                kilometers: parseInt(rawActivity.Km) || 0,
                expenses: parseFloat(rawActivity.Frais) || 0,
                rate: parseFloat(rawActivity.Tarif) || 0,
                description: rawActivity.Remarque,
                billed: rawActivity.Facturé === 1,
                disbursement: rawActivity.Débours === 1,
                createdAt: activityDate,
                updatedAt: activityDate,
            } satisfies typeof activities.$inferInsert

            chunkActivities.push(activity)
            imported++
        }
        await db.insert(activities).values(chunkActivities)
    }

    console.log(`Imported ${imported} activities`)

    // Update all project dates after bulk import
    console.log("Updating project activity dates...")
    const allProjects = await db.select({ id: projects.id }).from(projects)

    for (const project of allProjects) {
        await updateProjectActivityDates(project.id)
    }

    console.log("Project activity dates updated")
}

// Create Project access based on who did hours on a project
async function importProjectAccess() {
    console.log("Creating project access entries...")

    // Single query to get all unique user-project combinations that have activities
    const userProjectCombinations = await db
        .select({
            userId: activities.userId,
            projectId: activities.projectId,
        })
        .from(activities)
        .groupBy(activities.userId, activities.projectId)

    console.log(
        `Found ${userProjectCombinations.length} unique user-project combinations with activities`
    )

    // Create project access entries in bulk
    const accessEntries = userProjectCombinations.map((combination) => ({
        userId: combination.userId,
        projectId: combination.projectId,
        accessLevel: "write" as ProjectAccessLevel,
    }))

    // Insert in chunks to avoid potential query size limits
    const chunkSize = 1000
    let imported = 0

    for (let i = 0; i < accessEntries.length; i += chunkSize) {
        const chunk = accessEntries.slice(i, i + chunkSize)
        await db.insert(projectAccess).values(chunk)
        imported += chunk.length
        console.log(`Created ${imported} access entries`)
    }

    console.log(`Created ${imported} access entries`)
}
const importFunctions = [
    resetDatabase, // Add database reset as the first function to run
    importUsers,
    importLocations,
    importCompanies,
    importClients,
    importProjectTypes,
    importEngineers,
    importRateClasses,
    importProjects,
    importActivityTypes,
    importActivities,
    importProjectAccess,
]
for (const importFunction of importFunctions) {
    console.log(`Running ${importFunction.name}`)
    const start = Date.now()
    await importFunction()
    console.log(`Completed ${importFunction.name}, in ${Date.now() - start}ms \n`)
}
