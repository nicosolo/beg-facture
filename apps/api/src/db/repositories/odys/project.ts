import type { OdysProjet } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Project } from "@beg/types"

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
        const projects = await odysDb<OdysProjet>("Projet").select().orderBy("Nom", "asc")
        return projects.map(mapProject)
    },
    getById: async (id: number): Promise<Project | null> => {
        const project = await odysDb<OdysProjet>("Projet").where("Id", id).first()
        return project ? mapProject(project) : null
    },
    getByAccountId: async (accountId: number): Promise<Project[]> => {
        const projects = await odysDb<OdysProjet>("Projet").where("FK_Compte", accountId)
        return projects.map(mapProject)
    },
}
