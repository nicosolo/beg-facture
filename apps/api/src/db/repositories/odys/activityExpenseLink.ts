import type { OdysLienActiviteFrais } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { ActivityExpenseLink } from "@beg/types"

export const mapActivityExpenseLink = (lien: OdysLienActiviteFrais): ActivityExpenseLink => ({
    id: Number(lien.Id),
    activityId: lien.FK_Activite,
    expenseId: lien.FK_Frais,
    quantity: lien.Quantite,
    amount: lien.Montant,
    description: lien.Descr,
    tax: lien.Taxe,
    userAmount: lien.MontantUtilisateur,
    billingAmount: lien.MontantFacturation,
    expenseMode: lien.CD_ModeFrais,
    uid: lien.Uid,
    createdAt: lien.sys_tsCreationDate,
    updatedAt: lien.sys_tsUpdateDate,
    createdBy: Number(lien.sys_tsCreationUser),
    updatedBy: Number(lien.sys_tsUpdateUser),
})

export const odysActivityExpenseLinkRepository = {
    getAll: async (): Promise<ActivityExpenseLink[]> => {
        const links = await odysDb<OdysLienActiviteFrais>("LienActiviteFrais").select()
        return links.map(mapActivityExpenseLink)
    },
    getById: async (id: number): Promise<ActivityExpenseLink | null> => {
        const link = await odysDb<OdysLienActiviteFrais>("LienActiviteFrais")
            .where("Id", id)
            .first()
        return link ? mapActivityExpenseLink(link) : null
    },
    getByActivityId: async (activityId: number): Promise<ActivityExpenseLink[]> => {
        const links = await odysDb<OdysLienActiviteFrais>("LienActiviteFrais").where(
            "FK_Activite",
            activityId
        )
        return links.map(mapActivityExpenseLink)
    },
}
