unit wizard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  HTMLDialog, DragDrop, DropTarget, DragDropFile, Vcl.ComCtrls, JvExComCtrls,
  JvPageListTreeView, AdvEdBtn, HTMLabel, JvExControls, JvStaticText,
  Vcl.StdCtrls, ColListb, AdvDateTimePicker, AdvEdit, CurvyControls,
  Vcl.Buttons, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvCGrid, AdvCombo,
  JvDBLookup, XDBGrids, JvPageList, Vcl.ExtCtrls;

type
  TStep = record
    Title, Help           : string;
    Previous, Next, Parent: integer;
    Explorer              : boolean;
  end;
  TdlgWizard = class(TForm)
    pnlRight: TPanel;
    pnlLeft: TPanel;
    pnlTitle: TPanel;
    pnlBottom: TPanel;
    btnPrevious: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    lblStep: TLabel;
    lblHelp: THTMLabel;
    pglStep: TJvPageList;
    Page01: TJvStandardPage;
    Page02: TJvStandardPage;
    Page03: TJvStandardPage;
    Page04: TJvStandardPage;
    Page05: TJvStandardPage;
    Page06: TJvStandardPage;
    Page07: TJvStandardPage;
    Page08: TJvStandardPage;
    Page00: TJvStandardPage;
    edtType: TColumnListBox;
    edtMode: TColumnListBox;
    Label1: TLabel;
    Label2: TLabel;
    edtPériode: TAdvEdit;
    edtA: TAdvDateTimePicker;
    edtDe: TAdvDateTimePicker;
    btnGetInterval: TSpeedButton;
    Label6: TLabel;
    edtAdresse: TCurvyMemo;
    Label7: TLabel;
    edtEnvoi: TCurvyMemo;
    btnCopyAddress: TButton;
    btnLocalCH: TButton;
    Panel1: TPanel;
    btnCopyDocs: TSpeedButton;
    edtPrestations: TCurvyMemo;
    grdDocuments: TAdvColumnGrid;
    grdAdjudications: TAdvColumnGrid;
    grdOffres: TAdvColumnGrid;
    edtObjet: TAdvEdit;
    edtResponsable: TJvDBLookupCombo;
    grdFactures: TXDBGrid;
    Label3: TLabel;
    Panel2: TPanel;
    edtVisa: TAdvComboBox;
    dftFile: TDropFileTarget;
    Bevel3: TBevel;
    trvStep: TJvPageListTreeView;
    dlgMsg: THTMLDialog;
    lblType: TJvStaticText;
    Page09: TJvStandardPage;
    Page10: TJvStandardPage;
    Page11: TJvStandardPage;
    edtPrepare: TAdvEditBtn;
    HTMLabel1: THTMLabel;
    HTMLabel2: THTMLabel;
    Label4: TLabel;
    edtComment: TCurvyMemo;
    btnExplorer: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure pglStepChange(Sender: TObject);
    procedure edtResponsableChange(Sender: TObject);
    procedure dftFileEnter(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure dftFileDrop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure grdOffresCanDeleteRow(Sender: TObject; ARow: Integer;
      var CanDelete: Boolean);
    procedure btnCopyDocsClick(Sender: TObject);
    procedure Page05Show(Sender: TObject);
    procedure btnGetIntervalClick(Sender: TObject);
    procedure pglStepChanging(Sender: TObject; PageIndex: Integer;
      var AllowChange: Boolean);
    procedure trvStepCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure edtTypeClick(Sender: TObject);
    procedure edtModeClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCopyAddressClick(Sender: TObject);
    procedure btnLocalCHClick(Sender: TObject);
    procedure edtDateChange(Sender: TObject);
    procedure btnExplorerClick(Sender: TObject);
    procedure grdDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure edtPrepareDblClick(Sender: TObject);
    procedure edtPrepareClickBtn(Sender: TObject);
    procedure Page00Show(Sender: TObject);
    procedure Page01Show(Sender: TObject);
    procedure Page02Show(Sender: TObject);
    procedure Page03Show(Sender: TObject);
    procedure Page04Show(Sender: TObject);
    procedure Page06Show(Sender: TObject);
    procedure Page07Show(Sender: TObject);
    procedure Page10Show(Sender: TObject);
    procedure Page11Show(Sender: TObject);
  private
    { Déclarations privées }
    IDmandat: integer;
  public
    { Déclarations publiques }
  end;

var
  dlgWizard: TdlgWizard;
  Steps : array[0..11] of TStep;

implementation

{$R *.dfm}

uses main, System.IOUtils, Winapi.ShellAPI;

procedure TdlgWizard.btnCopyAddressClick(Sender: TObject);
begin
  edtEnvoi.Lines.Assign(edtAdresse.Lines);
end;

procedure TdlgWizard.btnCopyDocsClick(Sender: TObject);
var i: integer;
begin
  with grdDocuments do
    for i:=1 to RowCount-1 do
      if not Cells[3, i].IsEmpty then
        edtPrestations.Lines.Add(Cells[3, i]+' ('+Cells[1, i]+')')
end;

procedure TdlgWizard.btnExplorerClick(Sender: TObject);
var folder, command: AnsiString;
begin
  folder:=frmMain.GetDirectory(frmMain.tabFacture.FieldByName('Mandat').AsInteger);
  if folder='' then
    MessageDlg('Dossier introuvable !', mtInformation, [mbOK], 0)
  else begin
    command:='C:\Windows\explorer.exe'+' "'+folder+'"';
    WinExec(PAnsiChar(command), 1);
  end
end;

procedure TdlgWizard.btnGetIntervalClick(Sender: TObject);
begin
  with frmMain.tabFacture do begin
    edtDe.Date:=FieldByName('De').AsDateTime;
    edtA.Date:=FieldByName('A').AsDateTime;
    edtDateChange(nil);
  end;
end;

procedure TdlgWizard.btnLocalCHClick(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', PChar('http://www.local.ch'), nil, nil, SW_SHOWDEFAULT)
end;

procedure TdlgWizard.btnNextClick(Sender: TObject);
begin
  with pglStep do
    if Steps[ActivePageIndex].Next<>-1 then
      ActivePageIndex:=Steps[ActivePageIndex].Next;
end;

procedure TdlgWizard.btnPreviousClick(Sender: TObject);
begin
  with pglStep do
    ActivePageIndex:=Steps[ActivePageIndex].Previous;
end;

procedure TdlgWizard.dftFileDrop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);

  procedure DropFile(grd: TAdvColumnGrid);
  var f, i : integer;
  begin
    with grd, Sender as TDropFileTarget do begin
      for f:=0 to dftFile.Files.Count-1 do begin
        for i:=1 to RowCount-1 do
          if Cells[4, i]=Files[f] then begin
            MessageDlg('Le fichier '+ExtractFileName(Files[f])+' existe déjà dans la liste', mtInformation, [mbOk], 0);
            Exit;
          end;
        i:=RowCount-1;
        if  Cells[4, i]<>'' then begin
          i:=RowCount;
          RowCount:=RowCount+1;
        end;
        Cells[0, i]:=ExtractFileName(Files[f]);
        Cells[1, i]:=dateToStr(TFile.GetLastWriteTime(Files[f]));
        Cells[4, i]:=Files[f];
        AddExpand(3, i, 3*RowHeights[0]);
      end;
    end;
  end;

begin
  with Sender as TDropFileTarget do
    if Target is TAdvEdit then
      edtPrepare.Text:=dftFile.Files[0]
    else
      DropFile(Target as TAdvColumnGrid)
end;

procedure TdlgWizard.dftFileEnter(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
begin
  if dftFile.Target is TAdvEdit then
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

procedure TdlgWizard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  with pglStep do
    if (ActivePageIndex=10) and (edtPrepare.Text='') then begin
      dlgMsg.HTMLText.Text:='<b>Etape 11 :</b> Il faut insérer la facture préprarée<br>';
      dlgMsg.Height:=1*16+56;
      dlgMsg.ShowModal;
      CanClose:=False;
    end
    else if (ActivePageIndex=11) and (edtComment.Lines.Count=0) then begin
      dlgMsg.HTMLText.Text:='<b>Etape 12 :</b> Il faut indiquer le montant du forfait<br>';
      dlgMsg.Height:=1*16+56;
      dlgMsg.ShowModal;
      CanClose:=False;
    end;
end;

procedure TdlgWizard.FormCreate(Sender: TObject);
var i: integer;
begin
  IDmandat:=0;
  with Steps[0] do begin
    Title   :='Choix du mandat';
    Help    :='1) Choisir le <b>responsable</b><br>2) Choisir le <b>mandat</b><br>3) Choisir le patron (<b>Visa</b>) qui doit contrôler la facture';
    Previous:=-1;
    Next    :=1;
    Parent  :=-1;
    Explorer:=False;
  end;
  with Steps[1] do begin
    Title   :='Saisie des offres';
    Help    :='1) Ouvrir le dossier<br>2) Balançer les offres dans la liste<br>3) Contrôler la date<br>4) Saisir le montant HT<br>5) Commenter<br><br>'+
              '<b>Double clic</b> sur le nom du fichier, l''ouvre<br><b>ctrl+del</b> supprime la ligne sélectionnée';
    Previous:=0;
    Next    :=2;
    Parent  :=-1;
    Explorer:=True;
  end;
  with Steps[2] do begin
    Title   :='Saisie des adjudications';
    Help    :='1) Ouvrir le dossier<br>2) Balançer les adjudications dans la liste<br>3) Contrôler la date<br>4) Saisir le montant HT<br>5) Commenter<br><br>'+
              '<b>Double clic</b> sur le nom du fichier, l''ouvre<br><b>ctrl+del</b> supprime la ligne sélectionnée';
    Previous:=1;
    Next    :=3;
    Parent  :=-1;
    Explorer:=True;
  end;
  with Steps[3] do begin
    Title   :='Saisie des documents';
    Help    :='1) Ouvrir le dossier<br>2) Balançer les documents produits et transmis au client<br>3) Contrôler la date,<br>4) Commenter<br><br>'+
              'Il est très <b>important</b> de mettre un commentaire (p.ex.: Rapport d''étude géotechnique préliminaire)<br><br><b>Double clic</b> sur le nom du fichier, l''ouvre'+
              '<br><b>ctrl+del</b> supprime la ligne sélectionnée';
    Previous:=2;
    Next    :=4;
    Parent  :=-1;
    Explorer:=True;
  end;
  with Steps[4] do begin
    Title   :='Prestations';
    Help    :='Description des prestations telles qu''apparaissant sur la facture<br><br>La liste des documents produits doit y être insérée: bouton <b>[Documents]</b>';
    Previous:=3;
    Next    :=5;
    Parent  :=-1;
    Explorer:=False;
  end;
  with Steps[5] do begin
    Title   :='Période à facturer';
    Help    :='<b>[Tout]</b> Si tout doit être facturé<br><br><b>Sinon</b> préciser l''étendue de la période à facturer<br><br>Modifier. si nécessaire, le libellés de l''objet et de la période (p. ex.: Travaux 2014)';
    Previous:=4;
    Next    :=6;
    Parent  :=-1;
    Explorer:=False;
  end;
  with Steps[6] do begin
    Title   :='Adresse de facturation';
    Help    :='<b>Adresse</b>:<br>Adresse de la société qui doit payer<br><br><b>Envoi</b>:<br>Adresse de la personne qui doit contrôler et transmettre la facture';
    Previous:=5;
    Next    :=7;
    Parent  :=-1;
    Explorer:=False;
  end;
  with Steps[7] do begin
    Title   :='Type et mode de facturation';
    Help    :='1) Choisir le <b>type</b> de facture<br>2) Choisir le <b>mode</b> de facturation';
    Previous:=6;
    Next    :=8;
    Parent  :=-1;
    Explorer:=False;
  end;
  with Steps[8] do begin
    Title   :='Selon les données présentes';
    Help    :='';
    Previous:=7;
    Next    :=-1;
    Parent  :=7;
    Explorer:=False;
  end;
  with Steps[9] do begin
    Title   :='Selon l''offre';
    Help    :='';
    Previous:=7;
    Next    :=-1;
    Parent  :=7;
    Explorer:=False;
  end;
  with Steps[10] do begin
    Title   :='Selon la facture préparée';
    Help    :='1) Ouvrir le dossier<br>2) Balançer la facture préparée<br><br><b>Double clic</b> ouvre le fichier';
    Previous:=7;
    Next    :=-1;
    Parent  :=7;
    Explorer:=True;
  end;
  with Steps[11] do begin
    Title   :='Forfait';
    Help    :='Indiquer le <b>montant du forfait</b> pour la comptabilité';
    Previous:=7;
    Next    :=-1;
    Parent  :=7;
    Explorer:=False;
  end;
  for i:=Low(Steps) to High(Steps) do
    with Steps[i] do
      if Parent=-1 then
        TJvPageIndexNode(trvStep.Items.Add(nil, Format('%d. %s', [i+1, Title]))).PageIndex:=i
      else begin
        TJvPageIndexNode(trvStep.Items.AddChild(trvStep.Items[Parent], Format('%d. %s', [i+1, Title]))).PageIndex:=i;;
        trvStep.Items[Parent].Expand(True);
      end;
  pglStepChange(nil);
  with dftFile do begin
    Register(grdOffres);
    Register(grdAdjudications);
    Register(grdDocuments);
    Register(edtPrepare);
  end;
end;

procedure TdlgWizard.grdOffresCanDeleteRow(Sender: TObject; ARow: Integer;
  var CanDelete: Boolean);
begin
  with Sender as TAdvColumnGrid do begin
    CanDelete:=2<RowCount;
    if not CanDelete then
      Rows[ARow].Clear
  end;
end;

procedure TdlgWizard.grdDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  with Sender as TAdvColumnGrid do
    if (ACol=0) and (Cells[4, ARow]<>'') then
      if FileExists(Cells[4, ARow]) then
        ShellExecute(Handle, 'Open', PChar(Cells[4, ARow]), nil, nil, SW_SHOWDEFAULT)
      else
        MessageDlg('Le fichier ['+ExtractFileName(Cells[4, ARow])+'] est introuvable !', mtInformation, [mbOK], 0);
end;

procedure TdlgWizard.Page00Show(Sender: TObject);
begin
  edtResponsable.SetFocus;
end;

procedure TdlgWizard.Page01Show(Sender: TObject);
begin
  grdOffres.SetFocus;
end;

procedure TdlgWizard.Page02Show(Sender: TObject);
begin
  grdAdjudications.SetFocus;
end;

procedure TdlgWizard.Page03Show(Sender: TObject);
begin
  grdDocuments.SetFocus;
end;

procedure TdlgWizard.Page04Show(Sender: TObject);
begin
  edtprestations.SetFocus;
end;

procedure TdlgWizard.Page05Show(Sender: TObject);
begin
  with frmMain.tabFacture do
    if IDmandat<>FieldByName('IDmandat').AsInteger then begin
      IDmandat:=FieldByName('IDmandat').AsInteger;
      edtObjet.Text:=FieldByName('N').AsString+' '+FieldByName('Désignation').AsString;
      btnGetInterval.Click;
    end;
  edtObjet.SetFocus;
end;

procedure TdlgWizard.Page06Show(Sender: TObject);
begin
  edtAdresse.SetFocus;
end;

procedure TdlgWizard.Page07Show(Sender: TObject);
begin
  edtType.SetFocus;
end;

procedure TdlgWizard.Page10Show(Sender: TObject);
begin
  edtPrepare.SetFocus;
end;

procedure TdlgWizard.Page11Show(Sender: TObject);
begin
  edtComment.SetFocus;
end;

procedure TdlgWizard.edtDateChange(Sender: TObject);
begin
  edtPériode.Text:='Travaux du '+DateToStr(edtDe.Date)+' au '+DateToStr(edtA.Date);
end;

procedure TdlgWizard.edtModeClick(Sender: TObject);
begin
  Steps[7].Next:=8+edtMode.ItemIndex;
end;

procedure TdlgWizard.edtPrepareClickBtn(Sender: TObject);
begin
  edtPrepare.Text:='';
end;

procedure TdlgWizard.edtPrepareDblClick(Sender: TObject);
begin
  if edtPrepare.Text<>'' then
    if FileExists(edtPrepare.Text) then
      ShellExecute(Handle, 'Open', PChar(edtPrepare.Text), nil, nil, SW_SHOWDEFAULT)
    else
      MessageDlg('Le fichier ['+ExtractFileName(edtPrepare.Text)+'] est introuvable !', mtInformation, [mbOK], 0);
end;

procedure TdlgWizard.edtResponsableChange(Sender: TObject);
begin
  frmMain.tabResponsablesAfterScroll(nil);
end;

procedure TdlgWizard.edtTypeClick(Sender: TObject);
begin
  case edtType.ItemIndex of
    0 : with lblType do begin
          Caption:='';
          Color:=clBtnFace;
          BorderStyle:=sbsNone;
        end;
    1 : with lblType do begin
          Caption:='Quand vous terminerez l''assistant, saisissez la liste des factures déjà envoyées et leurs montants respectifs (onglet Données de facturation et documents - liste des situations)';
          Color:=clWindow;
          BorderStyle:=sbsSingle;
        end;
    2,
    3 : with lblType do begin
          Caption:='Quand la facture aura été envoyée, inscrivez la dans la liste des situations avec son montant HT (onglet Données de facturation et documents)';
          Color:=clWindow;
          BorderStyle:=sbsSingle;
        end;
  end;
end;

procedure TdlgWizard.pglStepChange(Sender: TObject);
begin
  with pglStep.ActivePage do begin
    trvStep.Selected:=trvStep.Items[PageIndex];
    pnlTitle.Caption:=Steps[PageIndex].Title;
    lblStep.Caption:=Format('Etape %d', [PageIndex+1]);
    if Steps[PageIndex].Help='' then
      lblHelp.Hide
    else begin
      lblHelp.Show;
      lblHelp.HTMLText.Text:=Steps[PageIndex].Help;
    end;
    btnPrevious.Visible:=-1<Steps[PageIndex].Previous;
    if Steps[PageIndex].Next=-1 then begin
      btnNext.Caption:='Terminer';
      btnNext.ModalResult:=mrOk;
    end
    else begin
      btnNext.Caption:='>>>';
      btnNext.ModalResult:=mrNone;
    end;
    btnExplorer.Visible:=Steps[PageIndex].Explorer;
  end;
end;

procedure TdlgWizard.pglStepChanging(Sender: TObject; PageIndex: Integer;
  var AllowChange: Boolean);
var p, h : integer;
    m    : string;

  procedure Warning(msg: string);
  begin
    m:=m+Format('<b>Etape %d :</b> %s<br>', [p+1, msg]);
    Inc(h);
  end;

begin
  m:='';
  h:=0;
  AllowChange:=True;
  for p:=pglStep.ActivePageIndex to PageIndex-1 do
    case p of
      0 : begin
            if edtVisa.ItemIndex=-1 then AllowChange:=False;
            if not AllowChange then
              Warning('Le visa doit être sélectionné');
          end;
      4 : begin
            if edtPrestations.Lines.Count=0 then AllowChange:=False;
            if not AllowChange then
              Warning('Les prestations doivent êre décrites');
          end;
      5 : begin
            if (edtObjet.Text='') or (edtPériode.Text='') then AllowChange:=False;
            if not AllowChange then
              Warning('L''objet et la période facturée doivent être précisés');
          end;
      6 : begin
            if edtAdresse.Lines.Count=0 then AllowChange:=False;
            if not AllowChange then
              Warning('L''adresse de facturation doit être précisée');
          end;
    end;
  if PageIndex in [8..11] then begin
    if edtMode.ItemIndex<>PageIndex-8 then AllowChange:=False;
    if not AllowChange then begin
      p:=7;
      Warning('Le mode de facturation sélectionné est différent');
    end
  end;
  if not AllowChange then begin
    dlgMsg.HTMLText.Text:=m;
    dlgMsg.Height:=h*16+56;
    dlgMsg.ShowModal;
  end;
end;

procedure TdlgWizard.trvStepCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  AllowCollapse:=False;
end;

end.
