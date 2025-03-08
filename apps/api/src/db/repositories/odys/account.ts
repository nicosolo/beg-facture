import type { OdysCompte } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Account } from "@beg/types"

export const mapAccount = (compte: OdysCompte): Account => ({
    id: Number(compte.Id),
    shortDescription: compte.DescAbr,
    name: compte.Nom,
    email: compte.Messagerie,
    email2: compte.Messagerie2,
    email3: compte.Messagerie3,
    website: compte.PageWeb,
    address1: compte.Adresse1,
    address2: compte.Adresse2,
    postalCode: compte.NPA,
    city: compte.Localite,
    phone1: compte.Telephone1,
    phone2: compte.Telephone2,
    phone3: compte.Telephone3,
    phone4: compte.Telephone4,
    description: compte.Description,
    contactId: compte.FK_Contact,
    archived: compte.Archive === "True",
    externalKey: compte.CleExterne,
    companyTypeId: compte.FK_TypeEntreprise,
    turnover: compte.ChiffreAffaire,
    employeeCount: compte.NbSalarie,
    referentUserId: compte.FK_UtilisateurReferent,
    regionId: compte.FK_Region,
    fax: compte.Fax,
    companyNotes: compte.RemarquesEntreprise,
    countryId: compte.FK_Pays,
    since: compte.DesLe,
    checkDate: compte.DateControle,
    mutationBaseId: compte.FK_BaseMutation,
    accountCategoryId: compte.FK_RubriqueCompte,
    poBox: compte.CasePostale,
    mobilePhone: compte.TelephoneMobile,
    languageId: compte.FK_Langue,
    bankRelation: compte.CD_RelationBancaire,
    instituteName: compte.NomInstitut,
    instituteAddress: compte.AdresseInstitut,
    institutePostalCode: compte.NPAInstitut,
    instituteCity: compte.LocaliteInstitut,
    iban: compte.IBAN,
    accountNumber: compte.NumeroCompte,
    clearingNumber: compte.NumeroClearing,
    swift: compte.Swift,
    instituteNotes: compte.RemarquesInstitut,
    postAccountBank: compte.ComptePostalBanque,
    ldapReplicable: compte.ReplicableLDAP === "True",
    exchangeReplicable: compte.ReplicableExchange === "True",
    winBIZReplicable: compte.ReplicableWinBIZ === "True",
    companyCreationDate: compte.DateCreationEntreprise,
    companyTerminationDate: compte.DateRadiationEntreprise,
    externalKey2: compte.CleExterne2,
    externalKey3: compte.CleExterne3,
    ide: compte.IDE,
    companyTerminationReasonId: compte.FK_MotifRadiationEntreprise,
    gln: compte.GLN,
    createdAt: compte.sys_tsCreationDate,
    updatedAt: compte.sys_tsUpdateDate,
    createdBy: Number(compte.sys_tsCreationUser),
    updatedBy: Number(compte.sys_tsUpdateUser),
    ideSite: compte.IDESiege,
})

export const odysAccountRepository = {
    getAll: async (): Promise<Account[]> => {
        const accounts = await odysDb<OdysCompte>("Compte").select().orderBy("Nom", "asc")
        return accounts.map(mapAccount)
    },
    getById: async (id: number): Promise<Account | null> => {
        const account = await odysDb<OdysCompte>("Compte").where("Id", id).first()
        return account ? mapAccount(account) : null
    },
    getActive: async (): Promise<Account[]> => {
        const accounts = await odysDb<OdysCompte>("Compte")
            .where("Archive", "False")
            .orderBy("Nom", "asc")
        return accounts.map(mapAccount)
    },
}
