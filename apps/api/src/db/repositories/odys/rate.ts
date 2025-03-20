import type { OdysTarif } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Rate } from "@beg/types"

export const mapRate = (rate: OdysTarif): Rate => ({
    id: Number(rate.Id),
    name: rate.Nom,
    amount: rate.Montant,
    archived: rate.Archive === "True",
    createdAt: rate.sys_tsCreationDate,
    updatedAt: rate.sys_tsUpdateDate,
    createdBy: Number(rate.sys_tsCreationUser),
    updatedBy: Number(rate.sys_tsUpdateUser),
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
