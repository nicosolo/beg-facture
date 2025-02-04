object dlgClear: TdlgClear
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsDialog
  BorderWidth = 16
  Caption = 'Retirer des heures de la base'
  ClientHeight = 217
  ClientWidth = 340
  Color = 14737632
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    AlignWithMargins = True
    Left = 24
    Top = 126
    Width = 256
    Height = 16
    Margins.Left = 24
    Margins.Top = 0
    Margins.Right = 60
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Attention :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitLeft = 0
    ExplicitTop = 82
    ExplicitWidth = 72
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 24
    Top = 144
    Width = 316
    Height = 16
    Margins.Left = 24
    Margins.Top = 2
    Margins.Right = 0
    Margins.Bottom = 16
    Align = alTop
    Caption = 'la date propos'#233'e n'#39'est peut-'#234'tre pas correcte !'
    ExplicitLeft = 0
    ExplicitTop = 98
    ExplicitWidth = 267
  end
  object edtA: TAdvDateTimePicker
    AlignWithMargins = True
    Left = 110
    Top = 94
    Width = 110
    Height = 24
    Hint = 
      'P'#233'riode de la facturation; Par d'#233'faut couvre l'#39'entier des heurs ' +
      'non factur'#233'es; Mais cet intervalle peut '#234'tre modifi'#233
    Margins.Left = 0
    Margins.Top = 4
    Margins.Right = 120
    Margins.Bottom = 8
    Align = alTop
    Date = 41932.705104166660000000
    Format = ''
    Time = 41932.705104166660000000
    DoubleBuffered = True
    Enabled = False
    Kind = dkDate
    ParentDoubleBuffered = False
    TabOrder = 0
    TabStop = True
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41932.705104166660000000
    Version = '1.2.2.0'
    LabelCaption = 'Jusqu'#39#224':'
    LabelPosition = lpLeftCenter
    LabelMargin = 8
    LabelTransparent = True
    LabelAlwaysEnabled = True
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object rabAll: TRadioButton
    AlignWithMargins = True
    Left = 0
    Top = 40
    Width = 340
    Height = 17
    Margins.Left = 0
    Margins.Top = 16
    Margins.Right = 0
    Margins.Bottom = 4
    Align = alTop
    Caption = 'Retirer toutes les heures de la facturation'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = rabClick
    ExplicitWidth = 312
  end
  object rabPartial: TRadioButton
    AlignWithMargins = True
    Left = 0
    Top = 69
    Width = 340
    Height = 17
    Margins.Left = 0
    Margins.Top = 8
    Margins.Right = 0
    Margins.Bottom = 4
    Align = alTop
    Caption = 'Retirer les heures jusqu'#39#224' la date suivante comprise:'
    TabOrder = 2
    OnClick = rabClick
    ExplicitWidth = 320
  end
  object pnlCode: TPanel
    Tag = 99
    Left = 0
    Top = 0
    Width = 340
    Height = 24
    Hint = 
      'Code du mandat dont la facture est en cours de pr'#233'paration; <b>d' +
      'ouble clic</b> si l'#39'onglet des factures en suspens et le respons' +
      'able sont s'#233'lectionn'#233's, permet d'#39'atteindre la bonne ligne'
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 160
    Margins.Bottom = 0
    Align = alTop
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = 10551295
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    ExplicitLeft = 76
    ExplicitWidth = 160
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 192
    Width = 340
    Height = 25
    Margins.Left = 0
    Margins.Top = 16
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitTop = 114
    ExplicitWidth = 312
    object btnCancel: TButton
      Left = 265
      Top = 0
      Width = 75
      Height = 25
      Margins.Left = 16
      Margins.Top = 16
      Margins.Right = 16
      Margins.Bottom = 16
      Align = alRight
      Cancel = True
      Caption = 'Annuler'
      Default = True
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 201
    end
    object btnOk: TButton
      AlignWithMargins = True
      Left = 174
      Top = 0
      Width = 75
      Height = 25
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
      ExplicitLeft = 36
    end
  end
end
