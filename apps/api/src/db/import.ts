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
    workloads,
    vatRates,
} from "./schema"
import { eq, and } from "drizzle-orm"
import fs from "fs/promises"
import path from "path"
import { hashPassword } from "@src/tools/auth"
import type {
    ActivityRateUser,
    ClassSchema,
    Company,
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

    await db.delete(invoices)
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
    await db.delete(workloads)
    await db.delete(users)
    await db.delete(vatRates)

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
                country: country as any,
                canton: canton as any,
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
        } as Company

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

    const allUsers = await db.select().from(users)
    const userMap = new Map(allUsers.map((u) => [u.initials, u.id]))

    const allEngineers = await db.select({ id: engineers.id }).from(engineers)
    const engineersArray = allEngineers.map((e) => e.id)

    const allProjectTypes = await db.select({ id: projectTypes.id }).from(projectTypes)
    const projectTypesArray = allProjectTypes.map((pt) => pt.id)

    const allClients = await db.select({ id: clients.id }).from(clients)
    const clientsArray = allClients.map((c) => c.id)

    const allCompanies = await db.select({ id: companies.id }).from(companies)
    const companiesArray = allCompanies.map((c) => c.id)

    const allLocations = await db.select({ id: locations.id }).from(locations)
    const locationsArray = allLocations.map((l) => l.id)

    // Process in chunks for bulk insert
    const chunkSize = 3000
    let imported = 0

    for (let i = 0; i < projectData.length; i += chunkSize) {
        const chunk = projectData.slice(i, i + chunkSize)
        const chunkProjects = []

        for (const rawProject of chunk) {
            const engineerId = engineersArray.includes(rawProject.IDingénieur)
                ? rawProject.IDingénieur
                : null
            const companyId = companiesArray.includes(rawProject.IDentreprise)
                ? rawProject.IDentreprise
                : null

            const typeId = projectTypesArray.includes(rawProject.IDtype) ? rawProject.IDtype : null

            const locationId = locationsArray.includes(rawProject.IDlocalité)
                ? rawProject.IDlocalité
                : null

            const clientId = clientsArray.includes(rawProject.IDmandant)
                ? rawProject.IDmandant
                : null

            const project = {
                id: rawProject.IDmandat,
                projectNumber: rawProject.Mandat,
                name: rawProject["Désignation"],
                projectManagerId: userMap.get(rawProject.Responsable) || null,
                startDate: rawProject.Début ? parseAccessDate(rawProject.Début) : new Date(),
                clientId,
                locationId,
                engineerId,
                companyId,
                typeId,
                remark: rawProject.Remarque,
                printFlag: rawProject.FlagImpression === "Oui",
                createdAt: rawProject.Début ? parseAccessDate(rawProject.Début) : new Date(),
                updatedAt: new Date(),
                ended: rawProject.Etat === "Terminé",
                subProjectName: rawProject["Sous-mandat"] || null,
            } satisfies typeof projects.$inferInsert

            chunkProjects.push(project)
            imported++
        }

        // Bulk insert the chunk
        await db.insert(projects).values(chunkProjects)
        console.log(`Imported ${imported} / ${projectData.length} projects`)
    }

    console.log(`Imported ${imported} projects total`)
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

    // Load all users with their activity rates
    const allUsers = await db.select().from(users)
    const userMap = new Map(allUsers.map((u) => [u.id, u]))

    // Load all rate classes for rate lookup
    const allRateClasses = await db.select().from(rateClasses)
    // Create a map for quick lookups: "class-year" -> amount
    const rateMap = new Map<string, number>()
    allRateClasses.forEach((rate) => {
        rateMap.set(`${rate.class}-${rate.year}`, rate.amount)
    })

    // Process in chunks due to potentially large size
    const chunkSize = 3000
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

            // Calculate rate based on user's rate class for this activity type
            let calculatedRate = 0
            const user = userMap.get(userId)
            let userClass: ClassSchema | undefined = undefined
            if (user && activityDate && user.activityRates) {
                // Find the user's rate class for this activity type
                userClass = user.activityRates.find((rate) => rate.activityId === activityTypeId)
                    ?.class as ClassSchema | undefined

                if (userClass) {
                    // Get the rate for this class and year
                    const year = activityDate.getFullYear()
                    const rateKey = `${userClass}-${year}`
                    calculatedRate = rateMap.get(rateKey) || 0
                }
            }

            // Use calculated rate if available, otherwise fall back to the original rate from the data
            const finalRate =
                calculatedRate > 0 ? calculatedRate : parseFloat(rawActivity.Tarif) || 0

            const activity = {
                // id: rawActivity.IDHeure,
                rateClass: userClass,
                userId,
                projectId,
                activityTypeId,
                date: activityDate,
                duration: Math.round(parseFloat(rawActivity.Heures) * 100) / 100,
                kilometers: parseFloat(rawActivity.Km) || 0,
                expenses: parseFloat(rawActivity.Frais) || 0,
                rate: finalRate,
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
    const allProjects = await db.select({ id: projects.id, name: projects.name }).from(projects)
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

async function importWorkloads() {
    console.log("Importing workloads from Taux.json...")
    const workloadData = await readJsonFile("Taux")

    if (workloadData.length === 0) {
        console.log("No workload data found in Taux.json")
        return
    }

    // Get all user IDs for validation
    const allUsers = await db.select({ id: users.id }).from(users)
    const validUserIds = new Set(allUsers.map((u) => u.id))

    const validWorkloads = []
    const erroredEntries: any[] = []

    for (const rawWorkload of workloadData) {
        // Validate required fields
        if (!rawWorkload.IDcollaborateur || !rawWorkload.Année || !rawWorkload.Mois) {
            erroredEntries.push({
                data: rawWorkload,
                reason: "Missing required fields",
            })
            continue
        }

        // Check if user exists
        if (!validUserIds.has(rawWorkload.IDcollaborateur)) {
            erroredEntries.push({
                data: rawWorkload,
                reason: `User with ID ${rawWorkload.IDcollaborateur} not found`,
            })
            continue
        }

        const workload = {
            userId: rawWorkload.IDcollaborateur,
            year: rawWorkload.Année,
            month: rawWorkload.Mois,
            workload: rawWorkload.Taux || 100, // Default to 100% if not specified
            createdAt: new Date(),
            updatedAt: new Date(),
        } satisfies typeof workloads.$inferInsert

        validWorkloads.push(workload)
    }

    // Bulk insert all valid workloads at once
    if (validWorkloads.length > 0) {
        await db.insert(workloads).values(validWorkloads)
        console.log(`Imported ${validWorkloads.length} workloads`)
    }

    if (erroredEntries.length > 0) {
        console.warn(`Failed to import ${erroredEntries.length} workload entries:`)
        erroredEntries.slice(0, 5).forEach((entry) => {
            console.warn(`  - User ${entry.data.IDcollaborateur}: ${entry.reason}`)
        })
        if (erroredEntries.length > 5) {
            console.warn(`  ... and ${erroredEntries.length - 5} more`)
        }
    }

    console.log(
        `Import complete: ${validWorkloads.length} workloads imported, ${erroredEntries.length} errors`
    )
}

async function importVatRates() {
    console.log("Importing historical VAT rates...")

    const historicalVatRates = [
        // 1995-2000: 6.5%
        { year: 1995, rate: 6.5 },
        { year: 1996, rate: 6.5 },
        { year: 1997, rate: 6.5 },
        { year: 1998, rate: 6.5 },
        { year: 1999, rate: 6.5 },
        { year: 2000, rate: 6.5 },
        // 2001-2010: 7.6%
        { year: 2001, rate: 7.6 },
        { year: 2002, rate: 7.6 },
        { year: 2003, rate: 7.6 },
        { year: 2004, rate: 7.6 },
        { year: 2005, rate: 7.6 },
        { year: 2006, rate: 7.6 },
        { year: 2007, rate: 7.6 },
        { year: 2008, rate: 7.6 },
        { year: 2009, rate: 7.6 },
        { year: 2010, rate: 7.6 },
        // 2011-2017: 8.0%
        { year: 2011, rate: 8.0 },
        { year: 2012, rate: 8.0 },
        { year: 2013, rate: 8.0 },
        { year: 2014, rate: 8.0 },
        { year: 2015, rate: 8.0 },
        { year: 2016, rate: 8.0 },
        { year: 2017, rate: 8.0 },
        // 2018-2023: 7.7%
        { year: 2018, rate: 7.7 },
        { year: 2019, rate: 7.7 },
        { year: 2020, rate: 7.7 },
        { year: 2021, rate: 7.7 },
        { year: 2022, rate: 7.7 },
        { year: 2023, rate: 7.7 },
        // 2024-present: 8.1%
        { year: 2024, rate: 8.1 },
    ]

    const vatRatesToInsert = historicalVatRates.map((rate) => ({
        year: rate.year,
        rate: rate.rate,
        createdAt: new Date(),
        updatedAt: new Date(),
    }))

    await db.insert(vatRates).values(vatRatesToInsert)

    const importedVatRates = await db.select().from(vatRates)
    console.log(`Imported ${importedVatRates.length} VAT rates from 1995 to 2024`)
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
    importWorkloads,
    importVatRates,
]
for (const importFunction of importFunctions) {
    console.log(`Running ${importFunction.name}`)
    const start = Date.now()
    await importFunction()
    console.log(`Completed ${importFunction.name}, in ${Date.now() - start}ms \n`)
}
