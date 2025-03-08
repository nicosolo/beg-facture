export interface OdysUser {
    Id: number | string
    Nom: string // Last name
    Prenom: string // First name
    Login: string
    Special: boolean | string
    Actif: "True" | "False" // Active status
    Droits: string | number // Rights/permissions
    OutlookLogin: string
    FK_Departement: number // Department foreign key
    ExchangeMailbox: string
    MotDePasse: string // Password
    FK_UtilisateurResponsable?: number // Manager/supervisor foreign key
    CleExterne?: string // External key
    Initiales?: string // Initials
    Archive: "True" | "False"
    FK_Contact?: number // Contact foreign key
    AppMobileActif: "True" | "False" // Mobile app active
    AppMobileNom?: string // Mobile app name
    AppMobileMotDePasse?: string // Mobile app password
    OdysCubeActif: "True" | "False"
    FK_TacheParDefaut?: number // Default task foreign key
    ActiveDirectoryGuid?: string
    ActiveDirectoryTexte?: string
    NoTelephoneMobile?: string // Mobile phone number
    UserOnlineGuid?: string
    sys_tsCreationUser?: string | number
    sys_tsCreationDate?: Date
    sys_tsUpdateUser?: string | number
    sys_tsUpdateDate?: Date
}

export interface OdysActivitY {
    Id: number
    FK_Rubrique: number
    FK_Tache: number
    FK_Utilisateur: number
    FK_Facture: number
    FK_TachePlanifiee: number
    DateActivite: Date // Date format
    Duree: number
    DureeReel: number
    DureeFacturee: number
    HeureDebut: Date // Date format
    HeureFin: Date // Date format
    Journee: "True" | "False"
    Description: string
    Montant: number
    Frais: number
    Tarif: number
    Replicable: "True" | "False"
    RepartitionAuto: "True" | "False"
    CD_ModeFacturation: string
    Rapport: string
    CD_StatutValidation: string
    FK_UtilisateurValidation: number
    DateHeureValidation: Date // Date format
    FraisUtilisateur: number
    FraisFacturation: number
    TarifPrixRevient: number
    PrixDeRevient: number
    NomModele: string
    EstModele: "True" | "False"
    FK_ActivitePlanifiee: number
    CleExterne: string
    Uid: string // UUID format
    ForcerDonneesFacturation: "True" | "False"
    Negative: "True" | "False"
    sys_tsCreationUser: number
    sys_tsCreationDate: Date // Date format
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date // Date format
    MontantRentabilite: number
    TarifRentabilite: number
    DureeRentabilite: number
    ReplicableIsPrivate: "True" | "False"
    ReplicableUseDescriptionAsObject: "True" | "False"
    CD_OutlookRendezvousStatutAff: string
}
