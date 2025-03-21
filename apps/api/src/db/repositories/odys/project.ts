import type { OdysProjet } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Project, Page } from "@beg/types"
import type { ProjectFilter } from "@beg/validations"

const projectTable = "Projet_____"
export const mapProject = (projet: OdysProjet): Project => ({
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
        const query = odysDb<OdysProjet>(projectTable)
        const countQuery = odysDb<OdysProjet>(projectTable)

        if (filter.accountId) {
            query.where("FK_Compte", filter.accountId)
            countQuery.where("FK_Compte", filter.accountId)
        }

        if (filter.name) {
            query.where("Nom", "like", `%${filter.name}%`)
            countQuery.where("Nom", "like", `%${filter.name}%`)
        }

        if (filter.archived !== undefined) {
            query.where("Archive", filter.archived ? "True" : "False")
            countQuery.where("Archive", filter.archived ? "True" : "False")
        }

        if (filter.referentUserId) {
            query.where("FK_UtilisateurReferent", filter.referentUserId)
            countQuery.where("FK_UtilisateurReferent", filter.referentUserId)
        }

        if (filter.fromDate) {
            query.where("sys_tsCreationDate", ">=", filter.fromDate.toISOString())
            countQuery.where("sys_tsCreationDate", ">=", filter.fromDate.toISOString())
        }

        if (filter.toDate) {
            query.where("sys_tsCreationDate", "<=", filter.toDate.toISOString())
            countQuery.where("sys_tsCreationDate", "<=", filter.toDate.toISOString())
        }

        // Get total count for pagination
        const [{ count }] = await countQuery.count({ count: "*" })
        const total = Number(count)

        // Add pagination
        const page = filter.page || 1
        const limit = filter.limit || 20
        const offset = (page - 1) * limit

        query.orderBy("Nom", "asc").offset(offset).limit(limit)

        const projects = await query
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
