unit summary;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ExtCtrls,
  AdvPanel, Vcl.StdCtrls, JvComponentBase, JvCaptionButton, Vcl.Buttons;

type
  TfrmSummary = class(TForm)
    broSummary: TWebBrowser;
    pnlTop: TAdvPanel;
    btnHome: TSpeedButton;
    btnPrintSummary: TSpeedButton;
    procedure btnHomeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintSummaryClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    FileName: TFileName;
  end;

var
  frmSummary: TfrmSummary;

implementation

{$R *.dfm}

procedure TfrmSummary.btnHomeClick(Sender: TObject);
begin
  broSummary.Navigate(filename);
end;

procedure TfrmSummary.btnPrintSummaryClick(Sender: TObject);
begin
  broSummary.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER);
end;

procedure TfrmSummary.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

end.
