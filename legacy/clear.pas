unit clear;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvDateTimePicker;

type
  TdlgClear = class(TForm)
    edtA: TAdvDateTimePicker;
    rabAll: TRadioButton;
    rabPartial: TRadioButton;
    Label1: TLabel;
    pnlCode: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    Panel1: TPanel;
    procedure rabClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dlgClear: TdlgClear;

implementation

{$R *.dfm}

procedure TdlgClear.rabClick(Sender: TObject);
begin
  edtA.Enabled:=rabPartial.Checked;
end;

end.
