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



CREATE TABLE OA_BEG.dbo.Rubrique___ (
	Id decimal(10,0) NOT NULL,
	FK_Rubrique decimal(10,0) NULL,
	FK_Projet decimal(10,0) NULL,
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
 CREATE NONCLUSTERED INDEX ParProjet ON OA_BEG.dbo.Rubrique___ (  FK_Projet ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX ParRubrique ON OA_BEG.dbo.Rubrique___ (  FK_Rubrique ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;