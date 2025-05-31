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
    activityRateUsers,
    projects,
    activityTypes,
    activities,
} from "./schema"
import bcrypt from "bcrypt"
import { eq, and } from "drizzle-orm"
import fs from "fs/promises"
import path from "path"
import type { UserRole, Class, ProjectAccessLevel } from "@beg/types"
import { hashPassword } from "@src/tools/auth"

const exportDir = "/app/export-mdb"

// Drop all existing data before import
async function resetDatabase() {
    console.log("Dropping all existing data...")

    await db.delete(activities)
    await db.delete(activityRateUsers)
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
function mapUserData(data: any) {
    // Use original ID if available
    return {
        id: data.IDcollaborateur || undefined, // Use original ID if available
        email: `${data.Initiales.toLowerCase()}@beg-geol.ch`,
        firstName: data.Prénom,
        lastName: data.Nom,
        initials: data.Initiales,
        password: data.Password || "password123", // Default password
        role: "user" as UserRole, // Properly typed as UserRole
        archived: false,
    }
}

// Similar mapping functions for other tables...

async function importUsers() {
    const userData = await readJsonFile("Collaborateurs")
    if (userData.length === 0) return

    for (const rawUser of userData) {
        const user = mapUserData(rawUser)

        // Hash password if it's not already hashed
        if (!user.password.startsWith("$2")) {
            user.password = await hashPassword(user.password)
        }

        await db.insert(users).values(user)
    }

    const importedUsers = await db.select().from(users)
    console.log(`Imported ${importedUsers.length} users`)
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
            }

            await db.insert(locations).values(location)
        } else {
            // If no tree details found, create a simple location with just the name
            const location = {
                id: rawLocation.IDlocalité,
                name: rawLocation.Localité,
                country: "CH", // Default to Switzerland
                canton: null,
                region: null,
                address: null,
            }

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
        }

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
        }

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
        }

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
        }

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
                    class: className as Class, // Properly typed as Class enum
                    year: tarif.Année || new Date().getFullYear(),
                    amount: parseFloat(tarif.Tarif) || 0,
                }

                await db.insert(rateClasses).values(rateClass)
            }
        }
    }

    const importedRateClasses = await db.select().from(rateClasses)
    console.log(`Imported ${importedRateClasses.length} rate classes`)
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

    for (const rawProject of projectData) {
        const project = {
            id: rawProject.IDmandat,
            projectNumber: rawProject.Mandat,
            name: rawProject["Désignation"],
            startDate: rawProject.Date ? new Date(rawProject.Date) : new Date(),
            clientId: rawProject.MandantID || clientMap.get(rawProject.Mandant),
            locationId: rawProject.LocalitéID || locationMap.get(rawProject.Localité),
            engineerId: rawProject.IngénieurID || engineerMap.get(rawProject.Ingénieur),
            companyId: rawProject.EntrepriseID || companyMap.get(rawProject.Entreprise),
            typeId: rawProject.TypeID || typeMap.get(rawProject.Type) || allTypes[0]?.id, // Default to first type
            remark: rawProject.Remarque,
            printFlag: rawProject.FlagImpression === "Oui",
        }

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
            billable: rawActivityType.Facturable === "Oui",
        }

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

            // Parse date in format "08/07/12 00:00:00" (DD/MM/YY)
            let activityDate = new Date()
            if (rawActivity.Date) {
                // Check if the date matches the pattern DD/MM/YY HH:MM:SS
                const datePattern = /^(\d{2})\/(\d{2})\/(\d{2}).*$/
                const match = String(rawActivity.Date).match(datePattern)

                if (match) {
                    // Convert parts to numbers (day, month, year)
                    const month = parseInt(match[1], 10) - 1
                    const day = parseInt(match[2], 10)
                    let year = parseInt(match[3], 10)
                    // Handle 2-digit year (20xx if < 50, 19xx if >= 50)
                    year = year < 50 ? 2000 + year : 1900 + year

                    activityDate = new Date(year, month, day)
                } else {
                    // Fallback to standard parsing for other formats
                    activityDate = new Date(rawActivity.Date)
                }
            }

            const activity = {
                // id: rawActivity.IDHeure,
                userId,
                projectId,
                activityTypeId,
                date: activityDate,
                duration: (parseFloat(rawActivity.Heures) || 0) * 60,
                kilometers: parseInt(rawActivity.Km) || 0,
                expenses: parseFloat(rawActivity.Frais) || 0,
                rate: parseFloat(rawActivity.Tarif) || 0,
                description: rawActivity.Remarque,
                billed: rawActivity.Facturé === "Oui",
                disbursement: rawActivity.Débours === "Oui",
            }

            chunkActivities.push(activity)
            imported++
        }
        await db.insert(activities).values(chunkActivities)
    }

    console.log(`Imported ${imported} activities`)
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

async function importActivityRateUsers() {
    // Taux contains rate information for users on different activities
    const activityRateData = await readJsonFile("LinkACC")
    if (activityRateData.length === 0) return

    // Get references to related entities
    const allUsers = await db.select().from(users)
    const userMap = new Map(allUsers.map((u) => [u.id, u.id]))

    let imported = 0

    for (const rawRate of activityRateData) {
        // Prefer original IDs when available
        const userId = rawRate.IDcollaborateur

        if (!userId) continue

        const activityRate = {
            userId,
            activityId: rawRate.IDactivité,
            class: rawRate.Classe as Class, // Properly typed as Class enum
        }

        await db.insert(activityRateUsers).values(activityRate)
        imported++
    }

    console.log(`Imported ${imported} activity rate users`)
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
    importActivityRateUsers,
]

for (const importFunction of importFunctions) {
    console.log(`Running ${importFunction.name}`)
    const start = Date.now()
    await importFunction()
    console.log(`Completed ${importFunction.name}, in ${Date.now() - start}ms \n`)
}
