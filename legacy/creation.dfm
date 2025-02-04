object dlgCreate: TdlgCreate
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'Nouvelle facture vide'
  ClientHeight = 357
  ClientWidth = 509
  Color = 14737632
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 509
    Height = 357
    AutoSize = True
    BevelKind = bkFlat
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object XDBGrid1: TXDBGrid
      Left = 8
      Top = 36
      Width = 400
      Height = 309
      Hint = 'Mandat s'#233'lectionn'#233
      DataSource = frmMain.dsrTous
      FixedStyle = fsGray
      FixedTheme = ftNone
      Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
      GridStyle.VisualStyle = vsXPStyle
      HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints, hoShowToolTips, hoShowDataHints, hoShowTotalToolTips]
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgHotButtons, dgTitleButtons, dgTitleHeaders, dgTitleWidthOff, dgMarkerAutoAlign, dgMarkerAutoToggle]
      StretchMode = True
      TabOrder = 1
      WheelScrollRows = 1
      OnCellDblClick = XDBGrid1CellDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'Nom'
          ShowEdit = False
          Visible = True
          Width = 1534
        end>
    end
    object Button1: TButton
      Left = 422
      Top = 293
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object Button2: TButton
      Left = 422
      Top = 320
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Annuler'
      Default = True
      ModalResult = 2
      TabOrder = 3
    end
    object edtFilter: TAdvEditBtn
      Left = 8
      Top = 8
      Width = 400
      Height = 24
      Hint = 'Filtre pour recherche rapide'
      EmptyTextStyle = []
      Flat = False
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      ReadOnly = False
      TabOrder = 0
      Text = ''
      Visible = True
      OnChange = edtFilterChange
      Version = '1.3.5.0'
      ButtonStyle = bsButton
      ButtonWidth = 16
      Etched = False
      ButtonCaption = #215
      OnClickBtn = edtFilterClickBtn
    end
  end
end
