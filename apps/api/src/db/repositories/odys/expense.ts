import type { OdysFrais } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Expense } from "@beg/types"

export const mapExpense = (frais: OdysFrais): Expense => ({
    id: Number(frais.Id),
    name: frais.Nom,
    shortDescription: frais.DescAbr,
    description: frais.Descr,
    expenseType: frais.CD_TypeFrais,
    amount: frais.Montant,
    unit: frais.Unite,
    archived: frais.Archive === "True",
    defaultQuantity: frais.QuantiteDefaut,
    articleId: frais.FK_Article,
    taxTypeId: frais.FK_TypeTaxe,
    expenseMode: frais.CD_ModeFrais,
    billingAmount: frais.MontantFacturation,
    useBillingAmount: frais.UtiliserMontantFacturation === "True",
    salaryRubricId: frais.FK_SalaireRubrique,
    label: frais.Libelle,
    createdAt: frais.sys_tsCreationDate,
    updatedAt: frais.sys_tsUpdateDate,
    createdBy: Number(frais.sys_tsCreationUser),
    updatedBy: Number(frais.sys_tsUpdateUser),
})

export const odysExpenseRepository = {
    getAll: async (): Promise<Expense[]> => {
        const expenses = await odysDb<OdysFrais>("Frais").select().orderBy("Nom", "asc")
        return expenses.map(mapExpense)
    },
    getById: async (id: number): Promise<Expense | null> => {
        const expense = await odysDb<OdysFrais>("Frais").where("Id", id).first()
        return expense ? mapExpense(expense) : null
    },
    getActive: async (): Promise<Expense[]> => {
        const expenses = await odysDb<OdysFrais>("Frais")
            .where("Archive", "False")
            .orderBy("Nom", "asc")
        return expenses.map(mapExpense)
    },
}
