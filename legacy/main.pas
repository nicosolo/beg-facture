unit main;

{
Ligne de commande thunderbird:
thunderbird.exe -compose
  "
   to='mail',
   cc='mail',
   subject='dinner',
   message='path+file'
  "

si plusieurs, séparer par ,

Installer DragDrop : http://melander.dk/delphi/dragdrop/

TVA par défaut = 7.7
}

{===============================================================================
7.12.14 IMPORTANT
La base des heures BEGdatas.mdb a été modifiée:

> Table Mandats
  Ajout de 2 champs:
  - Etat texte20 (Etat de la facturation)
    contenant -;A facturer;Facturation;Terminé
  - Note memo (Note de facturation)

> Ajout de la table Factures préparées
  - IDmandat (entier long)
  - FileName texte255
  - FullPath texte255, sans doublons

2.1.2015
> Table Factures préparées
  - ajout du champ Modified, type date
===============================================================================}

{===============================================================================
HISTORIQUE
v1.1 :
  > modification de la mise en forme HTML d'envoi:
    - donées générales sous forme de tableau de 2 colonnes
    - titre FRAIS conditionné
    - chemin et nom du fichier de facturation en lien
    - suppression de la pièce jointe
    - plus de pièces jointe, seulement des liens sur tous les fichier
    - insertion volontaire des sauts de ligne
!   ATTENTION: les liens n'ont pas l'air de marcher avec Thunderbird
  > remplacement du paneau d'info par des bulles html,mais pas terrible,
    finallement un volet étendu ou non en pied de fenêtre
  > ajout du bouton d'affichage ou non des infos avec mémorisation
  > ajout du bouton Favori dans les heures en suspens
  > ouverture du programme sur le favori
  > refonte complète du design et de l'ergonomie des listes de documents:
    - ajout du bouton d'expansion des remarques
    - collapse/expand et hauteur automatique
    - redimensionnement
    - correction de la commande de copie du total des situations
    - déplacement des boutons des listes vers leurs cibles respectives
  > ajout d'un splascreen, visible aussi par clic sur le texte d'aide
  > arrondi à 5 cts des pourcents;
  > refonte du panneaux des remarques:
    - collapse/expand automatique
    - colonne de boutons numérotés à la place des lignes
  > déplacement du bouton nouveau dans le volet des factures en suspens
  > ajout de la création d'une facture vierge (sans heures)
    dans le volet des factures en suspens
  > atteindre un mandat ajouté dans le volet des factures en suspens
  > suppression bug des cellules non float et des divisions par zéro
  > ajustement de la hauteur des grilles au bouton expand
  > ajustement de la hauteur des grilles au bouton expand à tous les
    cas d'ajout et de suppression
  > surlignage en bleu des mandats dont les dernières heures datent de plus de
    45 jours
  > BUG corrigé de manière curieuse:
    la grille s'écrase lorsque la ligne active est vide et que l'on en sort
    avec la roulette. Le handle de la souris est capté au niveau de l'appli et
    il n'y a plus de problème, ça gère même l'ajout d'une ligne vide.
  > correction du drop file pour que ce soit déposée dans la ligne vide si elle
    existe
  > la génération de facture repensée:
    - plus d'en-tête
    - générée depuis la liste
    - mise à jour dans les détail
  > enregistrement de la date de la dernière sauvegarde dans la liste des
    factures préparées
  > ajout de la liste des factures préparées avec une visualisation du résumé
  > ajout de l'envoi d'un message au boss pour contrôler la facture

v1.2:
  > impression de la liste des factures en suspens
  > tri manuel de la liste des factures en suspens
  > tri manuel de la liste des factures préparées
  > tri sur l'état de la liste des factures préparées
  > couleur de l'état de la liste des factures préparées
  > changement de bleu de la liste des factures en suspens
  > ajout des documents dans le résumé
  > impression du résumé
  > le look de la liste des factures en suspens est identique aux autres tables
  > librairie html pour envoi et prévisualisation
  > envoi du fichier html pour le charger dans un navigateur où les liens
    fonctionnent
  > les fichiers temporaires sont stockés dans user\appdatas\local\temp,
    il faudrait peut-être les détruire à la femreture du programme
  > barre de visa seulement visible dans les 2 volets de facturation

v1.3:
  > ajout variable TVA
  > ajout du calcul du montant de la TVA + Total TTC
  > correction de la mise à jour de la facture avec les tarifs du fichier INI
  > btnCopyDocs insére aussi au début la période de facturation
  > ajout de 3 boutons pour copier les adresses et les prestation pour faciliter
    la tâche de la comptabilité
  > quelques corrections de présentation des résumés html
  > gestion partielle des erreurs de sauvegarde et de chargement

v1.4:
  > sorti le formatage html de la procédure d'envoi
  > le fichier html est créé au même endroit et en même temps que le fichier fab
  > ajout de fenêtres d'affichage du résumé
  > modification de la présentation du résumé
  > tous les résumés sont directement lu dans le dossier
  > l'impression du résumé passe par une prévisualisation
  > ajout du bouton home sur le résumé pour revenir à la facture
  > ajout de la procedure section dans html
  > le bouton résumé est contextuel

v1.5
  > wizard
  > correction du visa dans le résumé
  > correction du chargement de la date de dernière modification
  > ajout de la date de dernière modification
  > suppression du scrolling lors d'ajout d'un ligne aux girlles
  > suppression de la ligne vide en sortie d'une grille
  > correction de la suppression de ligne des grilles: pas d'action si vide
  > ajout du bouton de recopie de la période au début de la description des
    prestation
  > retour en arrière du bouton de recopie des documents, période enlevée
  > ajout du double clic sur le code du mandat en haut à gauche pour atteindre
    la bonne ligne dans la liste des factures en suspens

v1.6 + 1.6.1
  > ajout de la date de dernière modification, mise à jour seulement
    au moment de la sauvegard
  > la date de visa n'est mise que lorsque le bouton Visa est cliqué
  > edtPériode éditable
  > correction base de donnée:
    - suppression du champ Mandat dans tabFacture
    - réorganisation des champs de tabFacture
    - UpdateDetails: filtre sur IDmandat, plus sur tabMandats
    - actGetHoursExecute: filtre sur IDmandat, plus sur tabMandats
    - données récupérées dans tabMandats vis tabSQL dans CD:TCurrentData
      IDmandat, Numéro, Code, Responsable, (Facture), Nom, De, A, [RecordCount]
      filtre sur IDmandat ou Code
      avec les méthodes GetCurrentData et GetCD
  > mise à jour des heures détaillées lors de facture vierge
  > récupération des données si vierge, mais avec des heures non facturées
  > la base des pnétros n'est ouverte que le temps de récupérer des données
  > les pénétros sont recherchés sur le code complet et exact du mandat
  > gestion des tarifs KBOB directement depuis la base des heures
  > ajout du bouton de sélection du tarif KBOB
  > sauvegarde de l'année KBOB dans le fichier FAB et d'autres infos
  > homogénéïsation du calcul
  > ajout KBOB dans html
  > séparation des montants totaux dans html
  > ajout de AppInfo

v1.6.2
  > corrections mineures
  > amélioration de la vitesse de sauvegarde 1/5
  > le détails des heures est rétabli après la sauvegarde
  > correction du bouton Explorer sur la liste des mandats en suspens
  > fenêtre taillable

v1.7
  > résumé en HTML5+CSS
  > si adresse d'envoi vide, pas dans résumé
  > envoi du résumé simplifié, sans pièce jointe
  > correction du bug de sauvegarde d'un nouveau fichier en vérifiant que
    le chemin est initialisé
  > mise à jour du détail des heures lorsque le bouton [Période] est pressé
  > ajout de la mise en garde des kilomètres pour les pénétros
  > effacement des heures: ajout de la période
  > SetFilename: correction pour qu'il retourne toujours quelque-chose

v1.7.1
  > légère modification du html
  > correction importante du chargement des données qui met à jour la période;
    problème lié à CD depuis version 1.6
  > Liste des factures préparées: filtre sur n'importe quoi bien séaparé du
    filtre sur l'état

v1.7.2
  > correction du bug d'envoi à la comptabilité (breakline en trop, après
    un deuxième envoi)
  > correction du bug de création d'un nouveau fichier après un autre (mise à 0
    de CD.FABname)
  > ajout du bouton VERIFIER qui met à jour les données de la base sans rien
    recalculer

v1.7.3
  > suppression de la comptabilité ascendante

v1.7.4
  > suppression d'un message de débogage oublié dans la dernière version
  ! problème de calcul parfois sur les autres honoraires du bureau, le
    sous-total est incorrect

v1.7.5
  > adresse IP du serveur au lieu du nom logique

v1.7.6
  > connection à la base désactivée

v1.8
  > ajout du statut Contrôle (-|A facturer|Contrôle|Facturation|Terminé)
    surlignage -|rouge|mauve|vert|biffé et bleu pour ancien
  > bouton Contrôle: le mandat est marqué Contrôle automatiquement
  > bouton Envoi: le mandat est marqué Facturation automatiquement
  > ajout de la liste des responsables dans ini (initiales+mail)
  > envoie en copie au responsable la facture visée

(version non publiée)
V1.8.1
  > ajout du fuchsia (contrôle) à l'état de facturation et à la liste des
    factures préparées

===============================================================================}

//{$DEFINE test}

interface

uses
  IniFiles, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, AdvSmoothSplashScreen, htmlhint,
  Data.Win.ADODB, ExeInfo, Vcl.Menus, JvMenus, frxClass, frxDBSet,
  JvComponentBase, JvMail, JvAppInst, DragDrop, DropTarget, DragDropFile,
  System.Actions, Vcl.ActnList, Data.DB, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.OleCtrls, SHDocVw, Vcl.ComCtrls, AdvDateTimePicker, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, AdvCGrid, Vcl.ExtCtrls, AdvSplitter, Vcl.Forms,
  AdvScrollBox, CurvyControls, AdvCombo, AdvEdBtn, AdvEdit, AdvPanel,
  Vcl.DBCtrls, JvExControls, JvNavigationPane, XDBGrids, AdvPageControl,
  Vcl.Mask, JvExMask, JvToolEdit, JvBaseEdits, Vcl.Buttons, HTMLabel, AdvUtil;

const
  AppName  = 'BEGfacture';
  COgreen  = $00C0FFC0;
  COred    = $00A0A0FF;
  COblue   = $00FFCCB0;
  COfuchsia= $00FFB0FF;

var
{$IFDEF test}
  DBmandats: string = 'D:\Documents\BEG\Bases\BEGdatas.mdb';
  DBpenetro: string = 'D:\Documents\BEG\Pénétromètres\peneBEG.mdb';
  FOmandats: string = 'C:\Users\jeans_000\Desktop\TRAVAIL\';
{$ELSE}
  DBmandats: string = '\\192.168.0.102\beg\Bases\BASES\BEGdatas.mdb';
  DBpenetro: string = '\\192.168.0.102\Publique\Pénétromètres\peneBEG.mdb';
  FOmandats: string = 'N:\Mandats\';
{$ENDIF}
  Comptable: string = 'liliane.bianco@beg-geol.ch';
  Hints    : boolean = True;
  Favorite : string = '';
  Tarifs   : array[2..8] of real = (0, 0, 0, 0, 0, 0, 0.65);
  TVA      : real = 7.7;
  RUN      : boolean= False;

type
  TGridLink = record
    name    : string;
    grid    : TAdvColumnGrid;
    panel   : TAdvPanel;
    button  : TSpeedButton;
    splitter: TAdvSplitter;
  end;
  TMemoLink = record
    name    : string;
    memo    : TMemo;
    panel   : TAdvPanel;
    button  : TSpeedButton;
    splitter: TAdvSplitter;
  end;
  TCurrentData = record
    IDmandat, Numéro       : integer;
    Code, Nom, Responsable : string;
    De, A                  : TDate;
    Folder, FABfile        : TFileName;
    Modified, IsOpen       : boolean;
  end;
  TfrmMain = class(TForm)
    adoDatas: TADOConnection;
    tabSQL: TADOQuery;
    tabDetails: TADOQuery;
    dsrDetails: TDataSource;
    grdDétails: TXDBGrid;
    tabDetailsDate: TDateTimeField;
    tabDetailsInitiales: TWideStringField;
    tabDetailsClasse: TWideStringField;
    tabDetailsHeures: TFloatField;
    tabDetailsKm: TSmallintField;
    tabDetailsFrais: TFloatField;
    tabDetailsRemarque: TWideMemoField;
    tabDetailsFacturé: TBooleanField;
    apcMain: TAdvPageControl;
    atsDétail: TAdvTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    edtEnvoi: TCurvyMemo;
    edtAdresse: TCurvyMemo;
    edtObjet: TAdvEdit;
    tabDetailsCode: TWideStringField;
    Shape3: TShape;
    Shape4: TShape;
    dlgSave: TSaveDialog;
    dlgOpen: TOpenDialog;
    Shape6: TShape;
    pnlLeft: TPanel;
    pnlCode: TPanel;
    tabFacture: TADOQuery;
    atsSuspens: TAdvTabSheet;
    dsrFacture: TDataSource;
    grdResponsables: TXDBGrid;
    tabFactureN: TWideStringField;
    tabFactureH: TFloatField;
    tabFactureDe: TDateTimeField;
    tabFactureA: TDateTimeField;
    dsrResponsables: TDataSource;
    grdFactures: TXDBGrid;
    tabResponsables: TADOQuery;
    tabFactureResponsable: TWideStringField;
    btnQuit: TButton;
    btnSaveAs: TButton;
    btnSave: TButton;
    btnOpen: TButton;
    btnSend: TButton;
    aclMain: TActionList;
    actGetHours: TAction;
    actOpenFolder: TAction;
    actSend: TAction;
    actOpen: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actQuit: TAction;
    btnCopyAddress: TButton;
    edtMode: TAdvComboBox;
    edtType: TAdvComboBox;
    Label24: TLabel;
    edtPrestations: TCurvyMemo;
    Panel2: TPanel;
    edtTotalOffre: TAdvEdit;
    edtTotalBase: TAdvEdit;
    edtDiffOffre: TAdvEdit;
    edtDiffBase: TAdvEdit;
    dlgDatas: TOpenDialog;
    OneInstance: TJvAppInstances;
    Mail: TJvMail;
    atsPénétro: TAdvTabSheet;
    grbPenetro: TGroupBox;
    grdPenetro: TAdvColumnGrid;
    adoPenetro: TADOConnection;
    sqlPenetro: TADOQuery;
    actFilter: TAction;
    Label1: TLabel;
    edtComment: TCurvyMemo;
    actCopyAddress: TAction;
    atsDatas: TAdvTabSheet;
    edtOffreMontant: TAdvEdit;
    edtSituations: TAdvEdit;
    edtSolde: TAdvEdit;
    grdOffres: TAdvColumnGrid;
    grdAdjudications: TAdvColumnGrid;
    grdSituations: TAdvColumnGrid;
    grdDocuments: TAdvColumnGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    grdFacture: TAdvColumnGrid;
    btnRabais: TSpeedButton;
    btnFrais: TSpeedButton;
    btnFraisType: TSpeedButton;
    Calculatrice: TJvCalcEdit;
    Label2: TLabel;
    Panel1: TPanel;
    btnLocalCH: TButton;
    atsHelp: TAdvTabSheet;
    HTMLabel1: THTMLabel;
    pnlTopDocs: TPanel;
    actCopyGrid: TAction;
    btnCopyFacture: TSpeedButton;
    btnRefreshDetails: TSpeedButton;
    btnFilter: TSpeedButton;
    btnRefreshFactures: TSpeedButton;
    btnGetPenetro: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btnPastePenetro: TSpeedButton;
    btnCopyPenetro: TSpeedButton;
    Panel16: TPanel;
    pnlDocs: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    tabFactureDésignation: TWideStringField;
    tabNotes: TADOTable;
    dsrNotes: TDataSource;
    tabFactureIDmandat: TAutoIncField;
    edtState: TDBComboBox;
    edtNote: TDBMemo;
    tabFactureEtat: TWideStringField;
    Panel21: TPanel;
    lblCode: TDBText;
    JvNavPanelHeader1: TJvNavPanelHeader;
    lblCodeFrame: TPanel;
    dsrPrepared: TDataSource;
    grdPrepared: TXDBGrid;
    tabPrepared: TADOTable;
    actClearHours: TAction;
    btnOpenFolder: TSpeedButton;
    btnFavorite: TSpeedButton;
    actFavorite: TAction;
    scbDocs: TAdvScrollBox;
    splGrdOffres: TAdvSplitter;
    splGrdAdjudications: TAdvSplitter;
    splGrdSituations: TAdvSplitter;
    splGrdDocuments: TAdvSplitter;
    pnlGrdOffres: TAdvPanel;
    btnCopySumOffres: TSpeedButton;
    pnlGrdAdjudications: TAdvPanel;
    pnlGrdSituations: TAdvPanel;
    btnCopySumSituations: TSpeedButton;
    pnlGrdDocuments: TAdvPanel;
    btnCopyDocs: TSpeedButton;
    tabTous: TADOQuery;
    dsrTous: TDataSource;
    Splash: TAdvSmoothSplashScreen;
    AdvScrollBox1: TAdvScrollBox;
    splAutres: TAdvSplitter;
    splKm: TAdvSplitter;
    splFrais: TAdvSplitter;
    splTiers: TAdvSplitter;
    pnlAutres: TAdvPanel;
    pnlKm: TAdvPanel;
    pnlFrais: TAdvPanel;
    pnlTiers: TAdvPanel;
    memAutres: TMemo;
    memKm: TMemo;
    memFrais: TMemo;
    memTiers: TMemo;
    edtFilter: TAdvEditBtn;
    edtPrepare: TAdvEditBtn;
    lblHint: THTMLabel;
    edtGoTo: TAdvEdit;
    lblDésignation: TDBText;
    edtDe: TAdvDateTimePicker;
    edtA: TAdvDateTimePicker;
    Panel11: TPanel;
    DBText1: TDBText;
    DBText2: TDBText;
    Label3: TLabel;
    actGetInterval: TAction;
    AdvPanel1: TAdvPanel;
    AdvPanel2: TAdvPanel;
    AdvPanel3: TAdvPanel;
    AdvPanel4: TAdvPanel;
    btnGetInterval: TSpeedButton;
    btnGetHours: TSpeedButton;
    btnGetAll: TSpeedButton;
    btnCreate: TSpeedButton;
    atsAllPrepared: TAdvTabSheet;
    dsrAllPrepared: TDataSource;
    tabAllPrepared: TADOQuery;
    grdAllPrepared: TXDBGrid;
    AdvPanel5: TAdvPanel;
    SpeedButton3: TSpeedButton;
    WebBrowser: TWebBrowser;
    btnControl: TButton;
    actControl: TAction;
    frxDBDataset: TfrxDBDataset;
    frxReport: TfrxReport;
    btnPrint: TSpeedButton;
    btnPrintSummary: TSpeedButton;
    edtFilterEtat: TAdvComboBox;
    Panel12: TPanel;
    Panel13: TPanel;
    btnBug: TSpeedButton;
    btnHint: TSpeedButton;
    pnlVisa: TPanel;
    edtBon: TCheckBox;
    edtResponsable: TAdvEdit;
    edtVisa: TAdvComboBox;
    edtVisaDate: TAdvEdit;
    btnCopyDescription: TSpeedButton;
    btnCopyAdresse: TSpeedButton;
    btnCopyEnvoi: TSpeedButton;
    btnShowBill: TButton;
    actShowBill: TAction;
    btnWizard: TButton;
    edtLast: TAdvEdit;
    edtPériode: TAdvEditBtn;
    btnKBOB: TSpeedButton;
    tabTarifs: TADOTable;
    dsrTarifs: TDataSource;
    popHistory: TJvPopupMenu;
    tabListeDesFactures: TADOTable;
    AppInfo: TExeInfo;
    tabFactureMandat: TSmallintField;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    btnAutres1: TSpeedButton;
    btnKm1: TSpeedButton;
    btnFrais1: TSpeedButton;
    btnTiers1: TSpeedButton;
    Splitter4: TSplitter;
    Label4: TLabel;
    btnVerify: TSpeedButton;
    actVerify: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actQuitClick(Sender: TObject);
    procedure actSaveClick(Sender: TObject);
    procedure actOpenClick(Sender: TObject);
    procedure actSaveAsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tabResponsablesAfterScroll(DataSet: TDataSet);
    procedure btnRefreshFacturesClick(Sender: TObject);
    procedure btntGetAllClick(Sender: TObject);
    procedure actOpenFolderExecute(Sender: TObject);
    procedure actSendExecute(Sender: TObject);
    procedure actSendUpdate(Sender: TObject);
    procedure actOpenFolderUpdate(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure DatasChanged(Sender: TObject);
    procedure adoDatasBeforeConnect(Sender: TObject);
    procedure adoDatasAfterConnect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dftFileDrop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure dftFileEnter(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure actGetHoursExecute(Sender: TObject);
    procedure HistoryClick(Sender: TObject);
    procedure OneInstanceCmdLineReceived(Sender: TObject; CmdLine: TStrings);
    procedure btnRefreshDetailsClick(Sender: TObject);
    procedure BilanChange(Sender: TObject);
    procedure adoPenetroBeforeConnect(Sender: TObject);
    procedure btnGetPenetroClick(Sender: TObject);
    procedure btnCopyPenetroClick(Sender: TObject);
    procedure actFilterUpdate(Sender: TObject);
    procedure actFilterExecute(Sender: TObject);
    procedure grdFilterCellDblClick(Column: TXColumn);
    procedure actSaveAsUpdate(Sender: TObject);
    procedure actCopyAddressExecute(Sender: TObject);
    procedure grdRowChanging(Sender: TObject; OldRow, NewRow: Integer;
      var Allow: Boolean);
    procedure grdCanInsertRow(Sender: TObject; ARow: Integer;
      var CanInsert: Boolean);
    procedure grdDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure grdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdFactureEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure grdCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure grdSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnRabaisClick(Sender: TObject);
    procedure btnFraisTypeClick(Sender: TObject);
    procedure btnFraisClick(Sender: TObject);
    procedure DataCalculate(Sender: TObject);
    procedure edtPrepareDblClick(Sender: TObject);
    procedure grdEditChange(Sender: TObject; ACol, ARow: Integer;
      Value: string);
    procedure btnDelFactureClick(Sender: TObject);
    procedure edtPrepareChange(Sender: TObject);
    procedure btnCopySumOffresClick(Sender: TObject);
    procedure btnCopySumSituationsClick(Sender: TObject);
    procedure btnLocalCHClick(Sender: TObject);
    procedure edtModeClick(Sender: TObject);
    procedure btnPastePenetroClick(Sender: TObject);
    procedure grdPenetroEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure actCopyGridUpdate(Sender: TObject);
    procedure actCopyGridExecute(Sender: TObject);
    procedure edtFilterChange(Sender: TObject);
    procedure edtFilterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnBugClick(Sender: TObject);
    procedure grdDétailsColumnResize(Sender: TObject);
    procedure btnCopyDocsClick(Sender: TObject);
    procedure grdFacturesCellDblClick(Column: TXColumn);
    procedure grdFacturesPaintColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TXColumn; Highlight: Boolean;
      Selections: TSelections; var Color: TColor; Font: TFont;
      var Image: TPersistent);
    procedure tabNotesAfterScroll(DataSet: TDataSet);
    procedure grdPreparedCellDblClick(Column: TXColumn);
    procedure actClearHoursUpdate(Sender: TObject);
    procedure actClearHoursExecute(Sender: TObject);
    procedure edtStateExit(Sender: TObject);
    procedure actFavoriteUpdate(Sender: TObject);
    procedure actFavoriteExecute(Sender: TObject);
    procedure grdResponsablesCellDblClick(Column: TXColumn);
    procedure grdResponsablesPaintColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TXColumn; Highlight: Boolean;
      Selections: TSelections; var Color: TColor; Font: TFont;
      var Image: TPersistent);
    procedure grdResponsablesEnter(Sender: TObject);
    procedure btnHintClick(Sender: TObject);
    procedure pnlGrdOffresMinimize(Sender: TObject);
    procedure pnlGrdOffresMaximize(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure SplashClick(Sender: TObject);
    procedure HTMLabel1Click(Sender: TObject);
    procedure btnMemoClick(Sender: TObject);
    procedure pnlMemoMaximize(Sender: TObject);
    procedure pnlMemoMinimize(Sender: TObject);
    procedure edtFilterClickBtn(Sender: TObject);
    procedure edtGoToChange(Sender: TObject);
    procedure edtGoToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdExpandClick(Sender: TObject; ACol, ARow: Integer;
      Expanded: Boolean);
    procedure grdOffresAutoAddRow(Sender: TObject; ARow: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure actIsMandatOk(Sender: TObject);
    procedure actGetIntervalExecute(Sender: TObject);
    procedure tabAllPreparedAfterScroll(DataSet: TDataSet);
    procedure atsAllPreparedShow(Sender: TObject);
    procedure atsDétailShow(Sender: TObject);
    procedure atsSuspensShow(Sender: TObject);
    procedure actControlUpdate(Sender: TObject);
    procedure actControlExecute(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure grdFacturesTitleClick(Column: TXColumn);
    procedure grdAllPreparedTitleClick(Column: TXColumn);
    procedure btnPrintSummaryClick(Sender: TObject);
    procedure grdAllPreparedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtFilterEtatChange(Sender: TObject);
    procedure grdAllPreparedPaintColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TXColumn; Highlight: Boolean;
      Selections: TSelections; var Color: TColor; Font: TFont;
      var Image: TPersistent);
    procedure atsDatasShow(Sender: TObject);
    procedure atsHelpShow(Sender: TObject);
    procedure atsPénétroShow(Sender: TObject);
    procedure btnCopyDescriptionClick(Sender: TObject);
    procedure btnCopyAdresseClick(Sender: TObject);
    procedure btnCopyEnvoiClick(Sender: TObject);
    procedure actShowBillUpdate(Sender: TObject);
    procedure actShowBillExecute(Sender: TObject);
    procedure btnWizardClick(Sender: TObject);
    procedure grdExit(Sender: TObject);
    procedure edtPériodeClickBtn(Sender: TObject);
    procedure pnlCodeDblClick(Sender: TObject);
    procedure edtBonClick(Sender: TObject);
    procedure btnKBOBClick(Sender: TObject);
    procedure grdFactureResize(Sender: TObject);
    procedure Splitter4Moved(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure Panel19Resize(Sender: TObject);
    procedure actVerifyExecute(Sender: TObject);
  private
    { Déclarations privées }
    Controles, Responsables, History : TStringList;
    APfilter : string;
    GridLinks: array [0..4] of TGridLink;
    MemoLinks: array [0..4] of TMemoLink;
    CD       : TCurrentData;

    procedure GetCurrentData(Id  : integer);
    function GetHTMLfile: TFileName;
    procedure DisplayHint(Sender: TObject);
    procedure UpdateHistory(filename: TFileName);
    procedure GetKBOB;

    function IsEmptyRow(row: TStrings): boolean;
    function IsEmptyTable(table: TAdvColumnGrid): boolean;
    function TableRowCount(table: TAdvColumnGrid): integer;
    function GridLinkIndex(name: string): integer;
    procedure SetGridTitleCollapsed(idx: integer);
    procedure SetGridTitleExpanded(idx: integer);
    procedure SetGridTitle(table: TAdvColumnGrid);
    procedure AdjustGridSize(table: TAdvColumnGrid; expand: integer);

    function MemoLinkIndex(name: string): integer;
    procedure SetMemoTitleCollapsed(idx: integer);
    procedure SetMemoTitleExpanded(idx: integer);
    procedure SetMemoTitle(idx: integer);

    function  SettingsFilename: string;
    procedure SetDefaultPrices;
    procedure SettingsLoad;
    procedure SettingsSave;
    function SetFilename: string;
    function RoundTo5(v: real): real;
    function CalculBase : real;
    procedure Calcul(WithBase: boolean = True);

    procedure ClearDatas;
    procedure SaveData(F: TIniFile; Data: TPanel            ); overload;
    procedure SaveData(F: TIniFile; Data: TMemo             ); overload;
    procedure SaveData(F: TIniFile; Data: TCurvyMemo        ); overload;
    procedure SaveData(F: TIniFile; Data: TAdvEdit          ); overload;
    procedure SaveData(F: TIniFile; Data: TCheckBox         ); overload;
    procedure SaveData(F: TIniFile; Data: TAdvComboBox      ); overload;
    procedure SaveData(F: TIniFile; Data: TSpeedButton      ); overload;
    procedure SaveData(F: TIniFile; Data: TAdvColumnGrid    ); overload;
    procedure SaveDatas;
    procedure CreateHTML;

    function IsSaved: Boolean;
    function SaveFile : Boolean;
    procedure LoadData(F: TIniFile; Data: TPanel            ); overload;
    procedure LoadData(F: TIniFile; Data: TMemo             ); overload;
    procedure LoadData(F: TIniFile; Data: TCurvyMemo        ); overload;
    procedure LoadData(F: TIniFile; Data: TAdvEdit          ); overload;
    procedure LoadData(F: TIniFile; Data: TCheckBox         ); overload;
    procedure LoadData(F: TIniFile; Data: TAdvComboBox      ); overload;
    procedure LoadData(F: TIniFile; Data: TSpeedButton      ); overload;
    procedure LoadData(F: TIniFile; Data: TAdvColumnGrid    ); overload;
    procedure LoadDatas;

    procedure UpdateGrdButtons;
    procedure UpdateDetails;
  public
    { Déclarations publiques }
    function GetDirectory(No: integer): TFileName;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses System.DateUtils,
     System.IOUtils,
     System.StrUtils,
     System.Types,
     System.Math,
     System.UITypes,
     Vcl.Clipbrd,
     Winapi.ShellAPI,
     WinApi.MAPI,
     creation,
     System.AnsiStrings,
     REST.Utils,
     summary,
     wizard,
     kbob,
     clear,
     html;

//=== Tools ====================================================================

procedure TfrmMain.GetCurrentData(Id  : integer);
const
  SQL = 'SELECT Mandats.IDmandat, Mandats.Mandat AS Numéro, [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat] AS Code, [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat] & " " & [Désignation] AS Nom, '+
        'Mandats.Responsable, Mandats.Facture, Min(Heures.Date) AS De, Max(Heures.Date) AS A '+
        'FROM Mandats INNER JOIN Heures ON Mandats.IDmandat = Heures.IDmandat '+
        'WHERE (((Heures.Facturé)=No)) '+
        'GROUP BY Mandats.IDmandat, Mandats.Mandat, [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat], [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat] & " " & [Désignation], Mandats.Responsable, Mandats.Facture '+
        'HAVING (((Mandats.IDmandat)=%d) AND ((Mandats.Mandat)>1000));';
begin
  tabSQL.SQL.Text:=Format(SQL, [Id]);
  with tabSQL do begin
    Open;
    CD.IDmandat:=FieldByName('IDmandat').AsInteger;
    CD.Numéro:=FieldByName('Numéro').AsInteger;
    CD.Code:=FieldByName('Code').AsString;
    CD.Nom:=FieldByName('Nom').AsString;
    CD.Responsable:=FieldByName('Responsable').AsString;
    CD.De:=FieldByName('De').AsDateTime;
    CD.A:=FieldByName('A').AsDateTime;
    CD.Folder:=GetDirectory(CD.Numéro);
    CD.FABfile:='';
    CD.FABfile:=frmMain.SetFilename;
    CD.Modified:=False;
    CD.IsOpen:=0<RecordCount;
    edtAdresse.Lines.Text:=FieldByName('Facture').AsString;
    Close;
  end;
  with CD do begin
    pnlCode.Caption:=Code;
    edtObjet.Text:=Nom;
    edtResponsable.Text:=Responsable;
    edtDe.Date:=De;
    edtA.Date:=A;
  end;
end;

function TfrmMain.GetHTMLfile: TFileName;
begin
  Result:=ChangeFileExt(CD.FABfile, '.html');
end;

procedure TfrmMain.DisplayHint(Sender: TObject);
begin
  lblHint.HTMLText.Text:=Application.Hint;
end;

procedure TfrmMain.GetKBOB;
var i: integer;
begin
  if btnKBOB.Tag=0 then btnKBOB.Tag:=YearOf(Date);
  btnKBOB.Caption:=Format('KBOB %d', [btnKBOB.Tag]);
  with tabTarifs do begin
    Filter:=Format('(Classe>''A'') And (Classe<''H'') AND (Année=%d)', [btnKBOB.Tag]);
    Filtered:=True;
    Open;
    Sort:='Classe ASC';
    First;
    for i:=2 to 7 do begin
      Tarifs[i]:=FieldByName('Tarif').AsFloat;
      Next;
    end;
    Close;
  end;
end;

function TfrmMain.IsEmptyRow(row: TStrings): boolean;
begin
  Result:=(row[0]='') and (row[2]='') and (row[3]='') and (row[4]='');
end;

function TfrmMain.IsEmptyTable(table: TAdvColumnGrid): boolean;
begin
  Result:=(table.RowCount=3) and IsEmptyRow(table.Rows[1]);
end;

function TfrmMain.TableRowCount(table: TAdvColumnGrid): integer;
begin
  if IsEmptyTable(table) then
    Result:=0
  else
    Result:=table.RowCount-2;
end;

function TfrmMain.GridLinkIndex(name: string): integer;
var i: integer;
begin
  for i:=0 to 3 do
    if (GridLinks[i].name=name) or
       (GridLinks[i].grid.Name=name) or
       (GridLinks[i].panel.Name=name) or
       (GridLinks[i].splitter.Name=name) then begin
      Result:=i;
      Exit;
    end;
  Result:=-1;
end;

procedure TfrmMain.SetGridTitleCollapsed(idx: integer);
var n: integer;
begin
  n:=TableRowCount(GridLinks[idx].grid);
  if n=0 then
    GridLinks[idx].panel.Caption.Text:=GridLinks[idx].name
  else
    GridLinks[idx].panel.Caption.Text:=Format('%s <b>(%d)</b>', [GridLinks[idx].name, n])
end;

procedure TfrmMain.SetGridTitleExpanded(idx: integer);
var n: integer;
begin
  n:=TableRowCount(GridLinks[idx].grid);
  if n=0 then
    GridLinks[idx].panel.Caption.Text:='<b>'+GridLinks[idx].name+'</b>'
  else
    GridLinks[idx].panel.Caption.Text:=Format('<b>%s</b> (%d)', [GridLinks[idx].name, n]);
end;

procedure TfrmMain.SetGridTitle(table: TAdvColumnGrid);
var i: integer;
begin
  i:=GridLinkIndex(table.Name);
  if GridLinks[i].panel.Collaps then
    SetGridTitleCollapsed(i)
  else
    SetGridTitleExpanded(i)
end;

procedure TfrmMain.AdjustGridSize(table: TAdvColumnGrid; expand: integer);
var i, h, r: integer;
begin
  i:=GridLinkIndex(table.Name);
  GridLinks[i].panel.Collaps:=False;
  h:=GridLinks[i].panel.Caption.Height-4;
  for r:=0 to GridLinks[i].grid.RowCount-1 do
    h:=h+GridLinks[i].grid.RowHeights[r];
  GridLinks[i].panel.Height:=h+expand;
  GridLinks[i].panel.Collaps:=TableRowCount(GridLinks[i].grid)=0;
  table.TopRow:=1;
end;

function TfrmMain.GetDirectory(No: integer): TFileName;
var i, j: integer;
    folders: TStringDynArray;
    path : string;
begin
  Result:='';
  case No of
       0..1999 : begin
                   i:=1000;
                   j:=1999;
                 end;
    2000..2499 : begin
                   i:=2000;
                   j:=2499;
                 end;
    2500..2799 : begin
                   i:=100*(No div 100);
                   j:=i+99;
                 end
    else         begin
                   i:=50*(No div 50);
                   j:=i+49;
                 end;
  end;
  path:=Format('%s%d - %d', [FOmandats, i, j]);
  if DirectoryExists(path) then begin
    folders:=TDirectory.GetDirectories(path,IntToStr(No)+'*');
    if 0<Length(folders) then Result:=folders[0]
  end
  else
    Result:=''
end;

function TfrmMain.SetFilename: string;
var fs: TFormatSettings;
begin
  if CD.FABfile='' then begin
    fs:=TFormatSettings.Create;
    fs.ShortDateFormat:='yyyy-mm-dd';
    Result:=Format('%s F %s.fab', [CD.Code, DateToStr(date, fs)]);
  end
  else
    Result:=CD.FABfile;
end;

function TfrmMain.MemoLinkIndex(name: string): integer;
var i: integer;
begin
  for i:=0 to 3 do
    if (MemoLinks[i].name=name) or
       (MemoLinks[i].memo.Name=name) or
       (MemoLinks[i].panel.Name=name) or
       (MemoLinks[i].button.Name=name) or
       (MemoLinks[i].splitter.Name=name) then begin
      Result:=i;
      Exit;
    end;
  Result:=-1;
end;

procedure TfrmMain.SetMemoTitleCollapsed(idx: integer);
begin
  if MemoLinks[idx].memo.Lines.Count=0 then
    MemoLinks[idx].panel.Caption.Text:=MemoLinks[idx].name
  else
    MemoLinks[idx].panel.Caption.Text:=MemoLinks[idx].name+' <b>(+)</b>'
end;

procedure TfrmMain.SetMemoTitleExpanded(idx: integer);
begin
  MemoLinks[idx].panel.Caption.Text:='<b>'+MemoLinks[idx].name+'</b>'
end;

procedure TfrmMain.SetMemoTitle(idx: integer);
begin
  if MemoLinks[idx].panel.Collaps then
    SetMemoTitleCollapsed(idx)
  else
    SetMemoTitleExpanded(idx)
end;

//=== Settings =================================================================

procedure TfrmMain.UpdateHistory(filename: TFileName);
const IMAX = 10;
var i   : integer;
    item: TMenuItem;
begin
  i:=History.IndexOf(filename);
  if not FileExists(filename) then begin
    if -1<i then begin
      History.Delete(i);
      popHistory.Items.Delete(i);
    end;
    Exit;
  end;
  case i of
    -1 : begin
           History.Insert(0, filename);
           item:=TMenuItem.Create(nil);
           item.Caption:=ExtractFileName(filename);
           item.OnClick:=HistoryClick;
           item.ImageIndex:=0;
           popHistory.Items.Insert(0, item);
         end;
     0 : Exit;
    else begin
      History.Move(i, 0);
      item:=TMenuItem.Create(nil);
      item.Caption:=ExtractFileName(filename);
      item.OnClick:=HistoryClick;
      item.ImageIndex:=0;
      popHistory.Items.Delete(i);
      popHistory.Items.Insert(0, item);
    end
  end;
  if IMAX<History.Count then begin
    History.Delete(IMAX);
    popHistory.Items.Delete(IMAX);
  end;
end;

function TfrmMain.SettingsFilename: string;
begin
  Result:=GetEnvironmentVariable('APPDATA')+'\GéoPuce';
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
  Result:=Result+'\'+AppName+'.ini';
end;

procedure TfrmMain.SetDefaultPrices;
var i: integer;
begin
  with grdFacture do begin
    for i:=2 to 7 do Floats[3, i]:=Tarifs[i];
    Floats[3,16]:=Tarifs[8];
  end;
end;

procedure TfrmMain.SettingsLoad;
var i, n: integer;
    item: TMenuItem;
begin
  Controles:=TStringList.Create;
  with Controles do begin
    Add('frank.philippossian@beg-geol.ch');
    Add('jean.savary@beg-geol.ch');
    Add('regis.monnet@beg-geol.ch');
  end;
  Responsables:=TStringList.Create;
  with Responsables do begin
    NameValueSeparator:='|';
    Add('bl|barbara@beg-geol.ch');
    Add('bm|battista.matasci@beg-geol.ch');
    Add('fc|filipe.carrasco@beg-geol.ch');
    Add('dc|didier.cardis@beg-geol.ch');
    Add('fn|francois.negro@beg-geol.ch');
    Add('gg|gregory.grosjean@beg-geol.ch');
    Add('jr|julien.richon@beg-geol.ch');
    Add('jt|julien.travelletti@beg-geol.ch');
    Add('mf|maria.fonticoba@beg-geol.ch');
    Add('md|michael.digout@beg-geol.ch');
    Add('rs|romain.sonney@beg-geol.ch');
    Add('ss|sebastien.simoens@beg-geol.ch');
    Add('vb|vincent.boitelet@beg-geol.ch');
  end;
  with TIniFile.Create(SettingsFilename) do begin
{$IFNDEF test}
    DBmandats:=ReadString(AppName, 'Base'         , DBmandats);
    DBpenetro:=ReadString(AppName, 'Pénétromètres', DBpenetro);
    FOmandats:=ReadString(AppName, 'Mandats'      , FOmandats);
{$ENDIF}
    Comptable:=ReadString(AppName, 'Comptable'    , Comptable);
    Favorite :=ReadString(AppName, 'Favori'       , Favorite);
    Hints    :=ReadBool  (AppName, 'Hint'         , Hints);
    btnHint.Down:=Hints;
    lblHint.Visible:=Hints;

    Tarifs[8]:=ReadFloat('Tarifs', 'km', Tarifs[8]);
    TVA:=ReadFloat('Tarifs', 'TVA', TVA);

    with grdPenetro do begin
      Cells[2, 1]:=ReadString('Pénétromètre', 'Installation', '600');
      Cells[2, 2]:=ReadString('Pénétromètre', 'Déplacement', '50');
      Cells[2, 3]:=ReadString('Pénétromètre', '0-5m', '35');
      Cells[2, 4]:=ReadString('Pénétromètre', '5-10m', '40');
      Cells[2, 5]:=ReadString('Pénétromètre', '10-15m', '48');
      Cells[2, 6]:=ReadString('Pénétromètre', '15-20m', '55');
      Cells[2, 7]:=ReadString('Pénétromètre', '100cps', '30');
      Cells[2, 8]:=ReadString('Pénétromètre', 'Graphique', '25');
      Cells[2, 9]:=ReadString('Pénétromètre', 'Km', '1.6');
      Cells[4, 1]:=Cells[2, 1];
      Cells[4,10]:=Cells[2, 1];
    end;

    Left  :=ReadInteger('Window', 'Left', Left  );
    Top   :=ReadInteger('Window', 'Top' , Top   );
    Width :=ReadInteger('Window', 'Width' , Width );
    Height:=ReadInteger('Window', 'Height' , Height);
    grdFactures.Width:=ReadInteger('Window', 'grdFactures' , grdFactures.Width );
    grdFacture.Width:=ReadInteger('Window', 'grdFacture' , grdFacture.Width );
    Panel18.Width:=ReadInteger('Window', 'Panel18' , Panel18.Width );
    grdAllPrepared.Width:=ReadInteger('Window', 'grdAllPrepared' , grdAllPrepared.Width );

    n:=ReadInteger('Visas', 'Count', 0);
    if n<>0 then begin
      edtVisa.Items.Clear;
      for i:=0 to n-1 do
        edtVisa.Items.Add(ReadString('Visas', 'Visa'+IntToStr(i+1), ''));
    end;
    n:=ReadInteger('Visas', 'Mails', 0);
    if n<>0 then begin
      Controles.Clear;
      for i:=0 to n-1 do
        Controles.Add(ReadString('Visas', 'Mail'+IntToStr(i+1), ''));
    end;
    n:=ReadInteger('Responsables', 'Responsables', 0);
    if n<>0 then begin
      Responsables.Clear;
      for i:=0 to n-1 do
        Responsables.Add(ReadString('Responsables', 'Responsable'+IntToStr(i+1), ''));
    end;

    History:=TStringList.Create;
    n:=ReadInteger('History', 'Count', 0);
    if n<>0 then
      for i:=0 to n-1 do begin
        History.Add(ReadString('History', 'File'+IntToStr(i+1), ''));
        item:=TMenuItem.Create(nil);
        item.Caption:=ExtractFileName(ReadString('History', 'File'+IntToStr(i+1), ''));
        item.OnClick:=HistoryClick;
        item.ImageIndex:=0;
        popHistory.Items.Add(item);
      end;

    Free;
  end;

  if not FileExists(DBmandats) then begin
    MessageDlg('La base des heures (BEGdatas.mdb) est introuvable.'#13#13+
               'Il faut préciser son chemin.',
               mtWarning, [mbOk], 0);
    dlgDatas.FileName:='BEGdatas.mdb';
    dlgDatas.Filter:='Base des heures du BEG|BEGdatas.mdb';
    if dlgDatas.Execute then
      DBmandats:=dlgDatas.FileName
    else
      MessageDlg('La base de donnée des heures est introuvable.'#13+
                 'Le programme ne peut pas fonctionner !'#13+
                 'Il faut s''adresser à l''administrateur réseau.',
                 mtError, [mbOk], 0)
  end;
  if FileExists(DBmandats) and not FileExists(DBpenetro) then begin
    MessageDlg('La base des pénétromètres (peneBEG.mdb) est introuvable.'#13#13+
               'Il faut préciser son chemin.',
               mtWarning, [mbOk], 0);
    dlgDatas.FileName:='peneBEG.mdb';
    dlgDatas.Filter:='Base des pénétromètres|peneBEG.mdb';
    if dlgDatas.Execute then
      DBpenetro:=dlgDatas.FileName
  end;
end;

procedure TfrmMain.SettingsSave;
var i: integer;
begin
  with TIniFile.Create(SettingsFilename) do begin
{$IFNDEF test}
    WriteString(AppName, 'Base'         , DBmandats);
    WriteString(AppName, 'Pénétromètres', DBpenetro);
    WriteString(AppName, 'Mandats'      , FOmandats);
{$ENDIF}
    WriteString(AppName, 'Comptable'    , Comptable);
    WriteBool  (AppName, 'Hint'         , Hints);
    WriteString(AppName, 'Favori'       , Favorite);
    WriteFloat('Tarifs', 'km', Tarifs[8]);
    WriteFloat('Tarifs', 'TVA', TVA);
    WriteInteger('Visas', 'Count', edtVisa.Items.Count);
    WriteInteger('Visas', 'Mails', edtVisa.Items.Count);
    for i:=0 to edtVisa.Items.Count-1 do begin
      WriteString('Visas', 'Visa'+IntToStr(i+1), edtVisa.Items[i]);
      WriteString('Visas', 'Mail'+IntToStr(i+1), Controles[i]);
    end;
    WriteInteger('Responsables', 'Responsables', Responsables.Count);
    for i:=0 to Responsables.Count-1 do
      WriteString('Responsables', 'Responsable'+IntToStr(i+1), Responsables[i]);
    with grdPenetro do begin
      WriteString('Pénétromètre', 'Installation', Cells[2, 1]);
      WriteString('Pénétromètre', 'Déplacement', Cells[2, 2]);
      WriteString('Pénétromètre', '0-5m', Cells[2, 3]);
      WriteString('Pénétromètre', '5-10m', Cells[2, 4]);
      WriteString('Pénétromètre', '10-15m', Cells[2, 5]);
      WriteString('Pénétromètre', '15-20m', Cells[2, 6]);
      WriteString('Pénétromètre', '100cps', Cells[2, 7]);
      WriteString('Pénétromètre', 'Graphique', Cells[2, 8]);
      WriteString('Pénétromètre', 'Km', Cells[2, 9]);
    end;
    if WindowState<>wsNormal then WindowState:=wsNormal;
    WriteInteger('Window', 'Left', Left);
    WriteInteger('Window', 'Top',  Top );
    WriteInteger('Window', 'Width' , Width );
    WriteInteger('Window', 'Height' , Height);
    WriteInteger('Window', 'grdFactures' , grdFactures.Width );
    WriteInteger('Window', 'grdFacture' , grdFacture.Width );
    WriteInteger('Window', 'Panel18' , Panel18.Width );
    WriteInteger('Window', 'grdAllPrepared' , grdAllPrepared.Width );
    WriteInteger('History', 'Count', History.Count);
    for i:=0 to History.Count-1 do
      WriteString('History', 'File'+IntToStr(i+1), History[i]);
  end;
end;

//=== Files write ==============================================================

procedure TfrmMain.ClearDatas;
var i: integer;
begin
  edtAdresse.Lines.Clear;
  edtEnvoi.Lines.Clear;
  edtOffreMontant.Text:='0';
  edtType.ItemIndex:=0;
  edtSituations.Text:='0';
  edtMode.ItemIndex:=0;
  edtPrepare.Text:='';
  for i:=0 to 3 do begin
    with GridLinks[i].grid do begin
      RemoveRows(1, RowCount-3);
      ClearRows(1, 1);
      AddExpand(3, 1, 3*RowHeights[0]);
      AdjustGridSize(GridLinks[i].grid, 0);
    end;
    GridLinks[i].panel.Collaps:=True;
  end;
  edtPrestations.Lines.Clear;
  edtComment.Lines.Clear;
  edtResponsable.Text:='';
  edtVisa.ItemIndex:=-1;
  edtVisaDate.Text:=DateToStr(Date);
  edtLast.Text:=DateToStr(Date);
  edtBon.Checked:=False;
//correction2.3: saisie des valeurs paramétrées
  with grdFacture do begin
    Floats[1, 2]:=0;
    Floats[2, 2]:=0;
    Floats[3, 2]:=0;
    Floats[1, 3]:=0;
    Floats[2, 3]:=0;
    Floats[3, 3]:=0;
    Floats[4, 3]:=0;
    Floats[1, 4]:=0;
    Floats[2, 4]:=0;
    Floats[3, 4]:=0;
    Floats[4, 4]:=0;
    Floats[1, 5]:=0;
    Floats[2, 5]:=0;
    Floats[3, 5]:=0;
    Floats[4, 5]:=0;
    Floats[1, 6]:=0;
    Floats[2, 6]:=0;
    Floats[3, 6]:=0;
    Floats[4, 6]:=0;
    Floats[1, 7]:=0;
    Floats[2, 7]:=0;
    Floats[3, 7]:=0;
    Floats[4, 7]:=0;
    Floats[1, 8]:=0;
    Floats[2, 8]:=0;
    Floats[4, 8]:=0;
    Floats[4, 9]:=0;
    Floats[4,10]:=0;
    Floats[3,11]:=0;
    Floats[4,11]:=0;
    Floats[4,12]:=0;
    Floats[1,13]:=0;
    Floats[1,16]:=0;
    Floats[2,16]:=0;
    Floats[3,16]:=0;
    Floats[4,16]:=0;
    Floats[1,17]:=0;
    Floats[4,17]:=0;
    Floats[4,18]:=0;
    Floats[3,20]:=4;
    Floats[4,20]:=0;
    Floats[4,21]:=0;
    Floats[4,22]:=0;
    Floats[4,24]:=0;
//ajout2.3
    Floats[4,25]:=TVA; //TVA
    Floats[4,26]:=0;  //TOTAL TTC
  end;

  for i:=0 to 3 do begin
    MemoLinks[i].memo.Lines.Clear;
    MemoLinks[i].panel.OnMinimize(MemoLinks[i].panel);
  end;

  SetDefaultPrices;
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TPanel);
begin
  F.WriteString('DATAS', Data.Name, Data.Caption);
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TMemo);
var i: integer;
begin
  F.WriteInteger('DATAS', Data.Name+'count', Data.Lines.Count);
  for i:=0 to Data.Lines.Count-1 do
    F.WriteString('DATAS', Data.Name+IntToStr(i), Data.Lines[i]);
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TCurvyMemo);
var i: integer;
begin
  F.WriteInteger('DATAS', Data.Name+'count', Data.Lines.Count);
  for i:=0 to Data.Lines.Count-1 do
    F.WriteString('DATAS', Data.Name+IntToStr(i), Data.Lines[i]);
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TAdvEdit);
begin
  F.WriteString('DATAS', Data.Name, Data.Text);
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TCheckBox);
begin
  F.WriteBool('DATAS', Data.Name, Data.Checked);
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TAdvComboBox);
begin
  F.WriteInteger('DATAS', Data.Name, Data.ItemIndex);
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TSpeedButton);
begin
  F.WriteBool('DATAS', Data.Name, Data.Down);
end;

procedure TfrmMain.SaveData(F: TIniFile; Data: TAdvColumnGrid);
var r, c: integer;
begin
  with Data do begin
    F.WriteInteger('DATAS', Data.Name+'RowCount', RowCount);
    F.WriteInteger('DATAS', Data.Name+'ColCount', ColCount);
    for r:=0 to RowCount-1 do
      for c:=0 to ColCount-1 do
        F.WriteString('DATAS', Format('%s%d.%d', [Data.Name, r, c]), Cells[c, r]);
  end;
end;

//gestion dangereuse des erreurs: évite des problèmes mais un fichier peut-être
//imparfaitement sauvé, mais si bug, noté dans le fichier
procedure TfrmMain.SaveDatas;
var f   : TIniFile;
    IsOk: boolean;
begin
  f:=TIniFile.Create(CD.FABfile);
  f.EraseSection('DATAS');
  f.EraseSection('CHECK');
try
  IsOk:=False;

  f.WriteInteger('INTERNAL', 'IDmandat', CD.IDmandat);
  f.WriteInteger('INTERNAL', 'Numéro', CD.Numéro);
  f.WriteString('INTERNAL', 'Code', CD.Code);
  f.WriteDate('INTERNAL', 'De', CD.De);
  f.WriteDate('INTERNAL', 'A', CD.A);
  f.WriteInteger('INTERNAL', 'KBOB', btnKBOB.Tag);

  SaveData(f, pnlCode);
  SaveData(f, edtObjet);
  SaveData(f, edtPériode);
  SaveData(f, edtAdresse);
  SaveData(f, edtEnvoi);
  SaveData(f, edtType);
  SaveData(f, edtMode);
  SaveData(f, edtPrestations);
  SaveData(f, edtComment);
  SaveData(f, edtResponsable);
  SaveData(f, edtVisa);
  SaveData(f, edtVisaDate);
  edtLast.Text:=DateToStr(Date);
  SaveData(f, edtLast);
  SaveData(f, edtBon);

  SaveData(f, edtOffreMontant);
  SaveData(f, edtSituations);
  SaveData(f, edtPrepare);
  SaveData(f, grdOffres);
  SaveData(f, grdAdjudications);
  SaveData(f, grdSituations);
  SaveData(f, grdDocuments);

  SaveData(f, grdFacture);
  SaveData(f, btnRabais);
  SaveData(f, btnFraisType);
  SaveData(f, btnFrais);
  SaveData(f, memAutres);
  SaveData(f, memKm);
  SaveData(f, memFrais);
  SaveData(f, memTiers);
  IsOk:=True;
finally
  f.WriteBool('CHECK', 'FullSaved', IsOk);
  f.Free;
  CD.Modified:=False;
  UpdateHistory(CD.FABfile);
  CreateHTML;

//pour que ça marche avec les factures vides ou non
  with tabListeDesFactures do begin
    Open;
    if Locate('IDmandat;FullPath', VarArrayOf([CD.IDmandat, CD.FABfile]), []) then begin
      Edit;
      FieldByName('Modified').AsDateTime:=Date;
      Post;
    end
    else
      InsertRecord([CD.IDmandat, ExtractFileName(CD.FABfile), CD.FABfile, Date]);
    Close;
  end;
  tabPrepared.Requery;
  tabAllPrepared.Requery;
end;
end;

procedure TfrmMain.CreateHTML;
var html    : THTML;
    filename: TFileName;

  procedure AddTable;
  var r: integer;
  begin
    with html do begin
      OpenFacture('Honoraires');
      Facture('Classe', 'Heures', 'Tarif', 'Montant');
      for r:=2 to 7 do
        if grdFacture.Floats[4, r]<>0 then
          Facture(grdFacture.Cells[0, r],
                  grdFacture.Cells[2, r],
                  grdFacture.Cells[3, r],
                  grdFacture.Cells[4, r]);
      Facture('Total h.',
              grdFacture.cells[2, 8],
              grdFacture.Cells[4, 8]);
      if grdFacture.Floats[4, 9]<>0 then begin
        Facture('Autres prestations (1)', grdFacture.Cells[4, 9]);
        Facture('Total', grdFacture.Cells[4, 10]);
      end;
      if grdFacture.Floats[4, 11]<>0 then begin
        if grdFacture.Cells[1, 11]='au pourcent' then
          Facture('Rabais au %', grdFacture.Cells[3, 11]+'%', grdFacture.Cells[4, 11])
        else
          Facture('Rabais au forfait', grdFacture.Cells[4, 11]);
        Facture('TOTAL', grdFacture.Cells[4, 12]);
      end;
      CloseTable;
      if grdFacture.Floats[4, 22]<>0 then begin
        OpenFacture('Frais');
        if grdFacture.Cells[4, 19]='Forfait v' then begin
          if grdFacture.Cells[1, 20]='au pourcent' then
            Facture('Frais BEG au %', grdFacture.Cells[3, 20]+'%', grdFacture.Cells[4, 20])
          else
            Facture('Frais BEG au forfait', grdFacture.Cells[4, 20]);
        end
        else begin
          if grdFacture.Floats[4, 16]<>0 then
            Facture('Km (2)',
                    grdFacture.Cells[2, 16],
                    grdFacture.Cells[3, 16],
                    grdFacture.Cells[4, 16]);
          if grdFacture.Floats[4, 17]<>0 then
            Facture('Frais (3)', grdFacture.Cells[4, 17]);
        end;
        if grdFacture.Floats[4, 21]<>0 then
          Facture('Frais de tiers (4)', grdFacture.Cells[4, 21]);
        Facture('Total des frais', grdFacture.Cells[4, 22]);
        CloseTable;
      end;
      OpenFacture('Montant total');
      Facture('TOTAL HT', grdFacture.Cells[4, 24]);
//ajout2.3 TVA+TTC
      Facture('TVA', grdFacture.Cells[3, 25]+'%', grdFacture.Cells[4, 25]);
      Facture('TOTAL TTC', grdFacture.Cells[4, 26]);
      CloseTable;
    end;
  end;

  procedure AddList(grid: TAdvColumnGrid; t: string);
  var i: integer;
  begin
    with html, grid do begin
      if not IsEmptyRow(Rows[1]) then begin
        OpenDocument('Liste des '+t);
        for i:=1 to RowCount-2 do
            Document(Cells[1, i],
                     FileLink(Cells[4, i]),
                     Cells[3, i]);
        CloseTable;
      end;
    end;
  end;

  function FormatMemo(memo: TStrings): string;
  var i: integer;
  begin
    Result:='';
    for i:=0 to memo.Count-1 do
      if i=0 then
        Result:=memo[i]
      else
        Result:=Result+'<br>'+memo[i]
  end;

begin
  filename:=GetHTMLfile;

  html:=THTML.Create('Facture '+CD.Code);
  with html do begin
    OpenInformation('Informations pour la comptabilité');
    Information('Type de facture', edtType.Text);
    Information('Responsable', edtResponsable.Text);
    if edtBon.Checked then
      Information('Visa', edtVisa.Text+' le '+edtVisaDate.Text)
    else
      Information('Pas de visa', edtVisa.Text);
    Information('Dernière modification', edtLast.Text);
    Information('Tarif', btnKBOB.Caption);
    Information('Remarques', FormatMemo(edtComment.Lines));
    Information('Fichier de facturation', FileLink(CD.FABfile));
    CloseTable;

    OpenInformation('Facture');
    Information('Adresse de facturation', FormatMemo(edtAdresse.Lines));
    if 0<edtEnvoi.Lines.Count then
      Information('Adresse d''envoi', FormatMemo(edtEnvoi.Lines));
    InformationObjet('Objet', edtObjet.Text);
    Information('Période de facturation', edtPériode.Text);
    Information('Prestations', FormatMemo(edtPrestations.Lines));

    case edtMode.ItemIndex of
      0: begin
           CloseTable;
           AddTable;
           if 0<memAutres.Lines.Count+memKm.Lines.Count+memFrais.Lines.Count+memTiers.Lines.Count then begin
             Add('<br>');
             OpenInformation;
             if 0<memAutres.Lines.Count then
               Information('1) Autres prestations', FormatMemo(memAutres.Lines));
             if 0<memKm.Lines.Count then
               Information('2) Frais de déplacement', FormatMemo(memKm.Lines));
             if 0<memFrais.Lines.Count then
               Information('3) Autres frais', FormatMemo(memFrais.Lines));
             if 0<memTiers.Lines.Count then
               Information('4) Frais de tiers', FormatMemo(memTiers.Lines));
           end;
         end;
      1: begin
           Information('Mode de facturation', 'A faire selon l''offre');
           CloseTable;
         end;
      2: begin
           Information('Mode de facturation', 'A faire selon la facture préparée');
           Information('Facture préparée', FileLink(edtPrepare.Text));
           CloseTable;
         end;
      3: begin
           Information('Mode de facturation', 'Forfait (voir remarques à la comptabilité)');
           CloseTable;
         end;
    end;

    OpenInformation('Liste des documents');
    CloseTable;
    AddList(grdOffres, 'offres');
    AddList(grdAdjudications, 'adjudications');
    AddList(grdSituations, 'situations');
    AddList(grdDocuments, 'documents');
    CloseHTML(Format('%s %s %s', [AppInfo.ProductName,
                                  AppInfo.ProductVersion,
                                  AppInfo.LegalCopyright]));

    SaveToFile(filename);
    Free;
  end;
end;

//=== Files read ===============================================================

function TfrmMain.IsSaved: Boolean;
begin
  if CD.Modified then
    case MessageDlg('Les données ont été modifiées.'#13'Voulez-vous les sauver ?',
                    mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes   : Result:=SaveFile;
      mrNo    : Result:=True;
      mrCancel: Result:=False;
    end
  else
    Result:=True;
end;

function TfrmMain.SaveFile: Boolean;
begin
  if ExtractFilePath(CD.FABfile)='' then
    with dlgSave do begin
      InitialDir:=CD.Folder;
      FileName:=SetFilename;
      if not Execute then begin
        Result:=False;
        Exit;
      end;
      CD.FABfile:=FileName;
    end;
  SaveDatas;
  Result:=True;
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TPanel);
begin
  Data.Caption:=F.ReadString('DATAS', Data.Name, '');
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TMemo);
var i, n: integer;
begin
  n:=F.ReadInteger('DATAS', Data.Name+'count', 0);
  for i:=0 to n-1 do
    Data.Lines.Add(F.ReadString('DATAS', Data.Name+IntToStr(i), ''));
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TCurvyMemo);
var i, n: integer;
begin
  n:=F.ReadInteger('DATAS', Data.Name+'count', 0);
  for i:=0 to n-1 do
    Data.Lines.Add(F.ReadString('DATAS', Data.Name+IntToStr(i), ''));
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TAdvEdit);
begin
  Data.Text:=F.ReadString('DATAS', Data.Name, '');
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TCheckBox);
begin
  Data.Checked:=F.ReadBool('DATAS', Data.Name, False);
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TAdvComboBox);
begin
  Data.ItemIndex:=F.ReadInteger('DATAS', Data.Name, 0);
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TSpeedButton);
begin
  Data.Down:=F.ReadBool('DATAS', Data.Name, True);
end;

procedure TfrmMain.LoadData(F: TIniFile; Data: TAdvColumnGrid);
var r, c, nr, nc: integer;
begin
  with Data do
    if Name='grdFacture' then begin
//correction2.3: pour raison de compatibilité ascendante,
//les 2 dernières lignes TVA+TTC ne sont pas lues
      for r:=0 to RowCount-3{<2.3=1} do
        for c:=0 to ColCount-1 do
          Cells[c, r]:=F.ReadString('DATAS', Format('%s%d.%d', [Name, r, c]), '');
    end
    else begin
      nr:=F.ReadInteger('DATAS', Name+'RowCount', 0);
      nc:=F.ReadInteger('DATAS', Name+'ColCount', 0);
      RowCount:=nr;
      for r:=0 to nr-1 do begin
        for c:=0 to nc-1 do
          Cells[c, r]:=F.ReadString('DATAS', Format('%s%d.%d', [Name, r, c]), '');
        if (0<r) and (r<nr-1) then
          AddExpand(3, r, 3*RowHeights[0]);
      end;
      AdjustGridSize(Data, 0);
      Sort(1);
    end;
end;

//ajout2.3: contrôle de l'intégrité du fichier
procedure TfrmMain.LoadDatas;
const
  SQL = 'SELECT Mandats.IDmandat, Mandats.Mandat AS Numéro, [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat] AS Code, [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat] & " " & [Désignation] AS Nom, '+
        'Mandats.Responsable, Mandats.Facture, Min(Heures.Date) AS De, Max(Heures.Date) AS A'#13+
        'FROM Mandats INNER JOIN Heures ON Mandats.IDmandat = Heures.IDmandat'#13+
        'WHERE (((Heures.Facturé)=No))'#13+
        'GROUP BY Mandats.IDmandat, Mandats.Mandat, [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat], [Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat] & " " & [Désignation], Mandats.Responsable, Mandats.Facture'#13+
        'HAVING (((Mandats.Mandat)>1000) AND (([Mandat] & IIf(IsNull([Sous-Mandat]),""," ") & [Sous-Mandat])="%s"));';
var f   : TIniFile;
    i   : integer;
    IsOk: boolean;
begin
  atsDatas.TabEnable:=True;
  atsDétail.TabEnable:=True;
  atsPénétro.TabEnable:=True;
  apcMain.ActivePage:=atsDatas;
  Application.ProcessMessages;

  UpdateHistory(CD.FABfile);

try
  IsOk:=False;
  ClearDatas;
  f:=TIniFile.Create(CD.FABfile);
  if not f.ReadBool('CHECK', 'FullSaved', True) then
    MessageDlg('Il semblerait qu''il y ait eu une erreur de sauvegarde'#13+
               'Vérifiez s''il manque des données avant de continuer de travailler.'#13+
               'Il suffit peut-être de relancer le programme pour que ça marche.'#13#13+
               'Et merci d''envoyez ce fichier sans le modifier à l''auteur du programme.', mtWarning, [mbOK], 0);

  CD.IDmandat:=f.ReadInteger('INTERNAL', 'IDmandat', 0);
  CD.Numéro:=f.ReadInteger('INTERNAL', 'Numéro', 0);
  CD.Code:=f.ReadString('INTERNAL', 'Code', '');
  CD.De:=f.ReadDate('INTERNAL', 'De', 0);
  CD.A:=f.ReadDate('INTERNAL', 'A', 0);

  i:=f.ReadInteger('INTERNAL', 'KBOB', 0);
//pour la compatibilité ascendante
  if i=0 then btnKBOB.Tag:=2014 else btnKBOB.Tag:=i;
  GetKBOB;

  LoadData(f, pnlCode);
  LoadData(f, edtObjet);
  LoadData(f, edtPériode);
  LoadData(f, edtAdresse);
  LoadData(f, edtEnvoi);
  LoadData(f, edtType);
  LoadData(f, edtMode);
  LoadData(f, edtPrestations);
  LoadData(f, edtComment);
  LoadData(f, edtResponsable);
  LoadData(f, edtVisa);
  LoadData(f, edtVisaDate);
  LoadData(f, edtLast);
  LoadData(f, edtBon);

  LoadData(f, edtOffreMontant);
  LoadData(f, edtSituations);
  LoadData(f, edtPrepare);
  LoadData(f, grdOffres);
  LoadData(f, grdAdjudications);
  LoadData(f, grdSituations);
  LoadData(f, grdDocuments);

  LoadData(f, grdFacture);
  LoadData(f, btnRabais);
  LoadData(f, btnFraisType);
  LoadData(f, btnFrais);
  LoadData(f, memAutres);
  LoadData(f, memKm);
  LoadData(f, memFrais);
  LoadData(f, memTiers);
  f.Free;

//  CD.Code:=pnlCode.Caption;
  CD.Nom:=edtObjet.Text;
  CD.Responsable:=edtResponsable.Text;
//pour la compatibilité ascendante
//  if CD.IDmandat=0 then begin
//    CD.De:=edtDe.Date;
//    CD.A:=edtA.Date;
//  end;
//fin de la compatibilité ascendante
  tabSQL.SQL.Text:=Format(SQL, [CD.Code]);
  with tabSQL do begin
    Open;
    if Eof then
      CD.IsOpen:=False
    else begin
      CD.IDmandat:=FieldByName('IDmandat').AsInteger;
      CD.Numéro:=FieldByName('Numéro').AsInteger;
      CD.De:=FieldByName('De').AsDateTime;
      CD.A:=FieldByName('A').AsDateTime;
      CD.IsOpen:=True;
      edtDe.Date:=CD.De;
      edtA.Date:=CD.A;
    end;
    Close;
  end;
//pour la compatibilité ascendante
//  if CD.IDmandat=0 then
//    with tabTous do begin
//      Open;
//      Locate('Code', pnlCode.Caption, []);
//      CD.IDmandat:=tabTous.FieldByName('IDmandat').AsInteger;
//      CD.Numéro:=tabTous.FieldByName('Numéro').AsInteger;
//      Close;
//    end;
//fin de la compatibilité ascendante
  CD.Folder:=GetDirectory(CD.Numéro);

  Application.ProcessMessages;
  UpdateGrdButtons;
  Calcul;

  for i:=0 to 3 do SetMemoTitle(i);
  UpdateDetails();
  CD.Modified:=False;
  IsOk:=True;
finally
  if not IsOk then
    MessageDlg('Il semblerait qu''il y ait eu une erreur de chargement du fichier.'#13+
               'Vérifiez s''il manque des données avant de continuer de travailler.'#13+
               'Il suffit peut-être de relancer le programme pour que ça marche.'#13#13+
               'Et merci d''envoyez ce fichier sans le modifier à l''auteur du programme.', mtWarning, [mbOK], 0);
end;
end;

//=== Buttons ==================================================================

procedure TfrmMain.btnMemoClick(Sender: TObject);
var i: integer;
begin
  i:=MemoLinkIndex(TControl(Sender).Name);
  MemoLinks[i].panel.Collaps:=not MemoLinks[i].button.Down
end;

procedure TfrmMain.btnBugClick(Sender: TObject);
begin
  with Mail do begin
    Clear;
    Recipient.Add.Address:='jean.savary@beg-geol.ch';
    Subject:='BEGfacture: problèmes ou/et suggestions';
    Mail.SendMail(True);
  end;
end;

procedure TfrmMain.btnCopyAdresseClick(Sender: TObject);
begin
  Clipboard.AsText:=edtAdresse.Lines.Text;
end;

procedure TfrmMain.btnCopyDescriptionClick(Sender: TObject);
begin
  Clipboard.AsText:=edtPrestations.Lines.Text;
end;

procedure TfrmMain.btnCopyDocsClick(Sender: TObject);
var i: integer;
begin
  with grdDocuments do
    for i:=1 to RowCount-2 do
      if not Cells[3, i].IsEmpty then
        edtPrestations.Lines.Add(Cells[3, i]+' ('+Cells[1, i]+')')
end;

procedure TfrmMain.btnCopyEnvoiClick(Sender: TObject);
begin
  Clipboard.AsText:=edtEnvoi.Lines.Text;
end;

procedure TfrmMain.btnCopyPenetroClick(Sender: TObject);
begin
  grdPenetro.CopyToClipBoard;
  with memAutres do begin
    Lines.Add('Pénétromètre:');
    Lines.Text:=memAutres.Lines.Text+Clipboard.AsText;
  end;
  btnPastePenetroClick(Sender);
end;

procedure TfrmMain.btnCopySumOffresClick(Sender: TObject);
begin
  edtOffreMontant.Text:=grdOffres.Cells[2, grdOffres.RowCount-1];
end;

procedure TfrmMain.btnCopySumSituationsClick(Sender: TObject);
begin
  edtSituations.Text:=grdSituations.Cells[2, grdSituations.RowCount-1];
end;

procedure TfrmMain.btnCreateClick(Sender: TObject);
var p: TPoint;
begin
  if not IsSaved then Exit;
  with TdlgCreate.Create(self) do begin
    p.X:=0;
    p.Y:=btnCreate.Height;
    p:=btnCreate.ClientToScreen(p);
    Left:=p.X;
    Top:=p.Y;
    tabTous.Open;
    tabTous.Filtered:=False;
    if ShowModal=mrOk then begin
      atsDatas.TabEnable:=True;
      atsDétail.TabEnable:=True;
      atsPénétro.TabEnable:=True;
      ClearDatas;

      GetCurrentData(tabTous.FieldByName('IDmandat').AsInteger);
      if not CD.IsOpen then begin
        CD.IDmandat:=tabTous.FieldByName('IDmandat').AsInteger;
        CD.Numéro:=tabTous.FieldByName('Numéro').AsInteger;
        CD.Code:=tabTous.FieldByName('Code').AsString;
        CD.Nom:=tabTous.FieldByName('Nom').AsString;
        CD.Responsable:=tabTous.FieldByName('Responsable').AsString;
        CD.De:=Date;
        CD.A:=Date;
        CD.Folder:=GetDirectory(CD.Numéro);
        CD.FABfile:=frmMain.SetFilename;
        CD.Modified:=True;
        pnlCode.Caption:=CD.Code;
        edtObjet.Text:=CD.Nom;
        edtResponsable.Text:=CD.Responsable;
        edtAdresse.Lines.Text:=tabTous.FieldByName('Facture').AsString;
        edtPériode.Text:='Dès le '+DateToStr(CD.De);
      end;
      btnRefreshDetails.Click;
      apcMain.ActivePage:=atsDatas;
      btnOpenFolder.Click;
    end;
    Free;
    tabTous.Close;
  end;
end;

procedure TfrmMain.btnDelFactureClick(Sender: TObject);
begin
  if edtPrepare.Text='' then Exit;
  if MessageDlg('Confirmez la suppression de la facture', mtInformation, [mbYes, mbNo], 0)=mrYes then begin
    edtPrepare.Text:='';
    DatasChanged(Sender)
  end;
end;

procedure TfrmMain.btnFraisClick(Sender: TObject);
begin
  UpdateGrdButtons;
end;

procedure TfrmMain.btnFraisTypeClick(Sender: TObject);
begin
  UpdateGrdButtons;
  Calcul(False);
end;

procedure TfrmMain.btnHintClick(Sender: TObject);
begin
  Hints:=not Hints;
  lblHint.Visible:=Hints;
  if Hints then
    ClientHeight:=ClientHeight+lblHint.Height
  else
    ClientHeight:=ClientHeight-lblHint.Height
end;

procedure TfrmMain.btnKBOBClick(Sender: TObject);
var p: TPoint;
begin
  tabTarifs.Open;
  with TdlgKBOB.Create(self) do begin
    p.X:=0;
    p.Y:=btnKBOB.Height;
    p:=btnKBOB.ClientToScreen(p);
    Left:=p.X;
    Top:=p.Y;
    edtYear.MaxValue:=YearOf(Date);
    if btnKBOB.Tag=0 then
      edtYear.Value:=YearOf(Date)
    else
      edtYear.Value:=btnKBOB.Tag;
    if ShowModal=mrOk then begin
      btnKBOB.Tag:=edtYear.Value;
      GetKBOB;
      SetDefaultPrices;
      Calcul;
    end;
    Free;
  end;
  tabTarifs.Close;
end;

procedure TfrmMain.btnRabaisClick(Sender: TObject);
begin
  UpdateGrdButtons;
end;

procedure TfrmMain.btnRefreshDetailsClick(Sender: TObject);
begin
  UpdateDetails;
end;

procedure TfrmMain.btnRefreshFacturesClick(Sender: TObject);
begin
  adoDatas.Close;
  adoDatas.Open();
  actFavorite.Execute;
end;

procedure TfrmMain.btnWizardClick(Sender: TObject);

  procedure SetGrid(Source, Cible: TAdvColumnGrid);
  var i : integer;
  begin
    for i:=1 to Source.RowCount-1 do begin
      if i=1 then
        Cible.Rows[i].Assign(Source.Rows[1])
      else begin
        Cible.InsertRows(i, 1);
        Cible.Rows[i].Assign(Source.Rows[i]);
      end;
      Cible.AddExpand(3, i, 3*Cible.RowHeights[0]);
    end;
    AdjustGridSize(Cible, 0);
    GridLinks[GridLinkIndex(Cible.Name)].panel.Collaps:=False;
    SetGridTitle(Cible);
  end;

begin
  if not IsSaved then Exit;
  dlgWizard:=TdlgWizard.Create(Application);
  dlgWizard.edtResponsable.Value:=tabResponsables.FieldByName('Responsable').AsString;
  dlgWizard.edtVisa.Items.Assign(edtVisa.Items);
  if dlgWizard.ShowModal=mrOk then begin
    atsDatas.TabEnable:=True;
    atsDétail.TabEnable:=True;
    atsPénétro.TabEnable:=True;
    ClearDatas;
    GetCurrentData(tabFacture.FieldByName('IDmandat').AsInteger);
    edtVisa.ItemIndex:=dlgWizard.edtVisa.ItemIndex;
    edtPrestations.Lines.Assign(dlgWizard.edtPrestations.Lines);
    edtObjet.Text:=dlgWizard.edtObjet.Text;
    edtDe.Date:=dlgWizard.edtDe.Date;
    edtA.Date:=dlgWizard.edtA.Date;
    edtAdresse.Lines.Assign(dlgWizard.edtAdresse.Lines);
    edtEnvoi.Lines.Assign(dlgWizard.edtEnvoi.Lines);
    edtType.ItemIndex:=dlgWizard.edtType.ItemIndex;
    edtMode.ItemIndex:=dlgWizard.edtMode.ItemIndex;
    edtPrepare.Text:=dlgWizard.edtPrepare.Text;
    edtComment.Lines.Assign(dlgWizard.edtComment.Lines);
    SetGrid(dlgWizard.grdOffres, grdOffres);
    SetGrid(dlgWizard.grdAdjudications, grdAdjudications);
    SetGrid(dlgWizard.grdDocuments, grdDocuments);
    btnCopySumOffres.Click;

    actGetHoursExecute(Sender);
    edtPériode.Text:=dlgWizard.edtPériode.Text;

    CD.FABfile:='';
    apcMain.ActivePage:=atsDétail;
  end;
  dlgWizard.Free;
end;

procedure TfrmMain.btnLocalCHClick(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', PChar('http://www.local.ch'), nil, nil, SW_SHOWDEFAULT)
end;

procedure TfrmMain.btnPastePenetroClick(Sender: TObject);
begin
  grdFacture.Cells[4, 9]:=grdPenetro.Cells[4,10];
  apcMain.ActivePage:=atsDétail;
  DataCalculate(Sender);
end;

procedure TfrmMain.btnPrintClick(Sender: TObject);
var oldsort: string;
begin
  with tabFacture do begin
    oldsort:=Sort;
    Sort:='Etat,N';
    frxReport.ShowReport();
    Sort:=oldsort;
  end;
end;

procedure TfrmMain.btnPrintSummaryClick(Sender: TObject);
begin
  WebBrowser.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER);
end;

procedure TfrmMain.UpdateGrdButtons;
begin
  with grdFacture do begin
    if btnFrais.Down then begin
      btnFrais.Caption:='au pourcent';
      Cells[1,20]:=btnFrais.Caption;
      CellProperties[3,20].ReadOnly:=False;
      CellProperties[3,20].BrushColor:=COgreen;
      CellProperties[4,20].ReadOnly:=True;
      CellProperties[4,20].BrushColor:=clWindow;
    end
    else begin
      btnFrais.Caption:='au forfait';
      Cells[1,20]:=btnFrais.Caption;
      CellProperties[3,20].ReadOnly:=True;
      CellProperties[3,20].BrushColor:=clWindow;
      CellProperties[4,20].ReadOnly:=False;
      CellProperties[4,20].BrushColor:=COgreen;
    end;
    if btnFraisType.Down then begin
      btnFraisType.Caption:='q';
      Cells[4,19]:='Forfait v';
      CellProperties[2,16].ReadOnly:=True;
      CellProperties[2,16].BrushColor:=clWindow;
      CellProperties[3,16].ReadOnly:=True;
      CellProperties[3,16].BrushColor:=clWindow;
      CellProperties[4,17].ReadOnly:=True;
      CellProperties[4,17].BrushColor:=clWindow;
      if btnFrais.Down then begin
        CellProperties[3,20].ReadOnly:=False;
        CellProperties[3,20].BrushColor:=COgreen;
      end
      else begin
        CellProperties[4,20].ReadOnly:=False;
        CellProperties[4,20].BrushColor:=COgreen;
      end;
      btnFrais.Enabled:=True;
    end
    else begin
      btnFraisType.Caption:='p';
      Cells[4,19]:='Détail ^';
      CellProperties[2,16].ReadOnly:=False;
      CellProperties[2,16].BrushColor:=COgreen;
      CellProperties[3,16].ReadOnly:=False;
      CellProperties[3,16].BrushColor:=COgreen;
      CellProperties[4,17].ReadOnly:=False;
      CellProperties[4,17].BrushColor:=COgreen;
      CellProperties[3,20].ReadOnly:=True;
      CellProperties[3,20].BrushColor:=clWindow;
      CellProperties[4,20].ReadOnly:=True;
      CellProperties[4,20].BrushColor:=clWindow;
      btnFrais.Enabled:=False;
    end;
    if btnRabais.Down then begin
      btnRabais.Caption:='au pourcent';
      Cells[1,11]:=btnRabais.Caption;
      CellProperties[3,11].ReadOnly:=False;
      CellProperties[3,11].BrushColor:=COgreen;
      CellProperties[4,11].ReadOnly:=True;
      CellProperties[4,11].BrushColor:=clWindow;
    end
    else begin
      btnRabais.Caption:='au forfait';
      Cells[1,11]:=btnRabais.Caption;
      CellProperties[3,11].ReadOnly:=True;
      CellProperties[3,11].BrushColor:=clWindow;
      CellProperties[4,11].ReadOnly:=False;
      CellProperties[4,11].BrushColor:=COgreen;
    end;
  end;
  DatasChanged(nil);
end;

//=== Edits ====================================================================

procedure TfrmMain.BilanChange(Sender: TObject);
begin
  with Sender as TAdvEdit do
    if FloatValue<0 then
      Color:=COred
    else if 0<FloatValue then
      Color:=COgreen
    else
      Color:=clWindow;
end;

procedure TfrmMain.edtBonClick(Sender: TObject);
begin
  if edtBon.Checked then
    edtVisaDate.Text:=DateToStr(Date)
  else
    edtVisaDate.Text:='';
  DatasChanged(nil);
end;

procedure TfrmMain.edtFilterChange(Sender: TObject);
begin
  if edtFilter.Text='' then
    tabDetails.Filtered:=False
  else begin
    tabDetails.Filter:='Remarque like ''*'+edtFilter.Text+'*''';
    tabDetails.Filtered:=True;
  end;
end;

procedure TfrmMain.edtFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    edtFilter.Text:=''
end;

procedure TfrmMain.edtGoToChange(Sender: TObject);
begin
  if tabFacture.Locate('N', edtGoTo.Text, []) then
    grdFactures.SetFocus;
end;

procedure TfrmMain.edtGoToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    edtGoto.Text:=''
  else if Key=VK_RETURN then
    edtGoToChange(Sender)
end;

procedure TfrmMain.edtModeClick(Sender: TObject);
begin
  edtPrepareChange(Sender);
  DatasChanged(Sender);
end;

procedure TfrmMain.edtPrepareChange(Sender: TObject);
begin
  if edtMode.ItemIndex=2 then
    if edtPrepare.Text='' then
      edtPrepare.Color:=COred
    else
      edtPrepare.Color:=COgreen
  else
    edtPrepare.Color:=clWindow
end;

procedure TfrmMain.edtPrepareDblClick(Sender: TObject);
begin
  if edtPrepare.Text<>'' then
    if FileExists(edtPrepare.Text) then
      ShellExecute(Handle, 'Open', PChar(edtPrepare.Text), nil, nil, SW_SHOWDEFAULT)
    else
      MessageDlg('Le fichier ['+ExtractFileName(edtPrepare.Text)+'] est introuvable !', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.edtPériodeClickBtn(Sender: TObject);
begin
  edtPrestations.Lines.Insert(0, edtPériode.Text);
end;

procedure TfrmMain.DataCalculate(Sender: TObject);
begin
  Calcul(False);
end;

procedure TfrmMain.DatasChanged(Sender: TObject);
begin
  CD.Modified:=True;
end;

procedure TfrmMain.edtStateExit(Sender: TObject);
begin
  if tabNotes.State=dsEdit then begin
    tabNotes.Post;
    tabFacture.Refresh;
  end;
end;

//=== Grids ====================================================================

procedure TfrmMain.grdFilterCellDblClick(Column: TXColumn);
begin
  if ActiveControl=grdDétails then
    with tabDetails do begin
      Filter:=Column.FieldName+'='''+Column.Field.AsString+'''';
      Filtered:=True;
    end
  else if ActiveControl=grdAllPrepared then
    with tabAllPrepared do begin
      if Eof then Exit;
      if Column.FieldName='FileName' then begin
        if FileExists(FieldByName('FullPath').AsString) then begin
          if not IsSaved then Exit;
          CD.FABfile:=FieldByName('FullPath').AsString;
          LoadDatas;
        end
        else
          MessageDlg('Le fichier ['+FieldByName('FileName').AsString+'] est introuvable !', mtInformation, [mbOK], 0);
      end
      else if Column.FieldName='Etat' then begin
        if -1<edtFilterEtat.Items.IndexOf(FieldByName('Etat').AsString) then begin
          edtFilterEtat.ItemIndex:=edtFilterEtat.Items.IndexOf(FieldByName('Etat').AsString);
          edtFilterEtatChange(nil);
        end;
      end
      else begin
        APfilter:=Column.FieldName+'='''+Column.Field.AsString+'''';
        edtFilterEtatChange(nil)
      end;
    end
end;

procedure TfrmMain.grdDétailsColumnResize(Sender: TObject);
begin
  with grdDétails do
    Columns[7].Width:=ClientWidth{-IndicatorWidth}-Columns.Count-
                      Columns[0].Width-
                      Columns[1].Width-
                      Columns[2].Width-
                      Columns[3].Width-
                      Columns[4].Width-
                      Columns[5].Width-
                      Columns[6].Width;
end;

procedure TfrmMain.grdCellValidate(Sender: TObject; ACol, ARow: Integer;
  var Value: string; var Valid: Boolean);
begin
  if Value='' then Value:='0';
end;

procedure TfrmMain.grdFactureEditCellDone(Sender: TObject; ACol, ARow: Integer);
begin
  Calcul(False);
end;

procedure TfrmMain.grdFactureResize(Sender: TObject);
begin
  with grdFacture do begin
    DefaultColWidth:=Max(ClientWidth div 5, 64);
    with btnRabais do begin
      Left:=CellRect(1,11).Left;
      Top:=CellRect(1,11).Top;
      Width:=CellSize(1,11).X;
      Height:=CellSize(1,11).Y;
    end;
    with btnFraisType do begin
      Left:=CellRect(4,19).Left;
      Top:=CellRect(4,19).Top;
      Width:=CellSize(4,19).X;
      Height:=CellSize(4,19).Y;
    end;
    with btnFrais do begin
      Left:=CellRect(1,20).Left;
      Top:=CellRect(1,20).Top;
      Width:=CellSize(1,20).X;
      Height:=CellSize(1,20).Y;
    end;
    with btnAutres1 do begin
      Left:=CellRect(0,9).Left;
      Top:=CellRect(0,9).Top;
      Height:=CellSize(0,9).Y;
    end;
    with btnKm1 do begin
      Left:=CellRect(0,16).Left;
      Top:=CellRect(0,16).Top;
      Height:=CellSize(0,16).Y;
    end;
    with btnFrais1 do begin
      Left:=CellRect(0,17).Left;
      Top :=CellRect(0,17).Top;
      Height:=CellSize(0,17).Y;
    end;
    with btnTiers1 do begin
      Left:=CellRect(0,21).Left;
      Top:=CellRect(0,21).Top;
      Height:=CellSize(0,21).Y;
    end;
  end;
end;

procedure TfrmMain.grdFacturesCellDblClick(Column: TXColumn);
begin
  if Column.Index=grdFactures.Columns.Count-1 then begin
    tabNotes.Edit;
    tabNotes.FieldByName('Etat').AsString:=edtState.Items[(edtState.ItemIndex+1) mod edtState.Items.Count];
    tabNotes.Post;
    tabFacture.Refresh;
  end
  else
end;

procedure TfrmMain.grdFacturesPaintColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TXColumn; Highlight: Boolean;
  Selections: TSelections; var Color: TColor; Font: TFont;
  var Image: TPersistent);
begin
  if tabFacture.FieldByName('Etat').AsString='A facturer' then
    if slRowSelected in Selections then
      Color:=clRed
    else
      Color:=COred
  else if tabFacture.FieldByName('Etat').AsString='Contrôle' then
    if slRowSelected in Selections then
      Color:=clFuchsia
    else
      Color:=COfuchsia
  else if tabFacture.FieldByName('Etat').AsString='Facturation' then
    if slRowSelected in Selections then
      Color:=clGreen
    else
      Color:=COgreen
  else if tabFacture.FieldByName('Etat').AsString='Terminé' then
    Font.Style:=Font.Style+[fsStrikeout]
  else if 45<Date-tabFacture.FieldByName('A').AsDateTime then
    if slRowSelected in Selections then
      Color:=$00F05000
    else
      Color:=COblue
end;

procedure TfrmMain.grdFacturesTitleClick(Column: TXColumn);
var asc    : boolean;
    oldsort: string;
begin
  with tabFacture, Column do begin
    oldsort:=Sort;
    asc:=Pos('DESC', oldsort)=0;
    if Pos(FieldName, oldsort)=0 then
      if asc then
        Sort:=FieldName+' ASC'
      else
        Sort:=FieldName+' DESC'
    else if asc then
      Sort:=FieldName+' DESC'
    else
      Sort:=FieldName+' ASC'
  end;
end;

procedure TfrmMain.grdSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  with Sender as TAdvColumnGrid do
    CanSelect:=not (CellProperties[ACol, ARow].ReadOnly or Columns[ACol].ReadOnly)
end;

//! retiré car exception sur la table, problème d'index
procedure TfrmMain.grdAllPreparedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not ((Key=VK_DELETE) and (Shift=[ssCtrl])) then Exit;
  if MessageDlg('Confirmez la suppression du LIEN de la facture',
                mtInformation, [mbYes, mbNo], 0, mbNo)=mrYes then begin
    if FileExists(tabAllPrepared.FieldByName('FullPath').AsString) then
      case MessageDlg('Voulez vous aussi supprimer le FICHIER du serveur'#13+
                      '[OUI] le lien et le fichier seront supprimés'#13+
                      '[NON] seul le lien sera supprimé',
                      mtInformation, [mbYes, mbNo, mbCancel], 0, mbCancel) of
        mrYes   : DeleteFile(tabAllPrepared.FieldByName('FullPath').AsString);
        mrCancel: Exit;
      end;
    with tabPrepared do begin
      MasterSource:=nil;
      if Locate('FullPath', tabAllPrepared.FieldByName('FullPath').AsString, []) then begin
        Delete;
        tabAllPrepared.Requery();
      end;
      MasterSource:=dsrFacture;
      Refresh;
    end;
  end;
end;

procedure TfrmMain.grdAllPreparedPaintColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TXColumn; Highlight: Boolean;
  Selections: TSelections; var Color: TColor; Font: TFont;
  var Image: TPersistent);
begin
  if DataCol<>4 then Exit;
  if tabAllPrepared.FieldByName('Etat').AsString='A facturer' then
    if slRowSelected in Selections then
      Color:=clRed
    else
      Color:=COred
  else if tabAllPrepared.FieldByName('Etat').AsString='Contrôle' then
    if slRowSelected in Selections then
      Color:=clFuchsia
    else
      Color:=COfuchsia
  else if tabAllPrepared.FieldByName('Etat').AsString='Facturation' then
    if slRowSelected in Selections then
      Color:=clGreen
    else
      Color:=COgreen
  else if tabAllPrepared.FieldByName('Etat').AsString='Terminé' then
    Font.Style:=Font.Style+[fsStrikeout]
end;

procedure TfrmMain.grdAllPreparedTitleClick(Column: TXColumn);
var asc    : boolean;
    oldsort: string;
begin
  with tabAllPrepared, Column do begin
    oldsort:=Sort;
    asc:=Pos('DESC', oldsort)=0;
    if Pos(FieldName, oldsort)=0 then
      if asc then
        Sort:=FieldName+' ASC'
      else
        Sort:=FieldName+' DESC'
    else if asc then
      Sort:=FieldName+' DESC'
    else
      Sort:=FieldName+' ASC'
  end;
end;

procedure TfrmMain.grdCanInsertRow(Sender: TObject; ARow: Integer;
  var CanInsert: Boolean);
begin
  with Sender as TAdvColumnGrid do
    CanInsert:=not IsEmptyRow(Rows[ARow]);
end;

procedure TfrmMain.grdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var delrow: integer;
begin
  if (Key=VK_DELETE) and (Shift=[ssCtrl]) then
    with Sender as TAdvColumnGrid do begin
      if IsEmptyRow(Rows[Row]) then Exit;
      if MessageDlg('Confirmez la suppression', mtInformation, [mbYes, mbNo], 0)=mrYes then begin
        if (Row=1) and (RowCount=3) then
          ClearRows(Row, 1)
        else begin
          delrow:=Row;
          Row:=Min(Row, RowCount-3);
          RemoveRows(delrow, 1);
        end;
        AdjustGridSize(Sender as TAdvColumnGrid, 0);
        DatasChanged(Sender);
        SetGridTitle(Sender as TAdvColumnGrid);
      end;
    end;
end;

procedure TfrmMain.grdOffresAutoAddRow(Sender: TObject; ARow: Integer);
begin
  with Sender as TAdvColumnGrid do
    AddExpand(3, ARow, 3*RowHeights[0]);
  AdjustGridSize(Sender as TAdvColumnGrid, 0);
end;

procedure TfrmMain.grdExit(Sender: TObject);
begin
  with Sender as TAdvColumnGrid do begin
    if (1<Row) and IsEmptyRow(Rows[Row]) then begin
      RemoveRows(Row, 1);
      Row:=1;
      AdjustGridSize(Sender as TAdvColumnGrid, 0);
      SetGridTitle(Sender as TAdvColumnGrid);
    end;
  end;
end;

procedure TfrmMain.grdEditChange(Sender: TObject; ACol, ARow: Integer;
  Value: string);
begin
  with Sender as TAdvColumnGrid do
    if Value<>Cells[ACol, ARow] then begin
      DatasChanged(Sender);
      SetGridTitle(Sender as TAdvColumnGrid);
    end;
end;

procedure TfrmMain.grdPenetroEditCellDone(Sender: TObject; ACol, ARow: Integer);
var i : integer;
    p, s: real;
begin
  with grdPenetro do begin
    s:=0;
    for i:=1 to 9 do begin
      p:=Floats[2, i]*Floats[3, i];
      s:=s+p;
      Floats[4, i]:=p;
    end;
    Floats[ColCount-1, RowCount-1]:=s;
  end;
end;

procedure TfrmMain.grdPreparedCellDblClick(Column: TXColumn);
begin
  with tabPrepared do begin
    if IsEmpty then Exit;
    if FileExists(FieldByName('FullPath').AsString) then begin
      if not IsSaved then Exit;
      CD.FABfile:=FieldByName('FullPath').AsString;
      LoadDatas;
    end
    else
      MessageDlg('Le fichier ['+FieldByName('FileName').AsString+'] est introuvable !', mtInformation, [mbOK], 0);
  end;
end;

procedure TfrmMain.grdDblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  with Sender as TAdvColumnGrid do
    if (ACol=0) and (Cells[4, ARow]<>'') then
      if FileExists(Cells[4, ARow]) then
        ShellExecute(Handle, 'Open', PChar(Cells[4, ARow]), nil, nil, SW_SHOWDEFAULT)
      else
        MessageDlg('Le fichier ['+ExtractFileName(Cells[4, ARow])+'] est introuvable !', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.grdExpandClick(Sender: TObject; ACol, ARow: Integer;
  Expanded: Boolean);
var h: integer;
begin
  h:=2*TAdvColumnGrid(Sender).RowHeights[0];
  if not Expanded then
    h:=-h;
  AdjustGridSize(TAdvColumnGrid(Sender), h);
end;

procedure TfrmMain.grdRowChanging(Sender: TObject; OldRow,
  NewRow: Integer; var Allow: Boolean);
begin
  with Sender as TAdvColumnGrid do
    if IsEmptyRow(Rows[OldRow]) then begin
      RemoveRows(OldRow, 1);
      AdjustGridSize(Sender as TAdvColumnGrid, 0);
      SetGridTitle(Sender as TAdvColumnGrid);
    end
end;

procedure TfrmMain.grdResponsablesCellDblClick(Column: TXColumn);
begin
  Favorite:=tabResponsables.FieldByName('Responsable').AsString;
  actFavorite.Caption:='< '+UpperCase(Favorite)+' >';
  actFavorite.Execute;
end;

procedure TfrmMain.grdResponsablesEnter(Sender: TObject);
begin
  tabResponsables.AfterScroll:=tabResponsablesAfterScroll;
end;

procedure TfrmMain.grdResponsablesPaintColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TXColumn; Highlight: Boolean;
  Selections: TSelections; var Color: TColor; Font: TFont;
  var Image: TPersistent);
begin
  if tabResponsables.FieldByName('Responsable').AsString=Favorite then begin
    Font.Style:=[fsBold];
    if slRowSelected in Selections then
      Color:=clGreen
    else
      Color:=COgreen
  end;
end;

//=== Panels ===================================================================

procedure TfrmMain.pnlMemoMaximize(Sender: TObject);
var i: integer;
begin
  i:=MemoLinkIndex(TControl(Sender).Name);
  SetMemoTitleExpanded(i);
  with MemoLinks[i].button do begin
    Down:=True;
    Font.Style:=[fsBold];
  end;
  MemoLinks[i].splitter.Enabled:=True;
end;

procedure TfrmMain.pnlMemoMinimize(Sender: TObject);
var i: integer;
begin
  i:=MemoLinkIndex(TControl(Sender).Name);
  SetMemoTitleCollapsed(i);
  with MemoLinks[i].button do begin
    Down:=False;
    Font.Style:=[];
  end;
  MemoLinks[i].splitter.Enabled:=False;
end;

procedure TfrmMain.pnlCodeDblClick(Sender: TObject);
begin
  if (pnlCode.Caption='') or
     (apcMain.ActivePageIndex<>0) or
     (tabResponsables.FieldByName('Responsable').AsString<>edtResponsable.Text) then
    Exit;
  edtGoTo.Text:='';
  edtGoTo.Text:=pnlCode.Caption;
end;

procedure TfrmMain.pnlGrdOffresMaximize(Sender: TObject);
var i: integer;
begin
  i:=GridLinkIndex(TControl(Sender).Name);
  SetGridTitleExpanded(i);
  if GridLinks[i].button<>nil then
    GridLinks[i].button.Enabled:=True;
  GridLinks[i].splitter.Enabled:=True;
end;

procedure TfrmMain.pnlGrdOffresMinimize(Sender: TObject);
var i: integer;
begin
  i:=GridLinkIndex(TControl(Sender).Name);
  SetGridTitleCollapsed(i);
  if GridLinks[i].button<>nil then
    GridLinks[i].button.Enabled:=False;
  GridLinks[i].splitter.Enabled:=False;
end;

//=== Drag&Drop ================================================================

procedure TfrmMain.dftFileDrop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);

  procedure DropFile(grd: TAdvColumnGrid);
  var f, i : integer;
      ok   : boolean;
  begin
    with grd, Sender as TDropFileTarget do begin
      for f:=0 to dftFile.Files.Count-1 do begin
        ok:=True;
        for i:=1 to RowCount-2 do
          if Cells[4, i]=Files[f] then begin
            MessageDlg('Le fichier '+ExtractFileName(Files[f])+' existe déjà dans la liste', mtInformation, [mbOk], 0);
            ok:=False;
            Break;
          end;
        if ok then begin
          i:=RowCount-2;
          if  (Cells[2, i]<>'') or (Cells[3, i]<>'') or (Cells[4, i]<>'') then begin
            i:=RowCount-1;
            RowCount:=RowCount+1;
          end;
          Cells[0, i]:=ExtractFileName(Files[f]);
          Cells[1, i]:=dateToStr(TFile.GetLastWriteTime(Files[f]));
          Cells[4, i]:=Files[f];
          AdjustGridSize(grd, 0);
          DatasChanged(Sender);
        end;
      end;
    end;
    GridLinks[GridLinkIndex(grd.Name)].panel.Collaps:=False;
    SetGridTitle(grd);
  end;

begin
  with Sender as TDropFileTarget do begin
    if Target=pnlLeft then begin
      if IsSaved then begin
        CD.FABfile:=dftFile.Files[0];
        LoadDatas;
      end;
    end
    else if Target is TAdvEdit then begin
      edtPrepare.Text:=dftFile.Files[0];
      DatasChanged(Sender);
    end
    else
      DropFile(GridLinks[GridLinkIndex(Target.Name)].grid);
  end;
end;

procedure TfrmMain.dftFileEnter(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
begin
  if dftFile.Target=pnlLeft then
    if (dftFile.Files.Count=1) and (ExtractFileExt(dftFile.Files[0])='.fab') then
      Effect:=DROPEFFECT_COPY
    else
      Effect:=DROPEFFECT_NONE
  else if dftFile.Target is TAdvEdit then
    if (dftFile.Files.Count=1) and (ExtractFileExt(dftFile.Files[0])<>'.fab') then
      Effect:=DROPEFFECT_COPY
    else
      Effect:=DROPEFFECT_NONE
  else
    if ExtractFileExt(dftFile.Files[0])='.fab' then
      Effect:=DROPEFFECT_NONE
    else
      Effect:=DROPEFFECT_COPY
end;

//=== Actions ==================================================================

procedure TfrmMain.actQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actClearHoursExecute(Sender: TObject);
const SQLall = 'UPDATE Heures SET Heures.Facturé = Yes'#13+
               'WHERE (((Heures.Facturé)=No)) AND (((Heures.IDmandat)=%d));';
      SQLpartial = 'UPDATE Heures SET Heures.Facturé = Yes'#13+
                   'WHERE (((Heures.Facturé)=No) AND ((Heures.IDmandat)=%d) AND ((Heures.Date)<=#%d/%d/%d#));';

begin
  with TdlgClear.Create(self) do begin
    pnlCode.Caption:=tabFacture.FieldByName('N').AsString;
    edtA.Date:=frmMain.edtA.Date;
    if ShowModal=mrOk then begin
      if rabAll.Checked then
        tabSQL.SQL.Text:=Format(SQLall, [tabFacture.FieldByName('IDmandat').AsInteger])
      else
        tabSQL.SQL.Text:=Format(SQLpartial, [tabFacture.FieldByName('IDmandat').AsInteger,
                                             MonthOf(edtA.Date),
                                             DayOf  (edtA.Date),
                                             YearOf (edtA.Date)]);
      tabSql.ExecSQL;
      tabFacture.Requery;
    end;
    Free;
  end;
end;

procedure TfrmMain.actClearHoursUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=grdFactures.Focused and not tabFacture.IsEmpty
end;

procedure TfrmMain.actControlExecute(Sender: TObject);
const SQL = 'UPDATE Mandats SET Mandats.Etat = "Contrôle" WHERE (((Mandats.IDmandat)=%d));';
var html : TStringList;
begin
  html:=TStringList.Create;
  with html do begin
    DefaultEncoding:=TEncoding.UTF8;
    LoadFromFile(GetHTMLFile);
    LineBreak:='';
  end;
  with Mail do begin
    Clear;
    Recipient.Add.Address:=Controles[edtVisa.ItemIndex];
    Subject:='FACTURE '+pnlCode.Caption+' à contrôler';
    Body.Assign(html);
    SendMail(True);
  end;
  html.Free;
  tabSQL.SQL.Text:=Format(SQL, [CD.IDmandat]);
  tabSql.ExecSQL;
  tabFacture.Requery;
end;

procedure TfrmMain.actControlUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(CD.Modified=False) and
                           (pnlCode.Caption<>'') and
                           (-1<edtVisa.ItemIndex) and
                           ((apcMain.ActivePage=atsDatas) or (apcMain.ActivePage=atsDétail));
end;

procedure TfrmMain.actCopyAddressExecute(Sender: TObject);
begin
  edtEnvoi.Lines.Assign(edtAdresse.Lines);
end;

procedure TfrmMain.actCopyGridExecute(Sender: TObject);
begin
  TAdvColumnGrid(ActiveControl).CopyToClipBoardAsHTML
end;

procedure TfrmMain.actCopyGridUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=ActiveControl is TAdvColumnGrid;
end;

procedure TfrmMain.actFavoriteExecute(Sender: TObject);
begin
  tabResponsables.AfterScroll:=nil;
  tabResponsables.Locate('Responsable', Favorite, []);
  tabFacture.Filter:='Responsable='''+Favorite+'''';
  tabFacture.Filtered:=True;
  grdFactures.SetFocus;
end;

procedure TfrmMain.actFavoriteUpdate(Sender: TObject);
begin
  actFavorite.Enabled:=Favorite<>'';
end;

procedure TfrmMain.actFilterExecute(Sender: TObject);
begin
  if apcMain.ActivePage=atsDétail then
    with tabDetails do
      if Filtered then
        Filtered:=False
      else begin
        Filter:=grdDétails.SelectedField.FieldName+'='''+grdDétails.SelectedField.AsString+'''';
        Filtered:=True;
      end
  else if apcMain.ActivePage=atsAllPrepared then begin
    with tabAllPrepared do
      if APfilter='' then
        APfilter:=grdAllPrepared.SelectedField.FieldName+'='''+grdAllPrepared.SelectedField.AsString+''''
      else
        APfilter:='';
    edtFilterEtatChange(nil)
  end
end;

procedure TfrmMain.actFilterUpdate(Sender: TObject);
begin
  if apcMain.ActivePage=atsDétail then
    if tabDetails.Filtered then
      TAction(Sender).Caption:='Tout voir'
    else
      TAction(Sender).Caption:='Filtrer'
  else if apcMain.ActivePage=atsAllPrepared then
    if APfilter='' then
        TAction(Sender).Caption:='Filtrer'
      else
        TAction(Sender).Caption:='Tout voir'
end;

procedure TfrmMain.btntGetAllClick(Sender: TObject);
begin
  if not IsSaved then Exit;
  atsDatas.TabEnable:=True;
  atsDétail.TabEnable:=True;
  atsPénétro.TabEnable:=True;
  ClearDatas;
  GetCurrentData(tabFacture.FieldByName('IDmandat').AsInteger);
  actGetHoursExecute(Sender);
  apcMain.ActivePage:=atsDatas;
  btnOpenFolder.Click;
end;


procedure TfrmMain.UpdateDetails;
const
  SQL = 'SELECT Heures.Date, Collaborateurs.Initiales, LinkACC.Classe, Code, Heures.Heures, Heures.Km, Heures.Frais, Heures.Remarque, Heures.Facturé'#13+
        'FROM (Collaborateurs INNER JOIN (Activités INNER JOIN Heures ON Activités.IDactivité = Heures.IDactivité) ON Collaborateurs.IDcollaborateur = Heures.IDcollaborateur) '+
        'INNER JOIN LinkACC ON (Activités.IDactivité = LinkACC.IDactivité) AND (Collaborateurs.IDcollaborateur = LinkACC.IDcollaborateur)'#13+
        'WHERE (((Heures.IDmandat)=%d) AND ((Heures.Date) Between #%d/%d/%d# And #%d/%d/%d#) AND ((Heures.Facturé)=No))'#13+
        'ORDER BY Heures.Date, Collaborateurs.Initiales, Classe';
begin
  tabDetails.Close;
  tabDetails.SQL.Text:=Format(SQL, [CD.IDmandat,
                                    MonthOf(edtDe.Date),
                                    DayOf  (edtDe.Date),
                                    YearOf (edtDe.Date),
                                    MonthOf(edtA.Date ),
                                    DayOf  (edtA.Date ),
                                    YearOf (edtA.Date )]);
  tabDetails.Open;
end;

procedure TfrmMain.actGetHoursExecute(Sender: TObject);
const
  SQL1 = 'SELECT LinkACC.Classe AS CL, Sum(Heures.Heures) AS SH'#13+
         'FROM Activités INNER JOIN ((Collaborateurs INNER JOIN Heures ON Collaborateurs.IDcollaborateur = Heures.IDcollaborateur) '+
         'INNER JOIN LinkACC ON Collaborateurs.IDcollaborateur = LinkACC.IDcollaborateur) ON (Activités.IDactivité = LinkACC.IDactivité) AND (Activités.IDactivité = Heures.IDactivité)'#13+
         'WHERE (((Heures.IDmandat)=%d) AND ((Heures.Date) Between #%d/%d/%d# And #%d/%d/%d#) AND ((Heures.Facturé)=No))'#13+
         'GROUP BY LinkACC.Classe'+#13+
         'ORDER BY LinkACC.Classe;';

  SQL2 = 'SELECT Sum(Heures.Km) AS Km, Sum(Heures.Frais) AS Frais'#13+
         'FROM Heures'#13+
         'WHERE (((Heures.IDmandat)=%d) AND ((Heures.Date) Between #%d/%d/%d# And #%d/%d/%d#) AND ((Heures.Facturé)=No));';
var r: integer;
begin
  edtPériode.Text:='Travaux du '+DateToStr(edtDe.Date)+' au '+DateToStr(edtA.Date);

  with tabSQL do begin
    SQL.Text:=Format(SQL1, [CD.IDmandat,
                            MonthOf(edtDe.Date), DayOf(edtDe.Date), YearOf(edtDe.Date),
                            MonthOf(edtA.Date), DayOf(edtA.Date), YearOf(edtA.Date)]);
    Open;
    with grdFacture do begin
      for r:=2 to 7 do begin
        Floats[1, r]:=0;
        Floats[2, r]:=0;
      end;
      while not Eof do begin
        case FieldByName('CL').AsString[1] of
          'B': begin
                 Cells[1, 2]:=FieldByName('SH').AsString;
                 Cells[2, 2]:=Cells[1, 2];
               end;
          'C': begin
                 Cells[1, 3]:=FieldByName('SH').AsString;
                 Cells[2, 3]:=Cells[1, 3];
               end;
          'D': begin
                 Cells[1, 4]:=FieldByName('SH').AsString;
                 Cells[2, 4]:=Cells[1, 4];
               end;
          'E': begin
                 Cells[1, 5]:=FieldByName('SH').AsString;
                 Cells[2, 5]:=Cells[1, 5];
               end;
          'F': begin
                 Cells[1, 6]:=FieldByName('SH').AsString;
                 Cells[2, 6]:=Cells[1, 6];
               end;
          'G': begin
                 Cells[1, 7]:=FieldByName('SH').AsString;
                 Cells[2, 7]:=Cells[1, 7];
               end;
          'R': Cells[1,13]:=FieldByName('SH').AsString;
        end;
        Next;
      end;
    end;
    Close;

    SQL.Text:=Format(SQL2, [CD.IDmandat,
                            MonthOf(edtDe.Date), DayOf(edtDe.Date), YearOf(edtDe.Date),
                            MonthOf(edtA.Date), DayOf(edtA.Date), YearOf(edtA.Date)]);
    Open;
    with grdFacture do begin
      Cells[1,16]:=FieldByName('Km').AsString;
      Cells[2,16]:=Cells[1,16];
      Cells[1,17]:=FieldByName('Frais').AsString;
      Cells[4,17]:=Cells[1,17];
    end;
    Close;
  end;
  UpdateDetails;
  Calcul;
end;

procedure TfrmMain.actGetIntervalExecute(Sender: TObject);
begin
  edtDe.Date:=CD.De;
  edtA.Date:=CD.A;
  UpdateDetails;
end;

procedure TfrmMain.actIsMandatOk(Sender: TObject);
begin
  TAction(Sender).Enabled:=CD.IsOpen;
end;

procedure TfrmMain.btnGetPenetroClick(Sender: TObject);
const
  SQL1='SELECT Max(Mesures.Profondeur) AS P'#13+
       'FROM (Mandats INNER JOIN Sondages ON Mandats.IDmandat = Sondages.IDmandat) INNER JOIN Mesures ON Sondages.IDsondage = Mesures.IDsondage'#13+
       'WHERE (((Mandats.Code)=''%s''))'#13+
       'GROUP BY Sondages.IDsondage;';
  SQL2='SELECT Count(Mesures.IDsondage) AS N100'#13+
       'FROM (Mandats INNER JOIN Sondages ON Mandats.IDmandat = Sondages.IDmandat) INNER JOIN Mesures ON Sondages.IDsondage = Mesures.IDsondage'#13+
       'WHERE (((Mandats.Code)=''%s'' AND (Mesures.Coups)>100));';
var p, s05, s10, s15, s20: real;
begin
  if not FileExists(DBpenetro) then begin
    MessageDlg('La base des pénétromètres (peneBEG.mdb) est introuvable.',
               mtWarning, [mbOk], 0);
    Exit;
  end;
  adoPenetro.Open();
  with sqlPenetro do begin
    SQL.Text:=Format(SQL1, [CD.Code]);
    Open;
    if RecordCount=0 then begin
      MessageDlg('Aucun pénétromètre n'' a été réalisés.', mtInformation, [mbOk], 0);
      Close;
      Exit;
    end;
    with grdPenetro do begin
      Floats[3, 2]:=RecordCount;
      Cells[3, 8]:=Cells[3, 2];
      s05:=0;
      s10:=0;
      s15:=0;
      s20:=0;
      while not Eof do begin
        p:=FieldByName('P').AsFloat;
        if p<=5 then
          s05:=s05+p
        else if p<=10 then begin
          s05:=s05+5;
          s10:=s10+p-5;
        end
        else if p<=15 then begin
          s05:=s05+5;
          s10:=s10+5;
          s15:=s15+p-10;
        end
        else begin
          s05:=s05+5;
          s10:=s10+5;
          s15:=s15+5;
          s20:=s20+p-15;
        end;
        Next;
      end;
      Floats[3, 1]:=1;
      Floats[3, 3]:=s05;
      Floats[3, 4]:=s10;
      Floats[3, 5]:=s15;
      Floats[3, 6]:=s20;
      Floats[3, 9]:=0;
      Close;
      SQL.Text:=Format(SQL2, [CD.Code]);
      Open;
      grdPenetro.Floats[3, 7]:=FieldByName('N100').AsFloat/5;
      Close;
      grdPenetroEditCellDone(nil, 0, 0);
    end;
  end;
  adoPenetro.Close;
end;

//C: ?
procedure TfrmMain.actOpenClick(Sender: TObject);
begin
  if not (IsSaved and dlgOpen.Execute) then Exit;
  CD.FABfile:=dlgOpen.FileName;
  LoadDatas;
end;

procedure TfrmMain.HistoryClick(Sender: TObject);
var old: TFileName;
begin
  if IsSaved then begin
    old:=CD.FABfile;
    CD.FABfile:=History[popHistory.Items.IndexOf(TMenuItem(Sender))];
    if FileExists(CD.FABfile) then
      LoadDatas
    else begin
      MessageDlg('Le fichier ['+ExtractFileName(CD.FABfile)+'] introuvable !', mtInformation, [mbOK], 0);
      UpdateHistory(CD.FABfile);
      CD.FABfile:=old;
    end;
  end;
end;

procedure TfrmMain.HTMLabel1Click(Sender: TObject);
begin
  Splash.Show;
end;

procedure TfrmMain.actOpenFolderExecute(Sender: TObject);
var folder, command: AnsiString;
begin
  if grdFactures.Focused then
    folder:=GetDirectory(tabFacture.FieldByName('Mandat').AsInteger)
  else
    folder:=CD.Folder;

  if folder='' then
    MessageDlg('Dossier introuvable !', mtInformation, [mbOK], 0)
  else begin
    command:='C:\Windows\explorer.exe'+' "'+folder+'"';
    WinExec(PAnsiChar(command), 1);
  end
end;

procedure TfrmMain.actOpenFolderUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(pnlCode.Caption<>'') or grdFactures.Focused;
end;

procedure TfrmMain.actSendExecute(Sender: TObject);
const SQL = 'UPDATE Mandats SET Mandats.Etat = "Facturation" WHERE (((Mandats.IDmandat)=%d));';
var html : TStringList;
    cc: string;
begin
  cc:=Responsables.Values[CD.Responsable];
  html:=TStringList.Create;
  with html do begin
    DefaultEncoding:=TEncoding.UTF8;
    LoadFromFile(GetHTMLFile);
    LineBreak:='';
  end;
  with Mail do begin
    Clear;
    Recipient.Add.Address:=Comptable;
    if cc<>'' then
      CarbonCopy.Add.Address:=cc;
    Subject:='FACTURE '+pnlCode.Caption;
    Body.Assign(html);
    SendMail(True);
  end;
  html.Free;
  tabSQL.SQL.Text:=Format(SQL, [CD.IDmandat]);
  tabSql.ExecSQL;
  tabFacture.Requery;
end;

procedure TfrmMain.actSendUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(CD.Modified=False) and
                           (pnlCode.Caption<>'') and
                           (edtBon.Checked) and
                           (-1<edtVisa.ItemIndex) and
                           ((apcMain.ActivePage=atsDatas) or (apcMain.ActivePage=atsDétail));
end;

procedure TfrmMain.actShowBillExecute(Sender: TObject);
var fn: TFileName;
begin
  if apcMain.ActivePage=atsSuspens then
    fn:=ChangeFileExt(tabPrepared.FieldByName('FullPath').AsString, '.html')
  else if (apcMain.ActivePage=atsDatas) or (apcMain.ActivePage=atsDétail) then
    fn:=GetHTMLFile
  else if apcMain.ActivePage=atsAllPrepared then
    fn:=ChangeFileExt(tabAllPrepared.FieldByName('FullPath').AsString, '.html');
  with TfrmSummary.Create(Application) do begin
    Height:=3*(Screen.Height div 4);//2*Height;
    ClientWidth:=700;
    with pnlTop do begin
      Text:=ExtractFileName(fn);
      Text:='<P align="center">'+LeftStr(Text, Length(Text)-5)+'</P>';
    end;
    FileName:=fn;
    broSummary.Navigate(fn);
  end;
end;

procedure TfrmMain.actShowBillUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(
      (apcMain.ActivePage=atsSuspens) and
      (not tabPrepared.IsEmpty) and
      FileExists(ChangeFileExt(tabPrepared.FieldByName('FullPath').AsString, '.html'))
    ) or (
      ((apcMain.ActivePage=atsDatas) or (apcMain.ActivePage=atsDétail)) and
      (not CD.Modified) and
      FileExists(GetHTMLFile)
    ) or (
      (apcMain.ActivePage=atsAllPrepared) and
      (not tabAllPrepared.IsEmpty) and
      FileExists(ChangeFileExt(tabAllPrepared.FieldByName('FullPath').AsString, '.html'))
    );
end;

procedure TfrmMain.actVerifyExecute(Sender: TObject);
const
  SQL1 = 'SELECT LinkACC.Classe AS CL, Sum(Heures.Heures) AS SH'#13+
         'FROM Activités INNER JOIN ((Collaborateurs INNER JOIN Heures ON Collaborateurs.IDcollaborateur = Heures.IDcollaborateur) '+
         'INNER JOIN LinkACC ON Collaborateurs.IDcollaborateur = LinkACC.IDcollaborateur) ON (Activités.IDactivité = LinkACC.IDactivité) AND (Activités.IDactivité = Heures.IDactivité)'#13+
         'WHERE (((Heures.IDmandat)=%d) AND ((Heures.Date) Between #%d/%d/%d# And #%d/%d/%d#) AND ((Heures.Facturé)=No))'#13+
         'GROUP BY LinkACC.Classe'+#13+
         'ORDER BY LinkACC.Classe;';

  SQL2 = 'SELECT Sum(Heures.Km) AS Km, Sum(Heures.Frais) AS Frais'#13+
         'FROM Heures'#13+
         'WHERE (((Heures.IDmandat)=%d) AND ((Heures.Date) Between #%d/%d/%d# And #%d/%d/%d#) AND ((Heures.Facturé)=No));';
var r: integer;
begin
  with tabSQL do begin
    SQL.Text:=Format(SQL1, [CD.IDmandat,
                            MonthOf(edtDe.Date), DayOf(edtDe.Date), YearOf(edtDe.Date),
                            MonthOf(edtA.Date), DayOf(edtA.Date), YearOf(edtA.Date)]);
    Open;
    with grdFacture do begin
      for r:=2 to 7 do
        Floats[1, r]:=0;
      while not Eof do begin
        case FieldByName('CL').AsString[1] of
          'B': Cells[1, 2]:=FieldByName('SH').AsString;
          'C': Cells[1, 3]:=FieldByName('SH').AsString;
          'D': Cells[1, 4]:=FieldByName('SH').AsString;
          'E': Cells[1, 5]:=FieldByName('SH').AsString;
          'F': Cells[1, 6]:=FieldByName('SH').AsString;
          'G': Cells[1, 7]:=FieldByName('SH').AsString;
          'R': Cells[1,13]:=FieldByName('SH').AsString;
        end;
        Next;
      end;
    end;
    Close;

    SQL.Text:=Format(SQL2, [CD.IDmandat,
                            MonthOf(edtDe.Date), DayOf(edtDe.Date), YearOf(edtDe.Date),
                            MonthOf(edtA.Date), DayOf(edtA.Date), YearOf(edtA.Date)]);
    Open;
    with grdFacture do begin
      Cells[1,16]:=FieldByName('Km').AsString;
      Cells[1,17]:=FieldByName('Frais').AsString;
    end;
    Close;
  end;
  UpdateDetails;

  edtTotalBase.FloatValue:=CalculBase;;
  edtDiffBase.FloatValue:=grdFacture.Floats[4,24]-edtTotalBase.FloatValue;
end;

procedure TfrmMain.actSaveAsClick(Sender: TObject);
begin
  with dlgSave do begin
    if CD.FABfile='' then begin
      InitialDir:=CD.Folder;
      FileName:=SetFilename;
    end
    else if ExtractFileDir(CD.FABfile)='' then begin
      InitialDir:=CD.Folder;
      FileName:=CD.FABfile;
    end
    else begin
      InitialDir:=ExtractFileDir(CD.FABfile);
      FileName:=ExtractFileName(CD.FABfile);
    end;
    if not Execute then Exit;
    CD.FABfile:=FileName;
    SaveDatas;
  end;
end;

procedure TfrmMain.actSaveAsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=pnlCode.Caption<>'';
end;

procedure TfrmMain.actSaveClick(Sender: TObject);
begin
  SaveFile;
end;

procedure TfrmMain.actSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=CD.Modified;
end;

function TfrmMain.RoundTo5(v: real): real;
begin
  Result:=Round(20*v)/20
end;

function TfrmMain.CalculBase : real;
var i: integer;
begin
  with grdFacture do begin
    Result:=0;
    for i:=2 to 7 do
      Result:=Result+Floats[1, i]*Tarifs[i];
    Result:=Result+Floats[1,16]*Tarifs[8]+Floats[1,17];
  end;
end;

procedure TfrmMain.Calcul(WithBase : boolean = True);
var r: integer;
begin
  DatasChanged(nil);
  with grdFacture do begin
    Floats[1, 8]:=ColumnSum(1, 2, 6);
    Floats[2, 8]:=ColumnSum(2, 2, 6);
    for r:=2 to 7 do
      Floats[4, r]:=Floats[2, r]*Floats[3, r];
    Floats[4, 8]:=ColumnSum(4, 2, 6);
    Floats[4,10]:=ColumnSum(4, 8, 9);
    if btnRabais.Down then
      Floats[4,11]:=RoundTo5(Floats[3,11]*Floats[4,10]/100)
    else
      if Floats[4,10]=0 then
        Floats[3,11]:=0
      else
        Floats[3,11]:=100*Floats[4,11]/Floats[4,10];
    Floats[4,12]:=Floats[4,10]-Floats[4,11];
    Floats[4,16]:=Floats[2,16]*Floats[3,16];
    Floats[4,18]:=ColumnSum(4,16,17);
    if btnFrais.Down then
      Floats[4,20]:=RoundTo5(Floats[3,20]*Floats[4,12]/100)
    else
      if Floats[4,12]=0 then
        Floats[3,20]:=0
      else
        Floats[3,20]:=100*Floats[4,20]/Floats[4,12];
    if btnFraisType.Down then
      Floats[4,22]:=Floats[4,20]+Floats[4,21]
    else
      Floats[4,22]:=Floats[4,18]+Floats[4,21];
    Floats[4,24]:=Floats[4,12]+Floats[4,22];
//ajoute2.3: TVA+TTC
    Floats[4,25]:=RoundTo5(Floats[3,25]*Floats[4,24]/100);
    Floats[4,26]:=Floats[4,24]+Floats[4,25];

    edtSolde.FloatValue:=edtOffreMontant.FloatValue-edtSituations.FloatValue;
    edtTotalOffre.Text:=edtSolde.Text;
    if WithBase then edtTotalBase.FloatValue:=CalculBase;;
    edtDiffOffre.FloatValue:=edtTotalOffre.FloatValue-Floats[4,24];
    edtDiffBase.FloatValue:=Floats[4,24]-edtTotalBase.FloatValue;

    pnlAutres.Collaps:=Floats[4,9]=0;
    if btnFraisType.Down then begin
      pnlKm.Collaps:=True;
      pnlFrais.Collaps:=True;
    end else begin
      pnlKm.Collaps:=Floats[4,16]=0;
      pnlFrais.Collaps:=Floats[4,17]=0;
    end;
    pnlTiers.Collaps:=Floats[4,21]=0;
  end;
end;

//=== Datas ====================================================================

procedure TfrmMain.adoDatasAfterConnect(Sender: TObject);
begin
  tabFacture.Open;
  tabResponsables.Open;
  tabResponsables.Last;
  tabNotes.Open;
  tabNotes.IndexFieldNames:='IDmandat';
  tabNotes.MasterFields:='IDmandat';
  tabPrepared.Open;
  tabPrepared.IndexFieldNames:='IDmandat';
  tabPrepared.MasterFields:='IDmandat';
  tabAllPrepared.Open;
  GetKBOB;
end;

procedure TfrmMain.adoDatasBeforeConnect(Sender: TObject);
const DB = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Mode=ReadWrite;Persist Security Info=False';
begin
  adoDatas.ConnectionString:=Format(DB, [DBmandats]);
end;

procedure TfrmMain.adoPenetroBeforeConnect(Sender: TObject);
const DB = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Mode=ReadWrite;Persist Security Info=False';
begin
  adoPenetro.ConnectionString:=Format(DB, [DBpenetro]);
end;

procedure TfrmMain.edtFilterClickBtn(Sender: TObject);
begin
  edtFilter.Text:=''
end;

procedure TfrmMain.edtFilterEtatChange(Sender: TObject);
begin
  with tabAllPrepared do begin
    if edtFilterEtat.ItemIndex=4 then
      if APfilter='' then begin
        Filter:='';
        Filtered:=False;
        Exit;
      end
      else
        Filter:=APfilter
    else if APfilter='' then
        Filter:='Etat='''+edtFilterEtat.Text+''''
      else
        Filter:='('+APfilter+') and (Etat='''+edtFilterEtat.Text+''')';
      Filtered:=True;
  end;
  grdAllPrepared.SetFocus;
end;

procedure TfrmMain.SplashClick(Sender: TObject);
begin
  Splash.Close;
end;

procedure TfrmMain.Splitter1Moved(Sender: TObject);
var i, w: integer;
begin
  with grdFactures do begin
    w:=-Columns[1].Width;
    for i:=0 to Columns.Count-1 do
      w:=w+Columns[i].Width+1;
    Columns[1].Width:=ClientWidth-w;
  end;
end;

procedure TfrmMain.Splitter4Moved(Sender: TObject);
var i, w: integer;
begin
  with grdAllPrepared do begin
    w:=-Columns[2].Width;
    for i:=0 to Columns.Count-1 do
      w:=w+Columns[i].Width+1;
    Columns[2].Width:=ClientWidth-w;
  end;
end;

procedure TfrmMain.tabAllPreparedAfterScroll(DataSet: TDataSet);
begin
  WebBrowser.Navigate(ChangeFileExt(tabAllPrepared.FieldByName('FullPath').AsString, '.html'));
end;

procedure TfrmMain.atsAllPreparedShow(Sender: TObject);
begin
  tabAllPrepared.AfterScroll:=tabAllPreparedAfterScroll;
  tabAllPreparedAfterScroll(tabAllPrepared);
  pnlVisa.Hide;
  grdAllPrepared.SetFocus;
end;

procedure TfrmMain.atsDatasShow(Sender: TObject);
begin
  pnlVisa.Show;
end;

procedure TfrmMain.atsDétailShow(Sender: TObject);
begin
  grdDétailsColumnResize(nil);
  pnlVisa.Show;
end;

procedure TfrmMain.atsHelpShow(Sender: TObject);
begin
  pnlVisa.Hide;
end;

procedure TfrmMain.atsPénétroShow(Sender: TObject);
begin
  pnlVisa.Hide;
end;

procedure TfrmMain.atsSuspensShow(Sender: TObject);
begin
  grdFactures.SetFocus;
  pnlVisa.Hide;
end;

procedure TfrmMain.tabNotesAfterScroll(DataSet: TDataSet);
begin
  with tabNotes.FieldByName('Etat') do
    if AsString='A facturer' then
      lblCodeFrame.Color:=COred
    else if AsString='Contrôle' then
      lblCodeFrame.Color:=COfuchsia
    else if AsString='Facturation' then
      lblCodeFrame.Color:=COgreen
    else if 45<Date-tabFacture.FieldByName('A').AsDateTime then
      lblCodeFrame.Color:=COblue
    else
      lblCodeFrame.Color:=clWindow;
end;

procedure TfrmMain.tabResponsablesAfterScroll(DataSet: TDataSet);
begin
  tabFacture.Filter:='Responsable='''+tabResponsables.FieldByName('Responsable').AsString+'''';
  tabFacture.Filtered:=True;
end;

//=== Window ===================================================================

procedure TfrmMain.OneInstanceCmdLineReceived(Sender: TObject;
  CmdLine: TStrings);
begin
  if (0<CmdLine.Count) and IsSaved then begin
    CD.FABfile:=CmdLine[0];
    LoadDatas;
  end;
end;

procedure TfrmMain.Panel19Resize(Sender: TObject);
var i, w: integer;
begin
  with grdDétails do begin
    w:=-Columns[7].Width;
    for i:=0 to Columns.Count-1 do
      w:=w+Columns[i].Width+1;
    Columns[7].Width:=ClientWidth-w;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SettingsSave;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=IsSaved;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var version: cardinal;
    r, c: integer;
begin
  Caption:=Format('%s %s %s - %s',
                  [AppInfo.ProductName,
                   AppInfo.ProductVersion,
                   AppInfo.LegalCopyright,
                   AppInfo.FileDescription]);

  Application.OnHint:=DisplayHint;

  edtA.Date:=Date;
  edtDe.Date:=StartOfTheMonth(IncMonth(Date, -3));
  edtVisaDate.Text:=DateToStr(Date);
  edtLast.Text:=DateToStr(Date);
  CD.FABfile:='';
  CD.Modified:=False;

  GridLinks[0].name:='Offres';
  GridLinks[0].grid:=grdOffres;
  GridLinks[0].panel:=pnlGrdOffres;
  GridLinks[0].button:=btnCopySumOffres;
  GridLinks[0].splitter:=splGrdOffres;

  GridLinks[1].name:='Adjudications';
  GridLinks[1].grid:=grdAdjudications;
  GridLinks[1].panel:=pnlGrdAdjudications;
  GridLinks[1].button:=nil;
  GridLinks[1].splitter:=splGrdAdjudications;

  GridLinks[2].name:='Situations';
  GridLinks[2].grid:=grdSituations;
  GridLinks[2].panel:=pnlGrdSituations;
  GridLinks[2].button:=btnCopySumSituations;
  GridLinks[2].splitter:=splGrdSituations;

  GridLinks[3].name:='Documents';
  GridLinks[3].grid:=grdDocuments;
  GridLinks[3].panel:=pnlGrdDocuments;
  GridLinks[3].button:=btnCopyDocs;
  GridLinks[3].splitter:=splGrdDocuments;

  MemoLinks[0].name    :='1. Autres prestations (ME, inclinos, pénétros...)';
  MemoLinks[0].memo    :=memAutres;
  MemoLinks[0].panel   :=pnlAutres;
  MemoLinks[0].button  :=btnAutres1;
  MemoLinks[0].splitter:=splAutres;

  MemoLinks[1].name    :='2. Déplacements (voiture)';
  MemoLinks[1].memo    :=memKm;
  MemoLinks[1].panel   :=pnlKm;
  MemoLinks[1].button  :=btnKm1;
  MemoLinks[1].splitter:=splKm;

  MemoLinks[2].name    :='3. Frais (train, achats de matériel, etc.)';
  MemoLinks[2].memo    :=memFrais;
  MemoLinks[2].panel   :=pnlFrais;
  MemoLinks[2].button  :=btnFrais1;
  MemoLinks[2].splitter:=splFrais;

  MemoLinks[3].name    :='4. Frais de tiers (laboratoire, pelle...)';
  MemoLinks[3].memo    :=memTiers;
  MemoLinks[3].panel   :=pnlTiers;
  MemoLinks[3].button  :=btnTiers1;
  MemoLinks[3].splitter:=splTiers;

  with dftFile do begin
    for r:=0 to 3 do begin
      Register(GridLinks[r].grid);
      Register(GridLinks[r].panel);
    end;
    Register(edtPrepare);
    Register(pnlLeft);
  end;

  with grdFacture do begin
    ClearRows(0, RowCount-1);
    Cells[0, 0]:='H O N O R A I R E S';

    Cells[1, 1]:='base';    CellProperties[1, 1].ReadOnly:=True; CellProperties[1, 1].BrushColor:=clWhite; CellProperties[1, 1].BrushColorTo:=$00F0F0F0;
    Cells[2, 1]:='corrigé'; CellProperties[2, 1].ReadOnly:=True; CellProperties[2, 1].BrushColor:=clWhite; CellProperties[2, 1].BrushColorTo:=$00F0F0F0;
    Cells[3, 1]:='Tarif';   CellProperties[3, 1].ReadOnly:=True; CellProperties[3, 1].BrushColor:=clWhite; CellProperties[3, 1].BrushColorTo:=$00F0F0F0;
    Cells[4, 1]:='Montant'; CellProperties[4, 1].ReadOnly:=True; CellProperties[4, 1].BrushColor:=clWhite; CellProperties[4, 1].BrushColorTo:=$00F0F0F0;

    Cells[0, 2]:='B';
    Cells[1, 2]:='0'; CellProperties[1, 2].ReadOnly:=True;
    Cells[2, 2]:='0';
    Cells[3, 2]:='180';
    Cells[4, 2]:='0'; CellProperties[4, 2].ReadOnly:=True;

    Cells[0, 3]:='C';
    Cells[1, 3]:='0'; CellProperties[1, 3].ReadOnly:=True;
    Cells[2, 3]:='0';
    Cells[3, 3]:='155';
    Cells[4, 3]:='0'; CellProperties[4, 3].ReadOnly:=True;

    Cells[0, 4]:='D';
    Cells[1, 4]:='0'; CellProperties[1, 4].ReadOnly:=True;
    Cells[2, 4]:='0';
    Cells[3, 4]:='132';
    Cells[4, 4]:='0'; CellProperties[4, 4].ReadOnly:=True;

    Cells[0, 5]:='E';
    Cells[1, 5]:='0'; CellProperties[1, 5].ReadOnly:=True;
    Cells[2, 5]:='0';
    Cells[3, 5]:='110';
    Cells[4, 5]:='0'; CellProperties[4, 5].ReadOnly:=True;

    Cells[0, 6]:='F';
    Cells[1, 6]:='0'; CellProperties[1, 6].ReadOnly:=True;
    Cells[2, 6]:='0';
    Cells[3, 6]:='100';
    Cells[4, 6]:='0'; CellProperties[4, 6].ReadOnly:=True;

    Cells[0, 7]:='G';
    Cells[1, 7]:='0'; CellProperties[1, 7].ReadOnly:=True;
    Cells[2, 7]:='0';
    Cells[3, 7]:='96';
    Cells[4, 7]:='0'; CellProperties[4, 7].ReadOnly:=True;

    Cells[0, 8]:='Total h.';
    Cells[1, 8]:='0'; CellProperties[1, 8].ReadOnly:=True;
    Cells[2, 8]:='0'; CellProperties[2, 8].ReadOnly:=True;
    CellProperties[3, 8].ReadOnly:=True;
    Cells[4, 8]:='0'; CellProperties[4, 8].ReadOnly:=True;

    Cells[0, 9]:='Autres';
    CellProperties[1, 9].ReadOnly:=True;
    CellProperties[2, 9].ReadOnly:=True;
    CellProperties[3, 9].ReadOnly:=True;
    Cells[4, 9]:='0';

    Cells[0,10]:='Total';
    CellProperties[1,10].ReadOnly:=True;
    CellProperties[2,10].ReadOnly:=True;
    CellProperties[3,10].ReadOnly:=True;
    Cells[4,10]:='0'; CellProperties[4,10].ReadOnly:=True;

    Cells[0,11]:='Rabais';
    Cells[1,11]:='au pourcent'; CellProperties[1,11].ReadOnly:=True;
    CellProperties[2,11].ReadOnly:=True;
    Cells[3,11]:='0';
    Cells[4,11]:='0'; CellProperties[4,11].ReadOnly:=True;

    Cells[0,12]:='TOTAL';
    CellProperties[1,12].ReadOnly:=True;
    CellProperties[2,12].ReadOnly:=True;
    CellProperties[3,12].ReadOnly:=True;
    Cells[4,12]:='0'; CellProperties[4,12].ReadOnly:=True; CellProperties[4,12].FontStyle:=[fsBold];

    Cells[0,13]:='N.F.';
    Cells[1,13]:='0'; CellProperties[1,13].ReadOnly:=True;
    CellProperties[2,13].ReadOnly:=True;
    CellProperties[3,13].ReadOnly:=True;
    CellProperties[4,13].ReadOnly:=True;

    Cells[0,14]:='F R A I S'; CellProperties[0,14].Alignment:=taCenter;

    Cells[1,15]:='base';    CellProperties[1,15].ReadOnly:=True; CellProperties[1,15].BrushColor:=clWhite; CellProperties[1,15].BrushColorTo:=$00F0F0F0;
    Cells[2,15]:='corrigé'; CellProperties[2,15].ReadOnly:=True; CellProperties[2,15].BrushColor:=clWhite; CellProperties[2,15].BrushColorTo:=$00F0F0F0;
    Cells[3,15]:='Tarif';   CellProperties[3,15].ReadOnly:=True; CellProperties[3,15].BrushColor:=clWhite; CellProperties[3,15].BrushColorTo:=$00F0F0F0;
    Cells[4,15]:='Montant'; CellProperties[4,15].ReadOnly:=True; CellProperties[4,15].BrushColor:=clWhite; CellProperties[4,15].BrushColorTo:=$00F0F0F0;

    Cells[0,16]:='Km';
    Cells[1,16]:='0'; CellProperties[1,16].ReadOnly:=True;
    Cells[2,16]:='0';  CellProperties[2,16].ReadOnly:=True;
    Cells[3,16]:='0.65';  CellProperties[3,16].ReadOnly:=True;
    Cells[4,16]:='0';  CellProperties[4,16].ReadOnly:=True;

    Cells[0,17]:='Frais';
    Cells[1,17]:='0'; CellProperties[1,17].ReadOnly:=True;
    CellProperties[2,17].ReadOnly:=True;
    CellProperties[3,17].ReadOnly:=True;
    Cells[4,17]:='0';  CellProperties[4,17].ReadOnly:=True;

    Cells[0,18]:='Total';
    CellProperties[1,18].ReadOnly:=True;
    CellProperties[2,18].ReadOnly:=True;
    CellProperties[3,18].ReadOnly:=True;
    Cells[4,18]:='0'; CellProperties[4,18].ReadOnly:=True;

    CellProperties[1,19].ReadOnly:=True;
    CellProperties[2,19].ReadOnly:=True;
    CellProperties[3,19].ReadOnly:=True;
    CellProperties[4,19].ReadOnly:=True;

    Cells[0,20]:='Forfait';
    Cells[1,20]:='au pourcent'; CellProperties[1,20].ReadOnly:=True;
    CellProperties[2,20].ReadOnly:=True;
    Cells[3,20]:='4';
    Cells[4,20]:='0'; CellProperties[4,20].ReadOnly:=True;

    Cells[0,21]:='Tiers';
    CellProperties[1,21].ReadOnly:=True;
    CellProperties[2,21].ReadOnly:=True;
    CellProperties[3,21].ReadOnly:=True;
    Cells[4,21]:='0';

    Cells[0,22]:='Total';
    CellProperties[1,22].ReadOnly:=True;
    CellProperties[2,22].ReadOnly:=True;
    CellProperties[3,22].ReadOnly:=True;
    Cells[4,22]:='0'; CellProperties[4,22].ReadOnly:=True; CellProperties[4,22].FontStyle:=[fsBold];

    Cells[0,23]:='T O T A L (honoraires+frais)'; CellProperties[0,23].Alignment:=taCenter;

    Cells[0,24]:='Total HT';
    CellProperties[1,24].ReadOnly:=True;
    CellProperties[2,24].ReadOnly:=True;
    CellProperties[3,24].ReadOnly:=True;
    Cells[4,24]:='0'; CellProperties[4,24].ReadOnly:=True; CellProperties[4,24].FontStyle:=[fsBold];

//ajout2.3 TVA+TTC
    Cells[0,25]:='TVA';
    Cells[1,25]:='%'; CellProperties[1,25].ReadOnly:=True;
    CellProperties[2,25].ReadOnly:=True;
    Cells[3,25]:='8'; CellProperties[3,25].ReadOnly:=True;
    Cells[4,25]:='0'; CellProperties[4,25].ReadOnly:=True;

    Cells[0,26]:='Total TTC';
    CellProperties[1,26].ReadOnly:=True;
    CellProperties[2,26].ReadOnly:=True;
    CellProperties[3,26].ReadOnly:=True;
    Cells[4,26]:='0'; CellProperties[4,26].ReadOnly:=True; CellProperties[4,26].FontStyle:=[fsBold]; CellProperties[4,26].BrushColor:=clYellow;

    for r:=1 to RowCount-1 do
      for c:=1 to ColCount-1 do
        if not CellProperties[c,r].ReadOnly then
          CellProperties[c,r].BrushColor:=COgreen;

    MergeCells(0, 0, 5, 1);
    MergeCells(1, 9, 3, 2);
    MergeCells(1,11, 2, 1);
    MergeCells(1,12, 3, 1);
    MergeCells(2,13, 3, 1);
    MergeCells(0,14, 5, 1);
    MergeCells(1,18, 3, 1);
    MergeCells(1,19, 3, 1);
    MergeCells(1,20, 2, 1);
    MergeCells(1,21, 3, 1);
    MergeCells(1,22, 3, 1);
    MergeCells(0,23, 5, 1);
    MergeCells(1,24, 3, 1);
//ajout2.3 TVA+TTC
    MergeCells(1,25, 2, 1);
    MergeCells(1,26, 3, 1);

    SelectRange(2, 2, 2, 2);
  end;

  with grdOffres do begin
    FloatingFooter.ColumnCalc[0]:=acCOUNT;
    FloatingFooter.ColumnCalc[2]:=acSUM;
  end;
  with grdAdjudications do begin
    FloatingFooter.ColumnCalc[0]:=acCOUNT;
    FloatingFooter.ColumnCalc[2]:=acSUM;
  end;
  with grdSituations do begin
    FloatingFooter.ColumnCalc[0]:=acCOUNT;
    FloatingFooter.ColumnCalc[2]:=acSUM;
  end;
  with grdDocuments do begin
    FloatingFooter.ColumnCalc[0]:=acCOUNT;
  end;


  with grdPenetro do begin
    Cells[0, 1]:='Installation';
    Cells[0, 2]:='Déplacements';
    Cells[0, 3]:='De 0 à 5 m';
    Cells[0, 4]:='De 5 à 10 m';
    Cells[0, 5]:='De 10 à 15 m';
    Cells[0, 6]:='De 15 à 20 m';
    Cells[0, 7]:='>100 cps/20 cm';
    Cells[0, 8]:='Graphiques';
    Cells[0, 9]:='Kilomètres';
    Cells[0,10]:='TOTAL';

    Cells[1, 1]:='bloc';
    Cells[1, 2]:='pces';
    Cells[1, 3]:='m';
    Cells[1, 4]:='m';
    Cells[1, 5]:='m';
    Cells[1, 6]:='m';
    Cells[1, 7]:='m';
    Cells[1, 8]:='pces';
    Cells[1, 9]:='km';

    Cells[3, 1]:='1';
    Cells[3, 2]:='0';
    Cells[3, 3]:='0';
    Cells[3, 4]:='0';
    Cells[3, 5]:='0';
    Cells[3, 6]:='0';
    Cells[3, 7]:='0';
    Cells[3, 8]:='0';
    Cells[3, 9]:='0';

    Cells[4, 2]:='0';
    Cells[4, 3]:='0';
    Cells[4, 4]:='0';
    Cells[4, 5]:='0';
    Cells[4, 6]:='0';
    Cells[4, 7]:='0';
    Cells[4, 8]:='0';
    Cells[4, 9]:='0';

    SelectCells(3, 2, 3, 2);
  end;

  grdDétailsColumnResize(nil);
  apcMain.ActivePage:=atsSuspens;
  atsDatas.TabEnable:=False;
  atsDétail.TabEnable:=False;
  atsPénétro.TabEnable:=False;
end;

procedure TfrmMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var i: integer;
begin
  i:=GridLinkIndex(ActiveControl.Name);
  if i=-1 then
    Handled:=False
  else with GridLinks[i].grid do
    if IsEmptyRow(Rows[Row]) then begin
      if 0<WheelDelta then
        Row:=Max(RowCount-3,1);
      Handled:=True;
    end
    else if (Row=RowCount-2) and (0>WheelDelta) then begin
      RowCount:=RowCount+1;
      Row:=Row+1;
      AddExpand(3, Row, 3*RowHeights[0]);
      AdjustGridSize(GridLinks[i].grid, 0);
      Handled:=True;
    end
    else
      Handled:=False
end;

procedure TfrmMain.FormShow(Sender: TObject);
var p: integer;
    s: string;
begin
  if Run then Exit;
  SettingsLoad;
  if not FileExists(DBmandats) then Close;
  adoDatas.Open();
  if Favorite<>'' then begin
    actFavorite.Caption:='< '+UpperCase(Favorite)+' >';
    actFavorite.Execute;
  end;
  p:=Pos('" "', CmdLine);
  if 0<p then begin
    s:=Copy(CmdLine, p+3, Length(CmdLine)-p-3);
    if s<>'' then begin
      CD.FABfile:=s;
      LoadDatas;
    end;
  end;
  RUN:=True;
end;

end.
