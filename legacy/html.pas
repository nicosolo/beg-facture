unit html;

interface

uses
  System.Classes;

type
  THTML = class(TStringList)
  private
  public
    constructor Create(Title: string);
    procedure CloseHTML(Footer: string);
    procedure OpenInformation; overload;
    procedure OpenInformation(Title: string); overload;
    procedure Information(Info1, Info2: string);
    procedure InformationObjet(Info1, Info2: string);
    procedure OpenFacture(Title: string);
    procedure Facture (Col1, Col2, Col3, Col4: string); overload;
    procedure Facture (Col1      , Col3, Col4: string); overload;
    procedure Facture (Col1            , Col4: string); overload;
    procedure OpenDocument(Title: string);
    procedure Document(Col1, Col2, Col3      : string);
    procedure CloseTable;
    function FileLink(FileName: string): string;
  end;

implementation

uses
  System.SysUtils;

constructor THTML.Create(Title: string);
begin
  inherited Create;
  DefaultEncoding:=TEncoding.UTF8;
  Add('<!DOCTYPE html>');
// ! pas compris par thunderbird
//  Add('<html lang="fr">');
  Add('<html>');
  Add('');
  Add('<head>');
  Add('<title>Facture 5808</title>');
  Add('<meta charset="UTF-8">');
  Add('<meta name="description" content="Résumé de la préparation d''une facture">');
  Add('<meta name="author" content="Jean Savary/BEG SA">');
  Add('');
  Add('<style>');
  Add('body {');
//largeur fixe
  Add('  width: 17cm;');
  Add('}');
  Add('caption {');
  Add('  font: 100% calibri, sans-serif;');
  Add('  font-weight: bold;');
  Add('}');
  Add('caption.main {');
  Add('  background-color: silver;');
  Add('  font: 125% calibri, sans-serif;');
  Add('  margin-top: 30px;');
  Add('  padding: 2px;');
  Add('}');
  Add('caption.sub {');
  Add('  font: 100% calibri, sans-serif;');
  Add('  font-weight: bold;');
  Add('  text-align: left;');
  Add('  padding: 2px 2px 0px 2px;');
  Add('}');
  Add('table, td {');
  Add('  border-collapse: collapse;');
  Add('  border: 1px solid silver;');
  Add('  font: 95% calibri, sans-serif;');
  Add('  padding: 2px;');
  Add('  vertical-align: text-top;');
  Add('}');
  Add('table.line {');
  Add('  width: 100%;');
  Add('}');
  Add('table.line, td.info1, td.info2 {');
  Add('  border-style: solid none solid none;');
  Add('}');
  Add('td.info1 {');
  Add('  font-weight: bold;');
  Add('  padding-right: 8px;');
  Add('  text-align: right;');
  Add('  width: 4cm;');
  Add('}');
  Add('table.fac {');
  Add('  width: 70%');
  Add('}');
  Add('td.fac2, td.fac3, td.fac4 {');
  Add('  text-align: right;');
  Add('  width: 25%;');
  Add('}');
  Add('td.doc1, td.doc2, td.doc3 {');
  Add('  border-style: none;');
  Add('}');
  Add('td.doc1 {');
  Add('  width: 1.8cm;');
  Add('}');
  Add('td.doc2 {');
  Add('  width: 5.7cm;');
  Add('}');
  Add('</style>');
  Add('</head>');
  Add('<body>');
  Add('');
end;

procedure THTML.CloseHTML(Footer: string);
begin
  Add('');
  Add('<p style="font:70% calibri, sans-serif;Text-align:right">'+Footer+'</p>');
  Add('');
  Add('</body>');
  Add('</html>');
end;

procedure THTML.OpenInformation;
begin
  Add('<table class="line">');
end;

procedure THTML.OpenInformation(Title: string);
begin
  Add('<table class="line">');
  Add('  <caption class="main">'+Title+'</caption>');
end;

procedure THTML.Information(Info1, Info2: string);
begin
  Add('  <tr>');
  Add('    <td class="info1">'+Info1+'</td>');
  Add('    <td class="info2">'+Info2+'</td>');
  Add('  </tr>');
end;

procedure THTML.InformationObjet(Info1, Info2: string);
begin
  Add('  <tr>');
  Add('    <td class="info1">'+Info1+'</td>');
  Add('    <td class="info2" style="background-color:silver;font-weight:bold">'+Info2+'</td>');
  Add('  </tr>');
end;

procedure THTML.OpenFacture(Title: string);
begin
  Add('<table class="fac">');
  Add('  <caption class="sub">'+Title+'</caption>');
end;

procedure THTML.Facture(Col1, Col2, Col3, Col4: string);
begin
  Add('  <tr>');
  Add('    <td class="fac1">'+Col1+'</td>');
  Add('    <td class="fac2">'+Col2+'</td>');
  Add('    <td class="fac3">'+Col3+'</td>');
  Add('    <td class="fac4">'+Col4+'</td>');
  Add('  </tr>');
end;

procedure THTML.Facture(Col1, Col3, Col4: string);
begin
  Add('  <tr>');
  Add('    <td class="fac1" colspan="2">'+Col1+'</td>');
  Add('    <td class="fac3">'+Col3+'</td>');
  Add('    <td class="fac4">'+Col4+'</td>');
  Add('  </tr>');
end;

procedure THTML.Facture(Col1, Col4: string);
begin
  Add('  <tr>');
  Add('    <td class="fac1" colspan="3">'+Col1+'</td>');
  Add('    <td class="fac4">'+Col4+'</td>');
  Add('  </tr>');
end;

procedure THTML.OpenDocument(Title: string);
begin
  Add('<table class="line">');
  Add('  <caption class="sub">'+Title+'</caption>');
end;

procedure THTML.Document(Col1, Col2, Col3: string);
begin
  Add('  <tr>');
  Add('    <td class="doc1">'+Col1+'</td>');
  Add('    <td class="doc2">'+Col2+'</td>');
  Add('    <td class="doc3">'+Col3+'</td>');
  Add('  </tr>');
end;

procedure THTML.CloseTable;
begin
  Add('</table>');
  Add('');
end;

function THTML.FileLink(FileName: string): string;
begin
  Result:=Format('<a href="file:///%s" moz-do-not-send="true">%s</a>',
                [FileName, ExtractFileName(FileName)]);
end;

end.
