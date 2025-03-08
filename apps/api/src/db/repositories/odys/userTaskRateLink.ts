import type { OdysLienUtilisateurTacheParTarif } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { UserTaskRateLink } from "@beg/types"

export const mapUserTaskRateLink = (lien: OdysLienUtilisateurTacheParTarif): UserTaskRateLink => ({
    id: Number(lien.Id),
    rateId: lien.FK_Tarif,
    userId: lien.FK_Utilisateur,
    taskId: lien.FK_Tache,
    amount: lien.Montant,
    createdAt: lien.sys_tsCreationDate,
    updatedAt: lien.sys_tsUpdateDate,
    createdBy: Number(lien.sys_tsCreationUser),
    updatedBy: Number(lien.sys_tsUpdateUser),
})

export const odysUserTaskRateLinkRepository = {
    getAll: async (): Promise<UserTaskRateLink[]> => {
        const links = await odysDb<OdysLienUtilisateurTacheParTarif>(
            "LienUtilisateurTacheParTarif"
        ).select()
        return links.map(mapUserTaskRateLink)
    },
    getById: async (id: number): Promise<UserTaskRateLink | null> => {
        const link = await odysDb<OdysLienUtilisateurTacheParTarif>("LienUtilisateurTacheParTarif")
            .where("Id", id)
            .first()
        return link ? mapUserTaskRateLink(link) : null
    },
    getByUserId: async (userId: number): Promise<UserTaskRateLink[]> => {
        const links = await odysDb<OdysLienUtilisateurTacheParTarif>(
            "LienUtilisateurTacheParTarif"
        ).where("FK_Utilisateur", userId)
        return links.map(mapUserTaskRateLink)
    },
}
