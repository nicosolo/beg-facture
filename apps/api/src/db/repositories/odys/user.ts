import type { OdysUser } from "../../../types/odys"
import { odysDb } from "../../odsy"
import type { User } from "@beg/types"

export const mapUser = (user: OdysUser): User => ({
    id: Number(user.Id),
    email: user.Login,
    name: user.Nom,
    firstName: user.Prenom,
    initials: user.Initiales || "",
    active: user.Actif === "True",
    archived: user.Archive === "True",
    createdAt: user.sys_tsCreationDate,
    updatedAt: user.sys_tsUpdateDate,
})

export const odysUserRepository = {
    getAll: async (): Promise<User[]> => {
        const users = await odysDb<OdysUser>("Utilisateur").select().orderBy("Initiales", "asc")
        console.log({ u: typeof users[4].sys_tsCreationDate })
        return users.map(mapUser)
    },
    getById: async (id: number) => {
        const user = await odysDb<OdysUser>("Utilisateur").where("Id", id).first()
        return user ? mapUser(user) : null
    },
}
