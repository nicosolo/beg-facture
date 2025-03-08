import type { OdysActivite } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Activity } from "@beg/types"

export const mapActivity = (activite: OdysActivite): Activity => ({
    id: Number(activite.Id),
    categoryId: activite.FK_Rubrique,
    taskId: activite.FK_Tache,
    userId: activite.FK_Utilisateur,
    invoiceId: activite.FK_Facture,
    scheduledTaskId: activite.FK_TachePlanifiee,
    date: activite.DateActivite,
    duration: activite.Duree,
    actualDuration: activite.DureeReel,
    billedDuration: activite.DureeFacturee,
    startTime: activite.HeureDebut,
    endTime: activite.HeureFin,
    isFullDay: activite.Journee === "True",
    description: activite.Description,
    amount: activite.Montant,
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
    getAll: async (): Promise<Activity[]> => {
        const activities = await odysDb<OdysActivite>("Activite").select()
        return activities.map(mapActivity)
    },
    getById: async (id: number): Promise<Activity | null> => {
        const activity = await odysDb<OdysActivite>("Activite").where("Id", id).first()
        return activity ? mapActivity(activity) : null
    },
    getByUserId: async (userId: number): Promise<Activity[]> => {
        const activities = await odysDb<OdysActivite>("Activite").where("FK_Utilisateur", userId)
        return activities.map(mapActivity)
    },
}
