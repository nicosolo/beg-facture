unit creation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, XDBGrids, Vcl.StdCtrls,
  AdvEdit, Vcl.ExtCtrls, AdvEdBtn;

type
  TdlgCreate = class(TForm)
    Button1: TButton;
    Button2: TButton;
    XDBGrid1: TXDBGrid;
    Panel1: TPanel;
    edtFilter: TAdvEditBtn;
    procedure edtFilterChange(Sender: TObject);
    procedure XDBGrid1CellDblClick(Column: TXColumn);
    procedure edtFilterClickBtn(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dlgCreate: TdlgCreate;

implementation

{$R *.dfm}

uses main;

procedure TdlgCreate.edtFilterChange(Sender: TObject);
begin
  with frmMain.tabTous do begin
    if edtFilter.Text='' then
      Filtered:=False
    else begin
      Filter:='Nom like ''*'+edtFilter.Text+'*''';
      Filtered:=True
    end;
  end;
end;

procedure TdlgCreate.edtFilterClickBtn(Sender: TObject);
begin
  edtFilter.Text:=''
end;

procedure TdlgCreate.XDBGrid1CellDblClick(Column: TXColumn);
begin
  Modalresult:=mrOK;
end;

end.
