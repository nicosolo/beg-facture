unit kbob;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, XDBGrids, Vcl.StdCtrls,
  AdvEdit, Vcl.ExtCtrls, AdvEdBtn, Vcl.Mask, AdvSpin;

type
  TdlgKBOB = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    grdTarifs: TXDBGrid;
    Panel1: TPanel;
    edtYear: TAdvSpinEdit;
    procedure grdTarifsCellDblClick(Column: TXColumn);
    procedure edtYearChange(Sender: TObject);
    procedure edtYearKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dlgKBOB: TdlgKBOB;

implementation

{$R *.dfm}

uses main;

procedure TdlgKBOB.edtYearChange(Sender: TObject);
begin
  with frmMain.tabTarifs do begin
    Filter:=Format('(Classe>''A'') And (Classe<''H'') AND (Année=%d)', [edtYear.Value]);
    Filtered:=True;
  end;
end;

procedure TdlgKBOB.edtYearKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=27 then ModalResult:=mrCancel;
end;

procedure TdlgKBOB.grdTarifsCellDblClick(Column: TXColumn);
begin
  Modalresult:=mrOK;
end;

end.
