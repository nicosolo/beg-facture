-- DROP SCHEMA dbo;

CREATE SCHEMA dbo;
-- OA_BEG.dbo.ActivitePlanifiee definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ActivitePlanifiee;

CREATE TABLE OA_BEG.dbo.ActivitePlanifiee (
	Id decimal(10,0) NOT NULL,
	FK_PlanningActivite decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	FK_TrancheHoraire decimal(10,0) NULL,
	FK_TypeActivitePlanifiee decimal(10,0) NULL,
	DateActivitePlanifiee datetime NULL,
	CD_TypePlanning varchar(10) COLLATE French_CI_AS NULL,
	TexteLibre varchar(3) COLLATE French_CI_AS NULL,
	TexteAffiche varchar(3) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	CD_StatutValidation varchar(10) COLLATE French_CI_AS NULL,
	FK_UtilisateurValidation decimal(10,0) NULL,
	DateHeureValidation datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ActivitePlanifiee PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Activite___ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Activite___;

CREATE TABLE OA_BEG.dbo.Activite___ (
	Id decimal(10,0) NOT NULL,
	FK_Rubrique decimal(10,0) NULL,
	FK_Tache decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	FK_Facture decimal(10,0) NULL,
	FK_TachePlanifiee decimal(10,0) NULL,
	DateActivite datetime NULL,
	Duree decimal(12,0) NULL,
	DureeReel decimal(12,0) NULL,
	DureeFacturee decimal(12,0) NULL,
	HeureDebut datetime NULL,
	HeureFin datetime NULL,
	Journee varchar(10) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Montant decimal(16,6) NULL,
	Frais decimal(16,6) NULL,
	Tarif decimal(10,2) NULL,
	Replicable varchar(10) COLLATE French_CI_AS NULL,
	RepartitionAuto varchar(5) COLLATE French_CI_AS NULL,
	CD_ModeFacturation varchar(10) COLLATE French_CI_AS NULL,
	Rapport text COLLATE French_CI_AS NULL,
	CD_StatutValidation varchar(10) COLLATE French_CI_AS NULL,
	FK_UtilisateurValidation decimal(10,0) NULL,
	DateHeureValidation datetime NULL,
	FraisUtilisateur decimal(16,6) NULL,
	FraisFacturation decimal(16,6) NULL,
	TarifPrixRevient decimal(10,2) NULL,
	PrixDeRevient decimal(12,2) NULL,
	NomModele varchar(255) COLLATE French_CI_AS NULL,
	EstModele varchar(5) COLLATE French_CI_AS NULL,
	FK_ActivitePlanifiee decimal(10,0) NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	Uid varchar(50) COLLATE French_CI_AS NULL,
	ForcerDonneesFacturation varchar(5) COLLATE French_CI_AS NULL,
	Negative varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	MontantRentabilite decimal(16,6) NULL,
	TarifRentabilite decimal(14,6) NULL,
	DureeRentabilite decimal(16,6) NULL,
	ReplicableIsPrivate varchar(5) COLLATE French_CI_AS NULL,
	ReplicableUseDescriptionAsObject varchar(5) COLLATE French_CI_AS NULL,
	CD_OutlookRendezvousStatutAff varchar(10) COLLATE French_CI_AS NULL,
	CONSTRAINT PrimaryKey_Activite___ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ActiviteParDate ON OA_BEG.dbo.Activite___ (  DateActivite ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ActiviteParRubrique ON OA_BEG.dbo.Activite___ (  FK_Rubrique ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ActiviteParUtilisateur ON OA_BEG.dbo.Activite___ (  FK_Utilisateur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Adresse____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Adresse____;

CREATE TABLE OA_BEG.dbo.Adresse____ (
	Id decimal(10,0) NOT NULL,
	FK_CodePolitesseAdresse decimal(10,0) NULL,
	FK_TitreCivil decimal(10,0) NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	AttentionDe varchar(255) COLLATE French_CI_AS NULL,
	Adresse1 varchar(200) COLLATE French_CI_AS NULL,
	Adresse2 varchar(100) COLLATE French_CI_AS NULL,
	CasePostale varchar(50) COLLATE French_CI_AS NULL,
	NPA varchar(20) COLLATE French_CI_AS NULL,
	Localite varchar(255) COLLATE French_CI_AS NULL,
	FK_Region decimal(10,0) NULL,
	FK_Pays decimal(10,0) NULL,
	Telephone varchar(20) COLLATE French_CI_AS NULL,
	Fax varchar(20) COLLATE French_CI_AS NULL,
	Messagerie varchar(100) COLLATE French_CI_AS NULL,
	PageWeb varchar(200) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Adresse____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Article____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Article____;

CREATE TABLE OA_BEG.dbo.Article____ (
	Id decimal(10,0) NOT NULL,
	CodeArticle varchar(30) COLLATE French_CI_AS NULL,
	DescriptionCourte varchar(50) COLLATE French_CI_AS NULL,
	DescriptionLongue text COLLATE French_CI_AS NULL,
	CodeBarre varchar(30) COLLATE French_CI_AS NULL,
	PrixVente decimal(16,4) NULL,
	Divers1 varchar(25) COLLATE French_CI_AS NULL,
	Divers2 varchar(25) COLLATE French_CI_AS NULL,
	Divers3 decimal(12,4) NULL,
	Divers4 text COLLATE French_CI_AS NULL,
	TauxTva decimal(5,2) NULL,
	TvaIncluse decimal(1,0) NULL,
	CodeTva varchar(20) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	FK_TypeTva decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Article____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ArticleParCleExterne ON OA_BEG.dbo.Article____ (  CleExterne ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Audit______ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Audit______;

CREATE TABLE OA_BEG.dbo.Audit______ (
	Id decimal(10,0) NOT NULL,
	NomFichier varchar(100) COLLATE French_CI_AS NULL,
	IdEnregistrement decimal(12,0) NULL,
	Evenement varchar(10) COLLATE French_CI_AS NULL,
	DateHeure datetime NULL,
	FK_Utilisateur decimal(10,0) NULL,
	IdEnregistrementNouveau decimal(12,0) NULL,
	Traite varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Audit______ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.AutorisationFonction definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.AutorisationFonction;

CREATE TABLE OA_BEG.dbo.AutorisationFonction (
	Id decimal(10,0) NOT NULL,
	FK_Fonction decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	Acces varchar(10) COLLATE French_CI_AS NULL,
	Modification varchar(10) COLLATE French_CI_AS NULL,
	Suppression varchar(10) COLLATE French_CI_AS NULL,
	Creation varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_AutorisationFonction PRIMARY KEY (Id)
);


-- OA_BEG.dbo.AutorisationValeur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.AutorisationValeur;

CREATE TABLE OA_BEG.dbo.AutorisationValeur (
	Id decimal(10,0) NOT NULL,
	CD_CategorieValeur varchar(10) COLLATE French_CI_AS NULL,
	FK_Groupe decimal(10,0) NULL,
	Creation varchar(5) COLLATE French_CI_AS NULL,
	Modification varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_AutorisationValeur PRIMARY KEY (Id)
);


-- OA_BEG.dbo.BaseVersion definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.BaseVersion;

CREATE TABLE OA_BEG.dbo.BaseVersion (
	Id decimal(10,0) NOT NULL,
	DateHeureReference decimal(14,0) NULL,
	TailleReference decimal(10,0) NULL,
	IsDemo varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_BaseVersion PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX BaseVersion_L1 ON OA_BEG.dbo.BaseVersion (  Id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.BusinessObjectParFonction definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.BusinessObjectParFonction;

CREATE TABLE OA_BEG.dbo.BusinessObjectParFonction (
	Id decimal(10,0) NOT NULL,
	FK_Fonction decimal(10,0) NULL,
	BO varchar(100) COLLATE French_CI_AS NULL,
	Enfant varchar(10) COLLATE French_CI_AS NULL,
	Interne varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_BusinessObjectParFonction PRIMARY KEY (Id)
);


-- OA_BEG.dbo.CategorieCode definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.CategorieCode;

CREATE TABLE OA_BEG.dbo.CategorieCode (
	Id decimal(10,0) NOT NULL,
	Nom varchar(50) COLLATE French_CI_AS NULL,
	DescriptionCourte varchar(15) COLLATE French_CI_AS NULL,
	DescriptionLongue varchar(50) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_CategorieCode PRIMARY KEY (Id)
);


-- OA_BEG.dbo.CategorieTachePlanifiee definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.CategorieTachePlanifiee;

CREATE TABLE OA_BEG.dbo.CategorieTachePlanifiee (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Couleur decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_CategorieTachePlanifiee PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ChampCalcule definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ChampCalcule;

CREATE TABLE OA_BEG.dbo.ChampCalcule (
	Id decimal(10,0) NOT NULL,
	NomObjet varchar(255) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	CD_TypeChampCalcule varchar(10) COLLATE French_CI_AS NULL,
	FormatAffichage varchar(255) COLLATE French_CI_AS NULL,
	Expression text COLLATE French_CI_AS NULL,
	AfficherTotal varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ChampCalcule PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ClasseDHeures definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ClasseDHeures;

CREATE TABLE OA_BEG.dbo.ClasseDHeures (
	Id decimal(10,0) NOT NULL,
	Designation varchar(200) COLLATE French_CI_AS NULL,
	Coefficient decimal(10,2) NULL,
	[Sequence] decimal(10,0) NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	HeureDebut datetime NULL,
	HeureFin datetime NULL,
	RepartitionAuto varchar(5) COLLATE French_CI_AS NULL,
	CoefficientTarifUtilise varchar(5) COLLATE French_CI_AS NULL,
	CoefficientTarif decimal(10,6) NULL,
	Lundi varchar(5) COLLATE French_CI_AS NULL,
	Mardi varchar(5) COLLATE French_CI_AS NULL,
	Mercredi varchar(5) COLLATE French_CI_AS NULL,
	Jeudi varchar(5) COLLATE French_CI_AS NULL,
	Vendredi varchar(5) COLLATE French_CI_AS NULL,
	Samedi varchar(5) COLLATE French_CI_AS NULL,
	Dimanche varchar(5) COLLATE French_CI_AS NULL,
	Ferie varchar(5) COLLATE French_CI_AS NULL,
	JoursSpecifiques varchar(5) COLLATE French_CI_AS NULL,
	ValidationResponsable varchar(5) COLLATE French_CI_AS NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ClasseDHeures PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Clearing___ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Clearing___;

CREATE TABLE OA_BEG.dbo.Clearing___ (
	Id decimal(12,0) NOT NULL,
	EnregistrementUtilisateur varchar(5) COLLATE French_CI_AS NULL,
	NoCB varchar(5) COLLATE French_CI_AS NULL,
	Nom varchar(60) COLLATE French_CI_AS NULL,
	Adresse varchar(35) COLLATE French_CI_AS NULL,
	NPA varchar(10) COLLATE French_CI_AS NULL,
	Localite varchar(35) COLLATE French_CI_AS NULL,
	Telephone varchar(18) COLLATE French_CI_AS NULL,
	Fax varchar(18) COLLATE French_CI_AS NULL,
	ComptePostal varchar(12) COLLATE French_CI_AS NULL,
	SWIFT varchar(14) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Clearing___ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.CodeCustomDescription definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.CodeCustomDescription;

CREATE TABLE OA_BEG.dbo.CodeCustomDescription (
	Id decimal(10,0) NOT NULL,
	FK_CategorieCode decimal(10,0) NULL,
	ValeurCode varchar(15) COLLATE French_CI_AS NULL,
	DescriptionCourte varchar(15) COLLATE French_CI_AS NULL,
	DescriptionLongue varchar(50) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_CodeCustomDescription PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Code_______ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Code_______;

CREATE TABLE OA_BEG.dbo.Code_______ (
	Id decimal(10,0) NOT NULL,
	FK_CategorieCode decimal(10,0) NULL,
	Valeur varchar(15) COLLATE French_CI_AS NULL,
	DescriptionCourte varchar(15) COLLATE French_CI_AS NULL,
	DescriptionLongue varchar(50) COLLATE French_CI_AS NULL,
	DescriptionCourteInternal varchar(15) COLLATE French_CI_AS NULL,
	DescriptionLongueInternal varchar(50) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Code_______ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Code_L1____ ON OA_BEG.dbo.Code_______ (  FK_CategorieCode ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Code_L2____ ON OA_BEG.dbo.Code_______ (  FK_CategorieCode ASC  , Valeur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Competence_ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Competence_;

CREATE TABLE OA_BEG.dbo.Competence_ (
	Id decimal(10,0) NOT NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	Tarif decimal(10,2) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Competence_ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Compte_____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Compte_____;

CREATE TABLE OA_BEG.dbo.Compte_____ (
	Id decimal(10,0) NOT NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	Messagerie varchar(100) COLLATE French_CI_AS NULL,
	Messagerie2 varchar(100) COLLATE French_CI_AS NULL,
	Messagerie3 varchar(100) COLLATE French_CI_AS NULL,
	PageWeb varchar(200) COLLATE French_CI_AS NULL,
	Adresse1 varchar(200) COLLATE French_CI_AS NULL,
	Adresse2 varchar(100) COLLATE French_CI_AS NULL,
	NPA varchar(20) COLLATE French_CI_AS NULL,
	Localite varchar(100) COLLATE French_CI_AS NULL,
	Telephone1 varchar(20) COLLATE French_CI_AS NULL,
	Telephone2 varchar(20) COLLATE French_CI_AS NULL,
	Telephone3 varchar(20) COLLATE French_CI_AS NULL,
	Telephone4 varchar(20) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	FK_Contact decimal(10,0) NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	FK_TypeEntreprise decimal(10,0) NULL,
	ChiffreAffaire decimal(12,2) NULL,
	NbSalarie decimal(10,0) NULL,
	FK_UtilisateurReferent decimal(10,0) NULL,
	FK_Region decimal(10,0) NULL,
	Fax varchar(20) COLLATE French_CI_AS NULL,
	RemarquesEntreprise varchar(255) COLLATE French_CI_AS NULL,
	FK_Pays decimal(10,0) NULL,
	DesLe datetime NULL,
	DateControle datetime NULL,
	FK_BaseMutation decimal(10,0) NULL,
	FK_RubriqueCompte decimal(10,0) NULL,
	CasePostale varchar(50) COLLATE French_CI_AS NULL,
	TelephoneMobile varchar(20) COLLATE French_CI_AS NULL,
	FK_Langue decimal(10,0) NULL,
	CD_RelationBancaire varchar(10) COLLATE French_CI_AS NULL,
	NomInstitut varchar(100) COLLATE French_CI_AS NULL,
	AdresseInstitut varchar(255) COLLATE French_CI_AS NULL,
	NPAInstitut varchar(20) COLLATE French_CI_AS NULL,
	LocaliteInstitut varchar(100) COLLATE French_CI_AS NULL,
	IBAN varchar(50) COLLATE French_CI_AS NULL,
	NumeroCompte varchar(255) COLLATE French_CI_AS NULL,
	NumeroClearing varchar(10) COLLATE French_CI_AS NULL,
	Swift varchar(30) COLLATE French_CI_AS NULL,
	RemarquesInstitut text COLLATE French_CI_AS NULL,
	ComptePostalBanque varchar(12) COLLATE French_CI_AS NULL,
	ReplicableLDAP varchar(5) COLLATE French_CI_AS NULL,
	ReplicableExchange varchar(5) COLLATE French_CI_AS NULL,
	ReplicableWinBIZ varchar(5) COLLATE French_CI_AS NULL,
	DateCreationEntreprise datetime NULL,
	DateRadiationEntreprise datetime NULL,
	CleExterne2 varchar(50) COLLATE French_CI_AS NULL,
	CleExterne3 varchar(50) COLLATE French_CI_AS NULL,
	IDE varchar(50) COLLATE French_CI_AS NULL,
	FK_MotifRadiationEntreprise decimal(10,0) NULL,
	GLN varchar(20) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	IDESiege varchar(50) COLLATE French_CI_AS NULL,
	CONSTRAINT PrimaryKey_Compte_____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX CompteParBaseMutation ON OA_BEG.dbo.Compte_____ (  FK_BaseMutation ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX CompteParCleExterne ON OA_BEG.dbo.Compte_____ (  CleExterne ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX CompteParDescAbr ON OA_BEG.dbo.Compte_____ (  DescAbr ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX CompteParNom ON OA_BEG.dbo.Compte_____ (  Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Compte_L6__ ON OA_BEG.dbo.Compte_____ (  Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Compte_L7__ ON OA_BEG.dbo.Compte_____ (  DateControle ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Contact____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Contact____;

CREATE TABLE OA_BEG.dbo.Contact____ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	Prenom varchar(100) COLLATE French_CI_AS NULL,
	Societe varchar(100) COLLATE French_CI_AS NULL,
	FK_TitreCivil decimal(10,0) NULL,
	Messagerie varchar(100) COLLATE French_CI_AS NULL,
	Messagerie2 varchar(100) COLLATE French_CI_AS NULL,
	Messagerie3 varchar(100) COLLATE French_CI_AS NULL,
	PageWeb varchar(200) COLLATE French_CI_AS NULL,
	Adresse1 varchar(200) COLLATE French_CI_AS NULL,
	Adresse2 varchar(100) COLLATE French_CI_AS NULL,
	NPA varchar(20) COLLATE French_CI_AS NULL,
	Localite varchar(100) COLLATE French_CI_AS NULL,
	FK_Pays decimal(10,0) NULL,
	FK_Region decimal(10,0) NULL,
	FK_Langue decimal(10,0) NULL,
	Telephone1 varchar(20) COLLATE French_CI_AS NULL,
	Telephone2 varchar(20) COLLATE French_CI_AS NULL,
	Telephone3 varchar(20) COLLATE French_CI_AS NULL,
	Telephone4 varchar(20) COLLATE French_CI_AS NULL,
	TelephoneMobile varchar(20) COLLATE French_CI_AS NULL,
	TelephoneFax varchar(20) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	CD_Sexe varchar(10) COLLATE French_CI_AS NULL,
	DateNaissance datetime NULL,
	FK_Nationalite decimal(10,0) NULL,
	FK_EtatCivil decimal(10,0) NULL,
	EtatCivilDesLe datetime NULL,
	EtatCivilRemarque text COLLATE French_CI_AS NULL,
	FK_Religion decimal(10,0) NULL,
	NoAVS varchar(255) COLLATE French_CI_AS NULL,
	FK_Origine decimal(10,0) NULL,
	ReferenceExterne1 varchar(255) COLLATE French_CI_AS NULL,
	Divers1 varchar(40) COLLATE French_CI_AS NULL,
	Divers2 varchar(40) COLLATE French_CI_AS NULL,
	Divers3 varchar(40) COLLATE French_CI_AS NULL,
	Divers4 varchar(40) COLLATE French_CI_AS NULL,
	Divers5 varchar(40) COLLATE French_CI_AS NULL,
	Divers6 varchar(40) COLLATE French_CI_AS NULL,
	Divers7 varchar(40) COLLATE French_CI_AS NULL,
	Divers8 varchar(40) COLLATE French_CI_AS NULL,
	Divers9 varchar(40) COLLATE French_CI_AS NULL,
	Divers10 varchar(40) COLLATE French_CI_AS NULL,
	NoAVSAncien varchar(255) COLLATE French_CI_AS NULL,
	FK_PermisSejour decimal(10,0) NULL,
	ParentName varchar(100) COLLATE French_CI_AS NULL,
	FK_UtilisateurReferent decimal(10,0) NULL,
	FK_FonctionContact decimal(10,0) NULL,
	FK_ContactBaseMutation decimal(10,0) NULL,
	DesLe datetime NULL,
	DateDeces datetime NULL,
	CasePostale varchar(50) COLLATE French_CI_AS NULL,
	FK_CodePolitesse decimal(10,0) NULL,
	DateControle datetime NULL,
	FK_BaseMutation decimal(10,0) NULL,
	CD_RelationBancaire varchar(10) COLLATE French_CI_AS NULL,
	NomInstitut varchar(100) COLLATE French_CI_AS NULL,
	AdresseInstitut varchar(200) COLLATE French_CI_AS NULL,
	NPAInstitut varchar(20) COLLATE French_CI_AS NULL,
	LocaliteInstitut varchar(100) COLLATE French_CI_AS NULL,
	IBAN varchar(30) COLLATE French_CI_AS NULL,
	NumeroCompte varchar(255) COLLATE French_CI_AS NULL,
	NumeroClearing varchar(10) COLLATE French_CI_AS NULL,
	Swift varchar(30) COLLATE French_CI_AS NULL,
	RemarquesInstitut text COLLATE French_CI_AS NULL,
	ComptePostalBanque varchar(12) COLLATE French_CI_AS NULL,
	ReplicableLDAP varchar(5) COLLATE French_CI_AS NULL,
	ReplicableExchange varchar(5) COLLATE French_CI_AS NULL,
	ReplicableWinBIZ varchar(5) COLLATE French_CI_AS NULL,
	DateValiditePermisSejour datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Contact____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ContactParBaseMutation ON OA_BEG.dbo.Contact____ (  FK_BaseMutation ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ContactParCleExterne ON OA_BEG.dbo.Contact____ (  CleExterne ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Contact_L4_ ON OA_BEG.dbo.Contact____ (  DateControle ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Contact_L5_ ON OA_BEG.dbo.Contact____ (  Nom ASC  , Prenom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.DWH_Connexion definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_Connexion;

CREATE TABLE OA_BEG.dbo.DWH_Connexion (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Serveur varchar(255) COLLATE French_CI_AS NULL,
	SchemaTable varchar(255) COLLATE French_CI_AS NULL,
	BaseDonnees varchar(255) COLLATE French_CI_AS NULL,
	Utilisateur varchar(255) COLLATE French_CI_AS NULL,
	MotDePasse varchar(255) COLLATE French_CI_AS NULL,
	Extension text COLLATE French_CI_AS NULL,
	ConnectionString text COLLATE French_CI_AS NULL,
	CD_DwhProvider varchar(10) COLLATE French_CI_AS NULL,
	Provider varchar(255) COLLATE French_CI_AS NULL,
	CD_DwhTableVue varchar(10) COLLATE French_CI_AS NULL,
	ChaineRemplacement text COLLATE French_CI_AS NULL,
	HasMotDePasseExecution varchar(5) COLLATE French_CI_AS NULL,
	Divers text COLLATE French_CI_AS NULL,
	ParamSchemaIni text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_Connexion PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_Dossier definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_Dossier;

CREATE TABLE OA_BEG.dbo.DWH_Dossier (
	Id decimal(10,0) NOT NULL,
	FK_DwhDossierParent decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	[Sequence] decimal(5,0) NULL,
	DroitGroupe varchar(5) COLLATE French_CI_AS NULL,
	NotExpanded varchar(5) COLLATE French_CI_AS NULL,
	NodeBold varchar(5) COLLATE French_CI_AS NULL,
	NodeUnderline varchar(5) COLLATE French_CI_AS NULL,
	NodeItalic varchar(5) COLLATE French_CI_AS NULL,
	CD_DwhNodeImage varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_Dossier PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX DWH_Dossier_L1 ON OA_BEG.dbo.DWH_Dossier (  FK_DwhDossierParent ASC  , Sequence ASC  , Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.DWH_Extraction definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_Extraction;

CREATE TABLE OA_BEG.dbo.DWH_Extraction (
	Id decimal(10,0) NOT NULL,
	FK_DwhConnexion decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	SqlQuery text COLLATE French_CI_AS NULL,
	FK_UtilisateurCreation decimal(10,0) NULL,
	Description text COLLATE French_CI_AS NULL,
	StoredProcedure varchar(255) COLLATE French_CI_AS NULL,
	CD_DwhExtractionType varchar(10) COLLATE French_CI_AS NULL,
	Script text COLLATE French_CI_AS NULL,
	ScriptTexte text COLLATE French_CI_AS NULL,
	ScriptInactif varchar(5) COLLATE French_CI_AS NULL,
	UseProviderSystemBase varchar(5) COLLATE French_CI_AS NULL,
	CD_DwhProviderYears varchar(10) COLLATE French_CI_AS NULL,
	CodeExtraction varchar(150) COLLATE French_CI_AS NULL,
	ParametresValeursDefaut varchar(5) COLLATE French_CI_AS NULL,
	CD_DwhEncryption varchar(10) COLLATE French_CI_AS NULL,
	SharedDataSourceKey varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	Remarques text COLLATE French_CI_AS NULL,
	CONSTRAINT PrimaryKey_DWH_Extraction PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_ExtractionColonne definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_ExtractionColonne;

CREATE TABLE OA_BEG.dbo.DWH_ExtractionColonne (
	Id decimal(10,0) NOT NULL,
	FK_DwhExtraction decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Libelle varchar(255) COLLATE French_CI_AS NULL,
	DataType varchar(255) COLLATE French_CI_AS NULL,
	FormatString varchar(255) COLLATE French_CI_AS NULL,
	CalculTotal varchar(5) COLLATE French_CI_AS NULL,
	[Sequence] decimal(5,0) NULL,
	CD_DwhColAlignment varchar(10) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Hidden varchar(5) COLLATE French_CI_AS NULL,
	Invisible varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_ExtractionColonne PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_ExtractionParametre definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_ExtractionParametre;

CREATE TABLE OA_BEG.dbo.DWH_ExtractionParametre (
	Id decimal(10,0) NOT NULL,
	FK_DwhExtraction decimal(10,0) NULL,
	CD_DwhTypeExtractionParametre varchar(10) COLLATE French_CI_AS NULL,
	[Sequence] decimal(9,0) NULL,
	FK_DwhGroupeExtractionParametre decimal(10,0) NULL,
	NbDecimales decimal(2,0) NULL,
	NegatifPossible varchar(5) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Variable varchar(255) COLLATE French_CI_AS NULL,
	ValeurString varchar(255) COLLATE French_CI_AS NULL,
	ValeurDate datetime NULL,
	ValeurDecimal decimal(15,5) NULL,
	ValeurBoolean varchar(5) COLLATE French_CI_AS NULL,
	FormatDate varchar(255) COLLATE French_CI_AS NULL,
	Invisible varchar(5) COLLATE French_CI_AS NULL,
	FK_ListeValeurCategorie decimal(10,0) NULL,
	FK_ListeValeurElement decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_ExtractionParametre PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_LienDroitDossierGroupe definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_LienDroitDossierGroupe;

CREATE TABLE OA_BEG.dbo.DWH_LienDroitDossierGroupe (
	Id decimal(10,0) NOT NULL,
	FK_DwhDossier decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_LienDroitDossierGroupe PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_LienDroitVueGroupe definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_LienDroitVueGroupe;

CREATE TABLE OA_BEG.dbo.DWH_LienDroitVueGroupe (
	Id decimal(10,0) NOT NULL,
	FK_DwhVue decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_LienDroitVueGroupe PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_LienExtractionConnexionSupplementaire definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_LienExtractionConnexionSupplementaire;

CREATE TABLE OA_BEG.dbo.DWH_LienExtractionConnexionSupplementaire (
	Id decimal(10,0) NOT NULL,
	FK_DwhExtraction decimal(10,0) NULL,
	FK_DwhConnexion decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_LienExtractionConnexionSupplementaire PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_LienExtractionExtraction definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_LienExtractionExtraction;

CREATE TABLE OA_BEG.dbo.DWH_LienExtractionExtraction (
	Id decimal(10,0) NOT NULL,
	FK_DwhExtractionBase decimal(10,0) NULL,
	FK_DwhExtractionLiee decimal(10,0) NULL,
	NomTable varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_LienExtractionExtraction PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_ProcedureStockeeParametre definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_ProcedureStockeeParametre;

CREATE TABLE OA_BEG.dbo.DWH_ProcedureStockeeParametre (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	FK_DwhExtraction decimal(10,0) NULL,
	CD_DwhTypeProcedureStockeeParametre varchar(10) COLLATE French_CI_AS NULL,
	Taille decimal(3,0) NULL,
	CD_DwhDirectionProcedureStockeeParametre varchar(10) COLLATE French_CI_AS NULL,
	Parametre varchar(255) COLLATE French_CI_AS NULL,
	ValeurString varchar(255) COLLATE French_CI_AS NULL,
	ValeurDate datetime NULL,
	ValeurDecimal decimal(15,5) NULL,
	ValeurBoolean varchar(5) COLLATE French_CI_AS NULL,
	NbDecimales decimal(1,0) NULL,
	FK_DwhExtractionParametre decimal(10,0) NULL,
	[Sequence] decimal(9,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_ProcedureStockeeParametre PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_Script_ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_Script_;

CREATE TABLE OA_BEG.dbo.DWH_Script_ (
	Id decimal(10,0) NOT NULL,
	CD_DwhScriptType varchar(10) COLLATE French_CI_AS NULL,
	Script text COLLATE French_CI_AS NULL,
	ScriptText text COLLATE French_CI_AS NULL,
	CD_DwhEncryption varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_Script_ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DWH_Vue____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DWH_Vue____;

CREATE TABLE OA_BEG.dbo.DWH_Vue____ (
	Id decimal(10,0) NOT NULL,
	FK_DwhDossier decimal(10,0) NULL,
	FK_DwhExtraction decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Titre varchar(255) COLLATE French_CI_AS NULL,
	TitreOnglet varchar(255) COLLATE French_CI_AS NULL,
	[Sequence] decimal(5,0) NULL,
	CD_DwhTypeAffichage varchar(10) COLLATE French_CI_AS NULL,
	NotVisible varchar(5) COLLATE French_CI_AS NULL,
	DroitGroupe varchar(5) COLLATE French_CI_AS NULL,
	NodeBold varchar(5) COLLATE French_CI_AS NULL,
	NodeUnderline varchar(5) COLLATE French_CI_AS NULL,
	NodeItalic varchar(5) COLLATE French_CI_AS NULL,
	CD_DwhNodeImage varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DWH_Vue____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX DWH_Vue_L1_ ON OA_BEG.dbo.DWH_Vue____ (  FK_DwhDossier ASC  , Sequence ASC  , Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Departement definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Departement;

CREATE TABLE OA_BEG.dbo.Departement (
	Id decimal(10,0) NOT NULL,
	Nom varchar(250) COLLATE French_CI_AS NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Departement PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DocumentComptable definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DocumentComptable;

CREATE TABLE OA_BEG.dbo.DocumentComptable (
	Id decimal(10,0) NOT NULL,
	NumeroDocument decimal(10,0) NULL,
	DateDocument datetime NULL,
	NotreReference text COLLATE French_CI_AS NULL,
	VotreReference text COLLATE French_CI_AS NULL,
	MontantTotal decimal(15,2) NULL,
	FK_Compte decimal(10,0) NULL,
	FK_Contact decimal(10,0) NULL,
	CD_TypeDocumentComptable varchar(10) COLLATE French_CI_AS NULL,
	CD_StatutDocumentComptable varchar(10) COLLATE French_CI_AS NULL,
	LectureSeule varchar(10) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	DiversAlpha1 varchar(255) COLLATE French_CI_AS NULL,
	DiversAlpha2 varchar(255) COLLATE French_CI_AS NULL,
	DiversAlpha3 varchar(255) COLLATE French_CI_AS NULL,
	DiversAlpha4 varchar(255) COLLATE French_CI_AS NULL,
	DiversAlpha5 varchar(255) COLLATE French_CI_AS NULL,
	DiversNum1 decimal(12,2) NULL,
	DiversNum2 decimal(12,2) NULL,
	DiversNum3 decimal(12,2) NULL,
	DiversNum4 decimal(12,2) NULL,
	DiversNum5 decimal(12,2) NULL,
	DiversDateTime1 datetime NULL,
	DiversDateTime2 datetime NULL,
	DiversDateTime3 datetime NULL,
	DiversDateTime4 datetime NULL,
	DiversDateTime5 datetime NULL,
	AcquittementBenevole varchar(5) COLLATE French_CI_AS NULL,
	TypeAcquittementBenevole varchar(255) COLLATE French_CI_AS NULL,
	Remarques text COLLATE French_CI_AS NULL,
	IdentifiantExterne varchar(255) COLLATE French_CI_AS NULL,
	PourcentageRemise decimal(7,3) NULL,
	PourcentageRemise2 decimal(7,3) NULL,
	FK_Mandat decimal(10,0) NULL,
	DossierData varchar(255) COLLATE French_CI_AS NULL,
	DossierFichierDestination varchar(255) COLLATE French_CI_AS NULL,
	ExtensionFichier varchar(255) COLLATE French_CI_AS NULL,
	IsAdresseMaster varchar(5) COLLATE French_CI_AS NULL,
	IsArticleMaster varchar(5) COLLATE French_CI_AS NULL,
	[Source] varchar(255) COLLATE French_CI_AS NULL,
	ContactDestinataire varchar(5) COLLATE French_CI_AS NULL,
	CodeAdresse varchar(255) COLLATE French_CI_AS NULL,
	CodePresentationFacture varchar(40) COLLATE French_CI_AS NULL,
	CodeConditionPaiement varchar(40) COLLATE French_CI_AS NULL,
	CD_RelationBancaire varchar(10) COLLATE French_CI_AS NULL,
	NumeroCompte varchar(255) COLLATE French_CI_AS NULL,
	NumeroClearing varchar(10) COLLATE French_CI_AS NULL,
	JourEcheance1 decimal(4,0) NULL,
	NoCompteCollectif varchar(12) COLLATE French_CI_AS NULL,
	GroupeAdresse varchar(10) COLLATE French_CI_AS NULL,
	CategorieDocument varchar(40) COLLATE French_CI_AS NULL,
	Communication1 varchar(28) COLLATE French_CI_AS NULL,
	Communication2 varchar(28) COLLATE French_CI_AS NULL,
	Communication3 varchar(28) COLLATE French_CI_AS NULL,
	Communication4 varchar(28) COLLATE French_CI_AS NULL,
	SoumisRappel varchar(5) COLLATE French_CI_AS NULL,
	CodeDocumentComptable varchar(25) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DocumentComptable PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX DocumentComptableParCleExterne ON OA_BEG.dbo.DocumentComptable (  CleExterne ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX DocumentComptableParDiversNum2 ON OA_BEG.dbo.DocumentComptable (  DiversNum2 ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Document___ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Document___;

CREATE TABLE OA_BEG.dbo.Document___ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(250) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	DateHeureCreation datetime NULL,
	FK_UtilisateurCreation decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Document___ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.DonneeVersion definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.DonneeVersion;

CREATE TABLE OA_BEG.dbo.DonneeVersion (
	Id decimal(10,0) NOT NULL,
	MotCle varchar(100) COLLATE French_CI_AS NULL,
	DateHeureFichier decimal(14,0) NULL,
	TailleFichier decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_DonneeVersion PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Ensemble___ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Ensemble___;

CREATE TABLE OA_BEG.dbo.Ensemble___ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(250) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Ensemble___ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.FacturationMedidata definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.FacturationMedidata;

CREATE TABLE OA_BEG.dbo.FacturationMedidata (
	Id decimal(10,0) NOT NULL,
	FK_DocumentComptable decimal(10,0) NULL,
	FK_Contact decimal(10,0) NULL,
	DateDecision datetime NULL,
	NumeroDecision varchar(255) COLLATE French_CI_AS NULL,
	NumeroAssure varchar(255) COLLATE French_CI_AS NULL,
	Loi varchar(255) COLLATE French_CI_AS NULL,
	Traitement varchar(255) COLLATE French_CI_AS NULL,
	TypeTraitement varchar(255) COLLATE French_CI_AS NULL,
	MotifTraitement varchar(255) COLLATE French_CI_AS NULL,
	NomEntreprise varchar(255) COLLATE French_CI_AS NULL,
	RoleLocalite varchar(255) COLLATE French_CI_AS NULL,
	PositionTarifaire varchar(50) COLLATE French_CI_AS NULL,
	DateDebutTraitement datetime NULL,
	DateFinTraitement datetime NULL,
	DatePremierePrestation datetime NULL,
	DateDernierePrestation datetime NULL,
	DonneesBrutesEnvoyees text COLLATE French_CI_AS NULL,
	DernierUploadSucces varchar(5) COLLATE French_CI_AS NULL,
	DernierUploadCodeRetour decimal(4,0) NULL,
	DernierUploadMessage text COLLATE French_CI_AS NULL,
	DernierUploadDateHeure datetime NULL,
	TransmissionReference varchar(50) COLLATE French_CI_AS NULL,
	CD_TransmissionStatut varchar(10) COLLATE French_CI_AS NULL,
	MedidataDateCreation datetime NULL,
	MedidataDateModification datetime NULL,
	Log text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_FacturationMedidata PRIMARY KEY (Id)
);


-- OA_BEG.dbo.FactureLayout definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.FactureLayout;

CREATE TABLE OA_BEG.dbo.FactureLayout (
	Id decimal(10,0) NOT NULL,
	Layout image NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_FactureLayout PRIMARY KEY (Id)
);


-- OA_BEG.dbo.FactureRecapInfoLigne definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.FactureRecapInfoLigne;

CREATE TABLE OA_BEG.dbo.FactureRecapInfoLigne (
	Id decimal(10,0) NOT NULL,
	FK_Facture decimal(10,0) NULL,
	CleLigne varchar(255) COLLATE French_CI_AS NULL,
	NePasImprimerDetail varchar(5) COLLATE French_CI_AS NULL,
	Texte text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_FactureRecapInfoLigne PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Facture____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Facture____;

CREATE TABLE OA_BEG.dbo.Facture____ (
	Id decimal(10,0) NOT NULL,
	FK_Mandat decimal(10,0) NULL,
	FK_Compte decimal(10,0) NULL,
	FK_Contact decimal(10,0) NULL,
	FK_FactureLayout decimal(10,0) NULL,
	DateFacture datetime NULL,
	Reference varchar(100) COLLATE French_CI_AS NULL,
	DateDu datetime NULL,
	DateAu datetime NULL,
	Montant decimal(12,2) NULL,
	Frais decimal(12,2) NULL,
	Total decimal(12,2) NULL,
	CD_EtatFacture varchar(10) COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	GenererDocument varchar(5) COLLATE French_CI_AS NULL,
	FK_ModeleDocumentCommercial decimal(10,0) NULL,
	NoDocumentComptable decimal(10,0) NULL,
	CD_TypeDocumentComptable varchar(10) COLLATE French_CI_AS NULL,
	Mouvement decimal(12,2) NULL,
	Remarques text COLLATE French_CI_AS NULL,
	Adresse text COLLATE French_CI_AS NULL,
	Texte text COLLATE French_CI_AS NULL,
	FK_ModeleRecapitulatif decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Facture____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Favoris____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Favoris____;

CREATE TABLE OA_BEG.dbo.Favoris____ (
	Id decimal(10,0) NOT NULL,
	FK_Utilisateur decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	[Sequence] decimal(3,0) NULL,
	NomFonction varchar(255) COLLATE French_CI_AS NULL,
	NomGroupe varchar(255) COLLATE French_CI_AS NULL,
	CD_UtilisateurAffichage varchar(10) COLLATE French_CI_AS NULL,
	NomAffichage varchar(255) COLLATE French_CI_AS NULL,
	IdPresentation decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Favoris____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Favoris_L1_ ON OA_BEG.dbo.Favoris____ (  FK_Utilisateur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Favoris_L2_ ON OA_BEG.dbo.Favoris____ (  FK_Utilisateur ASC  , Sequence ASC  , Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Fichier____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Fichier____;

CREATE TABLE OA_BEG.dbo.Fichier____ (
	Id decimal(10,0) NOT NULL,
	Extention varchar(25) COLLATE French_CI_AS NULL,
	NomOrigine varchar(250) COLLATE French_CI_AS NULL,
	CheminOrigine text COLLATE French_CI_AS NULL,
	NomInterne varchar(250) COLLATE French_CI_AS NULL,
	FK_Document decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Fichier____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Fonction___ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Fonction___;

CREATE TABLE OA_BEG.dbo.Fonction___ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	Appellation varchar(100) COLLATE French_CI_AS NULL,
	[Sequence] decimal(9,0) NULL,
	[Type] varchar(10) COLLATE French_CI_AS NULL,
	FK_Fonction decimal(10,0) NULL,
	Interne varchar(10) COLLATE French_CI_AS NULL,
	CD_CodeMenuFonction varchar(10) COLLATE French_CI_AS NULL,
	IndexImageSmall decimal(5,0) NULL,
	IsDevOnly varchar(5) COLLATE French_CI_AS NULL,
	Inverse varchar(5) COLLATE French_CI_AS NULL,
	DesactiveParDefaut varchar(5) COLLATE French_CI_AS NULL,
	SelectionUtilisateur varchar(5) COLLATE French_CI_AS NULL,
	Presentation varchar(150) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Fonction___ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Frais______ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Frais______;

CREATE TABLE OA_BEG.dbo.Frais______ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(50) COLLATE French_CI_AS NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Descr varchar(200) COLLATE French_CI_AS NULL,
	CD_TypeFrais varchar(10) COLLATE French_CI_AS NULL,
	Montant decimal(7,2) NULL,
	Unite varchar(50) COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	QuantiteDefaut decimal(7,2) NULL,
	FK_Article decimal(10,0) NULL,
	FK_TypeTaxe decimal(10,0) NULL,
	CD_ModeFrais varchar(10) COLLATE French_CI_AS NULL,
	MontantFacturation decimal(7,2) NULL,
	UtiliserMontantFacturation varchar(5) COLLATE French_CI_AS NULL,
	FK_SalaireRubrique decimal(10,0) NULL,
	Libelle varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Frais______ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.GroupeAdresse definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.GroupeAdresse;

CREATE TABLE OA_BEG.dbo.GroupeAdresse (
	Id decimal(10,0) NOT NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	CD_GenreAdresse varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_GroupeAdresse PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Groupe_____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Groupe_____;

CREATE TABLE OA_BEG.dbo.Groupe_____ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	Special varchar(10) COLLATE French_CI_AS NULL,
	Interne varchar(10) COLLATE French_CI_AS NULL,
	Securite varchar(10) COLLATE French_CI_AS NULL,
	ActiveDirectoryGuid varchar(255) COLLATE French_CI_AS NULL,
	ActiveDirectoryTexte varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Groupe_____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Groupe_L1__ ON OA_BEG.dbo.Groupe_____ (  Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.HistoriqueAlerteDetail definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.HistoriqueAlerteDetail;

CREATE TABLE OA_BEG.dbo.HistoriqueAlerteDetail (
	Id decimal(10,0) NOT NULL,
	FK_HistoriqueAlerteEntete decimal(10,0) NULL,
	CD_TypeDestination varchar(10) COLLATE French_CI_AS NULL,
	Destination varchar(100) COLLATE French_CI_AS NULL,
	MsgID varchar(50) COLLATE French_CI_AS NULL,
	ProviderErreurCode varchar(20) COLLATE French_CI_AS NULL,
	ProviderErreurDescription text COLLATE French_CI_AS NULL,
	ProviderStatut varchar(255) COLLATE French_CI_AS NULL,
	CD_StatutHistoriqueAlertDetail varchar(10) COLLATE French_CI_AS NULL,
	ObjetExterneId varchar(100) COLLATE French_CI_AS NULL,
	Destinataire varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_HistoriqueAlerteDetail PRIMARY KEY (Id)
);


-- OA_BEG.dbo.HistoriqueAlerteEntete definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.HistoriqueAlerteEntete;

CREATE TABLE OA_BEG.dbo.HistoriqueAlerteEntete (
	Id decimal(10,0) NOT NULL,
	DateHeureExecution datetime NULL,
	Objet varchar(255) COLLATE French_CI_AS NULL,
	Message text COLLATE French_CI_AS NULL,
	BatchID varchar(50) COLLATE French_CI_AS NULL,
	ProviderEnvoi text COLLATE French_CI_AS NULL,
	ProviderRetour text COLLATE French_CI_AS NULL,
	ProviderStatut varchar(255) COLLATE French_CI_AS NULL,
	CD_StatutHistoriqueAlerteEntete varchar(10) COLLATE French_CI_AS NULL,
	ObjetExterneType varchar(255) COLLATE French_CI_AS NULL,
	ObjetProprietaireType varchar(255) COLLATE French_CI_AS NULL,
	ObjetProprietaireId varchar(100) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_HistoriqueAlerteEntete PRIMARY KEY (Id)
);


-- OA_BEG.dbo.JourFerie__ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.JourFerie__;

CREATE TABLE OA_BEG.dbo.JourFerie__ (
	Id decimal(10,0) NOT NULL,
	DateJourFerie datetime NULL,
	Designation varchar(250) COLLATE French_CI_AS NULL,
	Couleur decimal(10,0) NULL,
	HeureVeilleDeFete decimal(10,2) NULL,
	Description text COLLATE French_CI_AS NULL,
	CD_JourFerieConcerne varchar(10) COLLATE French_CI_AS NULL,
	DeductionCompleteHeureVeilleFete varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_JourFerie__ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Licence____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Licence____;

CREATE TABLE OA_BEG.dbo.Licence____ (
	Id decimal(9,0) NOT NULL,
	NoLicence varchar(100) COLLATE French_CI_AS NULL,
	KeyExtention varchar(250) COLLATE French_CI_AS NULL,
	NoPersonnel varchar(100) COLLATE French_CI_AS NULL,
	NoActivation varchar(100) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Licence____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienActiviteFrais definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienActiviteFrais;

CREATE TABLE OA_BEG.dbo.LienActiviteFrais (
	Id decimal(10,0) NOT NULL,
	FK_Activite decimal(10,0) NULL,
	FK_Frais decimal(10,0) NULL,
	Quantite decimal(7,2) NULL,
	Montant decimal(15,6) NULL,
	Descr varchar(255) COLLATE French_CI_AS NULL,
	Taxe decimal(9,2) NULL,
	MontantUtilisateur decimal(15,6) NULL,
	MontantFacturation decimal(15,6) NULL,
	CD_ModeFrais varchar(10) COLLATE French_CI_AS NULL,
	Uid varchar(50) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienActiviteFrais PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienCompteContact definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienCompteContact;

CREATE TABLE OA_BEG.dbo.LienCompteContact (
	Id decimal(10,0) NOT NULL,
	FK_Compte decimal(10,0) NULL,
	FK_Contact decimal(10,0) NULL,
	CD_TypeContact varchar(10) COLLATE French_CI_AS NULL,
	FK_TypeRelation decimal(10,0) NULL,
	RelationInverse varchar(5) COLLATE French_CI_AS NULL,
	FK_Compte2 decimal(10,0) NULL,
	FK_Contact2 decimal(10,0) NULL,
	CD_SensRelation varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienCompteContact PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX LienCompteContactParCompte ON OA_BEG.dbo.LienCompteContact (  FK_Compte ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX LienCompteContactParContact ON OA_BEG.dbo.LienCompteContact (  FK_Contact ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.LienDocumentFichier definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienDocumentFichier;

CREATE TABLE OA_BEG.dbo.LienDocumentFichier (
	Id decimal(10,0) NOT NULL,
	FK_Document decimal(10,0) NULL,
	FK_Fichier decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienDocumentFichier PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienEnsembleGroupe definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienEnsembleGroupe;

CREATE TABLE OA_BEG.dbo.LienEnsembleGroupe (
	Id decimal(10,0) NOT NULL,
	FK_Ensemble decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienEnsembleGroupe PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienFactureRubrique definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienFactureRubrique;

CREATE TABLE OA_BEG.dbo.LienFactureRubrique (
	Id decimal(10,0) NOT NULL,
	FK_Facture decimal(10,0) NULL,
	FK_Rubrique decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienFactureRubrique PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienFactureTache definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienFactureTache;

CREATE TABLE OA_BEG.dbo.LienFactureTache (
	Id decimal(10,0) NOT NULL,
	FK_Facture decimal(10,0) NULL,
	FK_Tache decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienFactureTache PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienFactureUtilisateur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienFactureUtilisateur;

CREATE TABLE OA_BEG.dbo.LienFactureUtilisateur (
	Id decimal(10,0) NOT NULL,
	FK_Facture decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienFactureUtilisateur PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienGroupeAdresseCompteContact definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienGroupeAdresseCompteContact;

CREATE TABLE OA_BEG.dbo.LienGroupeAdresseCompteContact (
	Id decimal(10,0) NOT NULL,
	FK_GroupeAdresse decimal(10,0) NULL,
	FK_Compte decimal(10,0) NULL,
	FK_Contact decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienGroupeAdresseCompteContact PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienGroupeRapport definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienGroupeRapport;

CREATE TABLE OA_BEG.dbo.LienGroupeRapport (
	Id decimal(10,0) NOT NULL,
	FK_Rapport decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienGroupeRapport PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienGroupeTableauDeBord definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienGroupeTableauDeBord;

CREATE TABLE OA_BEG.dbo.LienGroupeTableauDeBord (
	Id decimal(10,0) NOT NULL,
	FK_TableauDeBord decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienGroupeTableauDeBord PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienGroupeUtilisateur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienGroupeUtilisateur;

CREATE TABLE OA_BEG.dbo.LienGroupeUtilisateur (
	Id decimal(10,0) NOT NULL,
	FK_Groupe decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienGroupeUtilisateur PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX LienGroupeUtilisateur_L1 ON OA_BEG.dbo.LienGroupeUtilisateur (  FK_Utilisateur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.LienJourFerieGroupe definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienJourFerieGroupe;

CREATE TABLE OA_BEG.dbo.LienJourFerieGroupe (
	Id decimal(10,0) NOT NULL,
	FK_JourFerie decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienJourFerieGroupe PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienObjetDocument definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienObjetDocument;

CREATE TABLE OA_BEG.dbo.LienObjetDocument (
	Id decimal(10,0) NOT NULL,
	FK_Document decimal(10,0) NULL,
	IdObjet decimal(10,0) NULL,
	NomObjet varchar(250) COLLATE French_CI_AS NULL,
	NomAssembly varchar(250) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienObjetDocument PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienPagePersoElementGroupe definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienPagePersoElementGroupe;

CREATE TABLE OA_BEG.dbo.LienPagePersoElementGroupe (
	Id decimal(10,0) NOT NULL,
	FK_PagePersoElement decimal(10,0) NULL,
	FK_Groupe decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienPagePersoElementGroupe PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienPlanningActiviteParametrePlanning definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienPlanningActiviteParametrePlanning;

CREATE TABLE OA_BEG.dbo.LienPlanningActiviteParametrePlanning (
	Id decimal(10,0) NOT NULL,
	FK_PlanningActiviteParametre decimal(10,0) NULL,
	FK_PlanningActivite decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienPlanningActiviteParametrePlanning PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienPlanningActiviteParametreUtilisateur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienPlanningActiviteParametreUtilisateur;

CREATE TABLE OA_BEG.dbo.LienPlanningActiviteParametreUtilisateur (
	Id decimal(10,0) NOT NULL,
	FK_PlanningActiviteParametre decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	[Sequence] decimal(3,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienPlanningActiviteParametreUtilisateur PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienPlanningTypeActivitePlanifiee definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienPlanningTypeActivitePlanifiee;

CREATE TABLE OA_BEG.dbo.LienPlanningTypeActivitePlanifiee (
	Id decimal(10,0) NOT NULL,
	FK_PlanningActivite decimal(10,0) NULL,
	FK_TypeActivitePlanifiee decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienPlanningTypeActivitePlanifiee PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienMandatFrais definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienMandatFrais;

CREATE TABLE OA_BEG.dbo.LienMandatFrais (
	Id decimal(10,0) NOT NULL,
	FK_Mandat decimal(10,0) NULL,
	FK_Frais decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienMandatFrais PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienMandatTache definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienMandatTache;

CREATE TABLE OA_BEG.dbo.LienMandatTache (
	Id decimal(10,0) NOT NULL,
	FK_Mandat decimal(10,0) NULL,
	FK_Tache decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienMandatTache PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ParMandat ON OA_BEG.dbo.LienMandatTache (  FK_Mandat ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ParTache ON OA_BEG.dbo.LienMandatTache (  FK_Tache ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.LienMandatUtilisateur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienMandatUtilisateur;

CREATE TABLE OA_BEG.dbo.LienMandatUtilisateur (
	Id decimal(10,0) NOT NULL,
	FK_Utilisateur decimal(10,0) NULL,
	FK_Mandat decimal(10,0) NULL,
	Resp varchar(10) COLLATE French_CI_AS NULL,
	Tarif decimal(12,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienMandatUtilisateur PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienRapportDataSource definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienRapportDataSource;

CREATE TABLE OA_BEG.dbo.LienRapportDataSource (
	Id decimal(10,0) NOT NULL,
	FK_Rapport decimal(10,0) NULL,
	DataSourceName varchar(255) COLLATE French_CI_AS NULL,
	DataSourceAssembly varchar(255) COLLATE French_CI_AS NULL,
	DataSourceIdentifier varchar(255) COLLATE French_CI_AS NULL,
	IsDataSourceParameter varchar(5) COLLATE French_CI_AS NULL,
	HasParamPrefixSource varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienRapportDataSource PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienRapportDataSourceRelation definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienRapportDataSourceRelation;

CREATE TABLE OA_BEG.dbo.LienRapportDataSourceRelation (
	Id decimal(10,0) NOT NULL,
	FK_LienRapportDataSource decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienRapportDataSourceRelation PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienRapportDataSourceRelationColonne definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienRapportDataSourceRelationColonne;

CREATE TABLE OA_BEG.dbo.LienRapportDataSourceRelationColonne (
	Id decimal(10,0) NOT NULL,
	FK_LienRapportDataSourceRelation decimal(10,0) NULL,
	NomColonneParent varchar(255) COLLATE French_CI_AS NULL,
	NomTableEnfant varchar(255) COLLATE French_CI_AS NULL,
	NomColonneEnfant varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienRapportDataSourceRelationColonne PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienRubriqueTache definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienRubriqueTache;

CREATE TABLE OA_BEG.dbo.LienRubriqueTache (
	Id decimal(10,0) NOT NULL,
	FK_Rubrique decimal(10,0) NULL,
	FK_Tache decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienRubriqueTache PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienTableauDeBordDataSource definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienTableauDeBordDataSource;

CREATE TABLE OA_BEG.dbo.LienTableauDeBordDataSource (
	Id decimal(10,0) NOT NULL,
	FK_TableauDeBord decimal(10,0) NULL,
	DataSourceName varchar(255) COLLATE French_CI_AS NULL,
	DataSourceAssembly varchar(255) COLLATE French_CI_AS NULL,
	DataSourceIdentifier varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienTableauDeBordDataSource PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienTachePlanfieeCategorieTachePlanifiee definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienTachePlanfieeCategorieTachePlanifiee;

CREATE TABLE OA_BEG.dbo.LienTachePlanfieeCategorieTachePlanifiee (
	Id decimal(10,0) NOT NULL,
	FK_TachePlanifiee decimal(10,0) NULL,
	FK_CategorieTachePlanifiee decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienTachePlanfieeCategorieTachePlanifiee PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienTacheUtilisateur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienTacheUtilisateur;

CREATE TABLE OA_BEG.dbo.LienTacheUtilisateur (
	Id decimal(10,0) NOT NULL,
	FK_Tache decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	Tarif decimal(10,2) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienTacheUtilisateur PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LienUtilisateurCompetence definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienUtilisateurCompetence;

CREATE TABLE OA_BEG.dbo.LienUtilisateurCompetence (
	Id decimal(10,0) NOT NULL,
	FK_Utilisateur decimal(10,0) NULL,
	FK_Competence decimal(10,0) NULL,
	Piquet varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienUtilisateurCompetence PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX LienUtilisateurCompetence_L1 ON OA_BEG.dbo.LienUtilisateurCompetence (  FK_Utilisateur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.LienUtilisateurTacheParTarif definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LienUtilisateurTacheParTarif;

CREATE TABLE OA_BEG.dbo.LienUtilisateurTacheParTarif (
	Id decimal(10,0) NOT NULL,
	FK_Tarif decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	FK_Tache decimal(10,0) NULL,
	Montant decimal(10,2) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LienUtilisateurTacheParTarif PRIMARY KEY (Id)
);


-- OA_BEG.dbo.LigneDocumentComptable definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.LigneDocumentComptable;

CREATE TABLE OA_BEG.dbo.LigneDocumentComptable (
	Id decimal(10,0) NOT NULL,
	FK_DocumentComptable decimal(10,0) NULL,
	CD_TypeLigneDocumentComptable varchar(10) COLLATE French_CI_AS NULL,
	DateLigneDocument datetime NULL,
	FK_Article decimal(10,0) NULL,
	Description text COLLATE French_CI_AS NULL,
	Quantite decimal(12,4) NULL,
	Prix decimal(16,4) NULL,
	PourcentageRemise decimal(7,3) NULL,
	MontantRemise decimal(10,2) NULL,
	TauxTva decimal(5,2) NULL,
	TvaIncluse decimal(1,0) NULL,
	Montant decimal(14,4) NULL,
	Unite varchar(15) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	DiversAlpha1 varchar(50) COLLATE French_CI_AS NULL,
	DiversAlpha2 varchar(50) COLLATE French_CI_AS NULL,
	DiversAlpha3 varchar(50) COLLATE French_CI_AS NULL,
	DiversAlpha4 varchar(50) COLLATE French_CI_AS NULL,
	DiversAlpha5 varchar(50) COLLATE French_CI_AS NULL,
	DiversNum1 decimal(12,2) NULL,
	DiversNum2 decimal(12,2) NULL,
	DiversNum3 decimal(12,2) NULL,
	DiversNum4 decimal(12,2) NULL,
	DiversNum5 decimal(12,2) NULL,
	DiversDateTime1 datetime NULL,
	DiversDateTime2 datetime NULL,
	DiversDateTime3 datetime NULL,
	DiversDateTime4 datetime NULL,
	DiversDateTime5 datetime NULL,
	NoLigne decimal(10,0) NULL,
	Remarques text COLLATE French_CI_AS NULL,
	PrixAuto varchar(5) COLLATE French_CI_AS NULL,
	PourcentageRemise2 decimal(7,3) NULL,
	MontantRemise2 decimal(10,2) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_LigneDocumentComptable PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX LigneDocumentComptableParCleExterne ON OA_BEG.dbo.LigneDocumentComptable (  CleExterne ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX LigneDocumentComptableParDocumentComptable ON OA_BEG.dbo.LigneDocumentComptable (  FK_DocumentComptable ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.ListeValeurCategorie definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ListeValeurCategorie;

CREATE TABLE OA_BEG.dbo.ListeValeurCategorie (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ListeValeurCategorie PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ListeValeurElement definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ListeValeurElement;

CREATE TABLE OA_BEG.dbo.ListeValeurElement (
	Id decimal(10,0) NOT NULL,
	FK_ListeValeurCategorie decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Code varchar(10) COLLATE French_CI_AS NULL,
	[Sequence] decimal(5,0) NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ListeValeurElement PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Log________ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Log________;

CREATE TABLE OA_BEG.dbo.Log________ (
	Id decimal(10,0) NOT NULL,
	[Source] varchar(100) COLLATE French_CI_AS NULL,
	CD_LogGravite varchar(10) COLLATE French_CI_AS NULL,
	DateHeure datetime NULL,
	CodeMessage varchar(100) COLLATE French_CI_AS NULL,
	Message text COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	IsChecked varchar(5) COLLATE French_CI_AS NULL,
	Detail text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Log________ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Message____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Message____;

CREATE TABLE OA_BEG.dbo.Message____ (
	Id decimal(10,0) NOT NULL,
	NomModele varchar(255) COLLATE French_CI_AS NULL,
	EstModele varchar(5) COLLATE French_CI_AS NULL,
	Destinataire text COLLATE French_CI_AS NULL,
	DestinataireCopie text COLLATE French_CI_AS NULL,
	Objet varchar(255) COLLATE French_CI_AS NULL,
	Texte text COLLATE French_CI_AS NULL,
	NomFichier varchar(255) COLLATE French_CI_AS NULL,
	TypeFichier varchar(20) COLLATE French_CI_AS NULL,
	FK_Utilisateur decimal(10,0) NULL,
	ParentName varchar(100) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Message____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ModeleDescriptionActivite definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ModeleDescriptionActivite;

CREATE TABLE OA_BEG.dbo.ModeleDescriptionActivite (
	Id decimal(10,0) NOT NULL,
	FK_Tache decimal(10,0) NULL,
	Code varchar(10) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ModeleDescriptionActivite PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ModeleDocumentCommercial definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ModeleDocumentCommercial;

CREATE TABLE OA_BEG.dbo.ModeleDocumentCommercial (
	Id decimal(10,0) NOT NULL,
	InclurePrestation varchar(5) COLLATE French_CI_AS NULL,
	InclureFrais varchar(5) COLLATE French_CI_AS NULL,
	MontantZero varchar(5) COLLATE French_CI_AS NULL,
	CD_GroupagePrestation varchar(10) COLLATE French_CI_AS NULL,
	CD_GroupageFrais varchar(10) COLLATE French_CI_AS NULL,
	CD_TypeDocumentCommercial varchar(10) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Designation text COLLATE French_CI_AS NULL,
	FK_Article decimal(10,0) NULL,
	CD_ContenuDocumentCommercial varchar(10) COLLATE French_CI_AS NULL,
	Unite varchar(255) COLLATE French_CI_AS NULL,
	CacherNomDossier varchar(5) COLLATE French_CI_AS NULL,
	TitrePrestation varchar(50) COLLATE French_CI_AS NULL,
	TitreFrais varchar(50) COLLATE French_CI_AS NULL,
	TitreMouvement varchar(50) COLLATE French_CI_AS NULL,
	InclureMouvement varchar(5) COLLATE French_CI_AS NULL,
	CodeDocumentComptable varchar(25) COLLATE French_CI_AS NULL,
	GlnSource varchar(20) COLLATE French_CI_AS NULL,
	GlnDestination varchar(20) COLLATE French_CI_AS NULL,
	Societe varchar(255) COLLATE French_CI_AS NULL,
	Adresse varchar(255) COLLATE French_CI_AS NULL,
	NPA varchar(10) COLLATE French_CI_AS NULL,
	Localite varchar(255) COLLATE French_CI_AS NULL,
	NoTelephone varchar(50) COLLATE French_CI_AS NULL,
	Mail varchar(255) COLLATE French_CI_AS NULL,
	NoZsr varchar(20) COLLATE French_CI_AS NULL,
	NoNif varchar(20) COLLATE French_CI_AS NULL,
	BanqueNom varchar(255) COLLATE French_CI_AS NULL,
	BanqueAdresse varchar(255) COLLATE French_CI_AS NULL,
	BanqueNpa varchar(10) COLLATE French_CI_AS NULL,
	BanqueLocalite varchar(255) COLLATE French_CI_AS NULL,
	BanqueNoAdherentBvr varchar(255) COLLATE French_CI_AS NULL,
	Script1 text COLLATE French_CI_AS NULL,
	Script2 text COLLATE French_CI_AS NULL,
	ScriptInfo text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	Script3 text COLLATE French_CI_AS NULL,
	BanqueIBAN varchar(100) COLLATE French_CI_AS NULL,
	Script4 text COLLATE French_CI_AS NULL,
	CONSTRAINT PrimaryKey_ModeleDocumentCommercial PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ModeleRapportActivite definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ModeleRapportActivite;

CREATE TABLE OA_BEG.dbo.ModeleRapportActivite (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Contenu text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ModeleRapportActivite PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ModeleRecapitulatif definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ModeleRecapitulatif;

CREATE TABLE OA_BEG.dbo.ModeleRecapitulatif (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	CD_ModeleRecapitulatifRegroupement varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ModeleRecapitulatif PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ModeleTexteFacture definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ModeleTexteFacture;

CREATE TABLE OA_BEG.dbo.ModeleTexteFacture (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Contenu text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ModeleTexteFacture PRIMARY KEY (Id)
);


-- OA_BEG.dbo.MouvementFinancier definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.MouvementFinancier;

CREATE TABLE OA_BEG.dbo.MouvementFinancier (
	Id decimal(10,0) NOT NULL,
	FK_Mandat decimal(10,0) NULL,
	FK_Rubrique decimal(10,0) NULL,
	DateMouvement datetime NULL,
	FK_TypeMouvementFinancier decimal(10,0) NULL,
	Reference varchar(50) COLLATE French_CI_AS NULL,
	Libelle varchar(255) COLLATE French_CI_AS NULL,
	Montant decimal(12,2) NULL,
	FK_Facture decimal(10,0) NULL,
	Remarques text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_MouvementFinancier PRIMARY KEY (Id)
);


-- OA_BEG.dbo.NPA________ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.NPA________;

CREATE TABLE OA_BEG.dbo.NPA________ (
	Id decimal(12,0) NOT NULL,
	EnregistrementUtilisateur varchar(5) COLLATE French_CI_AS NULL,
	NPA varchar(10) COLLATE French_CI_AS NULL,
	Localite varchar(18) COLLATE French_CI_AS NULL,
	CodeCanton varchar(2) COLLATE French_CI_AS NULL,
	CodePays varchar(10) COLLATE French_CI_AS NULL,
	Canton varchar(255) COLLATE French_CI_AS NULL,
	District varchar(255) COLLATE French_CI_AS NULL,
	NoDistrict varchar(10) COLLATE French_CI_AS NULL,
	Commune varchar(255) COLLATE French_CI_AS NULL,
	NoCommune varchar(10) COLLATE French_CI_AS NULL,
	Latitude decimal(10,4) NULL,
	Longitude decimal(10,4) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_NPA________ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ObjetSuppression definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ObjetSuppression;

CREATE TABLE OA_BEG.dbo.ObjetSuppression (
	Id decimal(10,0) NOT NULL,
	NomObjet varchar(255) COLLATE French_CI_AS NULL,
	IdObjet decimal(10,0) NULL,
	XmlDataRowObjet text COLLATE French_CI_AS NULL,
	IdUtilisateurConcerne decimal(10,0) NULL,
	DateConcerne datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ObjetSuppression PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePersoElement definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePersoElement;

CREATE TABLE OA_BEG.dbo.PagePersoElement (
	Id decimal(10,0) NOT NULL,
	Titre varchar(255) COLLATE French_CI_AS NULL,
	SequenceAffichage decimal(5,0) NULL,
	ConfirmationLecture varchar(5) COLLATE French_CI_AS NULL,
	AffichageNouveau varchar(5) COLLATE French_CI_AS NULL,
	NbJourAffichageNouveau decimal(5,0) NULL,
	NbElementAffichagePremier decimal(9,0) NULL,
	RepertoireFichier text COLLATE French_CI_AS NULL,
	FiltreFichier varchar(255) COLLATE French_CI_AS NULL,
	FK_PagePersoTypeElement decimal(10,0) NULL,
	FK_PagePerso decimal(10,0) NULL,
	DroitGroupe varchar(5) COLLATE French_CI_AS NULL,
	OuvertureRepertoire varchar(5) COLLATE French_CI_AS NULL,
	InclureSousRepertoire varchar(5) COLLATE French_CI_AS NULL,
	AffichageSousRepertoire varchar(5) COLLATE French_CI_AS NULL,
	AffichageNotificationPlanningPresence varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePersoElement PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePersoElementControlFilesNew definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePersoElementControlFilesNew;

CREATE TABLE OA_BEG.dbo.PagePersoElementControlFilesNew (
	Id decimal(10,0) NOT NULL,
	FK_PagePersoElement decimal(10,0) NULL,
	Fichier text COLLATE French_CI_AS NULL,
	DateAffichage datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePersoElementControlFilesNew PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePersoElementControlFilesRead definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePersoElementControlFilesRead;

CREATE TABLE OA_BEG.dbo.PagePersoElementControlFilesRead (
	Id decimal(10,0) NOT NULL,
	FK_PagePersoElement decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	Fichier text COLLATE French_CI_AS NULL,
	DateHeureLecturePremier datetime NULL,
	DateHeureLectureDernier datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePersoElementControlFilesRead PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePersoElementControlLinksNew definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePersoElementControlLinksNew;

CREATE TABLE OA_BEG.dbo.PagePersoElementControlLinksNew (
	Id decimal(10,0) NOT NULL,
	FK_PagePersoElement decimal(10,0) NULL,
	Url text COLLATE French_CI_AS NULL,
	DateAffichage datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePersoElementControlLinksNew PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePersoElementControlLinksRead definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePersoElementControlLinksRead;

CREATE TABLE OA_BEG.dbo.PagePersoElementControlLinksRead (
	Id decimal(10,0) NOT NULL,
	FK_PagePersoElement decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Url text COLLATE French_CI_AS NULL,
	DateHeureLecturePremier datetime NULL,
	DateHeureLectureDernier datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePersoElementControlLinksRead PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePersoElementLien definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePersoElementLien;

CREATE TABLE OA_BEG.dbo.PagePersoElementLien (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Url text COLLATE French_CI_AS NULL,
	SequenceAffichage decimal(5,0) NULL,
	FK_PagePersoElement decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePersoElementLien PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePersoTypeElement definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePersoTypeElement;

CREATE TABLE OA_BEG.dbo.PagePersoTypeElement (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	CodeElement varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePersoTypeElement PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PagePerso__ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PagePerso__;

CREATE TABLE OA_BEG.dbo.PagePerso__ (
	Id decimal(10,0) NOT NULL,
	Titre varchar(255) COLLATE French_CI_AS NULL,
	NombreColonne decimal(3,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PagePerso__ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ParametreSynchroExchange definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ParametreSynchroExchange;

CREATE TABLE OA_BEG.dbo.ParametreSynchroExchange (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Utilisateur varchar(100) COLLATE French_CI_AS NULL,
	MotDePasse varchar(255) COLLATE French_CI_AS NULL,
	Dossier varchar(255) COLLATE French_CI_AS NULL,
	TousLesComptes varchar(5) COLLATE French_CI_AS NULL,
	TousLesContacts varchar(5) COLLATE French_CI_AS NULL,
	CD_TypeDossierExchange varchar(10) COLLATE French_CI_AS NULL,
	GestionAnniversaire varchar(5) COLLATE French_CI_AS NULL,
	UniquementSiTelephone varchar(5) COLLATE French_CI_AS NULL,
	UniquementSiMail varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ParametreSynchroExchange PRIMARY KEY (Id)
);


-- OA_BEG.dbo.ParametreSynchroExchangeLienGroupeAdresseDossier definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ParametreSynchroExchangeLienGroupeAdresseDossier;

CREATE TABLE OA_BEG.dbo.ParametreSynchroExchangeLienGroupeAdresseDossier (
	Id decimal(10,0) NOT NULL,
	FK_ParametreSynchroExchange decimal(10,0) NULL,
	FK_GroupeAdresse decimal(10,0) NULL,
	CD_TypeLienGroupeAdresseDossier varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ParametreSynchroExchangeLienGroupeAdresseDossier PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Parametre__ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Parametre__;

CREATE TABLE OA_BEG.dbo.Parametre__ (
	Id decimal(10,0) NOT NULL,
	Cle varchar(30) COLLATE French_CI_AS NULL,
	Valeur varchar(250) COLLATE French_CI_AS NULL,
	Description varchar(100) COLLATE French_CI_AS NULL,
	CD_TypeParametre varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Parametre__ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Parametre_L1 ON OA_BEG.dbo.Parametre__ (  Cle ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.PartagePlanning definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PartagePlanning;

CREATE TABLE OA_BEG.dbo.PartagePlanning (
	Id decimal(10,0) NOT NULL,
	FK_UtilisateurSource decimal(10,0) NULL,
	FK_UtilisateurCible decimal(10,0) NULL,
	AffichageAbsences varchar(5) COLLATE French_CI_AS NULL,
	AffichageVacances varchar(5) COLLATE French_CI_AS NULL,
	AffichagePrestations varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PartagePlanning PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Periode____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Periode____;

CREATE TABLE OA_BEG.dbo.Periode____ (
	Id decimal(10,0) NOT NULL,
	FK_Utilisateur decimal(10,0) NULL,
	DateDebut datetime NULL,
	HeureSemaine decimal(5,2) NULL,
	HeureJour decimal(5,2) NULL,
	JourVacances decimal(5,2) NULL,
	HeureLundi decimal(5,2) NULL,
	HeureMardi decimal(5,2) NULL,
	HeureMercredi decimal(5,2) NULL,
	HeureJeudi decimal(5,2) NULL,
	HeureVendredi decimal(5,2) NULL,
	HeureSamedi decimal(5,2) NULL,
	HeureDimanche decimal(5,2) NULL,
	Fin varchar(10) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	HeureSemaine100 decimal(5,2) NULL,
	Pourcentage decimal(5,2) NULL,
	Remarque text COLLATE French_CI_AS NULL,
	ReportHeureSpecifique varchar(10) COLLATE French_CI_AS NULL,
	ReportVacancesSpecifique varchar(10) COLLATE French_CI_AS NULL,
	ReportHeure decimal(6,2) NULL,
	ReportJourVacances decimal(5,2) NULL,
	ReportHeureJour decimal(5,2) NULL,
	TarifPrixRevient decimal(10,2) NULL,
	PourcentagePlanifiable decimal(5,2) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Periode____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Periode_L1_ ON OA_BEG.dbo.Periode____ (  FK_Utilisateur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Periode_L2_ ON OA_BEG.dbo.Periode____ (  FK_Utilisateur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Periode_L3_ ON OA_BEG.dbo.Periode____ (  FK_Utilisateur ASC  , DateDebut ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.PeriodiciteTachePlanifiee definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PeriodiciteTachePlanifiee;

CREATE TABLE OA_BEG.dbo.PeriodiciteTachePlanifiee (
	Id decimal(10,0) NOT NULL,
	FK_TachePlanifiee decimal(10,0) NULL,
	CD_TypePeriodicite varchar(10) COLLATE French_CI_AS NULL,
	CD_QuotidienDetail varchar(10) COLLATE French_CI_AS NULL,
	RepetitionJour decimal(3,0) NULL,
	RegenerationQuotidienne decimal(3,0) NULL,
	CD_HebdomadaireDetail varchar(10) COLLATE French_CI_AS NULL,
	RepetitionHebdomadaire decimal(3,0) NULL,
	Lundi varchar(5) COLLATE French_CI_AS NULL,
	Mardi varchar(5) COLLATE French_CI_AS NULL,
	Mercredi varchar(5) COLLATE French_CI_AS NULL,
	Jeudi varchar(5) COLLATE French_CI_AS NULL,
	Vendredi varchar(5) COLLATE French_CI_AS NULL,
	Samedi varchar(5) COLLATE French_CI_AS NULL,
	Dimanche varchar(5) COLLATE French_CI_AS NULL,
	RegenerationHebdomadaire decimal(3,0) NULL,
	CD_MensuelDetail varchar(10) COLLATE French_CI_AS NULL,
	JourDuMois decimal(2,0) NULL,
	RepetitionMensuelle decimal(2,0) NULL,
	CD_NoSemaineMensuel varchar(10) COLLATE French_CI_AS NULL,
	JourDeLaSemaine decimal(1,0) NULL,
	RegenerationMensuelle decimal(3,0) NULL,
	CD_AnnuelDetail varchar(10) COLLATE French_CI_AS NULL,
	CD_Mois varchar(10) COLLATE French_CI_AS NULL,
	CD_NoSemaineAnnuel varchar(10) COLLATE French_CI_AS NULL,
	RegenerationAnnuelle decimal(3,0) NULL,
	DateDebut datetime NULL,
	NombreOccurence decimal(3,0) NULL,
	DateFin datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PeriodiciteTachePlanifiee PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Piquet_____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Piquet_____;

CREATE TABLE OA_BEG.dbo.Piquet_____ (
	Id decimal(10,0) NOT NULL,
	DateHeureDebut datetime NULL,
	DateHeureFin datetime NULL,
	FK_Competence decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	Description text COLLATE French_CI_AS NULL,
	FK_Piquet decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Piquet_____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PlanningActivite definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PlanningActivite;

CREATE TABLE OA_BEG.dbo.PlanningActivite (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	ValidationResponsable varchar(5) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	[Sequence] decimal(5,0) NULL,
	PasLigneModif varchar(5) COLLATE French_CI_AS NULL,
	PasGenActiviteSiActiviteExistante varchar(5) COLLATE French_CI_AS NULL,
	PasImprimerLigneVide varchar(5) COLLATE French_CI_AS NULL,
	CouleurLundi decimal(10,0) NULL,
	CouleurMardi decimal(10,0) NULL,
	CouleurMercredi decimal(10,0) NULL,
	CouleurJeudi decimal(10,0) NULL,
	CouleurVendredi decimal(10,0) NULL,
	CouleurSamedi decimal(10,0) NULL,
	CouleurDimanche decimal(10,0) NULL,
	CouleurLundiAlt decimal(10,0) NULL,
	CouleurMardiAlt decimal(10,0) NULL,
	CouleurMercrediAlt decimal(10,0) NULL,
	CouleurJeudiAlt decimal(10,0) NULL,
	CouleurVendrediAlt decimal(10,0) NULL,
	CouleurSamediAlt decimal(10,0) NULL,
	CouleurDimancheAlt decimal(10,0) NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PlanningActivite PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PlanningActiviteParametre definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PlanningActiviteParametre;

CREATE TABLE OA_BEG.dbo.PlanningActiviteParametre (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PlanningActiviteParametre PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PlanningCycle definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PlanningCycle;

CREATE TABLE OA_BEG.dbo.PlanningCycle (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	NombreDeJours decimal(5,0) NULL,
	Description text COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PlanningCycle PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PlanningCycleDetail definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PlanningCycleDetail;

CREATE TABLE OA_BEG.dbo.PlanningCycleDetail (
	Id decimal(10,0) NOT NULL,
	FK_PlanningCycle decimal(10,0) NULL,
	NoJour decimal(5,0) NULL,
	FK_TrancheHoraire decimal(10,0) NULL,
	FK_TypeActivitePlanifiee decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PlanningCycleDetail PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PlanningNotification definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PlanningNotification;

CREATE TABLE OA_BEG.dbo.PlanningNotification (
	Id decimal(10,0) NOT NULL,
	FK_Utilisateur decimal(10,0) NULL,
	FK_PlanningActivite decimal(10,0) NULL,
	FK_PlanningRegle decimal(10,0) NULL,
	DateDebut datetime NULL,
	DateFin datetime NULL,
	Commentaire text COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PlanningNotification PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PlanningRegle definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PlanningRegle;

CREATE TABLE OA_BEG.dbo.PlanningRegle (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	FK_PlanningActivite decimal(10,0) NULL,
	FK_PlanningTypeRegle decimal(10,0) NULL,
	ValeurX decimal(9,0) NULL,
	ValeurY decimal(9,0) NULL,
	CD_JourSemaine varchar(10) COLLATE French_CI_AS NULL,
	CD_PlanningReglePeriode varchar(10) COLLATE French_CI_AS NULL,
	FK_TypeActivitePlanifiee decimal(10,0) NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PlanningRegle PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PlanningTypeRegle definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PlanningTypeRegle;

CREATE TABLE OA_BEG.dbo.PlanningTypeRegle (
	Id decimal(10,0) NOT NULL,
	Code varchar(50) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PlanningTypeRegle PRIMARY KEY (Id)
);


-- OA_BEG.dbo.PreferenceUtilisateur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PreferenceUtilisateur;

CREATE TABLE OA_BEG.dbo.PreferenceUtilisateur (
	Id decimal(9,0) NOT NULL,
	FK_Utilisateur decimal(9,0) NULL,
	Nom varchar(250) COLLATE French_CI_AS NULL,
	Objet varchar(250) COLLATE French_CI_AS NULL,
	MotCle varchar(50) COLLATE French_CI_AS NULL,
	Version decimal(9,0) NULL,
	[Data] varchar(255) COLLATE French_CI_AS NULL,
	DataLong text COLLATE French_CI_AS NULL,
	FK_PreferenceUtilisateurBin decimal(9,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PreferenceUtilisateur PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX PreferenceUtilisateur_L1 ON OA_BEG.dbo.PreferenceUtilisateur (  Objet ASC  , MotCle ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX PreferenceUtilisateur_L2 ON OA_BEG.dbo.PreferenceUtilisateur (  Objet ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX PreferenceUtilisateur_L3 ON OA_BEG.dbo.PreferenceUtilisateur (  Objet ASC  , FK_Utilisateur ASC  , Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX PreferenceUtilisateur_L4 ON OA_BEG.dbo.PreferenceUtilisateur (  FK_Utilisateur ASC  , Objet ASC  , MotCle ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX PreferenceUtilisateur_L5 ON OA_BEG.dbo.PreferenceUtilisateur (  MotCle ASC  , FK_Utilisateur ASC  , Objet ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX PreferenceUtilisateur_L6 ON OA_BEG.dbo.PreferenceUtilisateur (  MotCle ASC  , FK_Utilisateur ASC  , Nom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.PreferenceUtilisateurBin definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.PreferenceUtilisateurBin;

CREATE TABLE OA_BEG.dbo.PreferenceUtilisateurBin (
	Id decimal(9,0) NOT NULL,
	DataBin image NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_PreferenceUtilisateurBin PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Processus__ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Processus__;

CREATE TABLE OA_BEG.dbo.Processus__ (
	Id decimal(10,0) NOT NULL,
	FK_ProcessusModele decimal(10,0) NULL,
	Designation varchar(255) COLLATE French_CI_AS NULL,
	FK_UtilisateurProprietaire decimal(10,0) NULL,
	DateDebut datetime NULL,
	Remarque text COLLATE French_CI_AS NULL,
	EstModele varchar(5) COLLATE French_CI_AS NULL,
	EstTermine varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Processus__ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Mandat_____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Mandat_____;

CREATE TABLE OA_BEG.dbo.Mandat_____ (
	Id decimal(10,0) NOT NULL,
	FK_Compte decimal(10,0) NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Descr text COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	Ordre decimal(12,0) NULL,
	CD_FacturationMandat varchar(10) COLLATE French_CI_AS NULL,
	FK_Tarif decimal(10,0) NULL,
	GenererDocument varchar(5) COLLATE French_CI_AS NULL,
	FK_ModeleDocumentCommercial decimal(10,0) NULL,
	EstModele varchar(5) COLLATE French_CI_AS NULL,
	NomModele varchar(255) COLLATE French_CI_AS NULL,
	Remarques text COLLATE French_CI_AS NULL,
	FK_UtilisateurReferent decimal(10,0) NULL,
	FaireValiderActiviteAvecDepassement varchar(5) COLLATE French_CI_AS NULL,
	CD_SaisieTarifTache varchar(10) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	FK_ModeleTexteFacture decimal(10,0) NULL,
	EstSaisieInterdite varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	FK_ContactFacturation decimal(10,0) NULL,
	CONSTRAINT PrimaryKey_Mandat_____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ParArchive ON OA_BEG.dbo.Mandat_____ (  Archive ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ParEstModele ON OA_BEG.dbo.Mandat_____ (  EstModele ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.ProprieteDynamique definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ProprieteDynamique;

CREATE TABLE OA_BEG.dbo.ProprieteDynamique (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	NomObjet varchar(255) COLLATE French_CI_AS NULL,
	CD_TypePropriete varchar(10) COLLATE French_CI_AS NULL,
	[Sequence] decimal(9,0) NULL,
	FK_PropDynGrp decimal(10,0) NULL,
	NbDecimales decimal(2,0) NULL,
	AfficherTotal varchar(5) COLLATE French_CI_AS NULL,
	AfficherSeparateurMillier varchar(5) COLLATE French_CI_AS NULL,
	NegatifPossible varchar(5) COLLATE French_CI_AS NULL,
	FormatAffichage varchar(255) COLLATE French_CI_AS NULL,
	EstObligatoire varchar(5) COLLATE French_CI_AS NULL,
	DefautValeurString varchar(255) COLLATE French_CI_AS NULL,
	DefautValeurDecimal decimal(15,5) NULL,
	DefautValeurDate datetime NULL,
	DefautValeurBoolean varchar(5) COLLATE French_CI_AS NULL,
	FK_ListeValeurCategorie decimal(10,0) NULL,
	FK_ListeValeurElement decimal(10,0) NULL,
	CD_DateValeurPredefinie varchar(10) COLLATE French_CI_AS NULL,
	FK_Contact decimal(10,0) NULL,
	FK_Compte decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CD_TypeAffichage varchar(10) COLLATE French_CI_AS NULL,
	FiltreDisponible varchar(5) COLLATE French_CI_AS NULL,
	Filtre text COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	CONSTRAINT PrimaryKey_ProprieteDynamique PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ProprieteDynamique_L1 ON OA_BEG.dbo.ProprieteDynamique (  NomObjet ASC  , Sequence ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ProprieteDynamique_L2 ON OA_BEG.dbo.ProprieteDynamique (  NomObjet ASC  , Id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Raccourci__ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Raccourci__;

CREATE TABLE OA_BEG.dbo.Raccourci__ (
	Id decimal(10,0) NOT NULL,
	NomObjet varchar(255) COLLATE French_CI_AS NULL,
	IdObjet decimal(10,0) NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Raccourci varchar(255) COLLATE French_CI_AS NULL,
	CD_TypeRaccourci varchar(10) COLLATE French_CI_AS NULL,
	IsDefaut varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Raccourci__ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Raccourci_L1 ON OA_BEG.dbo.Raccourci__ (  NomObjet ASC  , IdObjet ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.RapportBin_ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.RapportBin_;

CREATE TABLE OA_BEG.dbo.RapportBin_ (
	Id decimal(10,0) NOT NULL,
	DataBin image NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_RapportBin_ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.RapportParametre definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.RapportParametre;

CREATE TABLE OA_BEG.dbo.RapportParametre (
	Id decimal(10,0) NOT NULL,
	FK_Rapport decimal(10,0) NULL,
	CD_TypePropriete varchar(10) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	NomVariable varchar(255) COLLATE French_CI_AS NULL,
	[Sequence] decimal(9,0) NULL,
	FK_GroupeParametreRapport decimal(10,0) NULL,
	ValeurString varchar(255) COLLATE French_CI_AS NULL,
	ValeurDecimal decimal(15,5) NULL,
	ValeurDate datetime NULL,
	ValeurBoolean varchar(5) COLLATE French_CI_AS NULL,
	NbDecimales decimal(2,0) NULL,
	Invisible varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_RapportParametre PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Rapport____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Rapport____;

CREATE TABLE OA_BEG.dbo.Rapport____ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	FK_RapportBin decimal(10,0) NULL,
	Visible varchar(5) COLLATE French_CI_AS NULL,
	[Sequence] decimal(3,0) NULL,
	DroitGroupe varchar(5) COLLATE French_CI_AS NULL,
	MotCleInterne varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Rapport____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.RendezVousSuppression definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.RendezVousSuppression;

CREATE TABLE OA_BEG.dbo.RendezVousSuppression (
	Id decimal(10,0) NOT NULL,
	FK_Activite decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	OutlookLogin varchar(100) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_RendezVousSuppression PRIMARY KEY (Id)
);


-- OA_BEG.dbo.RendezVous_ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.RendezVous_;

CREATE TABLE OA_BEG.dbo.RendezVous_ (
	Id decimal(10,0) NOT NULL,
	FK_Utilisateur decimal(10,0) NULL,
	Sujet varchar(255) COLLATE French_CI_AS NULL,
	DateDebut datetime NULL,
	DateFin datetime NULL,
	Journee varchar(10) COLLATE French_CI_AS NULL,
	Duree decimal(15,0) NULL,
	Disponibilite decimal(3,0) NULL,
	Visibilite decimal(3,0) NULL,
	Description text COLLATE French_CI_AS NULL,
	Resources text COLLATE French_CI_AS NULL,
	EntryID varchar(255) COLLATE French_CI_AS NULL,
	Emplacement text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_RendezVous_ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.RepartitionHeures definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.RepartitionHeures;

CREATE TABLE OA_BEG.dbo.RepartitionHeures (
	Id decimal(10,0) NOT NULL,
	FK_Activite decimal(10,0) NULL,
	FK_ClasseDHeures decimal(10,0) NULL,
	Duree decimal(12,0) NULL,
	Coefficient decimal(10,2) NULL,
	Total decimal(12,0) NULL,
	CoefficientTarif decimal(10,6) NULL,
	Montant decimal(16,6) NULL,
	CoefficientTarifUtilise varchar(5) COLLATE French_CI_AS NULL,
	TarifPrixRevient decimal(10,2) NULL,
	PrixDeRevient decimal(12,2) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_RepartitionHeures PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Rubrique___ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Rubrique___;

CREATE TABLE OA_BEG.dbo.Rubrique___ (
	Id decimal(10,0) NOT NULL,
	FK_Rubrique decimal(10,0) NULL,
	FK_Mandat decimal(10,0) NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	Descr text COLLATE French_CI_AS NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	Ordre decimal(12,0) NULL,
	EDuree decimal(12,0) NULL,
	DateHeureDebut datetime NULL,
	DateHeureFin datetime NULL,
	PourcentAvancement decimal(5,2) NULL,
	Termine varchar(10) COLLATE French_CI_AS NULL,
	AjustementDureeEstimee decimal(12,0) NULL,
	AjustementCommentaire text COLLATE French_CI_AS NULL,
	FaireValiderSiDepasseDureePlanifiee varchar(5) COLLATE French_CI_AS NULL,
	FaireValiderSiDepasseDureeEstimee varchar(5) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	FK_Tarif decimal(10,0) NULL,
	CD_FacturationDossier varchar(10) COLLATE French_CI_AS NULL,
	EstSaisieInterdite varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	EstSaisieRapportActObligatoire varchar(5) COLLATE French_CI_AS NULL,
	CONSTRAINT PrimaryKey_Rubrique___ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ParMandat ON OA_BEG.dbo.Rubrique___ (  FK_Mandat ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ParRubrique ON OA_BEG.dbo.Rubrique___ (  FK_Rubrique ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.SalairePeriode definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.SalairePeriode;

CREATE TABLE OA_BEG.dbo.SalairePeriode (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	NoPeriode decimal(2,0) NULL,
	DateDebut datetime NULL,
	DateFin datetime NULL,
	Annee decimal(4,0) NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_SalairePeriode PRIMARY KEY (Id)
);


-- OA_BEG.dbo.SalaireRubrique definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.SalaireRubrique;

CREATE TABLE OA_BEG.dbo.SalaireRubrique (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	TypeValeur varchar(50) COLLATE French_CI_AS NULL,
	TypeDeterminant varchar(50) COLLATE French_CI_AS NULL,
	TypeCoefficient varchar(50) COLLATE French_CI_AS NULL,
	TypeCoefficientEmployeur varchar(50) COLLATE French_CI_AS NULL,
	TypeValeurEmployeur varchar(50) COLLATE French_CI_AS NULL,
	Ignorer varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_SalaireRubrique PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TableauDeBord definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TableauDeBord;

CREATE TABLE OA_BEG.dbo.TableauDeBord (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	FK_TableauDeBordBin decimal(10,0) NULL,
	Visible varchar(5) COLLATE French_CI_AS NULL,
	[Sequence] decimal(3,0) NULL,
	DroitGroupe varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TableauDeBord PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TableauDeBordBin definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TableauDeBordBin;

CREATE TABLE OA_BEG.dbo.TableauDeBordBin (
	Id decimal(10,0) NOT NULL,
	DataBin image NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TableauDeBordBin PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TableaudeBordParametre definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TableaudeBordParametre;

CREATE TABLE OA_BEG.dbo.TableaudeBordParametre (
	Id decimal(10,0) NOT NULL,
	FK_TableauDeBord decimal(10,0) NULL,
	CD_TypePropriete varchar(10) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	NomVariable varchar(255) COLLATE French_CI_AS NULL,
	[Sequence] decimal(9,0) NULL,
	FK_GroupeParametreTableauDeBord decimal(10,0) NULL,
	ValeurString varchar(255) COLLATE French_CI_AS NULL,
	ValeurDecimal decimal(15,5) NULL,
	ValeurDate datetime NULL,
	ValeurBoolean varchar(5) COLLATE French_CI_AS NULL,
	NbDecimales decimal(2,0) NULL,
	Invisible varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TableaudeBordParametre PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TachePlanifiee definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TachePlanifiee;

CREATE TABLE OA_BEG.dbo.TachePlanifiee (
	Id decimal(10,0) NOT NULL,
	FK_Processus decimal(10,0) NULL,
	FK_TachePlanifieePeriodique decimal(10,0) NULL,
	Objet varchar(255) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	FK_UtilisateurSuperviseur decimal(10,0) NULL,
	FK_UtilisateurAssigneA decimal(10,0) NULL,
	DateDebut datetime NULL,
	Echeance datetime NULL,
	DateFin datetime NULL,
	FK_Compte decimal(10,0) NULL,
	FK_Rubrique decimal(10,0) NULL,
	FK_Tache decimal(10,0) NULL,
	FK_Contact decimal(10,0) NULL,
	DureeEstimee decimal(12,0) NULL,
	CD_EtatTachePlanifiee varchar(10) COLLATE French_CI_AS NULL,
	CD_PrioriteTachePlanifiee varchar(10) COLLATE French_CI_AS NULL,
	PourcentRealise decimal(5,2) NULL,
	Remarque text COLLATE French_CI_AS NULL,
	EstModele varchar(5) COLLATE French_CI_AS NULL,
	ModeleParentName varchar(100) COLLATE French_CI_AS NULL,
	CD_TachePlanifieeModeleDateDebut varchar(10) COLLATE French_CI_AS NULL,
	NbJoursApresDebutProcessus decimal(10,0) NULL,
	FK_CategorieTachePlanifieePrincipale decimal(10,0) NULL,
	DateHeureCreation datetime NULL,
	FK_UtilisateurCreation decimal(10,0) NULL,
	Tarif decimal(10,2) NULL,
	CD_ModeFacturation varchar(10) COLLATE French_CI_AS NULL,
	DescriptionActiviteObligatoire varchar(5) COLLATE French_CI_AS NULL,
	AjustementDureePlanifiee decimal(12,0) NULL,
	AjustementCommentaire text COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TachePlanifiee PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TachePlanifieePeriodiqueException definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TachePlanifieePeriodiqueException;

CREATE TABLE OA_BEG.dbo.TachePlanifieePeriodiqueException (
	Id decimal(10,0) NOT NULL,
	FK_TachePlanifieePeriodique decimal(10,0) NULL,
	FK_TachePlanifiee decimal(10,0) NULL,
	DateException datetime NULL,
	Supprime varchar(5) COLLATE French_CI_AS NULL,
	Modifie varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TachePlanifieePeriodiqueException PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX IFK_TachePlanifieePeriodique ON OA_BEG.dbo.TachePlanifieePeriodiqueException (  FK_TachePlanifieePeriodique ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.TachePlanifieeRepartition definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TachePlanifieeRepartition;

CREATE TABLE OA_BEG.dbo.TachePlanifieeRepartition (
	Id decimal(10,0) NOT NULL,
	FK_TachePlanifiee decimal(10,0) NULL,
	Debut datetime NULL,
	Fin datetime NULL,
	Duree decimal(12,0) NULL,
	Description text COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TachePlanifieeRepartition PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Tache______ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Tache______;

CREATE TABLE OA_BEG.dbo.Tache______ (
	Id decimal(10,0) NOT NULL,
	CD_ModeFacturation varchar(10) COLLATE French_CI_AS NULL,
	CD_GenreTache varchar(10) COLLATE French_CI_AS NULL,
	CD_FacturationTache varchar(10) COLLATE French_CI_AS NULL,
	CD_LienMandatTache varchar(10) COLLATE French_CI_AS NULL,
	CD_ReplicationOutlook varchar(10) COLLATE French_CI_AS NULL,
	CD_HeureNegative varchar(10) COLLATE French_CI_AS NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Nom varchar(50) COLLATE French_CI_AS NULL,
	Descr text COLLATE French_CI_AS NULL,
	Tarif decimal(10,2) NULL,
	Couleur decimal(10,0) NULL,
	Archive varchar(10) COLLATE French_CI_AS NULL,
	Ordre decimal(12,0) NULL,
	CouleurFacture decimal(10,0) NULL,
	CouleurFactureUtilise varchar(5) COLLATE French_CI_AS NULL,
	DureeObligatoire varchar(5) COLLATE French_CI_AS NULL,
	FK_Article decimal(10,0) NULL,
	Unite varchar(255) COLLATE French_CI_AS NULL,
	ValidationResponsable varchar(5) COLLATE French_CI_AS NULL,
	FK_ModeleRapportActivite decimal(10,0) NULL,
	FK_SalaireRubrique decimal(10,0) NULL,
	HeureNulle varchar(5) COLLATE French_CI_AS NULL,
	CD_ModeDuree varchar(10) COLLATE French_CI_AS NULL,
	DureeFixe decimal(12,0) NULL,
	Libelle varchar(255) COLLATE French_CI_AS NULL,
	CouleurValidation decimal(10,0) NULL,
	CouleurValidationUtilise varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Tache______ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TarifNommage definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TarifNommage;

CREATE TABLE OA_BEG.dbo.TarifNommage (
	Id decimal(10,0) NOT NULL,
	FK_Tarif decimal(10,0) NULL,
	Montant decimal(10,2) NULL,
	Libelle varchar(255) COLLATE French_CI_AS NULL,
	FK_Article decimal(10,0) NULL,
	Unite varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TarifNommage PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Tarif______ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Tarif______;

CREATE TABLE OA_BEG.dbo.Tarif______ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Montant decimal(10,2) NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Tarif______ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TraductionParObjet definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TraductionParObjet;

CREATE TABLE OA_BEG.dbo.TraductionParObjet (
	Id decimal(10,0) NOT NULL,
	CodeLangue varchar(10) COLLATE French_CI_AS NULL,
	Texte text COLLATE French_CI_AS NULL,
	NomTable varchar(250) COLLATE French_CI_AS NULL,
	IdEnregistrement decimal(10,0) NULL,
	NomChamp varchar(250) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TraductionParObjet PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TrancheHoraire definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TrancheHoraire;

CREATE TABLE OA_BEG.dbo.TrancheHoraire (
	Id decimal(10,0) NOT NULL,
	Code varchar(5) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	[Sequence] decimal(3,0) NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TrancheHoraire PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TypeActivitePlanifiee definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TypeActivitePlanifiee;

CREATE TABLE OA_BEG.dbo.TypeActivitePlanifiee (
	Id decimal(10,0) NOT NULL,
	Code varchar(3) COLLATE French_CI_AS NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	NombreRequisLundi decimal(5,0) NULL,
	NombreRequisMardi decimal(5,0) NULL,
	NombreRequisMercredi decimal(5,0) NULL,
	NombreRequisJeudi decimal(5,0) NULL,
	NombreRequisVendredi decimal(5,0) NULL,
	NombreRequisSamedi decimal(5,0) NULL,
	NombreRequisDimanche decimal(5,0) NULL,
	Couleur decimal(10,0) NULL,
	CouleurFond decimal(10,0) NULL,
	CouleurModif decimal(10,0) NULL,
	CouleurFondModif decimal(10,0) NULL,
	CouleurModifValidee decimal(10,0) NULL,
	CouleurFondModifValidee decimal(10,0) NULL,
	CouleurSiEgal decimal(10,0) NULL,
	CouleurSiEgalFond decimal(10,0) NULL,
	CouleurSiPlusGrand decimal(10,0) NULL,
	CouleurSiPlusGrandFond decimal(10,0) NULL,
	CouleurSiPlusPetit decimal(10,0) NULL,
	CouleurSiPlusPetitFond decimal(10,0) NULL,
	SaisieTexteLibreAutorisee varchar(5) COLLATE French_CI_AS NULL,
	GenerationAutomatiqueActivite varchar(5) COLLATE French_CI_AS NULL,
	FK_ModeleActiviteJourFerie decimal(10,0) NULL,
	FK_ModeleActiviteLundi decimal(10,0) NULL,
	FK_ModeleActiviteMardi decimal(10,0) NULL,
	FK_ModeleActiviteMercredi decimal(10,0) NULL,
	FK_ModeleActiviteJeudi decimal(10,0) NULL,
	FK_ModeleActiviteVendredi decimal(10,0) NULL,
	FK_ModeleActiviteSamedi decimal(10,0) NULL,
	FK_ModeleActiviteDimanche decimal(10,0) NULL,
	Description text COLLATE French_CI_AS NULL,
	[Sequence] decimal(5,0) NULL,
	SansLigneRecap varchar(5) COLLATE French_CI_AS NULL,
	NeModifiePasPlanning varchar(5) COLLATE French_CI_AS NULL,
	AffichageTableauDeBord varchar(5) COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TypeActivitePlanifiee PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TypeAlerte_ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TypeAlerte_;

CREATE TABLE OA_BEG.dbo.TypeAlerte_ (
	Id decimal(10,0) NOT NULL,
	Nom varchar(255) COLLATE French_CI_AS NULL,
	Telephone varchar(5) COLLATE French_CI_AS NULL,
	Telephone2 varchar(5) COLLATE French_CI_AS NULL,
	Telephone3 varchar(5) COLLATE French_CI_AS NULL,
	Telephone4 varchar(5) COLLATE French_CI_AS NULL,
	Mobile varchar(5) COLLATE French_CI_AS NULL,
	Fax varchar(5) COLLATE French_CI_AS NULL,
	Email varchar(5) COLLATE French_CI_AS NULL,
	Email2 varchar(5) COLLATE French_CI_AS NULL,
	Email3 varchar(5) COLLATE French_CI_AS NULL,
	Objet varchar(255) COLLATE French_CI_AS NULL,
	Message text COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	ObjetProprietaireType varchar(255) COLLATE French_CI_AS NULL,
	ObjetProprietaireId varchar(100) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TypeAlerte_ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TypeMouvementFinancier definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TypeMouvementFinancier;

CREATE TABLE OA_BEG.dbo.TypeMouvementFinancier (
	Id decimal(10,0) NOT NULL,
	Nom varchar(250) COLLATE French_CI_AS NULL,
	DescAbr varchar(50) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	CD_MvtCumuleDans varchar(10) COLLATE French_CI_AS NULL,
	FK_Article decimal(10,0) NULL,
	Libelle varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	RepartirParActivite varchar(5) COLLATE French_CI_AS NULL,
	CONSTRAINT PrimaryKey_TypeMouvementFinancier PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TypeRelation definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TypeRelation;

CREATE TABLE OA_BEG.dbo.TypeRelation (
	Id decimal(10,0) NOT NULL,
	Designation varchar(100) COLLATE French_CI_AS NULL,
	DesignationInverse varchar(100) COLLATE French_CI_AS NULL,
	CD_TypeRelation varchar(10) COLLATE French_CI_AS NULL,
	CD_GenreRelation varchar(10) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TypeRelation PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TypeTvaDetail definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TypeTvaDetail;

CREATE TABLE OA_BEG.dbo.TypeTvaDetail (
	Id decimal(10,0) NOT NULL,
	FK_TypeTva decimal(10,0) NULL,
	DateDebut datetime NULL,
	Taux decimal(9,2) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TypeTvaDetail PRIMARY KEY (Id)
);


-- OA_BEG.dbo.TypeTva____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.TypeTva____;

CREATE TABLE OA_BEG.dbo.TypeTva____ (
	Id decimal(10,0) NOT NULL,
	CodeTva varchar(15) COLLATE French_CI_AS NULL,
	Libelle varchar(255) COLLATE French_CI_AS NULL,
	CD_TypeTvaArrondi varchar(10) COLLATE French_CI_AS NULL,
	CD_TypeTvaIncluse varchar(10) COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_TypeTva____ PRIMARY KEY (Id)
);


-- OA_BEG.dbo.Utilisateur definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Utilisateur;

CREATE TABLE OA_BEG.dbo.Utilisateur (
	Id decimal(10,0) NOT NULL,
	Nom varchar(100) COLLATE French_CI_AS NULL,
	Prenom varchar(100) COLLATE French_CI_AS NULL,
	[Login] varchar(100) COLLATE French_CI_AS NULL,
	Special varchar(10) COLLATE French_CI_AS NULL,
	Actif varchar(10) COLLATE French_CI_AS NULL,
	Droits varchar(10) COLLATE French_CI_AS NULL,
	OutlookLogin varchar(100) COLLATE French_CI_AS NULL,
	FK_Departement decimal(10,0) NULL,
	ExchangeMailbox varchar(100) COLLATE French_CI_AS NULL,
	MotDePasse varchar(255) COLLATE French_CI_AS NULL,
	FK_UtilisateurResponsable decimal(10,0) NULL,
	CleExterne varchar(50) COLLATE French_CI_AS NULL,
	Initiales varchar(10) COLLATE French_CI_AS NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	FK_Contact decimal(10,0) NULL,
	AppMobileActif varchar(5) COLLATE French_CI_AS NULL,
	AppMobileNom varchar(100) COLLATE French_CI_AS NULL,
	AppMobileMotDePasse varchar(255) COLLATE French_CI_AS NULL,
	OdysCubeActif varchar(5) COLLATE French_CI_AS NULL,
	FK_TacheParDefaut decimal(10,0) NULL,
	ActiveDirectoryGuid varchar(255) COLLATE French_CI_AS NULL,
	ActiveDirectoryTexte varchar(255) COLLATE French_CI_AS NULL,
	NoTelephoneMobile varchar(20) COLLATE French_CI_AS NULL,
	UserOnlineGuid varchar(255) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_Utilisateur PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Utilisateur_L1 ON OA_BEG.dbo.Utilisateur (  Nom ASC  , Prenom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Utilisateur_L2 ON OA_BEG.dbo.Utilisateur (  Actif ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX Utilisateur_L3 ON OA_BEG.dbo.Utilisateur (  Login ASC  , Nom ASC  , Prenom ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.ValeurProprieteDynamique definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ValeurProprieteDynamique;

CREATE TABLE OA_BEG.dbo.ValeurProprieteDynamique (
	Id decimal(10,0) NOT NULL,
	FK_ProprieteDynamique decimal(10,0) NULL,
	IdObjet decimal(10,0) NULL,
	ValeurString varchar(255) COLLATE French_CI_AS NULL,
	ValeurDecimal decimal(15,5) NULL,
	ValeurDate datetime NULL,
	ValeurBoolean varchar(5) COLLATE French_CI_AS NULL,
	FK_ListeValeurElement decimal(10,0) NULL,
	FK_Contact decimal(10,0) NULL,
	FK_Compte decimal(10,0) NULL,
	FK_Utilisateur decimal(10,0) NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ValeurProprieteDynamique PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX ParObjet ON OA_BEG.dbo.ValeurProprieteDynamique (  IdObjet ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ParPropriete ON OA_BEG.dbo.ValeurProprieteDynamique (  FK_ProprieteDynamique ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ValeurProprieteDynamique_L3 ON OA_BEG.dbo.ValeurProprieteDynamique (  IdObjet ASC  , FK_ProprieteDynamique ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.Valeur_____ definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.Valeur_____;

CREATE TABLE OA_BEG.dbo.Valeur_____ (
	Id decimal(10,0) NOT NULL,
	Valeur varchar(250) COLLATE French_CI_AS NULL,
	CD_CategorieValeur varchar(10) COLLATE French_CI_AS NULL,
	Description text COLLATE French_CI_AS NULL,
	Abreviation varchar(250) COLLATE French_CI_AS NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	Archive varchar(5) COLLATE French_CI_AS NULL,
	[Sequence] decimal(5,0) NULL,
	CONSTRAINT PrimaryKey_Valeur_____ PRIMARY KEY (Id)
);
 CREATE NONCLUSTERED INDEX Valeur_L1__ ON OA_BEG.dbo.Valeur_____ (  CD_CategorieValeur ASC  , Valeur ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- OA_BEG.dbo.ValidationPeriode definition

-- Drop table

-- DROP TABLE OA_BEG.dbo.ValidationPeriode;

CREATE TABLE OA_BEG.dbo.ValidationPeriode (
	Id decimal(10,0) NOT NULL,
	DateDebut datetime NULL,
	DateFin datetime NULL,
	FK_Utilisateur decimal(10,0) NULL,
	Blocage varchar(5) COLLATE French_CI_AS NULL,
	Remarque text COLLATE French_CI_AS NULL,
	FK_UtilisateurSauvegarde decimal(10,0) NULL,
	DateHeureSauvegarde datetime NULL,
	sys_tsCreationUser decimal(10,0) NULL,
	sys_tsCreationDate datetime NULL,
	sys_tsUpdateUser decimal(10,0) NULL,
	sys_tsUpdateDate datetime NULL,
	CONSTRAINT PrimaryKey_ValidationPeriode PRIMARY KEY (Id)
);