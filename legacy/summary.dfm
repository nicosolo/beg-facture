object frmSummary: TfrmSummary
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ScreenSnap = True
  SnapBuffer = 15
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object broSummary: TWebBrowser
    Left = 0
    Top = 36
    Width = 635
    Height = 263
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 216
    ExplicitTop = 152
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000A14100002F1B00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object pnlTop: TAdvPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    Color = 16316664
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    UseDockManager = True
    Version = '2.3.0.6'
    Caption.Color = clHighlight
    Caption.ColorTo = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -13
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = []
    ColorTo = 13684944
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWindowText
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    Text = '<P align="center">R'#233'sum'#233'</P>'
    TextVAlign = tvaCenter
    FullHeight = 36
    object btnHome: TSpeedButton
      AlignWithMargins = True
      Left = 8
      Top = 6
      Width = 80
      Height = 24
      Hint = 'Recharge le r'#233'sum'#233
      Margins.Left = 8
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alLeft
      Caption = '<<<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btnHomeClick
    end
    object btnPrintSummary: TSpeedButton
      AlignWithMargins = True
      Left = 547
      Top = 6
      Width = 80
      Height = 24
      Hint = 'Imprime le r'#233'sum'#233
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 8
      Margins.Bottom = 6
      Align = alRight
      Caption = 'Imprimer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btnPrintSummaryClick
      ExplicitLeft = 288
      ExplicitHeight = 22
    end
  end
end
