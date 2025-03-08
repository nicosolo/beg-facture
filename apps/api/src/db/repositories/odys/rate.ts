import type { OdysTarif } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Rate } from "@beg/types"

export const mapRate = (tarif: OdysTarif): Rate => ({
    id: Number(tarif.Id),
    name: tarif.Nom,
    amount: tarif.Montant,
    archived: tarif.Archive === "True",
    createdAt: tarif.sys_tsCreationDate,
    updatedAt: tarif.sys_tsUpdateDate,
    createdBy: Number(tarif.sys_tsCreationUser),
    updatedBy: Number(tarif.sys_tsUpdateUser),
})

export const odysRateRepository = {
    getAll: async (): Promise<Rate[]> => {
        const rates = await odysDb<OdysTarif>("Tarif").select().orderBy("Nom", "asc")
        return rates.map(mapRate)
    },
    getById: async (id: number): Promise<Rate | null> => {
        const rate = await odysDb<OdysTarif>("Tarif").where("Id", id).first()
        return rate ? mapRate(rate) : null
    },
    getActive: async (): Promise<Rate[]> => {
        const rates = await odysDb<OdysTarif>("Tarif")
            .where("Archive", "False")
            .orderBy("Nom", "asc")
        return rates.map(mapRate)
    },
}
