import type { OdysProjet } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Project, Page } from "@beg/types"
import type { ProjectFilter } from "@beg/validations"

const projectTable = "Projet_____"
export const mapProject = (
    projet: OdysProjet & {
        totalDuration?: number
        unBilledDuration?: number
        firstActivityDate?: string
        lastActivityDate?: string
    }
): Project => ({
    id: Number(projet.Id),
    accountId: projet.FK_Compte,
    shortDescription: projet.DescAbr,
    name: projet.Nom,
    description: projet.Descr,
    archived: projet.Archive === "True",
    order: projet.Ordre,
    billingMandate: projet.CD_FacturationMandat,
    rateId: projet.FK_Tarif,
    generateDocument: projet.GenererDocument === "True",
    commercialDocumentTemplateId: projet.FK_ModeleDocumentCommercial,
    isTemplate: projet.EstModele === "True",
    templateName: projet.NomModele,
    notes: projet.Remarques,
    referentUserId: projet.FK_UtilisateurReferent,
    validateActivityWithOverage: projet.FaireValiderActiviteAvecDepassement === "True",
    taskRateEntry: projet.CD_SaisieTarifTache,
    externalKey: projet.CleExterne,
    invoiceTextTemplateId: projet.FK_ModeleTexteFacture,
    isEntryForbidden: projet.EstSaisieInterdite === "True",
    createdAt: projet.sys_tsCreationDate,
    updatedAt: projet.sys_tsUpdateDate,
    createdBy: Number(projet.sys_tsCreationUser),
    updatedBy: Number(projet.sys_tsUpdateUser),
    billingContactId: projet.FK_ContactFacturation,
    totalDuration: projet.totalDuration || 0,
    unBilledDuration: projet.unBilledDuration || 0,
    firstActivityDate: projet.firstActivityDate ? new Date(projet.firstActivityDate) : null,
    lastActivityDate: projet.lastActivityDate ? new Date(projet.lastActivityDate) : null,
})

export const odysProjectRepository = {
    getAll: async (): Promise<Project[]> => {
        const projects = await odysDb<OdysProjet>(projectTable).select().orderBy("Nom", "asc")
        return projects.map(mapProject)
    },
    getById: async (id: number): Promise<Project | null> => {
        const project = await odysDb<OdysProjet>(projectTable).where("Id", id).first()
        return project ? mapProject(project) : null
    },
    getByAccountId: async (accountId: number): Promise<Project[]> => {
        const projects = await odysDb<OdysProjet>(projectTable).where("FK_Compte", accountId)
        return projects.map(mapProject)
    },
    filter: async (filter: ProjectFilter): Promise<Page<Project>> => {
        // Build a base query for counting
        const countQuery = odysDb<OdysProjet>(projectTable)

        if (filter.accountId) {
            countQuery.where("FK_Compte", filter.accountId)
        }

        if (filter.name) {
            countQuery.where(function () {
                this.where("Nom", "like", `${filter.name}%`)
                    .orWhere("Nom", "like", `% ${filter.name}%`)
                    .orWhere("Descr", "like", `${filter.name}%`)
                    .orWhere("Descr", "like", `% ${filter.name}%`)
            })
        }

        if (filter.archived !== undefined) {
            countQuery.where("Archive", filter.archived ? "True" : "False")
        }

        if (filter.referentUserId) {
            countQuery.where("FK_UtilisateurReferent", filter.referentUserId)
        }

        if (filter.fromDate) {
            countQuery.where("sys_tsCreationDate", ">=", filter.fromDate.toISOString())
        }

        if (filter.toDate) {
            countQuery.where("sys_tsCreationDate", "<=", filter.toDate.toISOString())
        }

        if (filter.hasUnbilledTime !== undefined) {
            // Create a subquery to properly handle activity calculations
            const activityStatsSubquery = odysDb
                .select("Rubrique___.FK_Projet")
                .select(
                    odysDb.raw(
                        "sum(Activite___.Duree - Activite___.DureeFacturee) as unBilledDuration"
                    )
                )
                .from("Activite___")
                .leftJoin("Rubrique___", "Activite___.FK_Rubrique", "Rubrique___.Id")
                .groupBy("Rubrique___.FK_Projet")
                .as("activity_stats")

            // Join with the main query
            countQuery.leftJoin(
                activityStatsSubquery,
                `${projectTable}.Id`,
                "activity_stats.FK_Projet"
            )

            if (filter.hasUnbilledTime) {
                countQuery.where("activity_stats.unBilledDuration", ">", 0)
            } else {
                countQuery.where(function () {
                    this.where("activity_stats.unBilledDuration", "<=", 0).orWhereNull(
                        "activity_stats.unBilledDuration"
                    )
                })
            }
        }
        // Get total count for pagination
        const [{ count }] = await countQuery.count({ count: "*" })
        const total = Number(count)

        // Add pagination
        const page = filter.page || 1
        const limit = filter.limit || 20
        const offset = (page - 1) * limit

        // Create a subquery for activity aggregates
        const activitySubquery = odysDb
            .select("Rubrique___.FK_Projet")
            .select(
                odysDb.raw(
                    "sum(CAST(Activite___.Duree AS DECIMAL(18,2)) - CAST(Activite___.DureeFacturee AS DECIMAL(18,2))) as unBilledDuration"
                )
            )
            .select(odysDb.raw("sum(CAST(Activite___.Duree AS DECIMAL(18,2))) as totalDuration"))
            .min("Activite___.DateActivite as firstActivityDate")
            .max("Activite___.DateActivite as lastActivityDate")
            .from("Activite___")
            .leftJoin("Rubrique___", "Activite___.FK_Rubrique", "Rubrique___.Id")
            .groupBy("Rubrique___.FK_Projet")
            .as("activity_stats")
        if (filter.hasUnbilledTime !== undefined) {
            if (filter.hasUnbilledTime) {
                activitySubquery.whereRaw(
                    "CAST(Activite___.Duree AS DECIMAL(18,2)) > CAST(Activite___.DureeFacturee AS DECIMAL(18,2))"
                )
            }
        }

        // Main query with subquery join
        const query = odysDb<
            OdysProjet & {
                totalDuration?: number
                firstActivityDate?: string
                lastActivityDate?: string
            }
        >(projectTable)
            .select(`${projectTable}.*`)
            .select([
                "activity_stats.totalDuration",
                "activity_stats.unBilledDuration",
                "activity_stats.firstActivityDate",
                "activity_stats.lastActivityDate",
            ])
            .leftJoin(activitySubquery, `${projectTable}.Id`, "activity_stats.FK_Projet")

        if (filter.accountId) {
            query.where(`${projectTable}.FK_Compte`, filter.accountId)
        }

        if (filter.name) {
            query.where(function () {
                this.where(`${projectTable}.Nom`, "like", `${filter.name}%`)
                    .orWhere(`${projectTable}.Nom`, "like", `% ${filter.name}%`)
                    .orWhere(`${projectTable}.Descr`, "like", `${filter.name}%`)
                    .orWhere(`${projectTable}.Descr`, "like", `% ${filter.name}%`)
            })
        }

        if (filter.archived !== undefined) {
            query.where(`${projectTable}.Archive`, filter.archived ? "True" : "False")
        }

        if (filter.referentUserId) {
            query.where(`${projectTable}.FK_UtilisateurReferent`, filter.referentUserId)
        }

        if (filter.fromDate) {
            query.where(`${projectTable}.sys_tsCreationDate`, ">=", filter.fromDate.toISOString())
        }

        if (filter.toDate) {
            query.where(`${projectTable}.sys_tsCreationDate`, "<=", filter.toDate.toISOString())
        }
        if (filter.hasUnbilledTime !== undefined) {
            if (filter.hasUnbilledTime) {
                query.where("activity_stats.unBilledDuration", ">", 0)
            } else {
                query.where("activity_stats.unBilledDuration", "<=", 0)
            }
        }
        if (filter.sortBy === "unBilledDuration") {
            query.orderBy("activity_stats.unBilledDuration", filter.sortOrder)
        } else if (filter.sortBy === "firstActivityDate") {
            query.orderBy("activity_stats.firstActivityDate", filter.sortOrder)
        } else if (filter.sortBy === "lastActivityDate") {
            query.orderBy("activity_stats.lastActivityDate", filter.sortOrder)
        } else {
            query.orderBy(`activity_stats.lastActivityDate`, "desc")
        }

        const projects = await query.offset(offset).limit(limit)
        const totalPages = Math.ceil(total / limit)

        return {
            data: projects.map(mapProject),
            total,
            page,
            limit,
            totalPages,
        }
    },
}
