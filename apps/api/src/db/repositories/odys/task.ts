import type { OdysTache } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Task } from "@beg/types"

export const mapTask = (tache: OdysTache): Task => ({
    id: Number(tache.Id),
    billingMode: tache.CD_ModeFacturation,
    taskType: tache.CD_GenreTache,
    taskBilling: tache.CD_FacturationTache,
    projectTaskLink: tache.CD_LienProjetTache,
    outlookReplication: tache.CD_ReplicationOutlook,
    negativeHour: tache.CD_HeureNegative,
    shortDescription: tache.DescAbr,
    name: tache.Nom,
    description: tache.Descr,
    rate: tache.Tarif,
    color: tache.Couleur,
    archived: tache.Archive === "True",
    order: tache.Ordre,
    invoiceColor: tache.CouleurFacture,
    useInvoiceColor: tache.CouleurFactureUtilise === "True",
    durationRequired: tache.DureeObligatoire === "True",
    articleId: tache.FK_Article,
    unit: tache.Unite,
    managerValidation: tache.ValidationResponsable === "True",
    activityReportTemplateId: tache.FK_ModeleRapportActivite,
    salaryRubricId: tache.FK_SalaireRubrique,
    zeroHour: tache.HeureNulle === "True",
    durationMode: tache.CD_ModeDuree,
    fixedDuration: tache.DureeFixe,
    label: tache.Libelle,
    validationColor: tache.CouleurValidation,
    useValidationColor: tache.CouleurValidationUtilise === "True",
    createdAt: tache.sys_tsCreationDate,
    updatedAt: tache.sys_tsUpdateDate,
    createdBy: Number(tache.sys_tsCreationUser),
    updatedBy: Number(tache.sys_tsUpdateUser),
})

export const odysTaskRepository = {
    getAll: async (): Promise<Task[]> => {
        const tasks = await odysDb<OdysTache>("Tache").select().orderBy("Nom", "asc")
        return tasks.map(mapTask)
    },
    getById: async (id: number): Promise<Task | null> => {
        const task = await odysDb<OdysTache>("Tache").where("Id", id).first()
        return task ? mapTask(task) : null
    },
    getActive: async (): Promise<Task[]> => {
        const tasks = await odysDb<OdysTache>("Tache")
            .where("Archive", "False")
            .orderBy("Nom", "asc")
        return tasks.map(mapTask)
    },
}
