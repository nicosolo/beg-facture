program BEGfacture;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  main in 'main.pas' {frmMain},
  kbob in 'kbob.pas' {dlgKBOB},
  html in 'html.pas',
  summary in 'summary.pas' {frmSummary},
  wizard in 'wizard.pas' {dlgWizard},
  creation in 'creation.pas' {dlgCreate},
  clear in 'clear.pas' {dlgClear};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
