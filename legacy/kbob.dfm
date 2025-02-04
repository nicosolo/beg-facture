object dlgKBOB: TdlgKBOB
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'Nouvelle facture vide'
  ClientHeight = 176
  ClientWidth = 189
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
    Width = 189
    Height = 176
    AutoSize = True
    BevelKind = bkFlat
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object grdTarifs: TXDBGrid
      Left = 8
      Top = 40
      Width = 77
      Height = 124
      Hint = 'Tarifs de l'#39'ann'#233'e s'#233'lectionn'#233'e'
      TabStop = False
      DataColLineColor = clNone
      DataRowLineColor = clNone
      DataSource = frmMain.dsrTarifs
      FixedStyle = fsGray
      FixedTheme = ftNone
      Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
      GridStyle.VisualStyle = vsXPStyle
      HighlightText = clNone
      HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints, hoShowToolTips, hoShowDataHints, hoShowTotalToolTips]
      Options = [dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgHotButtons, dgTitleButtons, dgTitleWidthOff, dgMarkerAutoAlign, dgMarkerAutoToggle]
      ReadOnly = True
      ScrollBars = ssNone
      ScrollProp.AutoHidden = ssBoth
      SelectCellColor = clNone
      SelectionColor = clNone
      SelectRowColor = clNone
      TabOrder = 1
      WheelScrollRows = 1
      OnCellDblClick = grdTarifsCellDblClick
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Classe'
          Title.Alignment = taCenter
          Title.Marker = tmAscend
          Title.MarkerIndex = 2
          Visible = True
          Width = 32
        end
        item
          Expanded = False
          FieldName = 'Tarif'
          Visible = True
          Width = 32
        end>
      OrderFields = 'Classe'
    end
    object btnOk: TButton
      Left = 102
      Top = 108
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object btnCancel: TButton
      Left = 102
      Top = 139
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Annuler'
      Default = True
      ModalResult = 2
      TabOrder = 3
    end
    object edtYear: TAdvSpinEdit
      Left = 8
      Top = 8
      Width = 77
      Height = 26
      Hint = 'Choix de l'#39'ann'#233'e'
      AllowNullValue = False
      Value = 2015
      FloatValue = 2015.000000000000000000
      HexValue = 21
      CheckMinValue = True
      CheckMaxValue = True
      IncrementFloat = 0.100000000000000000
      IncrementFloatPage = 1.000000000000000000
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      MaxValue = 2015
      MinValue = 2000
      TabOrder = 0
      Visible = True
      Version = '1.6.3.0'
      OnChange = edtYearChange
      OnKeyDown = edtYearKeyDown
    end
  end
end
