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

export interface OdysActivite {
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

export interface OdysProjet {
    Id: number
    FK_Compte: number
    DescAbr: string
    Nom: string
    Descr: string
    Archive: "True" | "False"
    Ordre: number
    CD_FacturationMandat: string
    FK_Tarif: number
    GenererDocument: "True" | "False"
    FK_ModeleDocumentCommercial: number
    EstModele: "True" | "False"
    NomModele: string
    Remarques: string
    FK_UtilisateurReferent: number
    FaireValiderActiviteAvecDepassement: "True" | "False"
    CD_SaisieTarifTache: string
    CleExterne: string
    FK_ModeleTexteFacture: number
    EstSaisieInterdite: "True" | "False"
    sys_tsCreationUser: number
    sys_tsCreationDate: Date
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date
    FK_ContactFacturation: number
}

export interface OdysLienActiviteFrais {
    Id: number
    FK_Activite: number
    FK_Frais: number
    Quantite: number
    Montant: number
    Descr: string
    Taxe: number
    MontantUtilisateur: number
    MontantFacturation: number
    CD_ModeFrais: string
    Uid: string
    sys_tsCreationUser: number
    sys_tsCreationDate: Date
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date
}

export interface OdysFrais {
    Id: number
    Nom: string
    DescAbr: string
    Descr: string
    CD_TypeFrais: string
    Montant: number
    Unite: string
    Archive: "True" | "False"
    QuantiteDefaut: number
    FK_Article: number
    FK_TypeTaxe: number
    CD_ModeFrais: string
    MontantFacturation: number
    UtiliserMontantFacturation: "True" | "False"
    FK_SalaireRubrique: number
    Libelle: string
    sys_tsCreationUser: number
    sys_tsCreationDate: Date
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date
}

export interface OdysCompte {
    Id: number
    DescAbr: string
    Nom: string
    Messagerie: string
    Messagerie2: string
    Messagerie3: string
    PageWeb: string
    Adresse1: string
    Adresse2: string
    NPA: string
    Localite: string
    Telephone1: string
    Telephone2: string
    Telephone3: string
    Telephone4: string
    Description: string
    FK_Contact: number
    Archive: "True" | "False"
    CleExterne: string
    FK_TypeEntreprise: number
    ChiffreAffaire: number
    NbSalarie: number
    FK_UtilisateurReferent: number
    FK_Region: number
    Fax: string
    RemarquesEntreprise: string
    FK_Pays: number
    DesLe: Date
    DateControle: Date
    FK_BaseMutation: number
    FK_RubriqueCompte: number
    CasePostale: string
    TelephoneMobile: string
    FK_Langue: number
    CD_RelationBancaire: string
    NomInstitut: string
    AdresseInstitut: string
    NPAInstitut: string
    LocaliteInstitut: string
    IBAN: string
    NumeroCompte: string
    NumeroClearing: string
    Swift: string
    RemarquesInstitut: string
    ComptePostalBanque: string
    ReplicableLDAP: "True" | "False"
    ReplicableExchange: "True" | "False"
    ReplicableWinBIZ: "True" | "False"
    DateCreationEntreprise: Date
    DateRadiationEntreprise: Date
    CleExterne2: string
    CleExterne3: string
    IDE: string
    FK_MotifRadiationEntreprise: number
    GLN: string
    sys_tsCreationUser: number
    sys_tsCreationDate: Date
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date
    IDESiege: string
}

export interface OdysLienUtilisateurTacheParTarif {
    Id: number
    FK_Tarif: number
    FK_Utilisateur: number
    FK_Tache: number
    Montant: number
    sys_tsCreationUser: number
    sys_tsCreationDate: Date
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date
}

export interface OdysTarif {
    Id: number
    Nom: string
    Montant: number
    Archive: "True" | "False"
    sys_tsCreationUser: number
    sys_tsCreationDate: Date
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date
}

export interface OdysTache {
    Id: number
    CD_ModeFacturation: string
    CD_GenreTache: string
    CD_FacturationTache: string
    CD_LienProjetTache: string
    CD_ReplicationOutlook: string
    CD_HeureNegative: string
    DescAbr: string
    Nom: string
    Descr: string
    Tarif: number
    Couleur: number
    Archive: "True" | "False"
    Ordre: number
    CouleurFacture: number
    CouleurFactureUtilise: "True" | "False"
    DureeObligatoire: "True" | "False"
    FK_Article: number
    Unite: string
    ValidationResponsable: "True" | "False"
    FK_ModeleRapportActivite: number
    FK_SalaireRubrique: number
    HeureNulle: "True" | "False"
    CD_ModeDuree: string
    DureeFixe: number
    Libelle: string
    CouleurValidation: number
    CouleurValidationUtilise: "True" | "False"
    sys_tsCreationUser: number
    sys_tsCreationDate: Date
    sys_tsUpdateUser: number
    sys_tsUpdateDate: Date
}
