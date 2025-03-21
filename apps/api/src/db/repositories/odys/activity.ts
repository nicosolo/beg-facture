import type { OdysActivite } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Activity, Page } from "@beg/types"
import type { ActivityFilter } from "@beg/validations"

export const mapActivity = (activite: OdysActivite & { CustomMontant?: number }): Activity => ({
    id: Number(activite.Id),
    categoryId: activite.FK_Rubrique,
    taskId: activite.FK_Tache,
    userId: activite.FK_Utilisateur,
    invoiceId: activite.FK_Facture,
    date: activite.DateActivite,
    duration: activite.Duree,
    actualDuration: activite.DureeReel,
    billedDuration: activite.DureeFacturee,
    startTime: activite.HeureDebut,
    endTime: activite.HeureFin,
    isFullDay: activite.Journee === "True",
    description: activite.Description,
    amount: activite.CustomMontant ?? activite.Montant,
    expense: activite.Frais,
    rate: activite.Tarif,
    isReplicable: activite.Replicable === "True",
    autoDistribution: activite.RepartitionAuto === "True",
    billingMode: activite.CD_ModeFacturation,
    report: activite.Rapport,
    validationStatus: activite.CD_StatutValidation,
    validationUserId: activite.FK_UtilisateurValidation,
    validationDateTime: activite.DateHeureValidation,
    userExpense: activite.FraisUtilisateur,
    billingExpense: activite.FraisFacturation,
    costPrice: activite.TarifPrixRevient,
    costValue: activite.PrixDeRevient,
    templateName: activite.NomModele,
    isTemplate: activite.EstModele === "True",
    scheduledActivityId: activite.FK_ActivitePlanifiee,
    externalKey: activite.CleExterne,
    uid: activite.Uid,
    forceBillingData: activite.ForcerDonneesFacturation === "True",
    isNegative: activite.Negative === "True",
    createdAt: activite.sys_tsCreationDate,
    updatedAt: activite.sys_tsUpdateDate,
    createdBy: Number(activite.sys_tsCreationUser),
    updatedBy: Number(activite.sys_tsUpdateUser),
    profitabilityAmount: activite.MontantRentabilite,
    profitabilityRate: activite.TarifRentabilite,
    profitabilityDuration: activite.DureeRentabilite,
    privateReplicable: activite.ReplicableIsPrivate === "True",
    useDescriptionAsObjectReplicable: activite.ReplicableUseDescriptionAsObject === "True",
    outlookAppointmentStatus: activite.CD_OutlookRendezvousStatutAff,
})

export const odysActivityRepository = {
    getAll: async (filter: ActivityFilter): Promise<Page<Activity>> => {
        const qb = odysDb<OdysActivite>("Activite___ as Activite")
            .select("Activite.*")
            .select(odysDb.raw("LienUtilisateurTacheParTarif.Montant as CustomMontant"))
            .join("Rubrique___ as Rubrique", "Activite.FK_Rubrique", "Rubrique.Id")
            .leftJoin("LienUtilisateurTacheParTarif", function () {
                this.on(
                    "LienUtilisateurTacheParTarif.FK_Utilisateur",
                    "=",
                    "Activite.FK_Utilisateur"
                ).andOn("LienUtilisateurTacheParTarif.FK_Tache", "=", "Activite.FK_Tache")
            })
            .where("Rubrique.FK_Projet", filter.projectId)
            .andWhere("LienUtilisateurTacheParTarif.FK_Tarif", "=", "26")

        // Create a separate count query that only selects the count
        const countQuery = odysDb<OdysActivite>("Activite___ as Activite")
            .count({ count: "*" })
            .join("Rubrique___ as Rubrique", "Activite.FK_Rubrique", "Rubrique.Id")
            .leftJoin("LienUtilisateurTacheParTarif", function () {
                this.on(
                    "LienUtilisateurTacheParTarif.FK_Utilisateur",
                    "=",
                    "Activite.FK_Utilisateur"
                ).andOn("LienUtilisateurTacheParTarif.FK_Tache", "=", "Activite.FK_Tache")
            })
            .where("Rubrique.FK_Projet", filter.projectId)
            .andWhere("LienUtilisateurTacheParTarif.FK_Tarif", "=", "26")

        if (filter.userId !== undefined) {
            qb.where("Activite.FK_Utilisateur", filter.userId)
            countQuery.where("Activite.FK_Utilisateur", filter.userId)
        }

        if (filter.taskId !== undefined) {
            qb.where("Activite.FK_Tache", filter.taskId)
            countQuery.where("Activite.FK_Tache", filter.taskId)
        }

        if (filter.startDate !== undefined) {
            qb.where("Activite.DateActivite", ">=", filter.startDate)
            countQuery.where("Activite.DateActivite", ">=", filter.startDate)
        }

        if (filter.endDate !== undefined) {
            qb.where("Activite.DateActivite", "<=", filter.endDate)
            countQuery.where("Activite.DateActivite", "<=", filter.endDate)
        }

        if (filter.validationStatus !== undefined) {
            qb.where("Activite.CD_StatutValidation", filter.validationStatus)
            countQuery.where("Activite.CD_StatutValidation", filter.validationStatus)
        }

        if (filter.isTemplate !== undefined) {
            qb.where("Activite.EstModele", filter.isTemplate ? "True" : "False")
            countQuery.where("Activite.EstModele", filter.isTemplate ? "True" : "False")
        }

        // Get total count for pagination
        const [{ count }] = await countQuery
        const total = Number(count)

        // Add pagination
        console.log(filter)
        const page = filter.page || 1
        const limit = filter.limit || 20
        const offset = (page - 1) * limit

        qb.orderBy("DateActivite", "desc").offset(offset).limit(limit)

        const activities = await qb
        const totalPages = Math.ceil(total / limit)

        return {
            data: activities.map(mapActivity),
            total,
            page,
            limit,
            totalPages,
        }
    },
    getById: async (id: number): Promise<Activity | null> => {
        const activity = await odysDb<OdysActivite>("Activite___ as Activite")
            .select("Activite.*")
            .select(odysDb.raw("LienUtilisateurTacheParTarif.Montant as CustomMontant"))
            .leftJoin("LienUtilisateurTacheParTarif", function () {
                this.on(
                    "LienUtilisateurTacheParTarif.FK_Utilisateur",
                    "=",
                    "Activite.FK_Utilisateur"
                ).andOn("LienUtilisateurTacheParTarif.FK_Tache", "=", "Activite.FK_Tache")
            })
            .where("Activite.Id", id)
            .first()
        return activity ? mapActivity(activity) : null
    },
    getByUserId: async (userId: number): Promise<Activity[]> => {
        const activities = await odysDb<OdysActivite>("Activite___ as Activite")
            .select("Activite.*")
            .select(odysDb.raw("LienUtilisateurTacheParTarif.Montant as CustomMontant"))
            .leftJoin("LienUtilisateurTacheParTarif", function () {
                this.on(
                    "LienUtilisateurTacheParTarif.FK_Utilisateur",
                    "=",
                    "Activite.FK_Utilisateur"
                ).andOn("LienUtilisateurTacheParTarif.FK_Tache", "=", "Activite.FK_Tache")
            })
            .where("Activite.FK_Utilisateur", userId)
        return activities.map(mapActivity)
    },
}
