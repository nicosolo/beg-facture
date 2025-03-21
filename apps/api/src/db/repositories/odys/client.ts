import type { OdysCompte } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { Client, Page } from "@beg/types"
import type { ClientFilter } from "@beg/validations"

export const mapClient = (compte: OdysCompte): Client => ({
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

export const odysClientRepository = {
    getAll: async (): Promise<Client[]> => {
        const clients = await odysDb<OdysCompte>("Compte").select().orderBy("Nom", "asc")
        return clients.map(mapClient)
    },

    filter: async (filter: ClientFilter): Promise<Page<Client>> => {
        const qb = odysDb<OdysCompte>("Compte").select("*")

        // Create a separate count query
        const countQuery = odysDb<OdysCompte>("Compte").count({ count: "*" })

        // Apply filters
        if (filter.name) {
            qb.where("Nom", "like", `%${filter.name}%`)
            countQuery.where("Nom", "like", `%${filter.name}%`)
        }

        if (filter.city) {
            qb.where("Localite", "like", `%${filter.city}%`)
            countQuery.where("Localite", "like", `%${filter.city}%`)
        }

        if (filter.postalCode) {
            qb.where("NPA", "like", `%${filter.postalCode}%`)
            countQuery.where("NPA", "like", `%${filter.postalCode}%`)
        }

        if (filter.iban) {
            qb.where("IBAN", "like", `%${filter.iban}%`)
            countQuery.where("IBAN", "like", `%${filter.iban}%`)
        }

        if (filter.address) {
            qb.where(function () {
                this.where("Adresse1", "like", `%${filter.address}%`).orWhere(
                    "Adresse2",
                    "like",
                    `%${filter.address}%`
                )
            })

            countQuery.where(function () {
                this.where("Adresse1", "like", `%${filter.address}%`).orWhere(
                    "Adresse2",
                    "like",
                    `%${filter.address}%`
                )
            })
        }

        // Get total count for pagination
        const [{ count }] = await countQuery
        const total = Number(count)

        // Add pagination
        const page = filter.page || 1
        const limit = filter.limit || 20
        const offset = (page - 1) * limit

        qb.orderBy("Nom", "asc").offset(offset).limit(limit)

        const clients = await qb
        const totalPages = Math.ceil(total / limit)

        return {
            data: clients.map(mapClient),
            total,
            page,
            limit,
            totalPages,
        }
    },
}
