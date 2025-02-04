object frmMain: TfrmMain
  Left = 0
  Top = 154
  Caption = 'BEG '#8211' Pr'#233'paration facture'
  ClientHeight = 779
  ClientWidth = 1386
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PrintScale = poPrintToFit
  ScreenSnap = True
  SnapBuffer = 15
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lblHint: THTMLabel
    Left = 0
    Top = 737
    Width = 1386
    Height = 42
    Align = alBottom
    BevelOuter = bvLowered
    BorderWidth = 4
    BorderColor = clNone
    Color = clInfoBk
    GradientType = gtFullVertical
    ParentColor = False
    Transparent = False
    Version = '2.2.2.1'
    ExplicitTop = 741
    ExplicitWidth = 1396
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 4
    Width = 106
    Height = 733
    Align = alLeft
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Shape3: TShape
      AlignWithMargins = True
      Left = 3
      Top = 96
      Width = 100
      Height = 4
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alTop
      ExplicitLeft = 4
      ExplicitTop = 132
      ExplicitWidth = 73
    end
    object Shape4: TShape
      AlignWithMargins = True
      Left = 3
      Top = 212
      Width = 100
      Height = 4
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alTop
      ExplicitLeft = 4
      ExplicitTop = 184
      ExplicitWidth = 73
    end
    object Shape6: TShape
      AlignWithMargins = True
      Left = 3
      Top = 360
      Width = 100
      Height = 4
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alTop
      ExplicitLeft = 7
      ExplicitTop = 278
      ExplicitWidth = 110
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 428
      Width = 95
      Height = 16
      Margins.Left = 5
      Margins.Top = 24
      Margins.Right = 6
      Margins.Bottom = 4
      Align = alTop
      Alignment = taCenter
      Caption = 'Calculatrice'
      ExplicitWidth = 66
    end
    object btnOpenFolder: TSpeedButton
      AlignWithMargins = True
      Left = 4
      Top = 56
      Width = 97
      Height = 32
      Hint = 
        'Ouvrel le dossier correspondant '#224' la facture en cours ou du mand' +
        'at s'#233'lectionn'#233' dans la liste des factures en suspens'
      Margins.Left = 4
      Margins.Top = 32
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actOpenFolder
      Align = alTop
      ExplicitTop = 118
    end
    object btnQuit: TButton
      AlignWithMargins = True
      Left = 4
      Top = 372
      Width = 97
      Height = 32
      Hint = 
        'Nous esp'#233'rons que votre s'#233'jour f'#251't agr'#233'able et nous vous souhait' +
        'ons bonne route. Nous nous ferons un plaisir de vous accueillir ' +
        #224' nouveau.'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actQuit
      Align = alTop
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      TabOrder = 0
      TabStop = False
    end
    object btnSaveAs: TButton
      AlignWithMargins = True
      Left = 4
      Top = 288
      Width = 97
      Height = 32
      Hint = 'Sauve la facture pr'#233'par'#233'e sous un nouveau nom'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actSaveAs
      Align = alTop
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      TabOrder = 1
      TabStop = False
    end
    object btnSave: TButton
      AlignWithMargins = True
      Left = 4
      Top = 256
      Width = 97
      Height = 32
      Hint = 'Sauve la facture pr'#233'par'#233'e'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actSave
      Align = alTop
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      TabOrder = 2
      TabStop = False
    end
    object btnOpen: TButton
      AlignWithMargins = True
      Left = 4
      Top = 224
      Width = 97
      Height = 32
      Hint = 
        'Ouvre une facture pr'#233'par'#233'e; La fl'#232'che affiche l'#39'historique des d' +
        'erni'#232'res factures ouvertes'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actOpen
      Align = alTop
      DropDownMenu = popHistory
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      Style = bsSplitButton
      TabOrder = 3
      TabStop = False
    end
    object btnSend: TButton
      AlignWithMargins = True
      Left = 4
      Top = 172
      Width = 97
      Height = 32
      Hint = 
        'Envoi de la facture '#224' la comptabilit'#233' seulement si elle a '#233't'#233' vi' +
        's'#233'e (bon et visa en pied de fen'#234'tre)'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actSend
      Align = alTop
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      TabOrder = 4
      TabStop = False
    end
    object Calculatrice: TJvCalcEdit
      AlignWithMargins = True
      Left = 5
      Top = 448
      Width = 95
      Height = 22
      Hint = 'Petite calcuatrice pas terrible'
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 0
      Align = alTop
      ButtonFlat = True
      DecimalPlaceRound = True
      TabOrder = 5
      DecimalPlacesAlwaysShown = False
    end
    object pnlCode: TPanel
      Tag = 99
      AlignWithMargins = True
      Left = 4
      Top = 0
      Width = 97
      Height = 24
      Hint = 
        'Code du mandat dont la facture est en cours de pr'#233'paration; <b>d' +
        'ouble clic</b> si l'#39'onglet des factures en suspens et le respons' +
        'able sont s'#233'lectionn'#233's, permet d'#39'atteindre la bonne ligne'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = 10551295
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 6
      OnDblClick = pnlCodeDblClick
    end
    object btnControl: TButton
      AlignWithMargins = True
      Left = 4
      Top = 140
      Width = 97
      Height = 32
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actControl
      Align = alTop
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      TabOrder = 7
      TabStop = False
    end
    object Panel13: TPanel
      Left = 0
      Top = 705
      Width = 106
      Height = 28
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 8
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 8
      object btnBug: TSpeedButton
        AlignWithMargins = True
        Left = 4
        Top = 0
        Width = 24
        Height = 24
        Hint = 'Signale un bug '#224' l'#39'auteur du programme'
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alLeft
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        OnClick = btnBugClick
        ExplicitLeft = 12
        ExplicitTop = 4
      end
      object btnHint: TSpeedButton
        AlignWithMargins = True
        Left = 28
        Top = 0
        Width = 24
        Height = 24
        Hint = 'Affiche/masque les informations en pied de fen'#234'tre'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alLeft
        AllowAllUp = True
        GroupIndex = 1
        Down = True
        Caption = '?'
        OnClick = btnHintClick
        ExplicitTop = -3
      end
    end
    object btnShowBill: TButton
      AlignWithMargins = True
      Left = 4
      Top = 108
      Width = 97
      Height = 32
      Hint = 
        'Affiche le r'#233'sum'#233' de la facture en cours de pr'#233'paration mais sau' +
        'v'#233'e, sinon dans les onglets <b>Facture en suspens</b> et <b>List' +
        'e des factures</b> r'#233'sum'#233' de la facture s'#233'lectionn'#233'e'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Action = actShowBill
      Align = alTop
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      TabOrder = 9
      TabStop = False
    end
    object btnWizard: TButton
      AlignWithMargins = True
      Left = 4
      Top = 320
      Width = 97
      Height = 32
      Hint = 'Assistant pour cr'#233'er une nouvelle facture'
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Assistant'
      ImageIndex = 7
      ImageMargins.Left = 4
      ImageMargins.Top = 4
      ImageMargins.Right = 4
      ImageMargins.Bottom = 4
      TabOrder = 10
      TabStop = False
      OnClick = btnWizardClick
    end
  end
  object Panel11: TPanel
    Left = 0
    Top = 0
    Width = 1386
    Height = 4
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
  end
  object Panel12: TPanel
    Left = 106
    Top = 4
    Width = 1280
    Height = 733
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object apcMain: TAdvPageControl
      Left = 0
      Top = 0
      Width = 1280
      Height = 705
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 0
      ActivePage = atsSuspens
      ActiveFont.Charset = DEFAULT_CHARSET
      ActiveFont.Color = clWindowText
      ActiveFont.Height = -12
      ActiveFont.Name = 'Tahoma'
      ActiveFont.Style = [fsBold]
      Align = alClient
      DoubleBuffered = True
      MultiLine = True
      DefaultTabColor = 15790320
      ActiveColor = clWindow
      TabBackGroundColor = clBtnFace
      TabMargin.LeftMargin = 16
      TabMargin.RightMargin = 16
      TabOverlap = 0
      Version = '2.0.2.4'
      PersistPagesState.Location = plRegistry
      PersistPagesState.Enabled = False
      TabOrder = 0
      TabStop = False
      object atsSuspens: TAdvTabSheet
        Hint = 'Liste des heures non factur'#233'es'
        Caption = 'Factures en suspens'
        Color = clWindow
        ColorTo = clNone
        TabColor = 15790320
        TabColorTo = clNone
        OnShow = atsSuspensShow
        object Splitter1: TSplitter
          Left = 908
          Top = 36
          Width = 4
          Height = 638
          AutoSnap = False
          MinSize = 256
          OnMoved = Splitter1Moved
        end
        object grdResponsables: TXDBGrid
          Left = 0
          Top = 36
          Width = 80
          Height = 638
          Hint = 
            'Liste (initiales) des responsables de mandats qui ont des heures' +
            ' non factur'#233'es; <b>Double clic</b>: Le responsable s'#233'lectionn'#233' d' +
            'evient le favori'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          DataColLineColor = clNone
          DataRowLineColor = clNone
          DataSource = dsrResponsables
          FillerButton = False
          FixedStyle = fsMild
          FixedTheme = ftNone
          Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
          GridStyle.VisualStyle = vsXPStyle
          HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints]
          IndicatorWidth = 12
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgHotButtons, dgTitleWidthOff, dgMarkerAutoSwitch]
          OptionsEx = [dgBlankRow, dgTotalFooter, dgTotalHeaderBox, dgTotalValuesBox, dgTotalFieldsBox, dgAutoAscendOrder, dgAutoUpdateSequence, dgDelayUpdateSequence, dgAutoUpdateTotals, dgDelayUpdateTotals, dgCalcWholeDataSet, dgCalcSelectedRows, dgDelaySelectedRows, dgSelectedAutoHidden]
          ParentColor = True
          ReadOnly = True
          ResizeOptions = [roColumnResize, roOptimalWidth, roDefaultWidth]
          ScrollBars = ssNone
          StretchMode = True
          TabOrder = 1
          WheelScrollRows = 1
          OnCellDblClick = grdResponsablesCellDblClick
          OnEnter = grdResponsablesEnter
          OnPaintColumnCell = grdResponsablesPaintColumnCell
          Columns = <
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'Responsable'
              Title.Alignment = taCenter
              TotalFooter.CalcValue = cvCount
              TotalFooter.TotalResult = trCalcValue
              Visible = True
              Width = 90
            end>
        end
        object grdFactures: TXDBGrid
          Left = 80
          Top = 36
          Width = 828
          Height = 638
          Hint = 
            'Liste des mandats non factur'#233's du responsable s'#233'lectionn'#233'; Donne' +
            ' le nombre d'#39'heures non factur'#233'es et leur p'#233'riode de r'#233'alisation' +
            '; [<u>bleu</u>]: la derni'#232're activit'#233' date de plus de 45 jours; ' +
            '<B>Double clic</B> sur l'#39#233'tat: modifie l'#39#233'tat; <B>Explorer</B>: ' +
            'ouverture de l'#39'explorateur dans le dossier s'#233'lectionn'#233
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          DataColLineColor = clNone
          DataRowLineColor = clNone
          DataSource = dsrFacture
          FillerButton = False
          FillerIndex = -1
          FixedStyle = fsMild
          FixedTheme = ftNone
          Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
          GridStyle.VisualStyle = vsXPStyle
          HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints]
          IndicatorWidth = 12
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgTitleButtons, dgTitleWidthOff, dgMarkerAutoAlign, dgMarkerAutoSwitch, dgMarkerAutoToggle]
          OptionsEx = [dgBlankRow, dgTotalFooter, dgTotalHeaderBox, dgTotalValuesBox, dgTotalFieldsBox, dgAutoAscendOrder, dgAutoUpdateSequence, dgDelayUpdateSequence, dgAutoUpdateTotals, dgDelayUpdateTotals, dgCalcWholeDataSet, dgCalcSelectedRows, dgDelaySelectedRows, dgSelectedAutoHidden]
          ParentColor = True
          ReadOnly = True
          ResizeOptions = [roColumnResize, roOptimalWidth, roDefaultWidth]
          TabOrder = 0
          WheelScrollRows = 1
          OnCellDblClick = grdFacturesCellDblClick
          OnPaintColumnCell = grdFacturesPaintColumnCell
          OnTitleClick = grdFacturesTitleClick
          Columns = <
            item
              Expanded = False
              FieldName = 'N'
              Title.Caption = 'Code'
              Title.Marker = tmAscend
              Title.MarkerIndex = 0
              ToolTips = False
              TotalFooter.Alignment = taCenter
              TotalFooter.CalcValue = cvCount
              TotalFooter.TotalResult = trCalcValue
              Visible = True
              Width = 90
            end
            item
              Expanded = False
              FieldName = 'D'#233'signation'
              Title.Caption = 'Mandat'
              TotalFooter.TotalBox = tbFalse
              Visible = True
              Width = 347
            end
            item
              Expanded = False
              FieldName = 'H'
              Title.Alignment = taRightJustify
              Title.Caption = 'Heures'
              ToolTips = False
              TotalFooter.Format = '%.2n'
              TotalFooter.FormatAsFloat = True
              TotalFooter.TotalResult = trCalcValue
              Visible = True
              Width = 80
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'De'
              Title.Alignment = taCenter
              ToolTips = False
              TotalFooter.CalcValue = cvMin
              TotalFooter.TotalResult = trCalcValue
              Visible = True
              Width = 96
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'A'
              Title.Alignment = taCenter
              ToolTips = False
              TotalFooter.CalcValue = cvMin
              TotalFooter.TotalResult = trCalcValue
              Visible = True
              Width = 96
            end
            item
              Expanded = False
              FieldName = 'Etat'
              ToolTips = False
              TotalFooter.TotalBox = tbFalse
              TotalFooter.Visible = False
              TotalFooter.TotalResult = trNone
              TotalHeader.CalcValue = cvUnique
              TotalHeader.TotalResult = trCalcValue
              Visible = True
              Width = 92
            end>
          OrderFields = 'N'
        end
        object Panel21: TPanel
          AlignWithMargins = True
          Left = 912
          Top = 39
          Width = 359
          Height = 634
          Margins.Left = 0
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alClient
          BevelOuter = bvNone
          BorderStyle = bsSingle
          ParentBackground = False
          TabOrder = 2
          object edtState: TDBComboBox
            AlignWithMargins = True
            Left = 132
            Top = 139
            Width = 93
            Height = 24
            Hint = 
              'Etat de la facturation du mandat s'#233'lectionn'#233'; <B>'#8212'</B>: mandat e' +
              'n cours; <B>A facturer</B>: mandat/phase termin'#233' et '#224' facturer; ' +
              '<B>Facturation</B>: facture en traitement '#224' la comptabilit'#233'; <B>' +
              'Termin'#233'</B>: Facture envoy'#233'e et heures '#224' retirer de la base des ' +
              'heures'
            Margins.Left = 132
            Margins.Top = 8
            Margins.Right = 132
            Margins.Bottom = 8
            Align = alTop
            DataField = 'Etat'
            DataSource = dsrNotes
            Items.Strings = (
              '-'
              'A facturer'
              'Contr'#244'le'
              'Facturation'
              'Termin'#233)
            TabOrder = 1
            TabStop = False
            OnExit = edtStateExit
          end
          object edtNote: TDBMemo
            AlignWithMargins = True
            Left = 16
            Top = 179
            Width = 325
            Height = 265
            Hint = 
              'Notes pour m'#233'moire sauv'#233'es dans la base des heures; <B>ESC</B> a' +
              'nnule les modifications en cours'
            Margins.Left = 16
            Margins.Top = 8
            Margins.Right = 16
            Margins.Bottom = 8
            TabStop = False
            Align = alClient
            DataField = 'Note'
            DataSource = dsrNotes
            TabOrder = 3
          end
          object JvNavPanelHeader1: TJvNavPanelHeader
            Left = 0
            Top = 0
            Width = 357
            Margins.Left = 2
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            Alignment = taCenter
            Caption = 'Etat de la facturation'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -16
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ColorFrom = 15790320
            ColorTo = clSilver
            ImageIndex = 0
          end
          object lblCodeFrame: TPanel
            AlignWithMargins = True
            Left = 16
            Top = 43
            Width = 325
            Height = 80
            Margins.Left = 16
            Margins.Top = 16
            Margins.Right = 16
            Margins.Bottom = 8
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderStyle = bsSingle
            Color = clWindow
            ParentBackground = False
            TabOrder = 0
            object lblCode: TDBText
              AlignWithMargins = True
              Left = 4
              Top = 4
              Width = 315
              Height = 19
              Hint = 'Code du mandat s'#233'lectionn'#233
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alTop
              Alignment = taCenter
              AutoSize = True
              DataField = 'N'
              DataSource = dsrFacture
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              Transparent = True
              ExplicitWidth = 61
            end
            object lblDésignation: TDBText
              AlignWithMargins = True
              Left = 4
              Top = 31
              Width = 315
              Height = 16
              Hint = 'Code du mandat s'#233'lectionn'#233
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alTop
              Alignment = taCenter
              AutoSize = True
              DataField = 'D'#233'signation'
              DataSource = dsrFacture
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              Transparent = True
              ExplicitWidth = 90
            end
            object DBText1: TDBText
              AlignWithMargins = True
              Left = 171
              Top = 55
              Width = 148
              Height = 19
              Hint = 'Code du mandat s'#233'lectionn'#233
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alRight
              DataField = 'A'
              DataSource = dsrFacture
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = True
              WordWrap = True
              ExplicitLeft = 187
            end
            object DBText2: TDBText
              AlignWithMargins = True
              Left = 4
              Top = 55
              Width = 148
              Height = 19
              Hint = 'Code du mandat s'#233'lectionn'#233
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alLeft
              Alignment = taRightJustify
              DataField = 'De'
              DataSource = dsrFacture
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = True
              WordWrap = True
            end
            object Label3: TLabel
              Left = 156
              Top = 51
              Width = 11
              Height = 27
              Align = alClient
              Alignment = taCenter
              Caption = #8212
              Layout = tlCenter
              ExplicitWidth = 12
              ExplicitHeight = 16
            end
          end
          object grdPrepared: TXDBGrid
            AlignWithMargins = True
            Left = 16
            Top = 460
            Width = 325
            Height = 156
            Hint = 
              'Liste des factures pr'#233'par'#233'es (*.FAB) du mandat s'#233'lectionn'#233'; Les ' +
              'liens sont sauv'#233's dans la bases de heures; <B>double-clic</B>: o' +
              'uvre le fichier s'#233'lectionn'#233'; <B>Ctrl+Del</B> supprime la ligne s' +
              #233'lectionn'#233'e'
            Margins.Left = 16
            Margins.Top = 8
            Margins.Right = 16
            Margins.Bottom = 16
            Align = alBottom
            DataSource = dsrPrepared
            FillerIndex = -1
            FixedStyle = fsMild
            FixedTheme = ftNone
            Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
            GridStyle.VisualStyle = vsXPStyle
            HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints]
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgHotButtons, dgTitleButtons, dgTitleHeaders, dgTitleWidthOff, dgAllowInsertOff, dgMarkerAutoAlign, dgMarkerAutoSwitch, dgMarkerAutoToggle]
            OptionsEx = [dgTotalHeaderBox, dgTotalValuesBox, dgTotalFieldsBox, dgTotalFooterBox, dgAutoUpdateOrder, dgAutoAscendOrder, dgAutoUpdateSequence, dgDelayUpdateSequence, dgAutoUpdateTotals, dgDelayUpdateTotals, dgCalcWholeDataSet, dgCalcSelectedRows, dgDelaySelectedRows, dgSelectedAutoHidden]
            StretchMode = True
            TabOrder = 4
            OnCellDblClick = grdPreparedCellDblClick
            Columns = <
              item
                Expanded = False
                FieldName = 'FileName'
                Title.Caption = 'Factures pr'#233'par'#233'es'
                Title.Marker = tmAscend
                Title.MarkerIndex = 0
                Visible = True
                Width = 264
              end
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'Modified'
                Title.Alignment = taCenter
                Title.Caption = 'Modifi'#233
                Visible = True
                Width = 80
              end>
            OrderFields = 'FileName'
          end
        end
        object AdvPanel3: TAdvPanel
          Left = 0
          Top = 0
          Width = 1272
          Height = 36
          Align = alTop
          Color = 16316664
          TabOrder = 3
          UseDockManager = True
          Version = '2.5.10.7'
          BorderColor = clBlack
          Caption.Color = clHighlight
          Caption.ColorTo = clNone
          Caption.Font.Charset = DEFAULT_CHARSET
          Caption.Font.Color = clWindowText
          Caption.Font.Height = -13
          Caption.Font.Name = 'Tahoma'
          Caption.Font.Style = []
          Caption.Indent = 0
          ColorTo = 13684944
          DoubleBuffered = True
          StatusBar.Font.Charset = DEFAULT_CHARSET
          StatusBar.Font.Color = clWindowText
          StatusBar.Font.Height = -11
          StatusBar.Font.Name = 'Tahoma'
          StatusBar.Font.Style = []
          Text = ''
          FullHeight = 36
          object btnFavorite: TSpeedButton
            AlignWithMargins = True
            Left = 0
            Top = 6
            Width = 80
            Height = 22
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Action = actFavorite
            Align = alLeft
          end
          object btnRefreshFactures: TSpeedButton
            AlignWithMargins = True
            Left = 1184
            Top = 6
            Width = 80
            Height = 22
            Hint = 
              'Met '#224' jour les donn'#233'es; Utile si quelqu'#39'un a inscrit des heures ' +
              'pendant que le programme est ouvert'
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alRight
            Caption = 'Actualiser'
            OnClick = btnRefreshFacturesClick
            ExplicitLeft = 830
            ExplicitTop = 2
          end
          object btnGetAll: TSpeedButton
            AlignWithMargins = True
            Left = 120
            Top = 6
            Width = 120
            Height = 22
            Hint = 
              'Cr'#233'ation d'#39'une nouvelle facture pour le mandat s'#233'lectionn'#233' dans ' +
              'la liste'
            Margins.Left = 40
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alLeft
            Caption = 'Cr'#233'er une facture'
            OnClick = btntGetAllClick
            ExplicitLeft = 250
          end
          object btnCreate: TSpeedButton
            AlignWithMargins = True
            Left = 240
            Top = 6
            Width = 120
            Height = 22
            Hint = 
              'Cr'#233'ation d'#39'une facture vide, lorsqu'#39'il n'#39'y a aucune heure inscri' +
              'te'
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alLeft
            Caption = 'Facture vierge'
            OnClick = btnCreateClick
            ExplicitLeft = 378
          end
          object btnPrint: TSpeedButton
            AlignWithMargins = True
            Left = 1094
            Top = 6
            Width = 90
            Height = 22
            Hint = 'Imprime la liste'
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alRight
            Caption = 'Imprimer'
            OnClick = btnPrintClick
            ExplicitLeft = 624
          end
          object edtGoTo: TAdvEdit
            AlignWithMargins = True
            Left = 440
            Top = 6
            Width = 64
            Height = 22
            Hint = 
              'Pour atteindre un mandat, il faut taper le code complet; <b>ESC<' +
              '/b> annule; <b>ENTER</b> r'#233'p'#232'te'
            Margins.Left = 80
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            EmptyTextStyle = []
            LabelCaption = 'Atteindre'
            LabelPosition = lpLeftCenter
            LabelTransparent = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -13
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            Lookup.Font.Charset = DEFAULT_CHARSET
            Lookup.Font.Color = clWindowText
            Lookup.Font.Height = -11
            Lookup.Font.Name = 'Arial'
            Lookup.Font.Style = []
            Lookup.Separator = ';'
            Align = alLeft
            CanUndo = False
            Color = clWindow
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = ''
            Visible = True
            OnChange = edtGoToChange
            OnKeyDown = edtGoToKeyDown
            Version = '3.5.5.0'
          end
        end
      end
      object atsDatas: TAdvTabSheet
        Hint = 'Donn'#233'es pour la facturation et diverses informations'
        Caption = 'Donn'#233'es de facturation et documents'
        Color = clWindow
        ColorTo = clNone
        TabColor = 15790320
        TabColorTo = clNone
        OnShow = atsDatasShow
        object Panel16: TPanel
          Left = 0
          Top = 0
          Width = 635
          Height = 674
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object Label24: TLabel
            AlignWithMargins = True
            Left = 34
            Top = 274
            Width = 593
            Height = 16
            Margins.Left = 34
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 1
            Align = alTop
            Caption = 'Description des prestations'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 179
          end
          object Label1: TLabel
            AlignWithMargins = True
            Left = 8
            Top = 471
            Width = 619
            Height = 16
            Margins.Left = 8
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 1
            Align = alTop
            Caption = 'Notes pour m'#233'moire et remarques '#224' la comptabilit'#233
            ExplicitWidth = 296
          end
          object btnCopyDocs: TSpeedButton
            Left = 220
            Top = 271
            Width = 24
            Height = 20
            Hint = 
              'Ajoute les <u>remarques et dates</u> de la liste documents '#224' la ' +
              'fin de la description des prestations '
            Caption = 't'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Wingdings 3'
            Font.Style = []
            ParentFont = False
            OnClick = btnCopyDocsClick
          end
          object btnCopyDescription: TSpeedButton
            Left = 8
            Top = 271
            Width = 24
            Height = 20
            Hint = 'Copie le texte'
            Caption = '/'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Wingdings 2'
            Font.Style = []
            ParentFont = False
            OnClick = btnCopyDescriptionClick
          end
          object Panel6: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 10
            Width = 635
            Height = 94
            Margins.Left = 0
            Margins.Top = 10
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            object Panel7: TPanel
              Left = 0
              Top = 0
              Width = 425
              Height = 94
              Align = alLeft
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object edtObjet: TAdvEdit
                Tag = 99
                AlignWithMargins = True
                Left = 8
                Top = 25
                Width = 409
                Height = 22
                Hint = 
                  'Titre de la facture; Le corriger pour qu'#39'elle corresponde '#224' la d' +
                  #233'signation du client'
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 8
                EmptyTextStyle = []
                ReturnIsTab = True
                Precision = 2
                LabelCaption = 'Objet de la facture'
                LabelPosition = lpTopLeft
                LabelMargin = 1
                LabelTransparent = True
                LabelFont.Charset = DEFAULT_CHARSET
                LabelFont.Color = clWindowText
                LabelFont.Height = -13
                LabelFont.Name = 'Tahoma'
                LabelFont.Style = [fsBold]
                Lookup.Font.Charset = DEFAULT_CHARSET
                Lookup.Font.Color = clWindowText
                Lookup.Font.Height = -11
                Lookup.Font.Name = 'Arial'
                Lookup.Font.Style = []
                Lookup.Separator = ';'
                Align = alTop
                Color = 12648384
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                Text = ''
                Visible = True
                OnChange = DatasChanged
                Version = '3.5.5.0'
                ExplicitTop = 42
              end
              object edtPériode: TAdvEditBtn
                AlignWithMargins = True
                Left = 8
                Top = 71
                Width = 409
                Height = 22
                Hint = 'P'#233'riode '#224' facturer; le libell'#233' peut '#234'tre chang'#233
                Margins.Left = 8
                Margins.Top = 16
                Margins.Right = 8
                Margins.Bottom = 8
                EmptyTextStyle = []
                LabelCaption = 'P'#233'riode de facturation'
                LabelPosition = lpTopLeft
                LabelMargin = 1
                LabelTransparent = True
                LabelFont.Charset = DEFAULT_CHARSET
                LabelFont.Color = clWindowText
                LabelFont.Height = -13
                LabelFont.Name = 'Tahoma'
                LabelFont.Style = [fsBold]
                Lookup.Font.Charset = DEFAULT_CHARSET
                Lookup.Font.Color = clWindowText
                Lookup.Font.Height = -11
                Lookup.Font.Name = 'Arial'
                Lookup.Font.Style = []
                Lookup.Separator = ';'
                Align = alTop
                Color = 12648384
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
                ShortCut = 0
                TabOrder = 1
                Text = ''
                Visible = True
                OnChange = DatasChanged
                Version = '1.6.2.0'
                ButtonStyle = bsDropDown
                ButtonWidth = 16
                ButtonHint = 
                  'Ins'#232're la p'#233'riode de facturation au d'#233'but de la description des ' +
                  'prestations'
                Flat = False
                Etched = False
                ButtonCaption = #215
                ReadOnly = False
                OnClickBtn = edtPériodeClickBtn
                ExplicitTop = 88
                ExplicitWidth = 410
              end
            end
            object Panel8: TPanel
              Left = 425
              Top = 0
              Width = 210
              Height = 94
              Align = alClient
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              object edtType: TAdvComboBox
                Tag = 99
                AlignWithMargins = True
                Left = 8
                Top = 39
                Width = 194
                Height = 24
                Hint = 
                  'Type de facture pour la comptabilit'#233'; <B>Facture</B>: facture no' +
                  'rmale; <B>Facture finale</B>: facture finale lorsqu'#39'il y a eu de' +
                  's situations ou des acomptes; <B>Situation</B>: facturation d'#39'un' +
                  'e part des prestations; <B>Acompte</B>: facturation d'#39'un pourcen' +
                  't du montant offert'
                Margins.Left = 8
                Margins.Top = 23
                Margins.Right = 8
                Margins.Bottom = 8
                Color = clWindow
                Version = '1.9.7.8'
                Visible = True
                Align = alTop
                ButtonWidth = 17
                Style = csDropDownList
                EmptyTextStyle = []
                DropWidth = 0
                Enabled = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                ItemIndex = -1
                Items.Strings = (
                  'Facture'
                  'Facture finale'
                  'Situation'
                  'Acompte')
                LabelCaption = 'Type de facture'
                LabelPosition = lpTopLeft
                LabelMargin = 1
                LabelTransparent = True
                LabelFont.Charset = DEFAULT_CHARSET
                LabelFont.Color = clWindowText
                LabelFont.Height = -13
                LabelFont.Name = 'Tahoma'
                LabelFont.Style = [fsBold]
                ParentColor = True
                ParentFont = False
                TabOrder = 0
                OnClick = DatasChanged
              end
              object edtMode: TAdvComboBox
                Tag = 99
                AlignWithMargins = True
                Left = 8
                Top = 86
                Width = 194
                Height = 24
                Hint = 
                  'Mode de facturation pour la comptabilit'#233'; <B>selon donn'#233'es pr'#233'se' +
                  'ntes</B>: la comptabilit'#233' utilise le pr'#233'sent fichier; <B>selon o' +
                  'ffre</B>: la compatbilit'#233' facture exactement comme l'#39'offre<BR><B' +
                  '>selon facture annex'#233'e</B>: la facture a '#233't'#233' pr'#233'par'#233'e dans Excel' +
                  ' et ce fichier [<B>Facture pr'#233'par'#233'e</B>] est envoy'#233' '#224' la comptab' +
                  'ilit'#233
                Margins.Left = 8
                Margins.Top = 15
                Margins.Right = 8
                Margins.Bottom = 8
                Color = clWindow
                Version = '1.9.7.8'
                Visible = True
                Align = alTop
                ButtonWidth = 17
                Style = csDropDownList
                EmptyTextStyle = []
                DropWidth = 0
                Enabled = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                ItemIndex = -1
                Items.Strings = (
                  'selon donn'#233'es pr'#233'sentes'
                  'selon offre'
                  'selon facture annex'#233'e'
                  'au forfait (voir notes)')
                LabelCaption = 'Mode de facturation'
                LabelPosition = lpTopLeft
                LabelMargin = 1
                LabelTransparent = True
                LabelFont.Charset = DEFAULT_CHARSET
                LabelFont.Color = clWindowText
                LabelFont.Height = -13
                LabelFont.Name = 'Tahoma'
                LabelFont.Style = [fsBold]
                ParentColor = True
                ParentFont = False
                TabOrder = 1
                OnClick = edtModeClick
              end
            end
          end
          object Panel3: TPanel
            Left = 0
            Top = 104
            Width = 635
            Height = 128
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object Panel4: TPanel
              Left = 0
              Top = 0
              Width = 306
              Height = 128
              Align = alLeft
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object Label6: TLabel
                AlignWithMargins = True
                Left = 34
                Top = 8
                Width = 264
                Height = 16
                Margins.Left = 34
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 1
                Align = alTop
                Caption = 'Adresse de facturation (soci'#233't'#233')'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitWidth = 214
              end
              object btnCopyAdresse: TSpeedButton
                Left = 8
                Top = 4
                Width = 24
                Height = 20
                Hint = 'Copie le texte'
                Caption = '/'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -16
                Font.Name = 'Wingdings 2'
                Font.Style = []
                ParentFont = False
                OnClick = btnCopyAdresseClick
              end
              object edtAdresse: TCurvyMemo
                Tag = 99
                AlignWithMargins = True
                Left = 8
                Top = 25
                Width = 290
                Height = 95
                Hint = 
                  'Adresse de la soci'#233't'#233' qui paye (normalement inscrite dans la bas' +
                  'e des heures)'
                Margins.Left = 8
                Margins.Top = 0
                Margins.Right = 8
                Margins.Bottom = 8
                Align = alClient
                Color = 12648384
                TabOrder = 0
                TabStop = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                ImeName = ''
                ParentFont = False
                ScrollBars = ssVertical
                WordWrap = True
                OnChange = DatasChanged
              end
            end
            object Panel5: TPanel
              Left = 330
              Top = 0
              Width = 305
              Height = 128
              Align = alClient
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              object Label7: TLabel
                AlignWithMargins = True
                Left = 34
                Top = 8
                Width = 263
                Height = 16
                Margins.Left = 34
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 1
                Align = alTop
                Caption = 'Adresse d'#39'envoi de la facture'
                ExplicitWidth = 166
              end
              object btnCopyEnvoi: TSpeedButton
                Left = 8
                Top = 4
                Width = 24
                Height = 20
                Hint = 'Copie le texte'
                Caption = '/'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -16
                Font.Name = 'Wingdings 2'
                Font.Style = []
                ParentFont = False
                OnClick = btnCopyEnvoiClick
              end
              object edtEnvoi: TCurvyMemo
                Tag = 99
                AlignWithMargins = True
                Left = 8
                Top = 25
                Width = 289
                Height = 95
                Hint = 'Adresse de la personne qui re'#231'oit la facture pour visa'
                Margins.Left = 8
                Margins.Top = 0
                Margins.Right = 8
                Margins.Bottom = 8
                Align = alClient
                TabOrder = 0
                TabStop = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                ImeName = ''
                ParentFont = False
                ScrollBars = ssVertical
                WordWrap = True
                OnChange = DatasChanged
              end
            end
            object Panel1: TPanel
              Left = 306
              Top = 0
              Width = 24
              Height = 128
              Align = alLeft
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 2
              object btnCopyAddress: TButton
                AlignWithMargins = True
                Left = 0
                Top = 96
                Width = 24
                Height = 24
                Hint = 'Recopie l'#39'adresse de facturation dans l'#39'adresse de visa'
                Margins.Left = 0
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 8
                Action = actCopyAddress
                Align = alBottom
                Caption = 'u'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Wingdings 3'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                TabStop = False
              end
              object btnLocalCH: TButton
                AlignWithMargins = True
                Left = 0
                Top = 30
                Width = 24
                Height = 24
                Hint = 'Ouvre Local.ch pour trouver une adresse'
                Margins.Left = 0
                Margins.Top = 30
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alTop
                Caption = '*'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -16
                Font.Name = 'Wingdings'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                TabStop = False
                OnClick = btnLocalCHClick
              end
            end
          end
          object edtPrestations: TCurvyMemo
            Tag = 99
            AlignWithMargins = True
            Left = 8
            Top = 291
            Width = 619
            Height = 172
            Hint = 
              'Description succinct, mais juste, e des prestations <b>IMPORTANT' +
              '</b>  ce texte appara'#238't sur les factures envoy'#233'es aux clients'
            Margins.Left = 8
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alTop
            Color = 12648384
            TabOrder = 2
            TabStop = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ImeName = ''
            ParentFont = False
            ScrollBars = ssVertical
            WordWrap = True
            OnChange = DatasChanged
          end
          object edtComment: TCurvyMemo
            Tag = 99
            AlignWithMargins = True
            Left = 8
            Top = 488
            Width = 619
            Height = 178
            Hint = 
              'Notes pour m'#233'moire et recommandations '#224' la comptabilit'#233' pour la ' +
              'facturation'
            Margins.Left = 8
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            TabOrder = 3
            TabStop = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ImeName = ''
            ParentFont = False
            ScrollBars = ssVertical
            WordWrap = True
            OnChange = DatasChanged
          end
          object edtPrepare: TAdvEditBtn
            AlignWithMargins = True
            Left = 129
            Top = 240
            Width = 498
            Height = 22
            Hint = 
              'Lien sur la feullie Excel de la facture pr'#233'par'#233'e; <B>Drag & drop' +
              '</B> pour y mettre le lien; <B>Double clic</B> pour ouvrir le fi' +
              'chier; <B>'#215'</B> supprime le lien'
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 12
            EditorEnabled = False
            EmptyTextStyle = []
            LabelCaption = 'Facture pr'#233'par'#233'e'
            LabelPosition = lpLeftCenter
            LabelMargin = 8
            LabelTransparent = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -13
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = [fsBold]
            Lookup.Font.Charset = DEFAULT_CHARSET
            Lookup.Font.Color = clWindowText
            Lookup.Font.Height = -11
            Lookup.Font.Name = 'Arial'
            Lookup.Font.Style = []
            Lookup.Separator = ';'
            Align = alTop
            Color = clWindow
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = True
            ParentFont = False
            ShortCut = 0
            TabOrder = 4
            Text = ''
            Visible = True
            OnChange = edtPrepareChange
            OnDblClick = edtPrepareDblClick
            Version = '1.6.2.0'
            ButtonStyle = bsButton
            ButtonWidth = 16
            Flat = False
            Etched = False
            ButtonCaption = #215
            ReadOnly = False
            OnClickBtn = btnDelFactureClick
            ExplicitLeft = 250
            ExplicitWidth = 378
          end
        end
        object pnlDocs: TPanel
          Left = 635
          Top = 0
          Width = 637
          Height = 674
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object pnlTopDocs: TPanel
            Left = 0
            Top = 0
            Width = 637
            Height = 26
            Align = alTop
            BevelOuter = bvNone
            Color = clWindow
            ParentBackground = False
            TabOrder = 0
            object btnCopySumOffres: TSpeedButton
              AlignWithMargins = True
              Left = 136
              Top = 1
              Width = 24
              Height = 24
              Hint = 'Ins'#232're le total des offres'
              Margins.Left = 0
              Margins.Top = 1
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alLeft
              Caption = 't'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Wingdings 3'
              Font.Style = []
              ParentFont = False
              OnClick = btnCopySumOffresClick
            end
            object btnCopySumSituations: TSpeedButton
              AlignWithMargins = True
              Left = 392
              Top = 1
              Width = 24
              Height = 24
              Hint = 'Ins'#232're le total des adjudications'
              Margins.Left = 0
              Margins.Top = 1
              Margins.Right = 0
              Margins.Bottom = 1
              Align = alLeft
              Caption = 't'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Wingdings 3'
              Font.Style = []
              ParentFont = False
              OnClick = btnCopySumSituationsClick
            end
            object edtOffreMontant: TAdvEdit
              Tag = 99
              AlignWithMargins = True
              Left = 56
              Top = 2
              Width = 80
              Height = 22
              Hint = 'Montant total HT du/des offres'
              Margins.Left = 56
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              TabStop = False
              EditAlign = eaRight
              EditType = etFloat
              EmptyTextStyle = []
              ReturnIsTab = True
              Precision = 2
              LabelCaption = 'Offre HT'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
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
              Align = alLeft
              Color = clWindow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = '0.00'
              Visible = True
              OnChange = DataCalculate
              Version = '3.5.5.0'
            end
            object edtSituations: TAdvEdit
              Tag = 99
              AlignWithMargins = True
              Left = 312
              Top = 2
              Width = 80
              Height = 22
              Hint = 'Montant total HT des situations'
              Margins.Left = 152
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              TabStop = False
              EditAlign = eaRight
              EditType = etFloat
              EmptyTextStyle = []
              ReturnIsTab = True
              Precision = 2
              LabelCaption = 'Situations HT'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
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
              Align = alLeft
              Color = clWindow
              TabOrder = 1
              Text = '0.00'
              Visible = True
              OnChange = DataCalculate
              Version = '3.5.5.0'
            end
            object edtSolde: TAdvEdit
              AlignWithMargins = True
              Left = 547
              Top = 2
              Width = 80
              Height = 22
              Hint = 'Solde restant entre les offres et les situations'
              Margins.Left = 0
              Margins.Top = 2
              Margins.Right = 10
              Margins.Bottom = 2
              TabStop = False
              BorderColor = clSilver
              EditAlign = eaRight
              EditorEnabled = False
              EditType = etFloat
              EmptyTextStyle = []
              ReturnIsTab = True
              Precision = 2
              LabelCaption = 'Solde'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
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
              Align = alRight
              Color = clWindow
              TabOrder = 2
              Text = '0.00'
              Visible = True
              Version = '3.5.5.0'
            end
          end
          object scbDocs: TAdvScrollBox
            AlignWithMargins = True
            Left = 8
            Top = 34
            Width = 621
            Height = 632
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            DoubleBuffered = True
            Ctl3D = False
            ParentCtl3D = False
            ParentDoubleBuffered = False
            TabOrder = 1
            object splGrdOffres: TAdvSplitter
              Left = 0
              Top = 157
              Width = 602
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitTop = 91
              ExplicitWidth = 415
            end
            object splGrdAdjudications: TAdvSplitter
              Left = 0
              Top = 317
              Width = 602
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitTop = 183
              ExplicitWidth = 415
            end
            object splGrdSituations: TAdvSplitter
              Left = 0
              Top = 477
              Width = 602
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitTop = 275
              ExplicitWidth = 415
            end
            object splGrdDocuments: TAdvSplitter
              Left = 0
              Top = 637
              Width = 602
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitTop = 367
              ExplicitWidth = 415
            end
            object pnlGrdOffres: TAdvPanel
              Left = 0
              Top = 0
              Width = 602
              Height = 157
              Hint = 
                'Liste des offres (orales ou fichiers) avec leurs dates, montants' +
                ' HT et remarques respectives; <B>Drag & drop</B> permet d'#39'y ajou' +
                'ter les fichier (attention, la date par d'#233'faut est celle du fich' +
                'ier, pas forc'#233'ment de son envoi); <B>Ctrl+Del</B> supprime la li' +
                'gne s'#233'lectionn'#233'e; <B>Double clic</B> ouvre le fichier s'#233'lectionn' +
                #233
              Margins.Left = 0
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alTop
              ParentColor = True
              TabOrder = 0
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = 15921646
              Caption.ColorTo = 13223094
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '<B>Ofres</B>'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlGrdOffresMinimize
              OnMaximize = pnlGrdOffresMaximize
              FullHeight = 157
              object grdOffres: TAdvColumnGrid
                Left = 0
                Top = 22
                Width = 602
                Height = 135
                Cursor = crDefault
                Hint = 
                  'Liste des offres (orales ou fichiers) avec leurs dates, montants' +
                  ' HT et remarques respectives; <B>Drag & drop</B> permet d'#39'y ajou' +
                  'ter les fichier (attention, la date par d'#233'faut est celle du fich' +
                  'ier, pas forc'#233'ment de son envoi); <B>Ctrl+Del</B> supprime la li' +
                  'gne s'#233'lectionn'#233'e; <B>Double clic</B> ouvre le fichier s'#233'lectionn' +
                  #233
                Margins.Left = 8
                Margins.Top = 0
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alClient
                BorderStyle = bsNone
                ColCount = 5
                Constraints.MinHeight = 1
                Ctl3D = True
                DrawingStyle = gdsClassic
                FixedCols = 0
                RowCount = 3
                Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
                ParentCtl3D = False
                ScrollBars = ssNone
                TabOrder = 0
                OnExit = grdExit
                OnKeyDown = grdKeyDown
                GridLineColor = 15527152
                GridFixedLineColor = 13947601
                HoverRowCells = [hcNormal, hcSelected]
                OnRowChanging = grdRowChanging
                OnAutoAddRow = grdOffresAutoAddRow
                OnCanInsertRow = grdCanInsertRow
                OnDblClickCell = grdDblClickCell
                OnExpandClick = grdExpandClick
                OnEditChange = grdEditChange
                ActiveCellFont.Charset = DEFAULT_CHARSET
                ActiveCellFont.Color = clWindowText
                ActiveCellFont.Height = -11
                ActiveCellFont.Name = 'Tahoma'
                ActiveCellFont.Style = [fsBold]
                ActiveCellColor = 16644337
                ActiveCellColorTo = 16576469
                ColumnHeaders.Strings = (
                  'Fichier'
                  'Date'
                  'Montant'
                  'Remarque'
                  'Chemin')
                ColumnSize.Stretch = True
                ColumnSize.StretchColumn = 3
                ControlLook.FixedGradientMirrorFrom = 16447735
                ControlLook.FixedGradientMirrorTo = 16052977
                ControlLook.FixedGradientHoverFrom = 16775139
                ControlLook.FixedGradientHoverTo = 16775139
                ControlLook.FixedGradientHoverMirrorFrom = 16772541
                ControlLook.FixedGradientHoverMirrorTo = 16508855
                ControlLook.FixedGradientDownFrom = 16377020
                ControlLook.FixedGradientDownTo = 16377020
                ControlLook.FixedGradientDownMirrorFrom = 16242317
                ControlLook.FixedGradientDownMirrorTo = 16109962
                ControlLook.FixedGradientDownBorder = 11440207
                ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownHeader.Font.Color = clWindowText
                ControlLook.DropDownHeader.Font.Height = -11
                ControlLook.DropDownHeader.Font.Name = 'Tahoma'
                ControlLook.DropDownHeader.Font.Style = []
                ControlLook.DropDownHeader.Visible = True
                ControlLook.DropDownHeader.Buttons = <>
                ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownFooter.Font.Color = clWindowText
                ControlLook.DropDownFooter.Font.Height = -11
                ControlLook.DropDownFooter.Font.Name = 'Tahoma'
                ControlLook.DropDownFooter.Font.Style = []
                ControlLook.DropDownFooter.Visible = True
                ControlLook.DropDownFooter.Buttons = <>
                Filter = <>
                FilterDropDown.Font.Charset = DEFAULT_CHARSET
                FilterDropDown.Font.Color = clWindowText
                FilterDropDown.Font.Height = -11
                FilterDropDown.Font.Name = 'Tahoma'
                FilterDropDown.Font.Style = []
                FilterDropDown.TextChecked = 'Checked'
                FilterDropDown.TextUnChecked = 'Unchecked'
                FilterDropDownClear = '(All)'
                FilterEdit.TypeNames.Strings = (
                  'Starts with'
                  'Ends with'
                  'Contains'
                  'Not contains'
                  'Equal'
                  'Not equal'
                  'Clear')
                FixedFooters = 1
                FixedColWidth = 160
                FixedRowHeight = 22
                FixedFont.Charset = DEFAULT_CHARSET
                FixedFont.Color = clBlack
                FixedFont.Height = -11
                FixedFont.Name = 'Tahoma'
                FixedFont.Style = []
                FloatFormat = '%.2n'
                FloatingFooter.CalculateHiddenRows = False
                FloatingFooter.Column = 2
                FloatingFooter.Visible = True
                HoverButtons.Buttons = <>
                HoverButtons.Position = hbLeftFromColumnLeft
                HTMLSettings.ImageFolder = 'images'
                HTMLSettings.ImageBaseName = 'img'
                Look = glVista
                MouseActions.DirectDateDrop = True
                MouseActions.WheelIncrement = 1
                Navigation.AdvanceOnEnter = True
                Navigation.AdvanceInsert = True
                Navigation.AdvanceAutoEdit = False
                Navigation.AdvanceAuto = True
                Navigation.AppendOnArrowDown = True
                Navigation.CursorWalkEditor = True
                PrintSettings.DateFormat = 'dd/mm/yyyy'
                PrintSettings.Font.Charset = DEFAULT_CHARSET
                PrintSettings.Font.Color = clWindowText
                PrintSettings.Font.Height = -11
                PrintSettings.Font.Name = 'Tahoma'
                PrintSettings.Font.Style = []
                PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
                PrintSettings.FixedFont.Color = clWindowText
                PrintSettings.FixedFont.Height = -11
                PrintSettings.FixedFont.Name = 'Tahoma'
                PrintSettings.FixedFont.Style = []
                PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
                PrintSettings.HeaderFont.Color = clWindowText
                PrintSettings.HeaderFont.Height = -11
                PrintSettings.HeaderFont.Name = 'Tahoma'
                PrintSettings.HeaderFont.Style = []
                PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
                PrintSettings.FooterFont.Color = clWindowText
                PrintSettings.FooterFont.Height = -11
                PrintSettings.FooterFont.Name = 'Tahoma'
                PrintSettings.FooterFont.Style = []
                PrintSettings.PageNumSep = '/'
                SearchFooter.ColorTo = 16052977
                SearchFooter.FindNextCaption = 'Find &next'
                SearchFooter.FindPrevCaption = 'Find &previous'
                SearchFooter.Font.Charset = DEFAULT_CHARSET
                SearchFooter.Font.Color = clWindowText
                SearchFooter.Font.Height = -11
                SearchFooter.Font.Name = 'Tahoma'
                SearchFooter.Font.Style = []
                SearchFooter.HighLightCaption = 'Highlight'
                SearchFooter.HintClose = 'Close'
                SearchFooter.HintFindNext = 'Find next occurrence'
                SearchFooter.HintFindPrev = 'Find previous occurrence'
                SearchFooter.HintHighlight = 'Highlight occurrences'
                SearchFooter.MatchCaseCaption = 'Match case'
                SearchFooter.ResultFormat = '(%d of %d)'
                ShowSelection = False
                ShowDesignHelper = False
                SortSettings.DefaultFormat = ssAutomatic
                SortSettings.Column = 1
                SortSettings.Show = True
                SortSettings.HeaderColor = 16579058
                SortSettings.HeaderColorTo = 16579058
                SortSettings.HeaderMirrorColor = 16380385
                SortSettings.HeaderMirrorColorTo = 16182488
                UIStyle = tsWindowsVista
                VAlignment = vtaCenter
                Version = '3.2.0.2'
                Columns = <
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Fichier'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 160
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edDateEdit
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Date'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 96
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taRightJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edFloat
                    FilterCaseSensitive = False
                    Fixed = False
                    FloatFormat = '%.2n'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Montant'
                    HeaderAlignment = taCenter
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 80
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Remarque'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 266
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Chemin'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 0
                  end>
                ColWidths = (
                  160
                  96
                  80
                  266
                  0)
                RowHeights = (
                  22
                  22
                  22)
              end
            end
            object pnlGrdAdjudications: TAdvPanel
              Left = 0
              Top = 160
              Width = 602
              Height = 157
              Hint = 
                'Liste des adjudications (orales ou fichiers) avec leurs dates, m' +
                'ontants HT et remarques respectives; <B>Drag & drop</B> permet d' +
                #39'y ajouter les fichier (attention, la date par d'#233'faut est celle ' +
                'du fichier, pas forc'#233'ment de son envoi); <B>Ctrl+Del</B> supprim' +
                'e la ligne s'#233'lectionn'#233'e; <B>Double clic</B> ouvre le fichier s'#233'l' +
                'ectionn'#233
              Align = alTop
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              TabOrder = 1
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = 15921646
              Caption.ColorTo = 13223094
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '<B>Adjudications</B>'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlGrdOffresMinimize
              OnMaximize = pnlGrdOffresMaximize
              FullHeight = 157
              object grdAdjudications: TAdvColumnGrid
                Left = 0
                Top = 22
                Width = 602
                Height = 135
                Cursor = crDefault
                Hint = 
                  'Liste des adjudications (orales ou fichiers) avec leurs dates, m' +
                  'ontants HT et remarques respectives; <B>Drag & drop</B> permet d' +
                  #39'y ajouter les fichier (attention, la date par d'#233'faut est celle ' +
                  'du fichier, pas forc'#233'ment de son envoi); <B>Ctrl+Del</B> supprim' +
                  'e la ligne s'#233'lectionn'#233'e; <B>Double clic</B> ouvre le fichier s'#233'l' +
                  'ectionn'#233
                Margins.Left = 8
                Margins.Top = 0
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alClient
                BorderStyle = bsNone
                ColCount = 5
                Ctl3D = True
                DrawingStyle = gdsClassic
                FixedCols = 0
                RowCount = 3
                Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
                ParentCtl3D = False
                ScrollBars = ssNone
                TabOrder = 0
                OnExit = grdExit
                OnKeyDown = grdKeyDown
                GridLineColor = 15527152
                GridFixedLineColor = 13947601
                HoverRowCells = [hcNormal, hcSelected]
                OnRowChanging = grdRowChanging
                OnAutoAddRow = grdOffresAutoAddRow
                OnCanInsertRow = grdCanInsertRow
                OnDblClickCell = grdDblClickCell
                OnExpandClick = grdExpandClick
                OnEditChange = grdEditChange
                ActiveCellFont.Charset = DEFAULT_CHARSET
                ActiveCellFont.Color = clWindowText
                ActiveCellFont.Height = -11
                ActiveCellFont.Name = 'Tahoma'
                ActiveCellFont.Style = [fsBold]
                ActiveCellColor = 16644337
                ActiveCellColorTo = 16576469
                ColumnHeaders.Strings = (
                  'Fichier'
                  'Date'
                  'Montant'
                  'Remarque'
                  'Chemin')
                ColumnSize.Stretch = True
                ColumnSize.StretchColumn = 3
                ControlLook.FixedGradientMirrorFrom = 16447735
                ControlLook.FixedGradientMirrorTo = 16052977
                ControlLook.FixedGradientHoverFrom = 16775139
                ControlLook.FixedGradientHoverTo = 16775139
                ControlLook.FixedGradientHoverMirrorFrom = 16772541
                ControlLook.FixedGradientHoverMirrorTo = 16508855
                ControlLook.FixedGradientDownFrom = 16377020
                ControlLook.FixedGradientDownTo = 16377020
                ControlLook.FixedGradientDownMirrorFrom = 16242317
                ControlLook.FixedGradientDownMirrorTo = 16109962
                ControlLook.FixedGradientDownBorder = 11440207
                ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownHeader.Font.Color = clWindowText
                ControlLook.DropDownHeader.Font.Height = -11
                ControlLook.DropDownHeader.Font.Name = 'Tahoma'
                ControlLook.DropDownHeader.Font.Style = []
                ControlLook.DropDownHeader.Visible = True
                ControlLook.DropDownHeader.Buttons = <>
                ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownFooter.Font.Color = clWindowText
                ControlLook.DropDownFooter.Font.Height = -11
                ControlLook.DropDownFooter.Font.Name = 'Tahoma'
                ControlLook.DropDownFooter.Font.Style = []
                ControlLook.DropDownFooter.Visible = True
                ControlLook.DropDownFooter.Buttons = <>
                Filter = <>
                FilterDropDown.Font.Charset = DEFAULT_CHARSET
                FilterDropDown.Font.Color = clWindowText
                FilterDropDown.Font.Height = -11
                FilterDropDown.Font.Name = 'Tahoma'
                FilterDropDown.Font.Style = []
                FilterDropDown.TextChecked = 'Checked'
                FilterDropDown.TextUnChecked = 'Unchecked'
                FilterDropDownClear = '(All)'
                FilterEdit.TypeNames.Strings = (
                  'Starts with'
                  'Ends with'
                  'Contains'
                  'Not contains'
                  'Equal'
                  'Not equal'
                  'Clear')
                FixedFooters = 1
                FixedColWidth = 160
                FixedRowHeight = 22
                FixedFont.Charset = DEFAULT_CHARSET
                FixedFont.Color = clBlack
                FixedFont.Height = -11
                FixedFont.Name = 'Tahoma'
                FixedFont.Style = []
                FloatFormat = '%.2n'
                FloatingFooter.CalculateHiddenRows = False
                FloatingFooter.Column = 2
                FloatingFooter.Visible = True
                HoverButtons.Buttons = <>
                HoverButtons.Position = hbLeftFromColumnLeft
                HTMLSettings.ImageFolder = 'images'
                HTMLSettings.ImageBaseName = 'img'
                Look = glVista
                MouseActions.DirectDateDrop = True
                MouseActions.WheelIncrement = 1
                Navigation.AdvanceOnEnter = True
                Navigation.AdvanceInsert = True
                Navigation.AdvanceAutoEdit = False
                Navigation.AdvanceAuto = True
                Navigation.AppendOnArrowDown = True
                Navigation.CursorWalkEditor = True
                PrintSettings.DateFormat = 'dd/mm/yyyy'
                PrintSettings.Font.Charset = DEFAULT_CHARSET
                PrintSettings.Font.Color = clWindowText
                PrintSettings.Font.Height = -11
                PrintSettings.Font.Name = 'Tahoma'
                PrintSettings.Font.Style = []
                PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
                PrintSettings.FixedFont.Color = clWindowText
                PrintSettings.FixedFont.Height = -11
                PrintSettings.FixedFont.Name = 'Tahoma'
                PrintSettings.FixedFont.Style = []
                PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
                PrintSettings.HeaderFont.Color = clWindowText
                PrintSettings.HeaderFont.Height = -11
                PrintSettings.HeaderFont.Name = 'Tahoma'
                PrintSettings.HeaderFont.Style = []
                PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
                PrintSettings.FooterFont.Color = clWindowText
                PrintSettings.FooterFont.Height = -11
                PrintSettings.FooterFont.Name = 'Tahoma'
                PrintSettings.FooterFont.Style = []
                PrintSettings.PageNumSep = '/'
                SearchFooter.ColorTo = 16052977
                SearchFooter.FindNextCaption = 'Find &next'
                SearchFooter.FindPrevCaption = 'Find &previous'
                SearchFooter.Font.Charset = DEFAULT_CHARSET
                SearchFooter.Font.Color = clWindowText
                SearchFooter.Font.Height = -11
                SearchFooter.Font.Name = 'Tahoma'
                SearchFooter.Font.Style = []
                SearchFooter.HighLightCaption = 'Highlight'
                SearchFooter.HintClose = 'Close'
                SearchFooter.HintFindNext = 'Find next occurrence'
                SearchFooter.HintFindPrev = 'Find previous occurrence'
                SearchFooter.HintHighlight = 'Highlight occurrences'
                SearchFooter.MatchCaseCaption = 'Match case'
                SearchFooter.ResultFormat = '(%d of %d)'
                ShowSelection = False
                ShowDesignHelper = False
                SortSettings.DefaultFormat = ssAutomatic
                SortSettings.Column = 1
                SortSettings.Show = True
                SortSettings.HeaderColor = 16579058
                SortSettings.HeaderColorTo = 16579058
                SortSettings.HeaderMirrorColor = 16380385
                SortSettings.HeaderMirrorColorTo = 16182488
                UIStyle = tsWindowsVista
                VAlignment = vtaCenter
                Version = '3.2.0.2'
                Columns = <
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Fichier'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 160
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edDateEdit
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Date'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 96
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taRightJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edFloat
                    FilterCaseSensitive = False
                    Fixed = False
                    FloatFormat = '%.2n'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Montant'
                    HeaderAlignment = taCenter
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 80
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Remarque'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 266
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Chemin'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 0
                  end>
                ColWidths = (
                  160
                  96
                  80
                  266
                  0)
                RowHeights = (
                  22
                  22
                  22)
              end
            end
            object pnlGrdSituations: TAdvPanel
              Left = 0
              Top = 320
              Width = 602
              Height = 157
              Hint = 
                'Liste des situations (orales ou fichiers) avec leurs dates, mont' +
                'ants HT et remarques respectives; <B>Drag & drop</B> permet d'#39'y ' +
                'ajouter les fichier (attention, la date par d'#233'faut est celle du ' +
                'fichier, pas forc'#233'ment de son envoi); <B>Ctrl+Del</B> supprime l' +
                'a ligne s'#233'lectionn'#233'e; <B>Double clic</B> ouvre le fichier s'#233'lect' +
                'ionn'#233
              Align = alTop
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = 15921646
              Caption.ColorTo = 13223094
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '<B>Situations</B>'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlGrdOffresMinimize
              OnMaximize = pnlGrdOffresMaximize
              FullHeight = 157
              object grdSituations: TAdvColumnGrid
                Left = 0
                Top = 22
                Width = 602
                Height = 135
                Cursor = crDefault
                Hint = 
                  'Liste des situations (orales ou fichiers) avec leurs dates, mont' +
                  'ants HT et remarques respectives; <B>Drag & drop</B> permet d'#39'y ' +
                  'ajouter les fichier (attention, la date par d'#233'faut est celle du ' +
                  'fichier, pas forc'#233'ment de son envoi); <B>Ctrl+Del</B> supprime l' +
                  'a ligne s'#233'lectionn'#233'e; <B>Double clic</B> ouvre le fichier s'#233'lect' +
                  'ionn'#233
                Margins.Left = 8
                Margins.Top = 0
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alClient
                BorderStyle = bsNone
                ColCount = 5
                Ctl3D = True
                DrawingStyle = gdsClassic
                FixedCols = 0
                RowCount = 3
                Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
                ParentCtl3D = False
                ScrollBars = ssNone
                TabOrder = 0
                OnExit = grdExit
                OnKeyDown = grdKeyDown
                GridLineColor = 15527152
                GridFixedLineColor = 13947601
                HoverRowCells = [hcNormal, hcSelected]
                OnRowChanging = grdRowChanging
                OnAutoAddRow = grdOffresAutoAddRow
                OnCanInsertRow = grdCanInsertRow
                OnDblClickCell = grdDblClickCell
                OnExpandClick = grdExpandClick
                OnEditChange = grdEditChange
                ActiveCellFont.Charset = DEFAULT_CHARSET
                ActiveCellFont.Color = clWindowText
                ActiveCellFont.Height = -11
                ActiveCellFont.Name = 'Tahoma'
                ActiveCellFont.Style = [fsBold]
                ActiveCellColor = 16644337
                ActiveCellColorTo = 16576469
                ColumnHeaders.Strings = (
                  'Fichier'
                  'Date'
                  'Montant'
                  'Remarque'
                  'Chemin')
                ColumnSize.Stretch = True
                ColumnSize.StretchColumn = 3
                ControlLook.FixedGradientMirrorFrom = 16447735
                ControlLook.FixedGradientMirrorTo = 16052977
                ControlLook.FixedGradientHoverFrom = 16775139
                ControlLook.FixedGradientHoverTo = 16775139
                ControlLook.FixedGradientHoverMirrorFrom = 16772541
                ControlLook.FixedGradientHoverMirrorTo = 16508855
                ControlLook.FixedGradientDownFrom = 16377020
                ControlLook.FixedGradientDownTo = 16377020
                ControlLook.FixedGradientDownMirrorFrom = 16242317
                ControlLook.FixedGradientDownMirrorTo = 16109962
                ControlLook.FixedGradientDownBorder = 11440207
                ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownHeader.Font.Color = clWindowText
                ControlLook.DropDownHeader.Font.Height = -11
                ControlLook.DropDownHeader.Font.Name = 'Tahoma'
                ControlLook.DropDownHeader.Font.Style = []
                ControlLook.DropDownHeader.Visible = True
                ControlLook.DropDownHeader.Buttons = <>
                ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownFooter.Font.Color = clWindowText
                ControlLook.DropDownFooter.Font.Height = -11
                ControlLook.DropDownFooter.Font.Name = 'Tahoma'
                ControlLook.DropDownFooter.Font.Style = []
                ControlLook.DropDownFooter.Visible = True
                ControlLook.DropDownFooter.Buttons = <>
                Filter = <>
                FilterDropDown.Font.Charset = DEFAULT_CHARSET
                FilterDropDown.Font.Color = clWindowText
                FilterDropDown.Font.Height = -11
                FilterDropDown.Font.Name = 'Tahoma'
                FilterDropDown.Font.Style = []
                FilterDropDown.TextChecked = 'Checked'
                FilterDropDown.TextUnChecked = 'Unchecked'
                FilterDropDownClear = '(All)'
                FilterEdit.TypeNames.Strings = (
                  'Starts with'
                  'Ends with'
                  'Contains'
                  'Not contains'
                  'Equal'
                  'Not equal'
                  'Clear')
                FixedFooters = 1
                FixedColWidth = 160
                FixedRowHeight = 22
                FixedFont.Charset = DEFAULT_CHARSET
                FixedFont.Color = clBlack
                FixedFont.Height = -11
                FixedFont.Name = 'Tahoma'
                FixedFont.Style = []
                FloatFormat = '%.2n'
                FloatingFooter.CalculateHiddenRows = False
                FloatingFooter.Column = 2
                FloatingFooter.Visible = True
                HoverButtons.Buttons = <>
                HoverButtons.Position = hbLeftFromColumnLeft
                HTMLSettings.ImageFolder = 'images'
                HTMLSettings.ImageBaseName = 'img'
                Look = glVista
                MouseActions.DirectDateDrop = True
                MouseActions.WheelIncrement = 1
                Navigation.AdvanceOnEnter = True
                Navigation.AdvanceInsert = True
                Navigation.AdvanceAutoEdit = False
                Navigation.AdvanceAuto = True
                Navigation.AppendOnArrowDown = True
                Navigation.CursorWalkEditor = True
                PrintSettings.DateFormat = 'dd/mm/yyyy'
                PrintSettings.Font.Charset = DEFAULT_CHARSET
                PrintSettings.Font.Color = clWindowText
                PrintSettings.Font.Height = -11
                PrintSettings.Font.Name = 'Tahoma'
                PrintSettings.Font.Style = []
                PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
                PrintSettings.FixedFont.Color = clWindowText
                PrintSettings.FixedFont.Height = -11
                PrintSettings.FixedFont.Name = 'Tahoma'
                PrintSettings.FixedFont.Style = []
                PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
                PrintSettings.HeaderFont.Color = clWindowText
                PrintSettings.HeaderFont.Height = -11
                PrintSettings.HeaderFont.Name = 'Tahoma'
                PrintSettings.HeaderFont.Style = []
                PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
                PrintSettings.FooterFont.Color = clWindowText
                PrintSettings.FooterFont.Height = -11
                PrintSettings.FooterFont.Name = 'Tahoma'
                PrintSettings.FooterFont.Style = []
                PrintSettings.PageNumSep = '/'
                SearchFooter.ColorTo = 16052977
                SearchFooter.FindNextCaption = 'Find &next'
                SearchFooter.FindPrevCaption = 'Find &previous'
                SearchFooter.Font.Charset = DEFAULT_CHARSET
                SearchFooter.Font.Color = clWindowText
                SearchFooter.Font.Height = -11
                SearchFooter.Font.Name = 'Tahoma'
                SearchFooter.Font.Style = []
                SearchFooter.HighLightCaption = 'Highlight'
                SearchFooter.HintClose = 'Close'
                SearchFooter.HintFindNext = 'Find next occurrence'
                SearchFooter.HintFindPrev = 'Find previous occurrence'
                SearchFooter.HintHighlight = 'Highlight occurrences'
                SearchFooter.MatchCaseCaption = 'Match case'
                SearchFooter.ResultFormat = '(%d of %d)'
                ShowSelection = False
                ShowDesignHelper = False
                SortSettings.DefaultFormat = ssAutomatic
                SortSettings.Column = 1
                SortSettings.Show = True
                SortSettings.HeaderColor = 16579058
                SortSettings.HeaderColorTo = 16579058
                SortSettings.HeaderMirrorColor = 16380385
                SortSettings.HeaderMirrorColorTo = 16182488
                UIStyle = tsWindowsVista
                VAlignment = vtaCenter
                Version = '3.2.0.2'
                Columns = <
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Fichier'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 160
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edDateEdit
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Date'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 96
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taRightJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edFloat
                    FilterCaseSensitive = False
                    Fixed = False
                    FloatFormat = '%.2n'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Montant'
                    HeaderAlignment = taCenter
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 80
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Remarque'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 266
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Chemin'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 0
                  end>
                ColWidths = (
                  160
                  96
                  80
                  266
                  0)
                RowHeights = (
                  22
                  22
                  22)
              end
            end
            object pnlGrdDocuments: TAdvPanel
              Left = 0
              Top = 480
              Width = 602
              Height = 157
              Hint = 
                'Liste des documents (fichiers) avec leurs dates et remarques res' +
                'pectives; <B>Drag & drop</B> permet d'#39'y ajouter les fichier (att' +
                'ention, la date par d'#233'faut est celle du fichier, pas forc'#233'ment d' +
                'e son envoi); <B>Ctrl+Del</B> supprime la ligne s'#233'lectionn'#233'e<BR>' +
                '<B>Double clic</B> ouvre le fichier s'#233'lectionn'#233
              Align = alTop
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              TabOrder = 3
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = 15921646
              Caption.ColorTo = 13223094
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '<B>Documents</B>'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlGrdOffresMinimize
              OnMaximize = pnlGrdOffresMaximize
              FullHeight = 157
              object grdDocuments: TAdvColumnGrid
                Left = 0
                Top = 22
                Width = 602
                Height = 135
                Cursor = crDefault
                Hint = 
                  'Liste des documents (fichiers) avec leurs dates et remarques res' +
                  'pectives; <B>Drag & drop</B> permet d'#39'y ajouter les fichier (att' +
                  'ention, la date par d'#233'faut est celle du fichier, pas forc'#233'ment d' +
                  'e son envoi); <B>Ctrl+Del</B> supprime la ligne s'#233'lectionn'#233'e<BR>' +
                  '<B>Double clic</B> ouvre le fichier s'#233'lectionn'#233
                Margins.Left = 8
                Margins.Top = 0
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alClient
                BorderStyle = bsNone
                ColCount = 5
                Ctl3D = True
                DrawingStyle = gdsClassic
                FixedCols = 0
                RowCount = 3
                Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
                ParentCtl3D = False
                ScrollBars = ssNone
                TabOrder = 0
                OnExit = grdExit
                OnKeyDown = grdKeyDown
                GridLineColor = 15527152
                GridFixedLineColor = 13947601
                HoverRowCells = [hcNormal, hcSelected]
                OnRowChanging = grdRowChanging
                OnAutoAddRow = grdOffresAutoAddRow
                OnCanInsertRow = grdCanInsertRow
                OnDblClickCell = grdDblClickCell
                OnExpandClick = grdExpandClick
                OnEditChange = grdEditChange
                ActiveCellFont.Charset = DEFAULT_CHARSET
                ActiveCellFont.Color = clWindowText
                ActiveCellFont.Height = -11
                ActiveCellFont.Name = 'Tahoma'
                ActiveCellFont.Style = [fsBold]
                ActiveCellColor = 16644337
                ActiveCellColorTo = 16576469
                ColumnHeaders.Strings = (
                  'Fichier'
                  'Date'
                  'Montant'
                  'Remarque'
                  'Chemin')
                ColumnSize.Stretch = True
                ColumnSize.StretchColumn = 3
                ControlLook.FixedGradientMirrorFrom = 16447735
                ControlLook.FixedGradientMirrorTo = 16052977
                ControlLook.FixedGradientHoverFrom = 16775139
                ControlLook.FixedGradientHoverTo = 16775139
                ControlLook.FixedGradientHoverMirrorFrom = 16772541
                ControlLook.FixedGradientHoverMirrorTo = 16508855
                ControlLook.FixedGradientDownFrom = 16377020
                ControlLook.FixedGradientDownTo = 16377020
                ControlLook.FixedGradientDownMirrorFrom = 16242317
                ControlLook.FixedGradientDownMirrorTo = 16109962
                ControlLook.FixedGradientDownBorder = 11440207
                ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownHeader.Font.Color = clWindowText
                ControlLook.DropDownHeader.Font.Height = -11
                ControlLook.DropDownHeader.Font.Name = 'Tahoma'
                ControlLook.DropDownHeader.Font.Style = []
                ControlLook.DropDownHeader.Visible = True
                ControlLook.DropDownHeader.Buttons = <>
                ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
                ControlLook.DropDownFooter.Font.Color = clWindowText
                ControlLook.DropDownFooter.Font.Height = -11
                ControlLook.DropDownFooter.Font.Name = 'Tahoma'
                ControlLook.DropDownFooter.Font.Style = []
                ControlLook.DropDownFooter.Visible = True
                ControlLook.DropDownFooter.Buttons = <>
                Filter = <>
                FilterDropDown.Font.Charset = DEFAULT_CHARSET
                FilterDropDown.Font.Color = clWindowText
                FilterDropDown.Font.Height = -11
                FilterDropDown.Font.Name = 'Tahoma'
                FilterDropDown.Font.Style = []
                FilterDropDown.TextChecked = 'Checked'
                FilterDropDown.TextUnChecked = 'Unchecked'
                FilterDropDownClear = '(All)'
                FilterEdit.TypeNames.Strings = (
                  'Starts with'
                  'Ends with'
                  'Contains'
                  'Not contains'
                  'Equal'
                  'Not equal'
                  'Clear')
                FixedFooters = 1
                FixedColWidth = 200
                FixedRowHeight = 22
                FixedFont.Charset = DEFAULT_CHARSET
                FixedFont.Color = clBlack
                FixedFont.Height = -11
                FixedFont.Name = 'Tahoma'
                FixedFont.Style = []
                FloatFormat = '%.2n'
                FloatingFooter.CalculateHiddenRows = False
                FloatingFooter.Column = 2
                FloatingFooter.Visible = True
                HoverButtons.Buttons = <>
                HoverButtons.Position = hbLeftFromColumnLeft
                HTMLSettings.ImageFolder = 'images'
                HTMLSettings.ImageBaseName = 'img'
                Look = glVista
                MouseActions.DirectDateDrop = True
                MouseActions.WheelIncrement = 1
                Navigation.AdvanceOnEnter = True
                Navigation.AdvanceInsert = True
                Navigation.AdvanceAutoEdit = False
                Navigation.AdvanceAuto = True
                Navigation.AppendOnArrowDown = True
                Navigation.CursorWalkEditor = True
                PrintSettings.DateFormat = 'dd/mm/yyyy'
                PrintSettings.Font.Charset = DEFAULT_CHARSET
                PrintSettings.Font.Color = clWindowText
                PrintSettings.Font.Height = -11
                PrintSettings.Font.Name = 'Tahoma'
                PrintSettings.Font.Style = []
                PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
                PrintSettings.FixedFont.Color = clWindowText
                PrintSettings.FixedFont.Height = -11
                PrintSettings.FixedFont.Name = 'Tahoma'
                PrintSettings.FixedFont.Style = []
                PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
                PrintSettings.HeaderFont.Color = clWindowText
                PrintSettings.HeaderFont.Height = -11
                PrintSettings.HeaderFont.Name = 'Tahoma'
                PrintSettings.HeaderFont.Style = []
                PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
                PrintSettings.FooterFont.Color = clWindowText
                PrintSettings.FooterFont.Height = -11
                PrintSettings.FooterFont.Name = 'Tahoma'
                PrintSettings.FooterFont.Style = []
                PrintSettings.PageNumSep = '/'
                SearchFooter.ColorTo = 16052977
                SearchFooter.FindNextCaption = 'Find &next'
                SearchFooter.FindPrevCaption = 'Find &previous'
                SearchFooter.Font.Charset = DEFAULT_CHARSET
                SearchFooter.Font.Color = clWindowText
                SearchFooter.Font.Height = -11
                SearchFooter.Font.Name = 'Tahoma'
                SearchFooter.Font.Style = []
                SearchFooter.HighLightCaption = 'Highlight'
                SearchFooter.HintClose = 'Close'
                SearchFooter.HintFindNext = 'Find next occurrence'
                SearchFooter.HintFindPrev = 'Find previous occurrence'
                SearchFooter.HintHighlight = 'Highlight occurrences'
                SearchFooter.MatchCaseCaption = 'Match case'
                SearchFooter.ResultFormat = '(%d of %d)'
                ShowSelection = False
                ShowDesignHelper = False
                SortSettings.DefaultFormat = ssAutomatic
                SortSettings.Column = 1
                SortSettings.Show = True
                SortSettings.HeaderColor = 16579058
                SortSettings.HeaderColorTo = 16579058
                SortSettings.HeaderMirrorColor = 16380385
                SortSettings.HeaderMirrorColorTo = 16182488
                UIStyle = tsWindowsVista
                VAlignment = vtaCenter
                Version = '3.2.0.2'
                Columns = <
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Fichier'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 200
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edDateEdit
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Date'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 96
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taRightJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edFloat
                    FilterCaseSensitive = False
                    Fixed = False
                    FloatFormat = '%.2n'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Montant'
                    HeaderAlignment = taCenter
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 0
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Remarque'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = False
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 306
                  end
                  item
                    AutoMinSize = 0
                    AutoMaxSize = 0
                    Alignment = taLeftJustify
                    Borders = []
                    BorderPen.Color = clSilver
                    ButtonHeight = 18
                    CheckFalse = 'N'
                    CheckTrue = 'Y'
                    Color = clWindow
                    ColumnPopupType = cpFixedCellsRClick
                    DropDownCount = 8
                    EditLength = 0
                    Editor = edNormal
                    FilterCaseSensitive = False
                    Fixed = False
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -13
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Header = 'Chemin'
                    HeaderAlignment = taLeftJustify
                    HeaderFont.Charset = DEFAULT_CHARSET
                    HeaderFont.Color = clWindowText
                    HeaderFont.Height = -13
                    HeaderFont.Name = 'Tahoma'
                    HeaderFont.Style = []
                    MinSize = 0
                    MaxSize = 0
                    Password = False
                    PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                    PrintColor = clWhite
                    PrintFont.Charset = DEFAULT_CHARSET
                    PrintFont.Color = clWindowText
                    PrintFont.Height = -11
                    PrintFont.Name = 'Tahoma'
                    PrintFont.Style = []
                    ReadOnly = True
                    ShowBands = False
                    SortStyle = ssAutomatic
                    SpinMax = 0
                    SpinMin = 0
                    SpinStep = 1
                    Tag = 0
                    Width = 0
                  end>
                ColWidths = (
                  200
                  96
                  0
                  306
                  0)
                RowHeights = (
                  22
                  22
                  22)
              end
            end
          end
        end
      end
      object atsDétail: TAdvTabSheet
        Hint = 'Calcul de la facture'
        Caption = 'Pr'#233'paration de la facture et heures r'#233'alis'#233'es'
        Color = clWindow
        ColorTo = clNone
        TabColor = 15790320
        TabColorTo = clNone
        OnShow = atsDétailShow
        object Splitter3: TSplitter
          Left = 710
          Top = 0
          Width = 8
          Height = 674
          AutoSnap = False
          MinSize = 256
          ResizeStyle = rsUpdate
        end
        object Panel18: TPanel
          Left = 0
          Top = 0
          Width = 710
          Height = 674
          Align = alLeft
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
          object Splitter2: TSplitter
            Left = 342
            Top = 36
            Width = 8
            Height = 608
            AutoSnap = False
            MinSize = 256
            ResizeStyle = rsUpdate
          end
          object Panel2: TPanel
            AlignWithMargins = True
            Left = 8
            Top = 644
            Width = 694
            Height = 22
            Margins.Left = 8
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alBottom
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object edtTotalOffre: TAdvEdit
              Left = 0
              Top = 0
              Width = 73
              Height = 22
              Hint = 'Solde '#224' disposition par rapport aux offres moins les situations'
              Margins.Left = 64
              Margins.Top = 0
              Margins.Right = 8
              Margins.Bottom = 0
              TabStop = False
              BorderColor = clSilver
              EditAlign = eaRight
              EditorEnabled = False
              EditType = etFloat
              EmptyTextStyle = []
              ReturnIsTab = True
              Precision = 2
              LabelCaption = 'SOLDE'
              LabelPosition = lpRightCenter
              LabelTransparent = True
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
              Align = alLeft
              Color = clWindow
              ReadOnly = True
              TabOrder = 0
              Text = '0.00'
              Visible = True
              Version = '3.5.5.0'
            end
            object edtTotalBase: TAdvEdit
              AlignWithMargins = True
              Left = 133
              Top = 0
              Width = 73
              Height = 22
              Hint = 'Total des co'#251'ts selon les donn'#233'es de la base des heures'
              Margins.Left = 60
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              TabStop = False
              BorderColor = clSilver
              EditAlign = eaRight
              EditorEnabled = False
              EditType = etFloat
              EmptyTextStyle = []
              ReturnIsTab = True
              Precision = 2
              LabelCaption = ' BASE'
              LabelPosition = lpRightCenter
              LabelTransparent = True
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
              Align = alLeft
              Color = clWindow
              ReadOnly = True
              TabOrder = 1
              Text = '0.00'
              Visible = True
              Version = '3.5.5.0'
            end
            object edtDiffOffre: TAdvEdit
              AlignWithMargins = True
              Left = 452
              Top = 0
              Width = 73
              Height = 22
              Hint = 'Diff'#233'rence entre le solde et la facture pr'#233'par'#233'e'
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 96
              Margins.Bottom = 0
              TabStop = False
              BorderColor = clSilver
              EditAlign = eaRight
              EditorEnabled = False
              EditType = etFloat
              EmptyTextStyle = []
              ReturnIsTab = True
              Precision = 2
              LabelCaption = 'SOLDE-TOTAL'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
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
              Align = alRight
              Color = clWindow
              ReadOnly = True
              TabOrder = 2
              Text = '0.00'
              Visible = True
              OnChange = BilanChange
              Version = '3.5.5.0'
            end
            object edtDiffBase: TAdvEdit
              Left = 621
              Top = 0
              Width = 73
              Height = 22
              Hint = 
                'Diff'#233'rence entre la facture pr'#233'par'#233'e et le co'#251't selon les donn'#233'e' +
                's de la base des heures'
              Margins.Left = 104
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              TabStop = False
              BorderColor = clSilver
              EditAlign = eaRight
              EditorEnabled = False
              EditType = etFloat
              EmptyTextStyle = []
              ReturnIsTab = True
              Precision = 2
              LabelCaption = 'TOTAL-BASE'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
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
              Align = alRight
              Color = clWindow
              ReadOnly = True
              TabOrder = 3
              Text = '0.00'
              Visible = True
              OnChange = BilanChange
              Version = '3.5.5.0'
            end
          end
          object grdFacture: TAdvColumnGrid
            AlignWithMargins = True
            Left = 8
            Top = 44
            Width = 334
            Height = 592
            Cursor = crDefault
            Hint = 'Calcul de la facture en cours; <B>Vert</B>: champs modifiables'
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alLeft
            ColCount = 5
            Ctl3D = True
            DrawingStyle = gdsClassic
            RowCount = 27
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
            ParentCtl3D = False
            ScrollBars = ssBoth
            TabOrder = 0
            OnSelectCell = grdSelectCell
            GridLineColor = 15527152
            GridFixedLineColor = 13947601
            HoverRowCells = [hcNormal, hcSelected]
            OnCellValidate = grdCellValidate
            OnEditCellDone = grdFactureEditCellDone
            OnResize = grdFactureResize
            ActiveCellFont.Charset = DEFAULT_CHARSET
            ActiveCellFont.Color = clWindowText
            ActiveCellFont.Height = -11
            ActiveCellFont.Name = 'Tahoma'
            ActiveCellFont.Style = [fsBold]
            ActiveCellColor = 16644337
            ActiveCellColorTo = 16576469
            ColumnHeaders.Strings = (
              'HONORAIRES')
            ControlLook.FixedGradientMirrorFrom = 16447735
            ControlLook.FixedGradientMirrorTo = 16052977
            ControlLook.FixedGradientHoverFrom = 16775139
            ControlLook.FixedGradientHoverTo = 16775139
            ControlLook.FixedGradientHoverMirrorFrom = 16772541
            ControlLook.FixedGradientHoverMirrorTo = 16508855
            ControlLook.FixedGradientDownFrom = 16377020
            ControlLook.FixedGradientDownTo = 16377020
            ControlLook.FixedGradientDownMirrorFrom = 16242317
            ControlLook.FixedGradientDownMirrorTo = 16109962
            ControlLook.FixedGradientDownBorder = 11440207
            ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
            ControlLook.DropDownHeader.Font.Color = clWindowText
            ControlLook.DropDownHeader.Font.Height = -11
            ControlLook.DropDownHeader.Font.Name = 'Tahoma'
            ControlLook.DropDownHeader.Font.Style = []
            ControlLook.DropDownHeader.Visible = True
            ControlLook.DropDownHeader.Buttons = <>
            ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
            ControlLook.DropDownFooter.Font.Color = clWindowText
            ControlLook.DropDownFooter.Font.Height = -11
            ControlLook.DropDownFooter.Font.Name = 'Tahoma'
            ControlLook.DropDownFooter.Font.Style = []
            ControlLook.DropDownFooter.Visible = True
            ControlLook.DropDownFooter.Buttons = <>
            EnhRowColMove = False
            Filter = <>
            FilterDropDown.Font.Charset = DEFAULT_CHARSET
            FilterDropDown.Font.Color = clWindowText
            FilterDropDown.Font.Height = -11
            FilterDropDown.Font.Name = 'Tahoma'
            FilterDropDown.Font.Style = []
            FilterDropDown.TextChecked = 'Checked'
            FilterDropDown.TextUnChecked = 'Unchecked'
            FilterDropDownClear = '(All)'
            FilterEdit.TypeNames.Strings = (
              'Starts with'
              'Ends with'
              'Contains'
              'Not contains'
              'Equal'
              'Not equal'
              'Clear')
            FixedRowHeight = 22
            FixedFont.Charset = DEFAULT_CHARSET
            FixedFont.Color = clBlack
            FixedFont.Height = -11
            FixedFont.Name = 'Tahoma'
            FixedFont.Style = [fsBold]
            FloatFormat = '%.2f'
            HoverButtons.Buttons = <>
            HoverButtons.Position = hbLeftFromColumnLeft
            HTMLSettings.ImageFolder = 'images'
            HTMLSettings.ImageBaseName = 'img'
            Look = glVista
            MouseActions.AutoSizeColOnDblClick = False
            MouseActions.PreciseNodeClick = False
            MouseActions.WheelIncrement = 1
            Navigation.AdvanceOnEnter = True
            Navigation.AdvanceAuto = True
            PrintSettings.DateFormat = 'dd/mm/yyyy'
            PrintSettings.Font.Charset = DEFAULT_CHARSET
            PrintSettings.Font.Color = clWindowText
            PrintSettings.Font.Height = -11
            PrintSettings.Font.Name = 'Tahoma'
            PrintSettings.Font.Style = []
            PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
            PrintSettings.FixedFont.Color = clWindowText
            PrintSettings.FixedFont.Height = -11
            PrintSettings.FixedFont.Name = 'Tahoma'
            PrintSettings.FixedFont.Style = []
            PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
            PrintSettings.HeaderFont.Color = clWindowText
            PrintSettings.HeaderFont.Height = -11
            PrintSettings.HeaderFont.Name = 'Tahoma'
            PrintSettings.HeaderFont.Style = []
            PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
            PrintSettings.FooterFont.Color = clWindowText
            PrintSettings.FooterFont.Height = -11
            PrintSettings.FooterFont.Name = 'Tahoma'
            PrintSettings.FooterFont.Style = []
            PrintSettings.PageNumSep = '/'
            SearchFooter.ColorTo = 16052977
            SearchFooter.FindNextCaption = 'Find &next'
            SearchFooter.FindPrevCaption = 'Find &previous'
            SearchFooter.Font.Charset = DEFAULT_CHARSET
            SearchFooter.Font.Color = clWindowText
            SearchFooter.Font.Height = -11
            SearchFooter.Font.Name = 'Tahoma'
            SearchFooter.Font.Style = []
            SearchFooter.HighLightCaption = 'Highlight'
            SearchFooter.HintClose = 'Close'
            SearchFooter.HintFindNext = 'Find next occurrence'
            SearchFooter.HintFindPrev = 'Find previous occurrence'
            SearchFooter.HintHighlight = 'Highlight occurrences'
            SearchFooter.MatchCaseCaption = 'Match case'
            SearchFooter.ResultFormat = '(%d of %d)'
            ShowDesignHelper = False
            SortSettings.DefaultFormat = ssAutomatic
            SortSettings.HeaderColor = 16579058
            SortSettings.HeaderColorTo = 16579058
            SortSettings.HeaderMirrorColor = 16380385
            SortSettings.HeaderMirrorColorTo = 16182488
            UIStyle = tsWindowsVista
            VAlignment = vtaCenter
            Version = '3.2.0.2'
            Columns = <
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edNormal
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                Header = 'HONORAIRES'
                HeaderAlignment = taCenter
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = False
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edFloat
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                HeaderAlignment = taCenter
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = False
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edFloat
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                HeaderAlignment = taCenter
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = False
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edFloat
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                HeaderAlignment = taCenter
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = False
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edFloat
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                HeaderAlignment = taCenter
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = False
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end>
            ColWidths = (
              64
              64
              64
              64
              64)
            RowHeights = (
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22)
            object btnRabais: TSpeedButton
              Left = 110
              Top = 172
              Width = 123
              Height = 24
              Hint = 'Commute le calcul de forfait '#224' pourcent'
              AllowAllUp = True
              GroupIndex = 1
              Down = True
              Caption = 'au pourcent'
              OnClick = btnRabaisClick
            end
            object btnFrais: TSpeedButton
              Left = 110
              Top = 356
              Width = 123
              Height = 24
              Hint = 'Commute le calcul de forfait '#224' pourcent'
              AllowAllUp = True
              GroupIndex = 3
              Down = True
              Caption = 'au pourcent'
              OnClick = btnFraisClick
            end
            object btnFraisType: TSpeedButton
              Left = 110
              Top = 292
              Width = 123
              Height = 24
              Hint = 'Commute entre le d'#233'tail des frais et les frais forfaitaires'
              AllowAllUp = True
              GroupIndex = 2
              Down = True
              Caption = 'q'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Wingdings 3'
              Font.Style = []
              ParentFont = False
              OnClick = btnFraisTypeClick
            end
            object btnAutres1: TSpeedButton
              Left = 70
              Top = 68
              Width = 22
              Height = 22
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              AllowAllUp = True
              GroupIndex = 91
              Caption = '1'
              OnClick = btnMemoClick
            end
            object btnKm1: TSpeedButton
              Left = 72
              Top = 109
              Width = 22
              Height = 22
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              AllowAllUp = True
              GroupIndex = 92
              Caption = '2'
              OnClick = btnMemoClick
            end
            object btnFrais1: TSpeedButton
              Left = 72
              Top = 149
              Width = 22
              Height = 22
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              AllowAllUp = True
              GroupIndex = 93
              Caption = '3'
              OnClick = btnMemoClick
            end
            object btnTiers1: TSpeedButton
              Left = 72
              Top = 189
              Width = 22
              Height = 22
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              AllowAllUp = True
              GroupIndex = 94
              Caption = '4'
              OnClick = btnMemoClick
            end
          end
          object AdvScrollBox1: TAdvScrollBox
            AlignWithMargins = True
            Left = 350
            Top = 44
            Width = 360
            Height = 592
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alClient
            DoubleBuffered = True
            Ctl3D = False
            ParentCtl3D = False
            ParentDoubleBuffered = False
            TabOrder = 2
            object splAutres: TAdvSplitter
              Left = 0
              Top = 147
              Width = 341
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitLeft = 6
              ExplicitTop = 140
              ExplicitWidth = 335
            end
            object splKm: TAdvSplitter
              Left = 0
              Top = 297
              Width = 341
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitTop = 295
              ExplicitWidth = 311
            end
            object splFrais: TAdvSplitter
              Left = 0
              Top = 447
              Width = 341
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitTop = 275
              ExplicitWidth = 415
            end
            object splTiers: TAdvSplitter
              Left = 0
              Top = 597
              Width = 341
              Height = 3
              Cursor = crVSplit
              Align = alTop
              AutoSnap = False
              MinSize = 86
              Appearance.BorderColor = clNone
              Appearance.BorderColorHot = clNone
              Appearance.Color = clWhite
              Appearance.ColorTo = clSilver
              Appearance.ColorHot = clWhite
              Appearance.ColorHotTo = clGray
              GripStyle = sgNone
              ExplicitTop = 367
              ExplicitWidth = 415
            end
            object pnlAutres: TAdvPanel
              Left = 0
              Top = 0
              Width = 341
              Height = 147
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              Margins.Left = 0
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alTop
              ParentColor = True
              TabOrder = 0
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = clWhite
              Caption.ColorTo = 14737632
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '1. Autres prestations (ME, inclinos, p'#233'n'#233'tros...)'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlMemoMinimize
              OnMaximize = pnlMemoMaximize
              FullHeight = 147
              object memAutres: TMemo
                Left = 0
                Top = 22
                Width = 341
                Height = 125
                Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
                Align = alClient
                BorderStyle = bsNone
                ScrollBars = ssVertical
                TabOrder = 0
                OnChange = DatasChanged
              end
            end
            object pnlKm: TAdvPanel
              Left = 0
              Top = 150
              Width = 341
              Height = 147
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              Align = alTop
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              TabOrder = 1
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = clWhite
              Caption.ColorTo = 14737632
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '2. D'#233'placements (voiture)'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlMemoMinimize
              OnMaximize = pnlMemoMaximize
              FullHeight = 147
              object memKm: TMemo
                Left = 0
                Top = 22
                Width = 341
                Height = 125
                Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
                Align = alClient
                BorderStyle = bsNone
                ScrollBars = ssVertical
                TabOrder = 0
                OnChange = DatasChanged
              end
            end
            object pnlFrais: TAdvPanel
              Left = 0
              Top = 300
              Width = 341
              Height = 147
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              Align = alTop
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              TabOrder = 2
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = clWhite
              Caption.ColorTo = 14737632
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '3. Frais (train, achats de mat'#233'riel, etc.)'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlMemoMinimize
              OnMaximize = pnlMemoMaximize
              FullHeight = 147
              object memFrais: TMemo
                Left = 0
                Top = 22
                Width = 341
                Height = 125
                Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
                Align = alClient
                BorderStyle = bsNone
                ScrollBars = ssVertical
                TabOrder = 0
                OnChange = DatasChanged
              end
            end
            object pnlTiers: TAdvPanel
              Left = 0
              Top = 450
              Width = 341
              Height = 147
              Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
              Align = alTop
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentColor = True
              ParentFont = False
              TabOrder = 3
              UseDockManager = True
              Version = '2.5.10.7'
              BorderColor = clBlack
              Caption.ButtonPosition = cbpLeft
              Caption.Color = clWhite
              Caption.ColorTo = 14737632
              Caption.Flat = True
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clWindowText
              Caption.Font.Height = -13
              Caption.Font.Name = 'Tahoma'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Height = 24
              Caption.Indent = 0
              Caption.MinMaxButton = True
              Caption.MinMaxButtonColor = clBlack
              Caption.MinMaxButtonHoverColor = clBlue
              Caption.MinMaxCaption = True
              Caption.Text = '4. Frais de tiers (laboratoire, pelle...)'
              Caption.TopIndent = 2
              Caption.Visible = True
              DoubleBuffered = True
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = clWindowText
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              Text = ''
              OnMinimize = pnlMemoMinimize
              OnMaximize = pnlMemoMaximize
              FullHeight = 147
              object memTiers: TMemo
                Left = 0
                Top = 22
                Width = 341
                Height = 125
                Hint = 'Justificatifs et d'#233'tails (dates, montants) des frais'
                Align = alClient
                BorderStyle = bsNone
                ScrollBars = ssVertical
                TabOrder = 0
                OnChange = DatasChanged
              end
            end
          end
          object AdvPanel1: TAdvPanel
            Left = 0
            Top = 0
            Width = 710
            Height = 36
            Align = alTop
            Color = 16316664
            TabOrder = 3
            UseDockManager = True
            Version = '2.5.10.7'
            BorderColor = clBlack
            Caption.Color = clHighlight
            Caption.ColorTo = clNone
            Caption.Font.Charset = DEFAULT_CHARSET
            Caption.Font.Color = clWindowText
            Caption.Font.Height = -13
            Caption.Font.Name = 'Tahoma'
            Caption.Font.Style = []
            Caption.Indent = 0
            ColorTo = 13684944
            DoubleBuffered = True
            StatusBar.Font.Charset = DEFAULT_CHARSET
            StatusBar.Font.Color = clWindowText
            StatusBar.Font.Height = -11
            StatusBar.Font.Name = 'Tahoma'
            StatusBar.Font.Style = []
            Text = ''
            FullHeight = 36
            object btnCopyFacture: TSpeedButton
              AlignWithMargins = True
              Left = 622
              Top = 6
              Width = 80
              Height = 22
              Hint = 'Copie le tableau pour '#234'tre coll'#233' dans Excel par exemple'
              Margins.Left = 16
              Margins.Top = 6
              Margins.Right = 8
              Margins.Bottom = 8
              Action = actCopyGrid
              Align = alRight
              ExplicitLeft = 0
              ExplicitTop = 0
            end
            object btnGetInterval: TSpeedButton
              AlignWithMargins = True
              Left = 8
              Top = 6
              Width = 80
              Height = 22
              Margins.Left = 8
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Action = actGetInterval
              Align = alLeft
              ExplicitTop = 14
            end
            object btnGetHours: TSpeedButton
              AlignWithMargins = True
              Left = 334
              Top = 6
              Width = 80
              Height = 22
              Hint = 'Mise '#224' jour des heures et frais et recalcule tout'
              Margins.Left = 8
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Action = actGetHours
              Align = alLeft
              ExplicitLeft = 510
              ExplicitTop = 3
            end
            object btnKBOB: TSpeedButton
              AlignWithMargins = True
              Left = 502
              Top = 6
              Width = 80
              Height = 22
              Hint = 'S'#233'lection du tarif KBOB orrespondant '#224' l'#39'ann'#233'e des travaux'
              Margins.Left = 8
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'KBOB'
              OnClick = btnKBOBClick
              ExplicitLeft = 518
            end
            object btnVerify: TSpeedButton
              AlignWithMargins = True
              Left = 414
              Top = 6
              Width = 80
              Height = 22
              Margins.Left = 0
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Action = actVerify
              Align = alLeft
              ExplicitLeft = 478
            end
            object edtA: TAdvDateTimePicker
              AlignWithMargins = True
              Left = 229
              Top = 6
              Width = 97
              Height = 22
              Hint = 
                'P'#233'riode de la facturation; Par d'#233'faut couvre l'#39'entier des heurs ' +
                'non factur'#233'es; Mais cet intervalle peut '#234'tre modifi'#233
              Margins.Left = 20
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Align = alLeft
              Date = 41932.000000000000000000
              Format = ''
              Time = 0.705104166663659300
              DoubleBuffered = True
              Kind = dkDate
              ParentDoubleBuffered = False
              TabOrder = 0
              BorderStyle = bsSingle
              Ctl3D = True
              DateTime = 41932.705104166660000000
              Version = '1.3.5.5'
              LabelCaption = 'A'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
              LabelFont.Charset = DEFAULT_CHARSET
              LabelFont.Color = clWindowText
              LabelFont.Height = -11
              LabelFont.Name = 'Tahoma'
              LabelFont.Style = []
            end
            object edtDe: TAdvDateTimePicker
              AlignWithMargins = True
              Left = 112
              Top = 6
              Width = 97
              Height = 22
              Hint = 
                'P'#233'riode de la facturation; Par d'#233'faut couvre l'#39'entier des heurs ' +
                'non factur'#233'es; Mais cet intervalle peut '#234'tre modifi'#233
              Margins.Left = 24
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Align = alLeft
              Date = 41932.000000000000000000
              Format = ''
              Time = 0.705104166663659300
              DoubleBuffered = True
              Kind = dkDate
              ParentDoubleBuffered = False
              TabOrder = 1
              BorderStyle = bsSingle
              Ctl3D = True
              DateTime = 41932.705104166660000000
              Version = '1.3.5.5'
              LabelCaption = 'De'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
              LabelFont.Charset = DEFAULT_CHARSET
              LabelFont.Color = clWindowText
              LabelFont.Height = -11
              LabelFont.Name = 'Tahoma'
              LabelFont.Style = []
            end
          end
        end
        object Panel19: TPanel
          Left = 718
          Top = 0
          Width = 554
          Height = 674
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          OnResize = Panel19Resize
          object grdDétails: TXDBGrid
            AlignWithMargins = True
            Left = 0
            Top = 44
            Width = 546
            Height = 622
            Hint = 
              'Liste des heures non factur'#233'es; <B>Double clic</B> filtre sur la' +
              ' cellule s'#233'lcetionn'#233'e; <B>Clic sur en-t'#234'te</B> tri de la colonne'
            Margins.Left = 0
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            DataSource = dsrDetails
            FillerButton = False
            FillerIndex = -1
            FixedStyle = fsMild
            FixedTheme = ftNone
            Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
            GridStyle.VisualStyle = vsXPStyle
            HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints, hoShowToolTips, hoShowDataHints, hoShowTotalToolTips]
            IndicatorWidth = 12
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgHotButtons, dgTitleButtons, dgTitleHeaders, dgTitleWidthOff, dgMarkerAutoAlign, dgMarkerAutoSwitch, dgMarkerAutoToggle]
            OptionsEx = [dgBlankRow, dgTotalFooter, dgTotalHeaderBox, dgTotalValuesBox, dgTotalFieldsBox, dgTotalFooterBox, dgAutoUpdateOrder, dgAutoAscendOrder, dgAutoUpdateSequence, dgDelayUpdateSequence, dgAutoUpdateTotals, dgDelayUpdateTotals, dgCalcWholeDataSet, dgCalcSelectedRows, dgDelaySelectedRows, dgSelectedAutoHidden]
            ParentShowHint = False
            ReadOnly = True
            ResizeOptions = [roColumnResize, roOptimalWidth, roDefaultWidth]
            ShowHint = True
            TabOrder = 0
            WheelScrollRows = 1
            OnCellDblClick = grdFilterCellDblClick
            OnColumnResize = grdDétailsColumnResize
            Columns = <
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'Date'
                ShowEdit = False
                Title.Alignment = taCenter
                Title.Marker = tmAscend
                Title.MarkerIndex = 0
                TotalFooter.TotalBox = tbFalse
                VAlignment = tvTopJustify
                Visible = True
                Width = 70
              end
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'Initiales'
                ShowEdit = False
                Title.Alignment = taCenter
                Title.Caption = 'I'
                Title.Hint = 'Collaborateur'
                TotalFooter.TotalBox = tbFalse
                VAlignment = tvTopJustify
                Visible = True
                Width = 32
              end
              item
                Alignment = taCenter
                Expanded = False
                FieldName = 'Classe'
                ShowEdit = False
                Title.Alignment = taCenter
                Title.Caption = 'C'
                Title.Hint = 'Cat'#233'gorie KBOB'
                TotalFooter.TotalBox = tbFalse
                VAlignment = tvTopJustify
                Visible = True
                Width = 24
              end
              item
                Expanded = False
                FieldName = 'Heures'
                ShowEdit = False
                Title.Alignment = taRightJustify
                TotalFooter.TotalBox = tbFalse
                TotalFooter.Format = '%.2f'
                TotalFooter.TotalResult = trCalcValue
                VAlignment = tvTopJustify
                Visible = True
                Width = 56
              end
              item
                Expanded = False
                FieldName = 'Km'
                ShowEdit = False
                Title.Alignment = taRightJustify
                TotalFooter.TotalBox = tbFalse
                TotalFooter.Format = '%.2f'
                TotalFooter.FormatAsFloat = True
                TotalFooter.TotalResult = trCalcValue
                VAlignment = tvTopJustify
                Visible = True
                Width = 56
              end
              item
                Expanded = False
                FieldName = 'Frais'
                ShowEdit = False
                Title.Alignment = taRightJustify
                TotalFooter.TotalBox = tbFalse
                TotalFooter.Format = '%.2f'
                TotalFooter.TotalResult = trCalcValue
                VAlignment = tvTopJustify
                Visible = True
                Width = 56
              end
              item
                Expanded = False
                FieldName = 'Code'
                ShowEdit = False
                Title.Caption = 'A'
                Title.Hint = 'Activit'#233
                TotalFooter.TotalBox = tbFalse
                VAlignment = tvTopJustify
                Visible = True
                Width = 24
              end
              item
                Expanded = False
                FieldName = 'Remarque'
                ShowEdit = False
                TotalFooter.TotalBox = tbFalse
                VAlignment = tvTopJustify
                Visible = True
                Width = 480
              end>
            OrderFields = 'Date'
          end
          object AdvPanel2: TAdvPanel
            Left = 0
            Top = 0
            Width = 554
            Height = 36
            Align = alTop
            Color = 16316664
            TabOrder = 1
            UseDockManager = True
            Version = '2.5.10.7'
            BorderColor = clBlack
            Caption.Color = clHighlight
            Caption.ColorTo = clNone
            Caption.Font.Charset = DEFAULT_CHARSET
            Caption.Font.Color = clWindowText
            Caption.Font.Height = -13
            Caption.Font.Name = 'Tahoma'
            Caption.Font.Style = []
            Caption.Indent = 0
            ColorTo = 13684944
            DoubleBuffered = True
            StatusBar.Font.Charset = DEFAULT_CHARSET
            StatusBar.Font.Color = clWindowText
            StatusBar.Font.Height = -11
            StatusBar.Font.Name = 'Tahoma'
            StatusBar.Font.Style = []
            Text = ''
            FullHeight = 36
            object btnRefreshDetails: TSpeedButton
              AlignWithMargins = True
              Left = 88
              Top = 6
              Width = 80
              Height = 22
              Hint = 
                'Met '#224' jour les donn'#233'es; Utile si quelqu'#39'un a inscrit des heures ' +
                'pendant que le programme est ouvert'
              Margins.Left = 0
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'Actualiser'
              OnClick = btnRefreshDetailsClick
              ExplicitLeft = 0
              ExplicitTop = 0
            end
            object btnFilter: TSpeedButton
              AlignWithMargins = True
              Left = 8
              Top = 6
              Width = 80
              Height = 22
              Margins.Left = 8
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 8
              Action = actFilter
              Align = alLeft
              ExplicitLeft = -3
            end
            object edtFilter: TAdvEditBtn
              AlignWithMargins = True
              Left = 386
              Top = 6
              Width = 160
              Height = 22
              Hint = 
                'Filtre les commentaires contenant la portion de texte inscrite i' +
                'ci; <B>'#215'</B> ou <B>ESC</B>annule le filtre'
              Margins.Left = 0
              Margins.Top = 6
              Margins.Right = 8
              Margins.Bottom = 8
              EmptyTextStyle = []
              LabelCaption = 'Remarque'
              LabelPosition = lpLeftCenter
              LabelTransparent = True
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
              Align = alRight
              Color = 16316664
              ParentColor = True
              ShortCut = 0
              TabOrder = 0
              Text = ''
              Visible = True
              OnChange = edtFilterChange
              OnKeyDown = edtFilterKeyDown
              Version = '1.6.2.0'
              ButtonStyle = bsButton
              ButtonWidth = 16
              Flat = False
              Etched = False
              ButtonCaption = #215
              ReadOnly = False
              OnClickBtn = edtFilterClickBtn
              ExplicitLeft = 387
            end
          end
        end
      end
      object atsPénétro: TAdvTabSheet
        Hint = 'Outils divers'
        Caption = 'P'#233'n'#233'trom'#232'tre'
        Color = clWindow
        ColorTo = clBtnFace
        TabColor = 15790320
        TabColorTo = clNone
        OnShow = atsPénétroShow
        object grbPenetro: TGroupBox
          AlignWithMargins = True
          Left = 16
          Top = 44
          Width = 1240
          Height = 349
          Margins.Left = 16
          Margins.Top = 8
          Margins.Right = 16
          Margins.Bottom = 8
          Align = alTop
          Caption = 'P'#233'n'#233'trom'#232'tre'
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          object Label4: TLabel
            AlignWithMargins = True
            Left = 17
            Top = 316
            Width = 1206
            Height = 16
            Margins.Left = 16
            Margins.Top = 8
            Margins.Right = 16
            Margins.Bottom = 16
            Align = alBottom
            Caption = 'Ne pas oublier d'#39'ajouter les kilom'#232'tres !'
            ExplicitWidth = 228
          end
          object grdPenetro: TAdvColumnGrid
            AlignWithMargins = True
            Left = 17
            Top = 25
            Width = 420
            Height = 283
            Cursor = crDefault
            Hint = 
              'Calcul du co'#251'ts des p'#233'n'#233'trom'#232'tres du mandat en cours; Ne pas oub' +
              'lier de compter les d'#233'placements; <B>Vert</B>: champs modifiable' +
              's'
            Margins.Left = 16
            Margins.Top = 8
            Margins.Right = 16
            Margins.Bottom = 0
            Align = alLeft
            BevelInner = bvNone
            BevelOuter = bvNone
            ColCount = 5
            Ctl3D = True
            DrawingStyle = gdsClassic
            FixedCols = 0
            RowCount = 11
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goTabs]
            ParentCtl3D = False
            ScrollBars = ssBoth
            TabOrder = 0
            OnSelectCell = grdSelectCell
            GridLineColor = 15527152
            GridFixedLineColor = 13947601
            HoverRowCells = [hcNormal, hcSelected]
            OnCellValidate = grdCellValidate
            OnEditCellDone = grdPenetroEditCellDone
            ActiveCellFont.Charset = DEFAULT_CHARSET
            ActiveCellFont.Color = clWindowText
            ActiveCellFont.Height = -11
            ActiveCellFont.Name = 'Tahoma'
            ActiveCellFont.Style = [fsBold]
            ActiveCellColor = 16644337
            ActiveCellColorTo = 16576469
            ColumnHeaders.Strings = (
              'Rubrique'
              'Unit'#233
              'Prix unitaire'
              'Quantit'#233
              'Montant')
            ControlLook.FixedGradientMirrorFrom = 16447735
            ControlLook.FixedGradientMirrorTo = 16052977
            ControlLook.FixedGradientHoverFrom = 16775139
            ControlLook.FixedGradientHoverTo = 16775139
            ControlLook.FixedGradientHoverMirrorFrom = 16772541
            ControlLook.FixedGradientHoverMirrorTo = 16508855
            ControlLook.FixedGradientDownFrom = 16377020
            ControlLook.FixedGradientDownTo = 16377020
            ControlLook.FixedGradientDownMirrorFrom = 16242317
            ControlLook.FixedGradientDownMirrorTo = 16109962
            ControlLook.FixedGradientDownBorder = 11440207
            ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
            ControlLook.DropDownHeader.Font.Color = clWindowText
            ControlLook.DropDownHeader.Font.Height = -11
            ControlLook.DropDownHeader.Font.Name = 'Tahoma'
            ControlLook.DropDownHeader.Font.Style = []
            ControlLook.DropDownHeader.Visible = True
            ControlLook.DropDownHeader.Buttons = <>
            ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
            ControlLook.DropDownFooter.Font.Color = clWindowText
            ControlLook.DropDownFooter.Font.Height = -11
            ControlLook.DropDownFooter.Font.Name = 'Tahoma'
            ControlLook.DropDownFooter.Font.Style = []
            ControlLook.DropDownFooter.Visible = True
            ControlLook.DropDownFooter.Buttons = <>
            EnhRowColMove = False
            Filter = <>
            FilterDropDown.Font.Charset = DEFAULT_CHARSET
            FilterDropDown.Font.Color = clWindowText
            FilterDropDown.Font.Height = -11
            FilterDropDown.Font.Name = 'Tahoma'
            FilterDropDown.Font.Style = []
            FilterDropDown.TextChecked = 'Checked'
            FilterDropDown.TextUnChecked = 'Unchecked'
            FilterDropDownClear = '(All)'
            FilterEdit.TypeNames.Strings = (
              'Starts with'
              'Ends with'
              'Contains'
              'Not contains'
              'Equal'
              'Not equal'
              'Clear')
            FixedFooters = 1
            FixedColWidth = 160
            FixedRowHeight = 22
            FixedFont.Charset = DEFAULT_CHARSET
            FixedFont.Color = clBlack
            FixedFont.Height = -11
            FixedFont.Name = 'Tahoma'
            FixedFont.Style = [fsBold]
            FloatFormat = '%.2f'
            FloatingFooter.CalculateHiddenRows = False
            FloatingFooter.Visible = True
            HoverButtons.Buttons = <>
            HoverButtons.Position = hbLeftFromColumnLeft
            HTMLSettings.ImageFolder = 'images'
            HTMLSettings.ImageBaseName = 'img'
            Look = glVista
            Navigation.AdvanceOnEnter = True
            Navigation.AdvanceOnEnterLoop = False
            Navigation.AdvanceAutoEdit = False
            Navigation.AutoComboSelect = False
            Navigation.AdvanceDirection = adTopBottom
            Navigation.ComboGetUpDown = False
            Navigation.CursorWalkEditor = True
            Navigation.CopyHTMLTagsToClipboard = False
            Navigation.TabToNextAtEnd = True
            Navigation.TabAdvanceDirection = adTopBottom
            PrintSettings.DateFormat = 'dd/mm/yyyy'
            PrintSettings.Font.Charset = DEFAULT_CHARSET
            PrintSettings.Font.Color = clWindowText
            PrintSettings.Font.Height = -11
            PrintSettings.Font.Name = 'Tahoma'
            PrintSettings.Font.Style = []
            PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
            PrintSettings.FixedFont.Color = clWindowText
            PrintSettings.FixedFont.Height = -11
            PrintSettings.FixedFont.Name = 'Tahoma'
            PrintSettings.FixedFont.Style = []
            PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
            PrintSettings.HeaderFont.Color = clWindowText
            PrintSettings.HeaderFont.Height = -11
            PrintSettings.HeaderFont.Name = 'Tahoma'
            PrintSettings.HeaderFont.Style = []
            PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
            PrintSettings.FooterFont.Color = clWindowText
            PrintSettings.FooterFont.Height = -11
            PrintSettings.FooterFont.Name = 'Tahoma'
            PrintSettings.FooterFont.Style = []
            PrintSettings.PageNumSep = '/'
            SearchFooter.ColorTo = 16052977
            SearchFooter.FindNextCaption = 'Find &next'
            SearchFooter.FindPrevCaption = 'Find &previous'
            SearchFooter.Font.Charset = DEFAULT_CHARSET
            SearchFooter.Font.Color = clWindowText
            SearchFooter.Font.Height = -11
            SearchFooter.Font.Name = 'Tahoma'
            SearchFooter.Font.Style = []
            SearchFooter.HighLightCaption = 'Highlight'
            SearchFooter.HintClose = 'Close'
            SearchFooter.HintFindNext = 'Find next occurrence'
            SearchFooter.HintFindPrev = 'Find previous occurrence'
            SearchFooter.HintHighlight = 'Highlight occurrences'
            SearchFooter.MatchCaseCaption = 'Match case'
            SearchFooter.ResultFormat = '(%d of %d)'
            ShowDesignHelper = False
            SortSettings.DefaultFormat = ssAutomatic
            SortSettings.HeaderColor = 16579058
            SortSettings.HeaderColorTo = 16579058
            SortSettings.HeaderMirrorColor = 16380385
            SortSettings.HeaderMirrorColorTo = 16182488
            UIStyle = tsWindowsVista
            Version = '3.2.0.2'
            Columns = <
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taLeftJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edNone
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                Header = 'Rubrique'
                HeaderAlignment = taLeftJustify
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = True
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 160
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taCenter
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edNone
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                Header = 'Unit'#233
                HeaderAlignment = taCenter
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = True
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = 14745568
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edFloat
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                Header = 'Prix unitaire'
                HeaderAlignment = taRightJustify
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = False
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = 14745568
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edFloat
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                Header = 'Quantit'#233
                HeaderAlignment = taRightJustify
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = False
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end
              item
                AutoMinSize = 0
                AutoMaxSize = 0
                Alignment = taRightJustify
                Borders = []
                BorderPen.Color = clSilver
                ButtonHeight = 18
                CheckFalse = 'N'
                CheckTrue = 'Y'
                Color = clWindow
                ColumnPopupType = cpFixedCellsRClick
                DropDownCount = 8
                EditLength = 0
                Editor = edFloat
                FilterCaseSensitive = False
                Fixed = False
                FloatFormat = '%.2n'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = []
                Header = 'Montant'
                HeaderAlignment = taRightJustify
                HeaderFont.Charset = DEFAULT_CHARSET
                HeaderFont.Color = clWindowText
                HeaderFont.Height = -13
                HeaderFont.Name = 'Tahoma'
                HeaderFont.Style = []
                MinSize = 0
                MaxSize = 0
                Password = False
                PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                PrintColor = clWhite
                PrintFont.Charset = DEFAULT_CHARSET
                PrintFont.Color = clWindowText
                PrintFont.Height = -11
                PrintFont.Name = 'Tahoma'
                PrintFont.Style = []
                ReadOnly = True
                ShowBands = False
                SortStyle = ssAutomatic
                SpinMax = 0
                SpinMin = 0
                SpinStep = 1
                Tag = 0
                Width = 64
              end>
            ExplicitHeight = 238
            ColWidths = (
              160
              64
              64
              64
              64)
            RowHeights = (
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22)
          end
        end
        object AdvPanel4: TAdvPanel
          Left = 0
          Top = 0
          Width = 1272
          Height = 36
          Align = alTop
          Color = 16316664
          TabOrder = 1
          UseDockManager = True
          Version = '2.5.10.7'
          BorderColor = clBlack
          Caption.Color = clHighlight
          Caption.ColorTo = clNone
          Caption.Font.Charset = DEFAULT_CHARSET
          Caption.Font.Color = clWindowText
          Caption.Font.Height = -13
          Caption.Font.Name = 'Tahoma'
          Caption.Font.Style = []
          Caption.Indent = 0
          ColorTo = 13684944
          DoubleBuffered = True
          StatusBar.Font.Charset = DEFAULT_CHARSET
          StatusBar.Font.Color = clWindowText
          StatusBar.Font.Height = -11
          StatusBar.Font.Name = 'Tahoma'
          StatusBar.Font.Style = []
          Text = ''
          FullHeight = 36
          object btnGetPenetro: TSpeedButton
            AlignWithMargins = True
            Left = 16
            Top = 6
            Width = 80
            Height = 22
            Hint = 
              '<B>Indispensable</B>: r'#233'cup'#232'rer les donn'#233'es sur les p'#233'n'#233'trom'#232'tre' +
              's r'#233'alis'#233's pour le mandat en cours'
            Margins.Left = 16
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alLeft
            Caption = 'Actualiser'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = btnGetPenetroClick
            ExplicitLeft = -35
            ExplicitTop = 0
            ExplicitHeight = 34
          end
          object btnPastePenetro: TSpeedButton
            AlignWithMargins = True
            Left = 96
            Top = 6
            Width = 80
            Height = 22
            Hint = 
              'Colle le total des sondages dans les autres prestations de la fa' +
              'cture; Attention: la valeur est remplac'#233'e'
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alLeft
            Caption = 'Coller total'
            OnClick = btnPastePenetroClick
            ExplicitLeft = 48
            ExplicitTop = 0
            ExplicitHeight = 34
          end
          object SpeedButton2: TSpeedButton
            AlignWithMargins = True
            Left = 176
            Top = 6
            Width = 80
            Height = 22
            Hint = 
              'Colle le total des sondages dans les autres prestations de la fa' +
              'cture; Attention: la valeur est remplac'#233'e; Ajoute tous les d'#233'tai' +
              'ls des sondages dans les notes concernant les autres prestations'
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alLeft
            Caption = 'Coller tout'
            OnClick = btnCopyPenetroClick
            ExplicitLeft = 144
            ExplicitTop = 0
            ExplicitHeight = 34
          end
          object btnCopyPenetro: TSpeedButton
            AlignWithMargins = True
            Left = 256
            Top = 6
            Width = 80
            Height = 22
            Hint = 'Copie le tableau pour '#234'tre coll'#233' dans Excel par exemple'
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Action = actCopyGrid
            Align = alLeft
            ExplicitLeft = 344
            ExplicitTop = 2
          end
        end
      end
      object atsAllPrepared: TAdvTabSheet
        Caption = 'Liste des factures pr'#233'par'#233'es'
        Color = clWindow
        ColorTo = clNone
        TabColor = 15790320
        TabColorTo = clNone
        OnShow = atsAllPreparedShow
        object Splitter4: TSplitter
          Left = 713
          Top = 36
          Width = 8
          Height = 638
          AutoSnap = False
          MinSize = 256
          ResizeStyle = rsUpdate
          OnMoved = Splitter4Moved
          ExplicitLeft = 721
        end
        object grdAllPrepared: TXDBGrid
          AlignWithMargins = True
          Left = 8
          Top = 44
          Width = 705
          Height = 622
          Hint = 
            'Liste des factures pr'#233'par'#233'es; <B>Double clic</B> filtre sur la c' +
            'ellule s'#233'lectionn'#233'e; <b>double clic sur le nom du fichier</b> ch' +
            'arge la facture; <b>CTRL+DEL</b> supprime le lien et '#233'ventuellem' +
            'ent le fichier'
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 8
          Align = alLeft
          DataSource = dsrAllPrepared
          FillerButton = False
          FillerIndex = -1
          FixedStyle = fsMild
          FixedTheme = ftNone
          Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
          GridStyle.VisualStyle = vsXPStyle
          HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints, hoShowToolTips, hoShowDataHints, hoShowTotalToolTips]
          IndicatorWidth = 12
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgHotButtons, dgTitleButtons, dgTitleWidthOff, dgAllowInsertOff, dgMarkerAutoAlign, dgMarkerAutoSwitch, dgMarkerAutoToggle]
          OptionsEx = [dgBlankRow, dgTotalFooter, dgTotalHeaderBox, dgTotalValuesBox, dgTotalFieldsBox, dgAutoAscendOrder, dgAutoUpdateSequence, dgDelayUpdateSequence, dgAutoUpdateTotals, dgDelayUpdateTotals, dgCalcWholeDataSet, dgCalcSelectedRows, dgDelaySelectedRows, dgSelectedAutoHidden]
          ParentShowHint = False
          ReadOnly = True
          ResizeOptions = [roColumnResize, roOptimalWidth, roDefaultWidth]
          ShowHint = True
          TabOrder = 0
          WheelScrollRows = 1
          OnCellDblClick = grdFilterCellDblClick
          OnKeyDown = grdAllPreparedKeyDown
          OnPaintColumnCell = grdAllPreparedPaintColumnCell
          OnTitleClick = grdAllPreparedTitleClick
          Columns = <
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'Modified'
              ShowEdit = False
              Title.Alignment = taCenter
              Title.Caption = 'Modifi'#233
              Title.Marker = tmAscend
              Title.MarkerIndex = 0
              TotalFooter.CalcValue = cvMax
              TotalFooter.TotalResult = trCalcValue
              Visible = True
              Width = 80
            end
            item
              Expanded = False
              FieldName = 'FileName'
              ShowEdit = False
              Title.Caption = 'Facture pr'#233'par'#233'e'
              TotalFooter.CalcValue = cvCount
              TotalFooter.TotalResult = trCalcValue
              Visible = True
              Width = 152
            end
            item
              Expanded = False
              FieldName = 'M'
              ShowEdit = False
              Title.Caption = 'Mandat'
              Visible = True
              Width = 328
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'Responsable'
              ShowEdit = False
              Title.Alignment = taCenter
              Title.Caption = 'Resp.'
              Visible = True
              Width = 40
            end
            item
              Expanded = False
              FieldName = 'Etat'
              ReadOnly = False
              ShowEdit = False
              Visible = True
              Width = 80
            end>
          OrderFields = 'Modified'
        end
        object AdvPanel5: TAdvPanel
          Left = 0
          Top = 0
          Width = 1272
          Height = 36
          Align = alTop
          Color = 16316664
          TabOrder = 1
          UseDockManager = True
          Version = '2.5.10.7'
          BorderColor = clBlack
          Caption.Color = clHighlight
          Caption.ColorTo = clNone
          Caption.Font.Charset = DEFAULT_CHARSET
          Caption.Font.Color = clWindowText
          Caption.Font.Height = -13
          Caption.Font.Name = 'Tahoma'
          Caption.Font.Style = []
          Caption.Indent = 0
          ColorTo = 13684944
          DoubleBuffered = True
          StatusBar.Font.Charset = DEFAULT_CHARSET
          StatusBar.Font.Color = clWindowText
          StatusBar.Font.Height = -11
          StatusBar.Font.Name = 'Tahoma'
          StatusBar.Font.Style = []
          Text = ''
          FullHeight = 36
          object SpeedButton3: TSpeedButton
            AlignWithMargins = True
            Left = 8
            Top = 6
            Width = 80
            Height = 22
            Hint = 
              '<B>Filtre</B> n'#39'affiche que les lignes '#233'gales '#224' la cellules s'#233'le' +
              'ctionn'#233'es; <B>Tout voir</B> affiche tout selon l'#39#233'tat s'#233'lectionn' +
              #233
            Margins.Left = 8
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 8
            Action = actFilter
            Align = alLeft
            ExplicitLeft = -19
            ExplicitTop = 3
          end
          object btnPrintSummary: TSpeedButton
            AlignWithMargins = True
            Left = 1184
            Top = 6
            Width = 80
            Height = 22
            Hint = 'Imprime le r'#233'sum'#233
            Margins.Left = 8
            Margins.Top = 6
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alRight
            Caption = 'Imprimer'
            OnClick = btnPrintSummaryClick
            ExplicitLeft = 288
          end
          object edtFilterEtat: TAdvComboBox
            Tag = 99
            AlignWithMargins = True
            Left = 613
            Top = 4
            Width = 100
            Height = 24
            Hint = 'Filtre la liste des factures selon leur '#233'tat'
            Margins.Left = 525
            Margins.Top = 4
            Margins.Right = 12
            Margins.Bottom = 0
            Color = 16316664
            Version = '1.9.7.8'
            Visible = True
            Align = alLeft
            ButtonWidth = 17
            Style = csDropDownList
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = 4
            Items.Strings = (
              '-'
              'A facturer'
              'Facturation'
              'Termin'#233
              '<TOUT>')
            LabelPosition = lpLeftCenter
            LabelMargin = 12
            LabelTransparent = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            ParentColor = True
            TabOrder = 0
            TabStop = False
            Text = '<TOUT>'
            OnChange = edtFilterEtatChange
          end
        end
        object WebBrowser: TWebBrowser
          AlignWithMargins = True
          Left = 721
          Top = 44
          Width = 543
          Height = 622
          Hint = 'R'#233'sum'#233' de la facture'
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          TabStop = False
          Align = alClient
          TabOrder = 2
          ExplicitLeft = 840
          ExplicitTop = 280
          ExplicitWidth = 300
          ExplicitHeight = 150
          ControlData = {
            4C0000001F380000494000000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E12620B000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object atsHelp: TAdvTabSheet
        Hint = 'Description de la proc'#233'dure '#224' suivre pour cr'#233'er une facture'
        Caption = 'Aide-m'#233'moire'
        Color = clWindow
        ColorTo = clNone
        TabColor = 15790320
        TabColorTo = clNone
        OnShow = atsHelpShow
        object HTMLabel1: THTMLabel
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 1240
          Height = 642
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 16
          Align = alClient
          HTMLText.Strings = (
            
              '<FONT size="10"><B><U>Proc'#233'dure '#224' suivre dans le cas d'#8217'une factu' +
              're simple</U></B><BR><BR>1. Onglet <B>[Factures en suspens]</B><' +
              'BR><IND x="16">11. Clic sur le mandat '#224' facturer<BR><IND x="16">' +
              '12. Bouton <B>[Cr'#233'er une facture]</B><BR><BR>2. Onglet <B>[Donn'#233 +
              'es de facturation et documents]</B><BR><IND x="16">21. Eventuell' +
              'ement modifier l'#8217'<B>[Objet de la facture]</B> pour qu'#8217'il corresp' +
              'onde au nom utilis'#233' par le client<BR><IND x="16">22. Choisir le ' +
              '<B>[Type de facture]</B><BR><IND x="16">23. Choisir le <B>[Mode ' +
              'de facturation]</B><BR><IND x="40">a. Si <B>[selon offre]</B>, i' +
              'ns'#233'rer l'#8217'offre dans l'#8217'onglet <B>[Offres et documents]</B><BR><IN' +
              'D x="40">b. Si <B>[selon facture annex'#233'e]</B>, ins'#233'rer la factur' +
              'e dans <B>[Facture pr'#233'par'#233'e]</B> '#224' l'#8217'onglet <B>[Offres et docume' +
              'nts]</B><BR><IND x="16">24. Pr'#233'ciser l'#39'<B>[Adresse de facturatio' +
              'n]</B><BR><IND x="16">25. Si n'#233'cessaire, pr'#233'ciser<B> [Adresse d'#39 +
              'envoi de la facture]</B><BR><IND x="16">26. Faire la <B>[Descrip' +
              'tion des prestations]</B> sans trop de d'#233'tails<BR><IND x="16">27' +
              '. Ins'#233'rer l'#8217'offre dans <B>[Offre]</B> si elle existe<BR><IND x="' +
              '16">28. Ins'#233'rer l'#8217'adjudication dans <B>[Adjudication]</B> si ell' +
              'e existe<BR><IND x="16">29. Ins'#233'rer les documents produits dans ' +
              '<B>[Documents]</B><BR><BR>3. Onglet <B>[Pr'#233'paration de la factur' +
              'e et heures r'#233'alis'#233'es]</B><BR><IND x="16">31. Modifier si n'#233'cess' +
              'aire les quantit'#233's, rabais et frais<BR><IND x="16">32. Documente' +
              'r si n'#233'cessaire les autres prestations et les frais<BR><BR>4. <B' +
              '>Pied de page</B> pour <U>visa et facturation</U><BR><IND x="16"' +
              '>41. Choisir le responsable dans<B> [Vis'#233' par]</B><BR><IND x="16' +
              '">42. <B>[Sauver]</B><BR><IND x="16">43. Bouton <B>[Contr'#244'le]</B' +
              '> envoie la facture pour contr'#244'le et visa<BR><BR><IND x="16">Fin' +
              'alement, il faut marquer en vert la facture pour indiquer qu'#39'ell' +
              'e est en cours de v'#233'rification, puis '#224' la comptabilit'#233':<BR><IND ' +
              'x="16">44. Onglet <B>[Factures en suspens]</B> '#233'tat=<U>Facturati' +
              'on</U><BR><BR><IND x="16">Celui qui vise la facture, fait:<BR><I' +
              'ND x="16">45. Cocher <B>[Bon pour facturation]</B><BR><IND x="16' +
              '">46. <B>[Sauver]</B><BR><IND x="16">47. <B>[Envoi]</B> '#224' la com' +
              'ptabilit'#233'<BR><BR></FONT><FONT size="8">'#169' 2014-2015, J. Savary/Bu' +
              'reau d'#39'Etudes G'#233'ologiques SA</FONT>')
          Transparent = False
          OnClick = HTMLabel1Click
          Version = '2.2.2.1'
          ExplicitLeft = 280
          ExplicitTop = 200
          ExplicitWidth = 120
          ExplicitHeight = 17
        end
      end
    end
    object pnlVisa: TPanel
      Left = 0
      Top = 705
      Width = 1280
      Height = 28
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 8
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object edtBon: TCheckBox
        Tag = 99
        AlignWithMargins = True
        Left = 944
        Top = 3
        Width = 147
        Height = 22
        Hint = 'Visa d'#39'un patron avant d'#39'envoyer '#224' la comptabilit'#233
        Margins.Left = 0
        Margins.Right = 0
        TabStop = False
        Align = alRight
        Alignment = taLeftJustify
        Caption = 'Bon pour facturation'
        TabOrder = 3
        OnClick = edtBonClick
      end
      object edtResponsable: TAdvEdit
        Tag = 99
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 49
        Height = 22
        Hint = 'Responsable du mandat en cours de facturation'
        Margins.Left = 0
        Margins.Right = 0
        TabStop = False
        EditAlign = eaCenter
        EditorEnabled = False
        EmptyTextStyle = []
        ReturnIsTab = True
        Precision = 2
        LabelCaption = 'Responsable'
        LabelPosition = lpRightCenter
        LabelMargin = 12
        LabelTransparent = True
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
        Align = alLeft
        Color = clWindow
        ReadOnly = True
        TabOrder = 0
        Text = ''
        Visible = True
        Version = '3.5.5.0'
      end
      object edtVisa: TAdvComboBox
        Tag = 99
        AlignWithMargins = True
        Left = 1171
        Top = 2
        Width = 97
        Height = 24
        Hint = 'Visa d'#39'un patron avant d'#39'envoyer '#224' la comptabilit'#233
        Margins.Left = 80
        Margins.Top = 2
        Margins.Right = 12
        Margins.Bottom = 2
        Color = clBtnFace
        Version = '1.9.7.8'
        Visible = True
        Align = alRight
        ButtonWidth = 17
        Style = csDropDownList
        EmptyTextStyle = []
        DropWidth = 0
        Enabled = True
        ItemIndex = -1
        Items.Strings = (
          'Frank'
          'Jean'
          'R'#233'gis')
        LabelCaption = 'Visa'
        LabelPosition = lpLeftCenter
        LabelMargin = 12
        LabelTransparent = True
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        ParentColor = True
        TabOrder = 2
        TabStop = False
        OnChange = DatasChanged
      end
      object edtVisaDate: TAdvEdit
        Tag = 99
        AlignWithMargins = True
        Left = 816
        Top = 3
        Width = 80
        Height = 22
        Hint = 'Derni'#232're modification de la facture en cours'
        Margins.Left = 0
        Margins.Right = 48
        TabStop = False
        EditAlign = eaCenter
        EditorEnabled = False
        EmptyTextStyle = []
        ReturnIsTab = True
        Precision = 2
        LabelCaption = 'Date du visa'
        LabelPosition = lpLeftCenter
        LabelMargin = 12
        LabelTransparent = True
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
        Align = alRight
        Color = clWindow
        ReadOnly = True
        TabOrder = 1
        Text = ''
        Visible = True
        Version = '3.5.5.0'
      end
      object edtLast: TAdvEdit
        Tag = 99
        AlignWithMargins = True
        Left = 165
        Top = 3
        Width = 80
        Height = 22
        Hint = 'Derni'#232're modification de la facture en cours'
        Margins.Left = 116
        Margins.Right = 0
        TabStop = False
        EditAlign = eaCenter
        EditorEnabled = False
        EmptyTextStyle = []
        ReturnIsTab = True
        Precision = 2
        LabelCaption = 'Derni'#232're modification'
        LabelPosition = lpRightCenter
        LabelMargin = 12
        LabelTransparent = True
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
        Align = alLeft
        Color = clWindow
        ReadOnly = True
        TabOrder = 4
        Text = ''
        Visible = True
        Version = '3.5.5.0'
      end
    end
  end
  object adoDatas: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Documents\BEG\Ba' +
      'ses\BEGdatas.mdb;Mode=Share Deny None;Persist Security Info=Fals' +
      'e;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    AfterConnect = adoDatasAfterConnect
    BeforeConnect = adoDatasBeforeConnect
    Left = 264
    Top = 432
  end
  object tabSQL: TADOQuery
    Connection = adoDatas
    CursorType = ctStatic
    Parameters = <>
    Left = 336
    Top = 432
  end
  object tabDetails: TADOQuery
    Connection = adoDatas
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT Heures.Date, Collaborateurs.Initiales, LinkACC.Classe, Co' +
        'de, Heures.Heures, Heures.Km, Heures.Frais, Heures.Remarque, Heu' +
        'res.Factur'#233
      
        'FROM (Collaborateurs INNER JOIN (Activit'#233's INNER JOIN Heures ON ' +
        'Activit'#233's.IDactivit'#233' = Heures.IDactivit'#233') ON Collaborateurs.IDco' +
        'llaborateur = Heures.IDcollaborateur) INNER JOIN LinkACC ON (Act' +
        'ivit'#233's.IDactivit'#233' = LinkACC.IDactivit'#233') AND (Collaborateurs.IDco' +
        'llaborateur = LinkACC.IDcollaborateur)'
      
        'WHERE (((Heures.IDmandat)=5053) AND ((Heures.Date) Between #1/1/' +
        '2014# And #12/31/2014#))'
      'ORDER BY Date;')
    Left = 840
    Top = 128
    object tabDetailsDate: TDateTimeField
      FieldName = 'Date'
    end
    object tabDetailsInitiales: TWideStringField
      FieldName = 'Initiales'
      Size = 3
    end
    object tabDetailsCode: TWideStringField
      FieldName = 'Code'
      Size = 2
    end
    object tabDetailsClasse: TWideStringField
      FieldName = 'Classe'
      Size = 1
    end
    object tabDetailsHeures: TFloatField
      FieldName = 'Heures'
      DisplayFormat = '0.00'
    end
    object tabDetailsKm: TSmallintField
      FieldName = 'Km'
      DisplayFormat = '0.00'
    end
    object tabDetailsFrais: TFloatField
      FieldName = 'Frais'
      DisplayFormat = '0.00'
    end
    object tabDetailsRemarque: TWideMemoField
      FieldName = 'Remarque'
      BlobType = ftWideMemo
    end
    object tabDetailsFacturé: TBooleanField
      FieldName = 'Factur'#233
    end
  end
  object dsrDetails: TDataSource
    DataSet = tabDetails
    Left = 896
    Top = 128
  end
  object dlgSave: TSaveDialog
    DefaultExt = '.fab'
    Filter = 'Facture (FAB)|*.fab'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Sauvegarde de la facture'
    Left = 336
    Top = 608
  end
  object dlgOpen: TOpenDialog
    DefaultExt = '.fab'
    Filter = 'Facture (FAB)|*.fab'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Ouvrir une facture'
    Left = 408
    Top = 608
  end
  object tabFacture: TADOQuery
    Connection = adoDatas
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT Mandats.Responsable, [Mandat] & IIf([Sous-mandat] Is Null' +
        ',""," " & [Sous-mandat]) AS N, Mandats.D'#233'signation, Sum(Heures.H' +
        'eures) AS H, Min(Heures.Date) AS De, Max(Heures.Date) AS A, Mand' +
        'ats.IDmandat, Mandats.Etat, Mandats.Mandat'
      
        'FROM Mandats INNER JOIN Heures ON Mandats.IDmandat = Heures.IDma' +
        'ndat'
      'WHERE (((Heures.Factur'#233')=No))'
      
        'GROUP BY Mandats.Responsable, [Mandat] & IIf([Sous-mandat] Is Nu' +
        'll,""," " & [Sous-mandat]), Mandats.D'#233'signation, Mandats.IDmanda' +
        't, Mandats.Etat, Mandats.Mandat'
      'HAVING (((Mandats.Mandat)>999));')
    Left = 224
    Top = 304
    object tabFactureN: TWideStringField
      FieldName = 'N'
      Size = 12
    end
    object tabFactureDésignation: TWideStringField
      FieldName = 'D'#233'signation'
      Size = 255
    end
    object tabFactureH: TFloatField
      FieldName = 'H'
      DisplayFormat = '0.00'
    end
    object tabFactureDe: TDateTimeField
      FieldName = 'De'
    end
    object tabFactureA: TDateTimeField
      FieldName = 'A'
    end
    object tabFactureEtat: TWideStringField
      FieldName = 'Etat'
    end
    object tabFactureResponsable: TWideStringField
      FieldName = 'Responsable'
      Size = 10
    end
    object tabFactureIDmandat: TAutoIncField
      FieldName = 'IDmandat'
      ReadOnly = True
    end
    object tabFactureMandat: TSmallintField
      FieldName = 'Mandat'
    end
  end
  object tabResponsables: TADOQuery
    Connection = adoDatas
    CursorType = ctStatic
    AfterScroll = tabResponsablesAfterScroll
    Parameters = <>
    SQL.Strings = (
      'SELECT Mandats.Responsable'
      
        'FROM Mandats INNER JOIN Heures ON Mandats.IDmandat = Heures.IDma' +
        'ndat'
      'WHERE (((Mandats.Mandat)>999) AND ((Heures.Factur'#233')=No))'
      'GROUP BY Mandats.Responsable'
      'ORDER BY Mandats.Responsable;')
    Left = 136
    Top = 304
  end
  object dsrFacture: TDataSource
    DataSet = tabFacture
    Left = 224
    Top = 352
  end
  object dsrResponsables: TDataSource
    DataSet = tabResponsables
    Left = 136
    Top = 352
  end
  object aclMain: TActionList
    Left = 408
    Top = 544
    object actGetHours: TAction
      Caption = 'Mise '#224' jour'
      ImageIndex = 1
      OnExecute = actGetHoursExecute
      OnUpdate = actIsMandatOk
    end
    object actVerify: TAction
      Caption = 'V'#233'rifier'
      Hint = 
        'Mise '#224' jour des heures et des frais de la base sans rien modifie' +
        'r afin de v'#233'rifier un '#233'ventuel changement depuis l'#39#233'dition de la' +
        ' facture'
      OnExecute = actVerifyExecute
      OnUpdate = actIsMandatOk
    end
    object actOpenFolder: TAction
      Caption = 'Explorer'
      ImageIndex = 2
      OnExecute = actOpenFolderExecute
      OnUpdate = actOpenFolderUpdate
    end
    object actShowBill: TAction
      Caption = 'R'#233'sum'#233
      Hint = 'Affiche le r'#233'sum'#233' de la facture'
      OnExecute = actShowBillExecute
      OnUpdate = actShowBillUpdate
    end
    object actControl: TAction
      Caption = 'Contr'#244'le'
      Hint = 
        'Envoi d'#39'un message pour faire contr'#244'ler la facture (<u>le visa  ' +
        'doit '#234'tre d'#233'fini</u>)'
      OnExecute = actControlExecute
      OnUpdate = actControlUpdate
    end
    object actSend: TAction
      Caption = 'Envoi'
      ImageIndex = 3
      OnExecute = actSendExecute
      OnUpdate = actSendUpdate
    end
    object actOpen: TAction
      Caption = 'Ouvrir...'
      ImageIndex = 4
      OnExecute = actOpenClick
    end
    object actSave: TAction
      Caption = 'Sauver'
      ImageIndex = 5
      OnExecute = actSaveClick
      OnUpdate = actSaveUpdate
    end
    object actSaveAs: TAction
      Caption = 'Sauver sous...'
      ImageIndex = 6
      OnExecute = actSaveAsClick
      OnUpdate = actSaveAsUpdate
    end
    object actQuit: TAction
      Caption = 'Quitter'
      ImageIndex = 7
      OnExecute = actQuitClick
    end
    object actFilter: TAction
      Caption = 'Filtrer'
      Hint = 
        '<B>Filtre</B> n'#39'affiche que les lignes '#233'gales '#224' la cellules s'#233'le' +
        'ctionn'#233'es; <B>Tout voir</B> affiche tout'
      OnExecute = actFilterExecute
      OnUpdate = actFilterUpdate
    end
    object actCopyAddress: TAction
      Caption = #232
      OnExecute = actCopyAddressExecute
    end
    object actCopyGrid: TAction
      Caption = 'Copier'
      OnExecute = actCopyGridExecute
      OnUpdate = actCopyGridUpdate
    end
    object actClearHours: TAction
      Caption = 'Retirer les heures'
      ShortCut = 24699
      OnExecute = actClearHoursExecute
      OnUpdate = actClearHoursUpdate
    end
    object actFavorite: TAction
      Caption = 'Favori'
      Hint = 'Affiche les factures en suspens du responsable favori'
      OnExecute = actFavoriteExecute
      OnUpdate = actFavoriteUpdate
    end
    object actGetInterval: TAction
      Caption = 'P'#233'riode'
      Hint = 'Saisi l'#39'interval complet non factur'#233
      OnExecute = actGetIntervalExecute
      OnUpdate = actIsMandatOk
    end
  end
  object dlgDatas: TOpenDialog
    Filter = 
      'Base des heures du BEG|BEGdatas.mdb|Base des p'#233'n'#233'trom'#232'tres|peneB' +
      'EG.mdb'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Chemin de la base de donn'#233'es'
    Left = 264
    Top = 608
  end
  object OneInstance: TJvAppInstances
    OnCmdLineReceived = OneInstanceCmdLineReceived
    Left = 336
    Top = 544
  end
  object Mail: TJvMail
    BlindCopy = <>
    CarbonCopy = <>
    Recipient = <>
    Left = 616
    Top = 544
  end
  object adoPenetro: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Documents\BEG\P'#233 +
      'n'#233'trom'#232'tres\peneBEG.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    BeforeConnect = adoPenetroBeforeConnect
    Left = 264
    Top = 488
  end
  object sqlPenetro: TADOQuery
    Connection = adoPenetro
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT Max(Mesures.Profondeur) AS P'
      
        'FROM (Mandats INNER JOIN Sondages ON Mandats.IDmandat = Sondages' +
        '.IDmandat) INNER JOIN Mesures ON Sondages.IDsondage = Mesures.ID' +
        'sondage'
      'WHERE (((Mandats.Code)="4618"))'
      'GROUP BY Sondages.IDsondage;')
    Left = 336
    Top = 488
  end
  object tabNotes: TADOTable
    Connection = adoDatas
    CursorType = ctStatic
    AfterScroll = tabNotesAfterScroll
    IndexFieldNames = 'IDmandat'
    MasterFields = 'IDmandat'
    MasterSource = dsrFacture
    TableName = 'Mandats'
    Left = 1056
    Top = 272
  end
  object dsrNotes: TDataSource
    DataSet = tabNotes
    Left = 1112
    Top = 272
  end
  object dsrPrepared: TDataSource
    DataSet = tabPrepared
    Left = 1120
    Top = 592
  end
  object tabPrepared: TADOTable
    Connection = adoDatas
    CursorType = ctStatic
    IndexFieldNames = 'IDmandat'
    MasterFields = 'IDmandat'
    MasterSource = dsrFacture
    TableName = 'Factures pr'#233'par'#233'es'
    Left = 1056
    Top = 592
  end
  object tabTous: TADOQuery
    Connection = adoDatas
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT Mandats.IDmandat, Mandats.Mandat AS Num'#233'ro, [Mandat] & II' +
        'f(IsNull([Sous-mandat]),""," ") & [Sous-mandat] AS Code, [Mandat' +
        '] & IIf(IsNull([Sous-mandat]),""," ") & [Sous-mandat] & " " & [D' +
        #233'signation] AS Nom, Mandats.Responsable, Mandats.Facture'
      'FROM Mandats'
      'WHERE (((Mandats.Mandat)>1000))'
      
        'ORDER BY [Mandat] & IIf(IsNull([Sous-mandat]),""," ") & [Sous-ma' +
        'ndat] & " " & [D'#233'signation] DESC;')
    Left = 400
    Top = 128
  end
  object dsrTous: TDataSource
    DataSet = tabTous
    Left = 400
    Top = 176
  end
  object Splash: TAdvSmoothSplashScreen
    Version = '1.6.1.2'
    AutoAdaptPictureSize = False
    BasicProgramInfo.AutoLoad = False
    BasicProgramInfo.ProgramName.Font.Charset = DEFAULT_CHARSET
    BasicProgramInfo.ProgramName.Font.Color = clWindowText
    BasicProgramInfo.ProgramName.Font.Height = -19
    BasicProgramInfo.ProgramName.Font.Name = 'Tahoma'
    BasicProgramInfo.ProgramName.Font.Style = [fsBold]
    BasicProgramInfo.ProgramVersion.Font.Charset = DEFAULT_CHARSET
    BasicProgramInfo.ProgramVersion.Font.Color = clWindowText
    BasicProgramInfo.ProgramVersion.Font.Height = -19
    BasicProgramInfo.ProgramVersion.Font.Name = 'Tahoma'
    BasicProgramInfo.ProgramVersion.Font.Style = []
    BasicProgramInfo.ProgramVersion.PosX = 80
    BasicProgramInfo.CopyRightFont.Charset = DEFAULT_CHARSET
    BasicProgramInfo.CopyRightFont.Color = clWindowText
    BasicProgramInfo.CopyRightFont.Height = -11
    BasicProgramInfo.CopyRightFont.Name = 'Tahoma'
    BasicProgramInfo.CopyRightFont.Style = []
    CloseOnMainFormShow = False
    CloseOnTimeout = True
    Fill.Color = clNone
    Fill.ColorTo = clNone
    Fill.ColorMirror = clNone
    Fill.ColorMirrorTo = clNone
    Fill.GradientType = gtVertical
    Fill.GradientMirrorType = gtSolid
    Fill.BackGroundPicturePosition = ppBottomCenter
    Fill.BackGroundPictureAspectMode = pmNormal
    Fill.Opacity = 0
    Fill.OpacityTo = 0
    Fill.BorderColor = clNone
    Fill.BorderWidth = 2
    Fill.Rounding = 0
    Fill.ShadowColor = clNone
    Fill.ShadowOffset = 0
    Fill.Glow = gmNone
    TimeOut = 2000
    ProgressBar.BackGroundFill.ColorMirror = clNone
    ProgressBar.BackGroundFill.ColorMirrorTo = clNone
    ProgressBar.BackGroundFill.GradientType = gtVertical
    ProgressBar.BackGroundFill.GradientMirrorType = gtSolid
    ProgressBar.BackGroundFill.BorderColor = clNone
    ProgressBar.BackGroundFill.Rounding = 0
    ProgressBar.BackGroundFill.ShadowOffset = 0
    ProgressBar.BackGroundFill.Glow = gmNone
    ProgressBar.ProgressFill.ColorMirror = clNone
    ProgressBar.ProgressFill.ColorMirrorTo = clNone
    ProgressBar.ProgressFill.GradientType = gtVertical
    ProgressBar.ProgressFill.GradientMirrorType = gtSolid
    ProgressBar.ProgressFill.BorderColor = clNone
    ProgressBar.ProgressFill.Rounding = 0
    ProgressBar.ProgressFill.ShadowOffset = 0
    ProgressBar.ProgressFill.Glow = gmNone
    ProgressBar.Font.Charset = DEFAULT_CHARSET
    ProgressBar.Font.Color = clWindowText
    ProgressBar.Font.Height = -11
    ProgressBar.Font.Name = 'Tahoma'
    ProgressBar.Font.Style = []
    ProgressBar.ProgressFont.Charset = DEFAULT_CHARSET
    ProgressBar.ProgressFont.Color = clWindowText
    ProgressBar.ProgressFont.Height = -11
    ProgressBar.ProgressFont.Name = 'Tahoma'
    ProgressBar.ProgressFont.Style = []
    ProgressBar.ValueFormat = '%.0f%%'
    ProgressBar.Step = 10.000000000000000000
    ProgressBar.Maximum = 100.000000000000000000
    Items = <
      item
        Picture.Data = {
          89504E470D0A1A0A0000000D49484452000001E80000011508060000002B5C76
          CB00000A3769434350735247422049454336313936362D322E310000789C9D96
          775453D91687CFBD37BD5092108A94D06B685202480DBD48912E2A3109104AC0
          90002236445470445191A6083228E080A34391B1228A850151B1EB041944D471
          70141B964964AD19DFBC79EFCD9BDF1FF77E6B9FBDCFDD67EF7DD6BA0090FC83
          05C24C5809800CA15814E1E7C5888D8B676007010CF000036C00E070B3B34216
          F8460299027CD88C6C9913F817BDBA0E20F9FB2AD33F8CC100FF9F94B9592231
          0050988CE7F2F8D95C1917C9383D579C25B74FC998B6344DCE304ACE22598232
          569373F22C5B7CF699650F39F332843C19CB73CEE265F0E4DC27E38D3912BE8C
          91601917E708F8B932BE26638374498640C66FE4B1197C4E36002892DC2EE673
          53646C2D63922832822DE37900E048C95FF0D22F58CCCF13CB0FC5CECC5A2E12
          24A78819265C53868D93138BE1CFCF4DE78BC5CC300E378D23E231D89919591C
          E1720066CFFC5914796D19B2223BD8383938306D2D6DBE28D47F5DFC9B92F776
          965E847FEE19441FF8C3F6577E990D00B0A665B5D9FA876D6915005DEB0150BB
          FD87CD602F008AB2BE750E7D711EBA7C5E52C4E22C672BABDCDC5C4B019F6B29
          2FE8EFFA9F0E7F435F7CCF52BEDDEFE56178F39338927431435E376E667AA644
          C4C8CEE270F90CE69F87F81F07FE751E1611FC24BE882F944544CBA64C204C96
          B55BC813880599428640F89F9AF80FC3FEA4D9B99689DAF811D0965802A5211A
          407E1E00282A1120097B642BD0EF7D0BC64703F9CD8BD199989DFBCF82FE7D57
          B84CFEC816247F8E63474432B81251CEEC9AFC5A02342000454003EA401BE803
          13C004B6C011B8000FE0030241288804716031E0821490014420171480B5A018
          9482AD6027A80675A0113483367018748163E03438072E81CB6004DC0152300E
          9E8029F00ACC40108485C810155287742043C81CB28558901BE403054311501C
          940825434248021540EBA052A81CAA86EAA166E85BE828741ABA000D43B7A051
          6812FA157A07233009A6C15AB0116C05B3604F38088E8417C1C9F032381F2E82
          B7C09570037C10EE844FC397E011580A3F81A7118010113AA28B301116C24642
          917824091121AB9012A4026940DA901EA41FB98A4891A7C85B1406454531504C
          940BCA1F1585E2A296A156A136A3AA5107509DA83ED455D4286A0AF5114D466B
          A2CDD1CEE800742C3A199D8B2E4657A09BD01DE8B3E811F438FA150683A1638C
          318E187F4C1C2615B302B319B31BD38E398519C68C61A6B158AC3AD61CEB8A0D
          C572B0626C31B60A7B107B127B053B8E7D8323E27470B6385F5C3C4E882BC455
          E05A702770577013B819BC12DE10EF8C0FC5F3F0CBF165F8467C0F7E083F8E9F
          2128138C09AE8448422A612DA192D046384BB84B78412412F5884EC470A280B8
          8658493C443C4F1C25BE255148662436298124216D21ED279D22DD22BD2093C9
          46640F723C594CDE426E269F21DF27BF51A02A582A0428F014562BD428742A5C
          5178A688573454F4545CAC98AF58A178447148F1A9125EC94889ADC4515AA554
          A37454E986D2B43255D9463954394379B3728BF205E547142CC588E243E1518A
          28FB286728635484AA4F6553B9D475D446EA59EA380D4333A605D05269A5B46F
          6883B429158A8A9D4AB44A9E4A8DCA7115291DA11BD103E8E9F432FA61FA75FA
          3B552D554F55BEEA26D536D52BAAAFD5E6A879A8F1D54AD4DAD546D4DEA933D4
          7DD4D3D4B7A977A9DFD340699869846BE46AECD138ABF1740E6D8ECB1CEE9C92
          3987E7DCD68435CD3423345768EED31CD09CD6D2D6F2D3CAD2AAD23AA3F5549B
          AEEDA19DAABD43FB84F6A40E55C74D47A0B343E7A4CE63860AC39391CEA864F4
          31A6743575FD7525BAF5BA83BA337AC67A517A857AED7AF7F409FA2CFD24FD1D
          FABDFA53063A0621060506AD06B70DF1862CC314C35D86FD86AF8D8C8D628C36
          1875193D3256330E30CE376E35BE6B423671375966D26072CD1463CA324D33DD
          6D7AD90C36B3374B31AB311B3287CD1DCC05E6BBCD872DD0164E16428B068B1B
          4C12D39399C36C658E5AD22D832D0B2DBB2C9F591958C55B6DB3EAB7FA686D6F
          9D6EDD687DC7866213685368D363F3ABAD992DD7B6C6F6DA5CF25CDFB9ABE776
          CF7D6E676EC7B7DB6377D39E6A1F62BFC1BED7FE8383A383C8A1CD61D2D1C031
          D1B1D6F1068BC60A636D669D77423B7939AD763AE6F4D6D9C159EC7CD8F91717
          A64B9A4B8BCBA379C6F3F8F31AE78DB9EAB9725CEB5DA56E0CB744B7BD6E5277
          5D778E7B83FB030F7D0F9E4793C784A7A967AAE741CF675ED65E22AF0EAFD76C
          67F64AF6296FC4DBCFBBC47BD087E213E553ED73DF57CF37D9B7D577CACFDE6F
          85DF297FB47F90FF36FF1B015A01DC80E680A940C7C095817D41A4A00541D541
          0F82CD8245C13D21704860C8F690BBF30DE70BE7778582D080D0EDA1F7C28CC3
          96857D1F8E090F0BAF097F1861135110D1BF80BA60C9829605AF22BD22CB22EF
          44994449A27AA315A313A29BA35FC778C794C74863AD6257C65E8AD38813C475
          C763E3A3E39BE2A717FA2CDCB9703CC13EA138E1FA22E345798B2E2CD6589CBE
          F8F812C5259C254712D18931892D89EF39A19C06CEF4D280A5B54BA7B86CEE2E
          EE139E076F076F92EFCA2FE74F24B92695273D4A764DDE9E3C99E29E5291F254
          C016540B9EA7FAA7D6A5BE4E0B4DDB9FF6293D26BD3D0397919871544811A609
          FB32B533F33287B3CCB38AB3A4CB9C97ED5C36250A12356543D98BB2BBC534D9
          CFD480C444B25E329AE3965393F326373AF7489E729E306F60B9D9F24DCB27F2
          7DF3BF5E815AC15DD15BA05BB0B66074A5E7CAFA55D0AAA5AB7A57EBAF2E5A3D
          BEC66FCD81B584B5696B7F28B42E2C2F7CB92E665D4F9156D19AA2B1F57EEB5B
          8B158A45C53736B86CA8DB88DA28D838B869EEA6AA4D1F4B7825174BAD4B2B4A
          DF6FE66EBEF895CD57955F7DDA92B465B0CCA16CCF56CC56E1D6EBDBDCB71D28
          572ECF2F1FDB1EB2BD73076347C98E973B97ECBC50615751B78BB04BB24B5A19
          5CD95D6550B5B5EA7D754AF5488D574D7BAD66EDA6DAD7BB79BBAFECF1D8D356
          A755575AF76EAF60EFCD7ABFFACE06A3868A7D987D39FB1E364637F67FCDFABA
          B949A3A9B4E9C37EE17EE98188037DCD8ECDCD2D9A2D65AD70ABA475F260C2C1
          CBDF787FD3DDC66CAB6FA7B7971E028724871E7F9BF8EDF5C341877B8FB08EB4
          7D67F85D6D07B5A3A413EA5CDE39D595D225ED8EEB1E3E1A78B4B7C7A5A7E37B
          CBEFF71FD33D56735CE578D909C289A2139F4EE69F9C3E9575EAE9E9E4D363BD
          4B7AEF9C893D73AD2FBC6FF06CD0D9F3E77CCF9DE9F7EC3F79DEF5FCB10BCE17
          8E5E645DECBAE470A973C07EA0E307FB1F3A061D063B871C87BA2F3B5DEE199E
          377CE28AFB95D357BDAF9EBB1670EDD2C8FC91E1EB51D76FDE48B821BDC9BBF9
          E856FAADE7B7736ECFDC5973177DB7E49ED2BD8AFB9AF71B7E34FDB15DEA203D
          3EEA3D3AF060C1833B63DCB1273F65FFF47EBCE821F961C584CE44F323DB47C7
          267D272F3F5EF878FC49D69399A7C53F2BFF5CFBCCE4D977BF78FC3230153B35
          FE5CF4FCD3AF9B5FA8BFD8FFD2EE65EF74D8F4FD5719AF665E97BC517F73E02D
          EB6DFFBB98771333B9EFB1EF2B3F987EE8F918F4F1EEA78C4F9F7E03F784F3FB
          8F70662A000000097048597300002E2300002E230178A53F7600002000494441
          54789CED9D05BC15D5F6C7F798D8FFA7D2DDDD65CBB3A54B40A41BA451C0469F
          4D79E96E10E956B1B0E96E415AC17A8AF14CEE7FFD983D30F7DC393DE7AC39E7
          ACEFFDACCFCC9D3367F63A337BF6DAB1F6DA17A5A7A72B41100421B1796CCDDE
          8B6993D5308CEB697BBD61A8FFA3EDD55AAEA4FF2FA3ED25CA302EA1ED05F4FF
          45B4A58DFA8BB67FD3DEDFD8D281BFE9D8AFB4FF0B1DFB055B3AF6336DBF5786
          FA8EB6DF3D53ADC86F1CBF31D5B8885B014110042138FDDFDB93850C6721DA2D
          4686B2086DF393312E40DBBC743C271D8361BE201EBA3CB7FE200CF4B764B88F
          D1F628A57D9CB6C70C657C49DBFDF4FFE1272B17FA3B1EBA243362A00541103C
          C6A3EFECCE479B4A64002BD0B62CB564CBD0B630C985BC9A9DE37292FC5A9CF8
          EBF94D5F1E24FDF7D3FE76AA486CA3ED5692838F572C28DDB62122065A100481
          917E6FEFBA980C5965DABD4D29E346DADE40FFE7E0D62B4AD0DD5E424B5DDBF1
          9F5FDA7A68336D3F27A3FD396D3F1B58BEC0771C0A2602171955260CA16D69EB
          000624CC1D6B63381F3F7720E3F7ECC7331DCBB839778211E0F8F9CB05D6C3E7
          3447FDCE7F37E377FC1DCF9486ED92998E19EA8CC2F88D32C771E8FFDF953976
          83AEA0DFE838C6707EA4E33FD0F6073AFE3D6D4F1C79A3E90F4A108494A2EF5B
          3BCB52997037950777D3BFB7905CC9AD539CB88AE4762D20FDE5ED870FD0F603
          2A4ADFA3ED7B03CA15F89E4D3B8F811674756566108181FCCDE6C1907F6560FC
          C6508768FF10597D64D803746CEF97731E38CDACA2200851D267D5CE8BC818C3
          28D5A5F71C2DCA02CC2A790534718A6AE94472E6951D47D0C25E45F76971FF32
          F9B7B26AC78C7471F39345998E1F90DB7D3E4B2FD47CFE11CAA8DB697F2719EE
          4DB4DD787056E3A3F156521084F0E8BD72071CB66A1886D18CB6F549B232AB94
          08E09E55D1F2F4AB3B8F1C260BBE84F61751F9F7C9A3A5F3A5D4F8B518686F83
          DA65012DE7C6718AB45C7092366B493E24F9880CF8B62F6634FE874341411032
          D26BE58EE2B469472F6F73DAE6E1D627C12940D25BCB91C1BB8ECEA6F26ECE23
          A5F2EDE2552B3E88814E4CE040525F0BF8B168AB05ABA9A6BE92F6DFDC3FBDD1
          B77CAA0942EAD173F9F64BE9FD6B4ABB9DA95A7D13B73E490A3CC61F870CDD73
          740B6D2790CCEE5732DFCFBC6AC50E31D0C901021234D172A6589B856BA9F63E
          9FF6E7ED9BD6E82B5ED5042179E9B96C7B0E32C8DD69B72349366E7D52888A24
          63495E25634DAD6A636CDF1279B7732BE53662A0930F8CE1DCA4656889B68B3E
          A6ED0C2A44E6ED9DD2F0175ED5C2A77ABF556D6953CAC7293FA317BDCF8C83F3
          DEF7818F3B7AF38730B3C0AF1EF634F097E998F3B54299A9E07766819FE3BE69
          3A1DCF74CC8F1EC1673904B8F77E667B049A4911E4DEFF411F3C33A57915D621
          9D1ECBB61721751EA5DD56CAF42311788057781792CEC3F61E7B87F2C650DA7F
          A76FF1BC4931562D063AB981B1B6A634A49568B7681E152A63F74C69B89159AF
          7040377EDDA06709A9C2284EE3DC7DE9B69254E9789276D19DED95A02182599F
          BB47CBF6E1FB8EBD4ADBB97D8AE74D68DF1C31D0A903E659B683946CB7E8236A
          8E0CA7FD657B263738C3AC972084CAFF485EE248B8FB926D9865F10C99818794
          1866AF538E6416C913AFED3F3E88B60B7A17CB9390E59C18E8D4E4362DFB4A75
          58FC3C6D5FDF3DA94142D734859460FC9487AAC4D5A7E2E125DBAEA5CD13D43C
          7B98B697C6336D216A4A92BC41B2E3B52F8E0FE85D34CF9BDC0A858B18E8D406
          D34166923C59BAE3E267683B6FD7C40649317623241D585DE9E57825D66DF156
          B492BB1A86F11C6DFF15AF7485985096641519E9B70D43F5EB55244FC24CD112
          032D0018EAB924BD4B775CD277D7C4FA9F732B24083E8CA1D6F3A97824D46DD1
          D61B95A1C6D06E8578A427C48D7B49EE4C3B707C8252C613BD8AE4FE915BA160
          888116ECDC40F22919690403E8B77342FD6FB8151204857589951A1CEB44BA2E
          DC7A0DE5FB1795E9151C97651B85B8039BD78DA461DA81137DC848CFE5562810
          62A0055FE00DD982A466994E4B06D07F93778EAF2FDDDE022723A7B6A812D3E0
          3B649CD1BA9AA424F257AA80604FAF8F3878A20555CA1EEE5128F7116E859C10
          032DF803CE3113491A96EDBCB4DD8EF1F54E722B24A424582C6648AC2E4E86F9
          0ADA0C5366A01123C8E942F2518BE4D6915F9EE845467A1AB732BE8881168271
          3FC97632D2EDC9482FE756464839D2A8F51C932559BB2CD852D5308CD9CA5C49
          49485DAE26993AF2D057B569DBA547C15C9E599F5A0CB4100A58856769B92E4B
          5FA1ED93DBC7D5932959423C8013CF30B72FDA79FE160438EB47BB186FBED8ED
          EB0B094B23929B461DFAEAA1EE05737DC0AD0C10032D840ABAFF0692542DD775
          69B3ED63EB79A69629242DC3A6B6ACEAAAA72D1967C4AD9FAE243A9DE04C4E92
          77C8480F82C3E0C30572B1063811032D84CB9D249F9391BE9F8CF4016E6584A4
          05DDDA696E5E908C7369DA2C56D2A52D040673E0FF4372CBE8C35F3527231D93
          21965010032D44421192CFCA775B5677DB98BA6BB99511929221D47A3EEDD6C5
          C838D75366509EABDCBAA690F4C0B37FEDE8235FD77D387FCEBD1C0A88811622
          05E3D2EF9091AE4546FA236E6584A40253AA46BA75B14EF336F7370C0331BC65
          6EB3102EE86DF99C8C745332D2ABE39DB81868211AB000C7AA0ADD96D5DE3AA6
          EE1A6E6584A461F0B49655A35E1AB5E31B9B2F34CC88609D5CD049485DE0B7B0
          72CC91AF3B74CB9F737A3C1316032D440BE691AE20237D2719E975DCCA08090F
          C2798E89F6221DE76EBE4C1967174AA813BD4A09C55F2427488E921C2741FC82
          FF2AD3231E63A93FE973FED4827D38805EA4055EED78A7AFD4DB6B94198BFC7A
          65F69AC1892A97DEA692073CEECD5432D2D793911E1ACF4405215AF022AFACF0
          F0B25BB68EAECB325623240D2F53EBF9D7682E40C619F35A3167FF367754F224
          7F906C25D941B28764B7DE1E7BF1F6E231F73C7E6EFD410C17C05017D282AEE0
          3224A5F4FFC9389C808ACC903147BFBEAE5BBE9C8FC7234131D0825B5C47F226
          19E96A64A4631A9651485AB094E4F8682ED061EEA6EB0C65BC4DBB95DD51C933
          7C4FF21EC9C724EB49B6BD7247C93FB89479BA5A6154028E6BC9E083F2FCC62F
          D1FAAE445285A4BA322B4A39E2AD630C798C8CF40564A407C63A2131D0829B14
          20995BB1FBF27BB78CAAF337B73242C2F1D2F45655FF17E997C938A30BF65D92
          72EEA9C406E2DF6F205946F20EC9A657EF2C991001829EAC5208FE031F69512F
          6CFE122D4FAC9857439991093155F30A2EFD5C62C0D863278DAE79730C886522
          62A005B7B983041EB38F722B222414C79419FB3D223ABCBE299B32D4FBB45BDA
          3D95E20E8C32A62D2E800CBEBBD451667D5CE1894A85F0BBF66A19F7D2D64397
          2AD358372469A0CCB1ED44A43F19E9D364A45F8855029C067A0EC99B8CE9BB01
          C6592EB26DB3905C4E7299329D2C3016867997E8FEC5E21370B4C8AE92DFB9A2
          1FB5A257532BFA1D6E458484E185E9ADAB45D4654BC6194E4C980293A8C61943
          42F00E9E34E49E52FBB89589358F552888E78C6188B75FDE76184B3FDE45D286
          0473D52F63542D129E1F77FCE4375DF2E488B87219084E03BDF9B70FDBCE624C
          9F857C4DDE40770F6A8CB949F22BB35BB8304909653A58E46253CE3DF01BA756
          ECB1BCDC969175D8A2F00809C36192A9917CB1FD9C4D5719867A8B76CBBBAA51
          7CD84C028FE00543EE29FD27B7321C0C2C5F00DDF6678DF52BDB0F633A532B92
          87498AB12A161E63C9489F2223BDCCED0B4B17779C393AAF29BA7BBED1B2C5F7
          F3820FCE432BBB92961B496E5266CB3BD14005E43565BE70821088E7A9F51CB6
          8122E38CAED24524D5DC5729A6A0E770C8D0FB4ABFCFAD88971850AE00A6828D
          7865C79151B4BD0F87546278E22334E86C32D2379191DEE1E685C5407B8C43AF
          37C12214ABB5A842CDE7A3358AE90B772B33D3D65089D345DE825AD153A815BD
          865B11C1B31C249911EE97DACDD97881A10C7CEF2EF7558A191F923C36ECBE32
          9F732BE2650694CD0F0FF1559057771EB999B6CF2AD3B1CCCB604873D9F813A7
          AA75CE9DDDB5592C62A03DCE97731E408B7B879661855B2CC0781B822FB454A6
          439697E71BA27231BA528FE5E5378F8CD8AB1B5EBD514795123CCBB333DA54FB
          2B82EFBD4AD2C46D656204DEDDFEC3EF2FF316B7228946FF32F93FA5CD5D8377
          1EB987B62F9354645629100548DE20237D371969573CEEC54027180767354654
          20B41C661469B90001017A90B453A6439A17C1B87A5B15A187EEBAA1359BB9AB
          8E90E850EB196394FDB8F508012CF681D6DF88E135CBC8B4C32878B44CFED583
          771DC5143A846D7D5E998EB75EE4DF244F933CE3C6C5C4402730076636FE9236
          7D8AB65AF01C6DFB92F452DE5CADE7696A45CFA25674C4735C0501B49BBDF16E
          659CF56DF03AF3487ABF56ABECD7DC8A240B8F96CE87AEEF7143761F9D4FDB21
          CAF4FCF6224F4CF8EAD49A4EB9B27F10ED85C44027015FCC38DBAA7EAA58EB85
          88618CAEBF16CC2AF9924799355F57D7F715520B32CE082789F8DA5E2EB7E043
          D22DAD56D9F9DC8A242B8F94CA87A86A6D87EE398A4AD00465962F5E024E6333
          C948972123FD633417F2724617C264FFF446A8ADB72CD666210A3174297B29BC
          5EEFCA3D578CDA34A27642444312BC45DB591BAF300CB550990B377895A5249D
          C9389FE2562415E85732DF9B64A42BD0EE6465CEA1F612D62C9636D15C440C74
          12B27F5AA315C5DB2C8433C5EBCAF4FAF60205941939485A164224A0A554965B
          093FC0C90D719987A7D52E9BCEAD4C2A4146FA7B32D28846D65B99BD875EB269
          ADA915BD905AD1CB23BD80977E8CE022FBA6353A49461A9E8F6849B7E6D647D3
          55898116C2845ACF181E69CEAD871FB0C047B31175CA7DCCAD48AA42461A95A2
          E1C3F61EC3EA5EE8F6F652DC88D164A4DF27231DD10A6D62A0931832D27F9568
          BB081ED41807E9C5AD0F51A372AF150537A5D53EC4AD889018B49DB9A18C320C
          AF3A8561FDF3FA649C4F722B2228D5B744DE0F86ED3B86E04E98CE56985B1F4D
          5E922748225A9E520C7492B3776AC37432D27D941927BC33B33A98178DC862CF
          32EB212400649C9167314CE3C5F8CC180F6F39A26E399999E021FA16CF7B808C
          34829B205A9B57E64CF79DF8F537D33AE6CCB63FDC2F8A814E01CE1AE9768BBA
          2B33F6F77DCCEA345662A085D078519951F4BCC6609281649CCF702B2264868C
          F4A9E1FB8E21C21C16EBA9C4AD0F8190B408B2D230DC2F8A814E11F64E69F837
          19E98768772349414655CA54EEB5A2F0A6B4DA071975103C4E9B991B6A18DE18
          96F1E5F19175CBBDC4AD8410983EC5F3FE40461AE19111EFDC0B0BA9D4A75674
          756A45AF0BE74B62A0530832D23F946CB7080E636B146F8850842AF5EAB8A2C0
          0C19E72B943975C64B616CE188D47754BDF2926F130418E9D7F61FAF49BB887D
          9E8F591D0CEFA14728AC98E262A0538C3D531A7E4C467A1CED7663540399540A
          3AC11F2F9014E256C2068CF3C3A3EA971FCBAD88101EBD8BE5F98A8CF4FDCA34
          D2DCE190EF9878F29B5B3BE6C816B2C7BF18E8D4E42912C4B8BE9629FD5BAAF4
          5A71C1C6B4DA32862764A0F58C0D550D4375E7D6C38701629C131732D2BB5FFB
          E2387A0EB134A9C1AC0E96D014032DF8670FBABADB2FC642F12F30A98085D911
          74621B53FA8207693D7DFD45CA30C62B3354A257786174FDF283B99510A2A377
          D13C4BC848E339F66756A526B5A2CB522B3AA475A3C540A72E58141DB539AE6E
          9FCA4A0CB490912ECA3B5363C07832CE4F722B21B8067A0EE1DDCDE9D98D163C
          A6BDB60BE56431D029CA9EC90D4E532B7ABA3297ABE4C00B9E958247A0D633A2
          3F7969FA1DA6E878ADAB5D88026A45FF9976E0381612DAA2CCA94F5C349D74EA
          9B7E1DB267FB6FB013C540A736F09415032D7881418ACF27C2973D244DC634A8
          206B382719BD8AE4D94346FA1565AED9CCC5E5CA0CD81474753F31D0290CB5A2
          B795EAB01885514986E48B30A429789056D3D617378CB3CB917A0184C5AD43C6
          39AA6502054F8379EC8809C1190E34A4E577C5400B2B148F81CE59A5D78A4B37
          A6D5FE83216DC15B20CAD2C5DC4A28733A55BB310D2B48109D24865AD1BFA71D
          3881F8D87319D52835E9D437153A64CFB635D04962A0058CB53DCA902E825020
          F468D8F16985E4815ACFD59477D6F24D23E3BC985B09212E60D52B7874733A8C
          61853631D04240D692FCA378A6B6E45462A0539DFF28FEB9A960833267350829
          40AF22B9D3A915FDBC32E74673D174F2A96F07B4CF9ED5EF1AE262A0539CDD93
          1AFC5CAAC3E2BDB45B9A21F9EB18D2143C42CB69EB6F21CB7C0FB71EC4EF24AD
          C636AAF027B722425C594AB28FA43853FA083F8A69859BFD9D20065A00BB9418
          6821FE78658EF1D3649CF7722B21C4176A459F1971F0C44865C684E0A2B61203
          2D04E10BA674B963E30A4C50EBB92A6DEEE5D64399433CC3B89510D8984DF2AA
          32A73E71508BE4397F1F8A8116C051A6742F614A57E087C331D117CC73EE48AD
          E77FB8151178E85938F78F23BF3CB190765B32A95065F2A96FAF6D9F3DEB0F4E
          1F8A8116C049A67439A3F9084CB49CBAAE90328CB017AF8F01A3C838EFE45642
          6067BEE233D098CD72AB32C7C33321065A004143CEC508C97FA9494FC5BF20C6
          2965462F1384D524A715DF90DBED4A0CB410805F98D295E526530C6A3D5F499B
          36DC7A108F8D6B5CF1276E25047E7A14CAFDC7C82F4FBC4BBB5CBD3AB7F9FB40
          0CB400B8A697FCC594AEC007BA12AF61D66137C90C661D046F81804D5C06BAEC
          E46FBEBDB47DB6AC99A22A8A811680DF89F231E657A674053E3A732B403C4DAD
          67710C13ECBCCF98369C65CB906CF2FD400CB400B8E2209F664A5760A0C59475
          550D837D153314829CD1A3046F82A9A6F0A4E65A51ADB212032DF881CB9BFA7B
          A674051EDA732B400C1AFF4045AE1E23C1A3F428943B7DE4A1AFD6D3EE7D714A
          12FE370748362AD3307FE87492186801708D097EC394AE1067A8F59C85364D98
          D540C4BC95CC3A08DE659B8A8D814685102D74CB1863BBA543F66C3F07FBA218
          6801FC8B29DDE34CE90AF107210DB9F299C510693D0B017023DCAB658C11BE73
          8BD246B963CE6C11CD1810032D809C0C69228AD3098674051E9A33A78FBC3687
          5907C1DBEC0BF37C18E3432A63CB7873E7DCD97F744B2131D002C8C390E6A18D
          69B5FF66485788332DA6AC430088FB99D5184BAD6759AD4A0844A090C7BEC618
          2DE4CD5DF3E6700CD1E91662A005509421CD3D0C690A3CD425C9C2983E2A8253
          19D3171203843C465E815D3CAC4C236CB58C3775CB9F33EE4EAD62A005509221
          CD6D0C690A3C34604E7F05B59EBF62D641F0383D0AE6FA67E4A1AFEEA2DD9DDD
          0BE6F2C40C1331D0294EA90E8BD1FD588421E94C73FE84E4A3C594759729FE65
          252732A72F240864A41DA73B7121065AC0BABC1730A4FB39439A42FCB993E40A
          C6F4D1727E9B317D41881831D0C2BF19D2DCBB31ADB6CC814E0D6A32A73F7F42
          934A12D6534848C4400BF730A4F92E439A020FDCDEDB6F30A72F081123063A85
          29D97E717EC3505518925EC590A610671E9ABCB6B861180518553842B296317D
          41880A31D0A94D331223CE6962810CCE956384F8712773FAE8DE96C86142C222
          063A45A1D6330C730786A4976E4AAB9D69DD532129B983397D89BB2D243462A0
          5317C446E6985E359B214D21CE3C34792D2A80B733AA80D8C79F32A62F085123
          063A757982214D8C09BEC390AE107F10FCE67AC6F4574F6C5AE92FC6F405216A
          C440A72025DB2D6AA20CA33A43D2E337A5D53EC390AE107F6E614E5F1C118584
          470C748A41C6F92ADA0C6648FA3792090CE90A3CDCC89CFE07CCE90B42D48881
          4E3D609CF331A43B61D388DA9E886F2BC4856A8C691F99D8ACD211C6F405C115
          C440A71025DA2D6A6A28D59921E9FF910C61485760A0F9A4B5D718862AC1A882
          A7E2290B42A488814E11C838A345339929F9919B47D639C194B6107F2A289EF8
          EE161F31A62D08AE21063A0528D176511965A8158A67D18253242F31A42BF051
          91397D995E25240562A0931C32CE9569F396E29BF232905ACF3F32A52DF05081
          31ED9F49F633A62F08AE21063A8929DE666163C330A629BEE5FEDE2399CE94B6
          C04759C6B4B74C6C5649A6F209498118E824A4589B85971BA6B776374635D092
          E9B865641D89859C42349FB41663CF9C0E629B18D316045711039D64146BBDF0
          6E65A8B1B45B9859955E649C0F31EB20C49F82249733A6BF99316D41701531D0
          4942D1560B4A1B86F1B232636C733363CBA83A53B995105828CE9CFE4EE6F405
          C135C4402738455A2EB8C930545FDA6DA078A7B658A005D3955B09818DA28C69
          63EC591CC484A4410C74024246F93ADA3C48D296A412B33A76BE26A94FADE7DF
          B81511D8E034D0472635AB2C794F481AC4402708851F9A9F5719C6FDB4DB805A
          CC5867F7126E9D7CF885A4F6D6D1758F712B22B0528831EDBD8C690B82EB8881
          F620059BCFC75ABA050C73C1819BC920D7A06D295EAD02F23B493D32CEE2A023
          14604C7B1F63DA82E03A62A019C9DFF48D0BA8559C87760B91312E4686186BE8
          96A16388C4741DB37AA102E3DC70EB98BAEF732B22F0D27CE25A43192A3FA30A
          326B40482A380D74DECB6F9F5A053B86611E30AC4FF4016C8CF307ED1F9D3BD9
          B0CE55CEC7ED973CFFDD8CDFF1773C531AB64BFA1C43C174216D2FA09D8B697B
          19FD9F85B659E8F3AB697B351DFF9742342FE36C44AF1C741C863927C9C599EE
          4CE280F1BE06649C57732B2278826B15EF14ABA38C690B82EB701AE85E5A84C4
          E43B923ADBC6D45DCBAD88E0197233A72F065A482AA48B5B88842F486A9371F6
          E494969B07BE859E9997CEF7CC64ECA209D893E2D35BE2D4AB632753EF8A2DCD
          CCC79CAF154A2F91DF5E1DE7E31F2EE97DEBF32AFEE46248D38EAC012D241562
          A085707997A4D9F6B1F5BEE756240018BFBF8B5B09467E604A372753BAE0B749
          CD2A7B394F0A42D8888116420531B55F2579828CF33FDCCA089E242B63DAA718
          D316849820065A08856F485A6F1F57EF2D6E45044F938D31ED6F19D316849820
          065A08C60A920E3BC6D793168A100CCEA98162A085A4430CB4E00F8CE7F5DD39
          BEFE0C6E458484E16AC6B4C5400B49871868C1172C383085E4F19D13EA4BA127
          8403A781FE8E316D41880962A0053B9F93F4DC35B1FE466E45848484D3409F66
          4C5B1062821868011C247986640E19E7746E65848485D340FFCC98B620C40431
          D0A90D569E42408BA9BB2636F88B5B1921E1E134D0BF30A62D0831410C74EAF2
          3F928924EB49FE66D645480EC4400B828B88814E5D2E23794ECBA9D21D17AFA4
          ED72A58CD5BB26D69745EF8548B894316D31D042D221065A00D949DA69F9B974
          C7254B0D43CDA1FDD53B27D497A86142A8709627BF33A62D0831410CB4E0CB55
          242DB49C28D379C974431913778CAF7798572DC1CB349FB816658911F4C4D821
          C33442D221065A0804960F7C9C6440D9CE4B9753AB3A6DFBB87A6B987512BC09
          77592206DA45067DFEC505B4B920D32A6E3E2BC4F93BEEBB729C615B062ED3B1
          60ABBD391CF7B7AA9CEFB5321D7758392EE0EA760EC733AD2867D3C5E958203D
          82DCAF33DC2F9590185C48521F52AECBD2CF2833FD67FB5889CB2D64E062E6F4
          C540BBCB63CA9CE121F0D1450CB4102E3791BC59AEEBD24FA8963770DB98BA9F
          722B247802EEB2440CB4907470BF5442E2720BC927E5BB2D9B6B28F5E8D63175
          8F732B24B0722173FA6798D31704D711032D444B3392DA15BA2D7B4A196AC4D6
          D175A5A04C4DB85BB05296094987646AC10DAE24194ED2A4C2C3CBDA9091DECF
          AD901077B823D1495926241D92A90537B9916473C5EECB7B6D19556732B73242
          5C11032D082E23995A709B2B48269191BE4519AAEB9691752480446A205DDC82
          E03292A98558D186A454C51ECBEB91913EC9AD8C105BE674BCE14CF3896B1175
          8ECB594CCA3221E9904C2DC4926A246B2BF5585E6BF3C83ABBB89511620E5AD1
          5C06FA0AA674052166888116624D7E928FC848DF4B467A23B732424CF955F12D
          98712553BA821033380DF47F497E624CDF6D2EB0095A1128A82ED15BEE39A2DC
          5C4BF26EE59E2BEEDD34A2F6BA38A4F703C99A38A4E3557633A57B5A99CF9A83
          AB98D2158498C169A05FF8EDC3B64319D38F1B791F980B437DA516AC997B0DC9
          7524D7EB6D36921C24B99419FF1AADCE2C2CCAC60EFCE655957BADA8B129ADF6
          8E5826F4E9CBF76DA0CDBF639986E0C869C6B4A5052D241DD2C51D078ECD6FF6
          A7325B753F84727EC1E6F311291D4B401626294E5294A4144939651A6FCE5583
          A201ADABB7C948DF4846FA08B73282EB701A6869410B498718680F7268CE03E9
          B439A92543ACEBC22D16FC8B36959439E71872B3325BA789424E92E5557AADB8
          65635A6DCE025D701FCEE7F92FC6B405212688814E300ECE6A8CB1FBF7B4A822
          2D17E019C25BFA6E92DA249595F75BD86549A693916E48463A9D5B19C135387D
          4AB231A62D0831410C7482736066634C6DF94CCBB3C55A2FCC4BDB2624AD94D9
          25EE55B07CE5A324AF722B22B806A781CECA98B620C40431D049C6FEE98D8ED1
          06CE77438BB75988AEF01E240F2ABEE92F8178A16AEF956B36BC566B3DB72282
          2B7CC398B6186821E910039DC4EC9BD668336DDA9668BB088BAF0F20E94C7219
          AF561940FE9B4546BA2219E95FB99511A2E65BC6B4A58B5B483AC440A7007BA7
          3684B3599F12ED160D5366977253E59D716A78A83F4FD2875B11216A4E31A67D
          5D87B99B2E9DD4ACF21F8C3A0882AB88814E21F64E6988EEEF074BB65B8495A6
          20F99855B2E851B5CFCA37360CAFB5965B11212ABE624C1B0182E07F71805107
          41701531D029C89E290DDF2DD97E311CC8A69034E4D6479991D6469391AE4646
          FA1F6E65848839C19C3E2A9C62A085A4410C748AB26772839FC84837A6DD4124
          4F33AB03E0D0D681643CB72242C4A0057D4699AD590EF233A52B0831410C740A
          43461A73909F29D56131BC6F472AFE71E967ABF55D397BFDB05ABF30EB2144C0
          9C8E37FCD97CD25AF83BE46252410CB49054888116D4EE490D4697EEB818AD9E
          11CCAA20BC299CC5FEC3AC87103987149F812ECA94AE20C40431D0C259764D6C
          30928C34A6AA3CC9AC4A1F6A45A7512B5AC28026268795197E9683924CE90A42
          4C10032DD8C1583416E5E0741C434CE56E242F33EA2044CE178C6917EF3077D3
          05939A553EC3A88320B8861868E11CD48A4E2FDD71497B65C6F3E61CCFEB41AD
          E861D48AFE9351072132380DF4E5CAF4E43ECCA88320B88618682103BB26D6FF
          918C745B652EC6C1E5348631CC07486633A52F44CE7EE6F4D103749859876460
          02C9526E253CC4729202F14E540CB4900932D21F94E9B464A63217DCE0A29312
          03F6F98EDF00002000494441549D88EC55BC53AD2A90AC624A3B691874635184
          6DE50CDDEA29461FF99AA5374F0CB4E00FC4EF6E44720553FAB756EBBBB2D8FA
          61B5B85B644218CCE970C32FCD27AD3D42BB059954A8C294AE20B88E1868C191
          9D13EA7F45AD684CBB7A8C490574AF375766201521B1D8A9C4400B42D4888116
          02F11A496FC5B702563325063A11D946528729EDBC1DE76ECE3EB15925CE853B
          04C115C4400B7EA156F437653A2FC138700726158A57EFB7AAD4BAA1357733A5
          2F44C666E6F4AB92AC60D64110A2460CB4108C498ACF4083DA2462A0138B2DCC
          E9DFAEC4400B4980186821203BC7D75F57B6F3D27DB45B9C49857B95B986B590
          20CCE970C3E18726AF457CF76C4C2ADCCE94AE20B88A1868211416923CCE94F6
          8DD5FBADBA74DDD09A7F30A52F44C63AC5370E5DB1E3DCCD574F6C5649C2C50A
          098D1868211496293E030D07358C297EC294BE10196B159F8146B98678E06F32
          A52F08AE20065A08858D243F92FC1F53FAD59518E84483FB79DDA7C4400B098E
          186821283BC6D7FBA76CE7A528706B33A95095295D2172D6936058E252A6F46B
          91F4624A5B105C410CB4102A1B149F812EC394AE1021B3DBDFF0FB4393D7C248
          DFCAA442E18E6F6C2E31B169A5BD4CE90B42D488811642651363DAC56E7864D5
          C56B87D4FC8B5107217CB0E00A97810668458B8116121631D042A8EC614CFB62
          652E7F79805107217C60A00731A65F9F642863FA82101562A08550C102089C63
          8A859418E8440353AD7E22B98629FD9B3BCDDB9C6F42934A4799D21784A81003
          2D84041CC5CA75597A9C760B33A99087295D214266B7BFE1AF1653D6BDABCC55
          D138C0822B88E72E816E8484440CB4100E27149F81CEC194AE101D589B99CB40
          0331D042C222065A0807CE1582B232A62D44CE4A9233241730A55FB1D3BCCD65
          2634A9B493297D41881831D04238FCC498F6D58C690B1132AB5DF5532DA6ACFB
          8C766F6154A313494FC6F4052122C4400BE120065A8884258AD740B7EC3C7FCB
          C0F10F54FC8D510741081B31D04238FCC998F6258C690BD1319F64B0329DB638
          4088DA2624D398D217848810032D840367A0908B19D316A26056BBEA477537F7
          CD8C6A745362A08504430CB4100EE9DC0A0809CB5CC56BA0AB769EBFA5C6F807
          2AAE61D44110C2420CB4100E9CDDCC12E633B1818146542FCE3CD49F640D63FA
          82101662A08570E08A220638C7BF852899D5AEFA772DA6ACC394AB068C6ADC47
          ADE872D48ADECEA88320848C1868211CB8D68306D2824E7CA62A5E030D27B527
          489A32EA20082123065A08876B19D3FE85316DC11D10550CE16239C3B63E40AD
          E897A915BD85510741080931D04238E4644CFBBF8C690B2E30AB5DF57F5A4E5D
          3785769F665403ADE817486A32EA20082121065A08877C8C69FFC898B6E01E13
          481E53BCD3E6EEEFB260CBADE31A57FC98510741088A18682124CA765E7AA561
          B02E58F10363DA824BCC6C5BFD04B5A2172A73110B4E869391AE4E46FA1F663D
          04C12F62A0855029A5F8224181938C690BEE92A6F80D7465928E24E398F51004
          BF88811642A53C73FAC798D3175C825AD16B5B4E5B8FEEE55B995579A1EBC2AD
          0BC636AAF01DB31E82E088186821546E624EFF2873FA82BB203637B781C6AC84
          5748DA33EB21088E8881164285B330FD95E47BC6F405F75941B24DF1F7CCB4D5
          ADE83799F510844C8881168252B6F3D2A2B429CCA8C2BEB5436A4A1CF0246266
          9B6AE92DA7ADFF0FED2E6056057E1513C9489721232D3305044F21065A08853A
          CCE9EF664E5F880D8B491076B31CB31EB995E9B8D69A590F41C88018682114B8
          3D6EC5402721D48A3ED36ADAFAA7687729B72E442B6A45AFA656F46C6E4504C1
          420CB41090329D979434945195598D6DCCE90B3162469B6ACBC848AFA5DD1BB8
          7521C6775BB475CB988615A44228780231D042301E664E1F63CFEB98751062CB
          A3245E88EA7505C93C32D2D5C948FFCAAD8C20888116FC52A6D392EB94C13E2E
          F7C5BAA135C5833B89A156F427ADA7AF4774B146DCBA10A549A6745BBCB5D998
          0615C4315160450CB410887E245732EBF03973FA427C1840525BF1AE396ED184
          E4803297A6140436C4400B8E50EB392F6D7A72EB41BCCBAD80107BA6B7AE7690
          5AD14394778CE2E3D48ADE4FADE8E9DC8A08BC8C3EF2F5CDB4C9C591B61868C1
          1F88F47405B30EE8627C875907217EBC44D252F1AE9A6667C2C34BB69D1C5DBF
          FCDBDC8A083C8C3EFC554B6518131553CF8E18682113A53B2EA96B18AA29B71E
          C4D675436B9EE25642880FD48AFEB5F58C0DDD697719B72E9A4B48169191AE49
          46FA436E6584F831EAD0571750198875C30772EA21065AC80019E7ECB419CFAD
          87C60BF363853832BD55D5E56D666E4074B1C6DCBA682E2759DE7DC9B6BB46D5
          2FBF9E5B1921F69071BE8A3618DA68C0AD8B1868E11CA53B2EA6FC60BC41BB9C
          EB3EDB79835B0181851E24FF26B98E5B110D0AECB7C848DF4F465AA6FC253123
          0F7D55DA500A330A8A73EB02C4400B764693DCCEAD8466FBFA61B5F6722B21C4
          9F692DAB9EA456341C14BD14D5EB5F24EF745FBAADCEA87AD2DD9D8C90717E90
          36186FE6F6BD39871868E12CD47A7E96369DB8F5B0318B5B01810F32D273DACE
          DC802E46AF747503B4A4DFECB16C7BC39175CBBDC5AD8CE00E23BF3C71196D86
          28C3E8C6AD8B2F62A00555AAC3E2E70C433DC5AD878D3F48A6722B21B0D399E4
          46652E66E11550982F2323DD958CF4646E6584E81871F044792AFBD053539A5B
          1727C440A73025DB2FBE8832E748DAEDC2AD8B0F0BD70FABF51DB712022F535B
          56FD815AD1AD9439D5EE026E7D6C5C4C32A9E7B2EDC568FBD888BAE5CE702B24
          8447DA8113C84FBDA9FC7B517923388E2362A0531432CED72B738CEF1E6E5D1C
          18C5AD80E00DC848BFDF76D6C6E769F7696E5D1CE84F52ACE7F2EDAD47D42977
          9A5B192134D20E1C2FAC94318176EFE0D6251862A0539092ED16DDAA0C0363BC
          5E090861670DB59E25BCA760E739925B95E9D9ED35EA936C2423DD988CF4766E
          6504FFBCF6C571F418F6A5DD6794397DCEF388814E214AB45B7485A1149CC1FA
          286F7519DA79915B01C15B4C6D51E51F6A45C3C37693F2D678B4455192CF7BAD
          D8D12DAD7659090DEA41C83857A40D5ACD55B875090731D0294089B68B0C659C
          5D2968A8F266ABD9E2736A3D4B684F211364A44FB59BBD111EDD98E27409B73E
          0EA045368D8C746D7AD7BAA5D52AFB2DB7420219E6FDC71178E9797A266D697B
          21B73EE122063AC921E37CB7420655AA1AB72E4140DCED47B89510BCCB9487AA
          AC25230D87C629DCBA04009588DB7AADDCD1998CF4126E655295E1FB8EC1F1AB
          976118587CE56A6E7D22450C741252ACCDC28B0D334CDD239441AB72EB13220B
          370CAFF519B71282B721233DB5DD9C8D2569F7516E5D02908D6471EF953B16D1
          B6CF6BB5CA1EE556285518B6EF183CEC5B1BE6AA680598D5891A31D04944B1D6
          0B31EDA39532543BDAE6E4D6270C7E53E67AC082100A58C0A01049236E4582D0
          90E4BE3EAB7662D185A1C36B96F9835BA16465D8DE63B0652DA8EC7B92B685B9
          F5710B31D0094E91960B8A1986AA43BB4DA8B5ECF56E6C7F3C43ADE72F9D3EA8
          DE6F153C2E6FA0DF9801431F38BBD19F19E777CE7F16E0B8B593E15FFB756D9F
          F91E77D4C39E06FE321D73BED6F96BFAB99661289F53CEA7EBE7B86F9A4EC733
          1DF3A387BFFB65FF9EDF7BEF73C31CAEF5FC8C36D53E556130A5799533D48AC6
          B294A884DE14CE7719C0D8340C74C73E6FEE8483E6CCE1F797F98759A7A461E8
          9EA388EED69EF219E2B717E2D6C74510E6F80331D00946E1160BB252D9862927
          7792607CB928B34AD1B291647880CF2B91DC17275D84F883B8C7B785FB2532D2
          FF6B3F67535DDAFD88A494EB5AB94F016546C77BA4EF5B3B31A77BC9B0FBCA48
          80930821C39C9F36589AB403C9FF31ABE3369802DBB5EDF5D7FF2206DAA3146C
          3E1F6D8C5CB45B9A76CAD1B602B53AAA2BB3FBC608FCED84015DDB6D36BC564B
          5A14A9CBADADA6ADBF9B5AD1617BEF4F6E5EF97B32D2F7D2EE2724F9DD572D26
          20A424564BDADBEFAD5D43E94D9E39F4DED2D2F51D0283771DCD429BFA541EB6
          2641E324E1BCB28380F2B057BBAC59275907C4403390AFC91B580C1C9E85D793
          D1C5D28E39C8E2E6A4639802959F8E1554E6726757B12A1A7BFA9071DEC5AD84
          C00EBA7E239A5E4746FA7887D737A1B05EA3CC0A6DA25042992B273DD7EFED5D
          E3E9DD9F32E49ED2C7B895F21AAFEE3C72A16106A96942E522E6C2275B6BD962
          37491332CE19CA434E03DDF5F2DBA7D6C64EA0F1BE50C6E7327E37E371FB2503
          8E3D3A1CCF9486ED9281C61E15828018670381C010C3ABF0323A8EDA5F163A7E
          A532DDFEBD1A28245ECCDB98567B02B7128227B8B1F5F4F5F74F6F5DEDCD48BE
          3CE9C1CA5F9091C690CF07CA3B6B99870AC6D107913CF5C8EA5D6F5309820538
          560DB9A7D4EFBC6AF1F1CA8E23282BEFA2B2B31E6D215999558A35D348BAB7CF
          96F557DF0F380D74619544DE7642586C2569C7AD84E0299E2523FD1619E9F448
          BE4C467A6F87B99B105BF93D955833182CD05D5B53CBE947DFD9BD82B60BC948
          BDF9EA5DA5FEC7AB5A6C7979FB6134562A50D3E62E05DF1AC3B845254828CE28
          F991A45BFBEC595FF7778274710BF1E624493D6A3D67AA2D0A290DE6EBA3476D
          79A41798D4ACF21E32D2B7D3EEFB2479DC528C01F4B035D7F2BFFEEFEEFE908C
          168600569311DBF5CA9D2523AAC4788597B61EBA8E3655F5AC93CACA38EB897F
          3DB35AF1067E132DC9381F0E74921868219EFC4C5277535A6D09DC2038F16CEB
          191B564C6F553562034446FA8B8E733763CC72B54AFC190E00EB4FDFA7CECF64
          F876C07B7BD691515B47FB6BC9C86D7EF9DF257EE053CF3FCF6FFAF24AC3383B
          D65E8AF444701978DB97A163F0B1491647D770F95B993E172F75C89E2DA873AC
          1868215EA09BAE1E19E70DDC8A089E050B1A2002DEA2682E32B159A5C3DA48BF
          A530FB21B9C0786C6D2D6719F8C1DE93069C8C0CB593FEDD4FC610CE66C7C910
          1E7DE1B6E2AEAFABFEECFA039718CA408BF77A4AE3EC96D2C6B0423E3A0E47D7
          02CA747885AEA96A889DF882A445C71CD9D687FA0531D0423CF893A4C9A611B5
          3FE05644F03C83DACCDCB0645ACBAA51CD1126237DAAE31B9BD1DDBD4099F102
          92991C5A32AD6FFCC447FB3085EBBF243F9231454BFB4765187040FB9BFEC77B
          F9A7B6A017D171D80338B65E6098B6210B1D83532B5AC267B7646EAF3ABB15C3
          1B0EE811C2D4A9BE649C7F09E78B62A0855883B1E6469B47D6799B5B11212128
          ABCC0527E6457BA1894D2B9DEE346F732DDA1DA752D729118B4658065C883FE8
          CDE8D83167B688CA3F31D0422C8197626D32CE61857214521EB4A217522B3AEA
          0036139A54FA8B36ED3BCFDFB287B6AF2899DE28C407B49A3165EE914EB9B2FF
          14E945C4400BB102B1B5EB6E195947029108E10287A26624B3DDBAE0F8072A0E
          D1461A61149335D885E00DCEB69AC93047DD6B28065A88051F923426E3ECBA83
          8A90323CDD76E68637A6B6ACFAB75B172423BD928C34A67321D46639B7AE2B08
          1AF84D60ACB97F34AD663B62A0053741B7CE089247B78CAAF317B732424283A5
          531F2299EEE645C9481F20237D23EDA62973A105417083ED245D3BE7CEEEEA9A
          F662A005B7808768DBADA3EB2EE35644481A9EA256F41C6A45BB5AD923238D45
          093A7659B0052B618D56C91FF35E881DF0CAC6BCE6D7BAE4C9E15A6F8F851868
          C10D10E5A8031967094022B8094201B752A6B38DEB8C6B5C7166D7855B11D169
          06C92DB14843486A305FBF3719E6982D7222065A88068CB33C423279EB98BA09
          1D7E50F02C4FB69DB571E6D41655FE8CC5C5C736AA70888C740DDAEDA7CC9650
          9658A42324157B49FA76CD9B23A2C55DC2410CB4100930C608F0DE7FDB98BA27
          B89511929A02CA9CC33C2E56099091C674AE57C95063810A38F9DC18ABB48484
          06C378A8C48DED962F675C7C6CC4400BE1B285A4D7F6B1F53EE6564448191EA7
          56F4546A45FF11CB44C850EFEEB6682BBABA3B91BCA4643A966082C86B707E7D
          B95BFE9CFF8D67C262A08550D9AFCCDAE35C32CE518561148430C94BD2916454
          AC131AD3B002F2F6B86E8BB72EA6EDCB24AD9584B54C55D0B3329364D0C3F973
          1EE150400CB4108C83242F92CCD83EAE9EEB5E8A8210228FB59BBD71F29487AA
          C4656DE4310D2A9CA24DDB87976C1B4FDBA12437C5235DC113A09286B9F24F3F
          5C20D75E4E45C4400BFEC07C3E144C4B778CAF1775C8454188925C249D495E8B
          67A2A3EB975F4B461ADDDE8D485E50E6FC6C21394139F706C98BDD0BE6F24404
          4431D0821D2C6C810C3A7EE784FA212F892608716220B5A227522BFAD778264A
          461A4E910BBA2FD9B684B66D489E22C9174F1D84988279F1D34886F52898EB20
          B32E1910032DA0F0C1E2EF5349E6EE9A58FF34B33E82E08FEC24DD480673243E
          AA7E790CF14CEAB16C3BA29BB524194852944317C115BE52E6EC80B13D0AE5F6
          64586231D0A9098CF22665B696E7ED9ED4C0CB0146F691ACE55642F00CB7B59B
          B371D894E655D8865D46D62D872936537A9A861A5DDF98435D8D4B1F216CB0BA
          DE1892053D0BE78EC9FC7AB710039D3AA05BF03D929524ABF64C6E709C599F90
          5837B4667F6E1D04C1891175CBA1928075ABE7F55CBEFD6665B6EEB196F525AC
          8A094E7CA3CC95CC26F52A92670FB732A122063A79C1DC3DB43CB1B2D41AECEF
          9DD2F077568D0421491951A71C5A659FF65AB1A3AF32A76621B84A715EAD521E
          8C2D636D004C955ADDBB689E849B8522063A3940C643AD708332BBAE37926CDB
          37AD514C033B08829091B4DA65313DEBD55E2B77609C1C11C9B022575392EB58
          154B1DB0780542702E2059D9BB589EB83A14BA8D18E8C40299EF4B65CE4D8641
          C654809D24FBBE98D1588CB1207884B45A65E1E781A98A9FF559B5B30F6DEF52
          E678753D25C6DA6D0E29D3282F27F9A06FF1BC4953168A81E60793E2E1398D38
          AFDFE9ED492D5F2BD3D310F1AE0F1E9CD5F81B2E250541888CE135CBC0116915
          A4CF9B3B114614E3D5B548EE2329AB245259B8A01CC452A16B48DEEE5732DF01
          5E7562070C34E6F45DCFAD481202C3FBB716ECC3A10451907EB3095AC4A78FCC
          6D92706323822084CFF0FBCBA01CF848CB807E6FEFC2D431B4AE6B6829C2A69C
          3741D9885E42F8D3603AE8E724FBC928A7C4EA7917A56FECB4865B0941108454
          64E8BDA531663D5B8B7A64F5EEDCCA1CBBAE4E5285A4824A9D453BD06BB85BCB
          0E92CD243B1F2D933F659D5BA58B5B1004C1230CB9A71486B3166851FDDFDD8D
          EEEF02CAEC0A2F43524A99C151D0D2BE9647CB8841573F86EC0E6BC1D8F1014B
          06942BF0039B661E450CB42008824779F5AE52E8CA3DA46599FDB301EFEFF917
          6DF22BD38063C5AF5C5A722873D812061CE75C4972A14B2AA18B1E9ED1F6613A
          FCFF13C98F24588EF15B92EF95E9530341CB1886F9FBC72B164C89AE69B71003
          2D08829080BC7247491843C8D640E73DF1D13EB4C2AFD072194916650653B940
          0B38A3CEFBCDD8F72196FFCC2FCF542BE2E9C85BC986186841108424E685DB8A
          A3D5FA8B16218110032D088220081E440CB420088220781031D082200882E041
          C4400B822008820711032D088220081E440CB42008822078104F1868A3CA84FB
          69F38832E7E68D4CDFD8695E9CD245483DACDB8A397F2328DD5DF1485710BC0C
          BD17D7D0660C49419243F45E3CC4AC9220240CF4FE603DF0DB9519BCE5297A7F
          229EDE16B281A644712E22D460A23B22C79CA284FF893461DB75B1F4DA0C6546
          BEC10FDA1CED35C3A0264907BDBF5D99CB370A42C8E8F7024B086625F98CDE89
          EDCC2AB9C18B24CDF5FEDBF14A94EE25A25DE15E6623594BF73260000E418837
          94472FA54D4392AB49D6501EDDE7701A562CBB49EF4F50E6D2C01111D0409332
          88F78A16265AB8657CCEFF833EDF42DB774866FB5134145E56E757D3EA40D749
          DAA5C384A4A43DC938BDFF0BBD1359290F276C707FD21F0B3474D6FFBE4BF29F
          3826DF8A648ADEFF1FE9922D9AD68720C48047D5F97702CB01E78A65628E069A
          5E0CC46F7D4599C6D95F0C57D4246ED0F2047D67166D7BD10BF563A889DBBA98
          01BAB61784FA5D418814CA7767431C527E736399CF7CB67DC43C46FCE3AF5CB8
          6EDCD1F7055DDB78E7F11B5AD03D3A134715ECF7123D75A8B88B8116BC843D8F
          E6A477E6627A47FE8A5562990C342588D552562A3300BB0514C05A9CFB951920
          1D055131924ACA8CEB8A171BB55F84946B134AC2BA6B70ACFEEE7A658E410B42
          4CA17C778B325B8697D0FE8BF4723D19E525372A33DF23DE3116343815E5F538
          E942525599B1979BD3BD89F76FB1DFCB632427E29CBE20040379B4A3B51F4BE3
          0C3218682AB0E014F28132C78000121F4E32CCE965D5CE244D94695C61B00B84
          91F62DFA7CF4CF37A5EB4B1076211EA05576A9DE8FBA7B8AF2ED627A0F0AE9EB
          EE71C32F8311F46661C9BF67E9777C18EFC429CD95BA0CC278FEDE58177E8210
          2E942727501E858DC41874CC7D96CE1968DDA285F7B4659CB14A4A5D52E8137F
          5FA6CFE0D43591BE3B8DB63D95D92D1512F4DD352A751622179218CACB8795B9
          BE6D4243BFA38A077438429B23DC7A08823F288F7E11AFB4EC2D68746F592F28
          5A010D0319673BBAA63BD465DD044110042165396BA075EB7980EDF818DDC275
          1D4A0B5D032D48FE4D5258EBF00DC9E7245329DD2FC3B85639DA345366C522BB
          3E8C6B61AAD63CBAD6261755477A2569F3A032C7E9D03D6AE8F4B691CCA7F4D6
          86781DF434606EE95D247994E9948345CD7792FCE173FA7EFBBC70FA2EC6FC9F
          51E642EC18039914201DF4860C24B99CE42D3A774910BD70CD962435943907D6
          D2EB53653E9BA321FC36DC177495DEAACC6782CADB6EA44FB220DA6E4BEDC884
          A9387548E02F017F08F4F6E0DECDA1EB7FECF01D3CA7DECA5C0FB7A4EDA3F2F4
          997D0C1A0E5113E81ADF85A10F86791E576697D7BBF4DD850EE734A0CDBD2447
          E8F397F4314C2FC4748C7B94D93D8E34D1753696CEF9368474F19B6A29F35E60
          B6059EF1F7CAEC76FBC9E774F88DA4F9EB7EA76BE15D6C4C525699F90A8E5998
          95B1886445204731FA2E74C0B33849E70DD2C7D0338671BAFB94D92307BD3ED2
          BFEDEB00D7C2B3C4F3C0F7DF0F160F81CECF491BCC39BD5999CE3B18BFC6B835
          BAE7A706BA8FF4DDFCB4E9ABCCD80B8BE8DC77029C5B5EFF1EDCF3294EE50A9D
          83F719791EC31C69FA5853654EE3C47B80D92943E9B34F7DBE771B6D701ED240
          5E423EC0F55F77A3FCA2EB175766795B5D99D36431C300EFE33248304749FA3E
          E6F336D4FAC10112E7E31EAFD33A1E0CF2FD70F2FE383AE79B107E13EC465B65
          3A286338046B55EF2059AE82E457FDFDBCCACC37980A955B99EF3D7C1EDE2799
          41DFFF21C077710FE1C98DF76D099D1BF13444FD6C5ADB7EC7CFFA77A09C4679
          9D6EB5A0EF54A6A10078002F479A6810851E50A697E8F50E1F43878174CE0BCA
          1C034B0F709DFFD3D78171361C4E81E1EB4FE7A1B0EC108E67B99FF450708C50
          E6CDBCC0E114E8DE97CE83735DDB2005035EE239EAFCFDB653DFE1180CA4BDA0
          42A13450EFE3E5F16BA089D2247DF43E0A30BF069AF48293DF6BCA2CA0EDA0D0
          BE9BE4713AE719FA6D7EF3067D8E29472355E6A10E54A070FDC7E89C8A918ED3
          D27731D50FB305CA3B7C0C9F862E740E0A9ED63ECF1C2FE13087EF54D2620705
          CE1B61A805E3D85FEF1725C964A095996F604861285F221D610C313FD2F75ED7
          20E9499FA3F7EA237F09D2E779B48E37397C7CBF9FAFAD50A693A7FD3AA84C21
          06C19D0EE7DFA0F55E47E7350950396BAE05D77B4EA73F5599058E1DE4D59EFA
          5AABFD5C0B9542ABA180CA97A381D695937E2448CF37AF216F20BEC193745E4F
          4A6B9A9FB460B07AEA7D14B67E0DB4322B1A0FEB7DCB80FA82A96978B761BCD2
          286D94173D6C9FE33D42C5E753FD1B90E64C651A3F5F6A90F4A3731EB78C5AB8
          E8461766E2F4529967E2A0818167BB0B6532A591699EAEF6059846729BC3E52B
          92D4261944E7E17DEF1FA0E26DE57D1851E4FD46CACCFBD7FA9C5703BAC2A007
          C9FB4F205D95D9C119CF1395213CC77BFC7C1765372A80A8505FEAF371056556
          349FA1F33A07A81CE2BCBE7A1F762822034D693C4F9BC754667B82994DA8BCA0
          72DCC8FA91356D2760F2B5EBD3444821B4AA604C2C830A6F38786FA3B0AEA215
          833E681DE2A51BE07019AB95870758C676182FC53EFD7DAB150090190AC32846
          3A9F521BE70FD4F9EE7F8056C05E65DE5C1841ABC281D6C447F49D9B28BDFF3A
          5C0B3AAF5266AB0F2010036AFBC82C68C514B79D8E6030E9FA77C514D20B05C9
          08DB21F4046C50E6B342418DDF8E96C64B7A5A41A6B9B1741CB5E489FA3B78A6
          78515053C7B384F12CAB05AD89B0F3175D1FDFC573B7FC168EE9344E2BB32706
          2F25EE635D923751F3B7391EA24509E378790849F96DE1B901E9D59536A39499
          77709F6034F19B72EA53D0BA80E35931D2FF7B87EFA317008542297D08791FC6
          17056065651A090BB49650E1C66FCFD02BA05B0218C22AA80F7DA7AF0B675054
          006094D02B8082EF433ABF6A083D0B288C91072EB4FDB6ABD4F9CA285A880BE8
          5A25A22C63062BD3402B9DCE1A65F6A0E0F9C3A094D2E94EA5B4D229ADE951A4
          153694262A6C3D829C86B9F39671C67D45E51E157B549AF02E211FA0E2149181
          56E67CF296B6FFF15C6188F13EC2C8E05E95D6E7DDE8A33F1C7ED11395CD7618
          E3AEF00D40D9859E4BBC4B78CEE899CAA70D7DB0962B8651472BFF791F463B50
          DE47ABF979FD2F7A1A5196A2C715F914E5272ACB4E954D0BCC1AEAA4F7F15EA0
          C56C9551F87E31ADCFEB94D63F4EBD616E808A236D9ED0FFE21DC5FB7B44A70D
          FD0BE8EDB95A88DDF8B8EEBDA9BB86D1E245E18D82E42178BFFA9C839AF77C65
          76433E4AFFA33B7483C3E550FBB28C330AD3F674DE9BB6EBE037A12587D620BA
          83911951937C584506BAABACFB83170935E5C5560B5F473FC28B809A24326F09
          FD9D560ED77A559D37CE68893E6EBB0E32ED089B9EF86C44E64BB80BA58B16A4
          D5BA4425062FDA5B3EE7A02041AB1F2F356A988B1CC2A2A2668AE78BDF03E7C2
          553ED74037242A5D7EBB8F02E888CA015A8C9671C6BD7BDA5E6BD79ED4481395
          1C542AFAEAF3E023F1B3EE75C1B3422DD9AA1DA3F56805E5387B2A9DEB3BC4E0
          2628082CE38CFCDFDD3254A41F2AC9F88DD65C6AB47C9E76B8060A7ECB3863BA
          583DBAC66FD687741D0CC1CC56E6B358499F35F6A30B5AB99671C6B3ED6CAFC4
          D27550E9445C02B47C0B2833EFB65381B18C339E4357ABD54DD7426183C20E06
          1A86B39F3A6F60C382AE55C7F65DF42ED5B59713BA75DD4D99EF12EEF3483AF6
          66285DA72E01C36A1911F45821CFA3DC40C5E9B4D61179B5853E0715F09BED06
          490F63A135E8DB0B11123A0F582A8ACA3F0000187649444154C61986087966A2
          D573A5DF05E42FB424B3FB7CF762653E77CB38A3CBB5ADBDBB5D375A1ED382FB
          8DF201EFD1D8006AE13759C639D2BC6F1DC33B7A0B7D7FA34D27E8814AA5631E
          A5CFD1CB63196718C3BAF6A87FBAFC45BE7A55EB389E8EBDAB1DA15D43DB0BCB
          38A3117603A5B1D3470F3432CEBEB796812E6CBB86DFB064BAA074EAE2056702
          4C951AA4CE772974F735CE004696AEFF94328D056E366A19F61A20D2BFC1525C
          99358FBBE87BBB7DAE830C899B8B1F3F531FEE802E8540E35F4EE8166F5BFD2F
          AE7B9FEFB890CEF4D3E85CB498AD2EE487E8FF67EDE333F43F5EB67BF5BFA8F5
          3D69EFC647ED93CEC174358C47A1704477F0C8405DFD2E81D6B0950FDAFB1A67
          ADDB223DF4802E4564B0EE245DADCF75A6BA41FFBBDBD738EB6BA06BAF6E843A
          A265668D1D63DCEB3187EB7FA9C7FC10DD0EF9A707FDFFAA55ABD7C6FC2F3A66
          EF8A432D399E51BF0C2D301E7DEC2D0EDC33D20D0590555942B7A0532165BD13
          F86E47BB71D6D741ED1F853F0ABD46BAB5BA378312E6B8E27DFA5FF462B5F21D
          76406B19DDD1CA6C39A185823CFDA853CBC606F2067AC9BAD8AF47FBEFE956E5
          78DB6F0BDB40EB42F845FD2F7E7F23DF4ABC7E5F4663284599157554085068C7
          64D8CE812C7A8B2ECA26B6FBB0D4760EDE15AB27719AEF3DD57972542489EB7B
          64CF372867C6D9CFD1C33FCFA2E2A232F6B800BC6B65F5FE71927F3BE8878ADC
          13DAD8583D9D18029B1060F82AAABCAF87630AE87FD7D88DB3BE069EFB9B5A32
          266CEA69559A508ED74BF709C9ABF5196C9891F490EF51D1C27B34DACFEF8914
          D85AABF2F396DD38DBF458A2E55CC16C1F0F707C01754B0B37C569CCD73AE769
          DFEE4FDD256D8DADA2461DA8BB69B2325BBBA8C5DDE5F0797BDBFE385FE3EC03
          5A113078189342C502B5BC706F365E6CEBF74E0FE4B4419F2DA5DF0A23849622
          0C16C6DBED85424975BE72F39E5346C68B49D7408189C2155D90706608EA9815
          2986E9646315D428C4E707381D85EBB3CABC1FBECFE642757E9CEB2A18EC60DD
          5D61D2D6B6FF9CBF9328CD6D94F667CA7C0678A1D1D2DCE9EF7C26D052E8EDA7
          E2850A256643E01E97406F90DD89471734D630C817E9E6F42E273014600D5BA1
          DB7BAFCFE7F6FBF982BF4215AD4EC3F4E3C0F9788760D817F9FB61CA743CEAE2
          E77A68A5C3E8E0DD2E84AE7A3AEFD700D7720263A756EFD93BF4FDCF029C0BA3
          649517C8AFF132D0E0B0325B9DFE8CD525B6FDAB5D4E1BF7A884DE476F559ABF
          13493F9435EB7D0EDBCBD841412A64A82CA1DB1A3D2318C6C05056A01ED84079
          1FBD597EF3BE32F38DC53501D270A2863ADF5B04C7AE6D01CE45BE69A2F7916F
          DC36D0613DFB8B748DCB3EE0EEAF6085D5F76B9C35B7F8396629B53A9083107D
          769AF481B7238C590EC38CC56BEF9ABADBB63F3B9022C804E88A55E71D8A5068
          877BB3434E4FB350A7A36C5B0BFB83F939C035EC2D3C7F6156DDA2863A5F6978
          2B506B5D17D6A851A3D250D85EC0A2754AFFC308E0B9C119ED39F486B8D1FAD7
          DD69D5F4BF877D5B830EC083DFBAF7182BF39A811EE3EFBEE8562BBAFDE0D486
          FC8282C85E40DA2B42A1E621A770BED6381D0AC07783E88BFB691974DCCF4006
          7A7C00638F38E588B486713E942368A1846BA0EFB0ED67EAE9F101853074C1FD
          72722A8C253042A7037C6ECF93DDE8BEC09B3AA41920216077EA5A1D4E0F91EE
          FAB6DE35F48606F4A2D7E5351CFE1ED087E0B418C8408F0D90F7BF0F92F7E16B
          815E4A34F86E802F077D275097BA9D70F28D7DB1A658E41BF4AA5AFE3077D2EF
          40EFD50C7F275FA40D191EA2E50DE9AF76820C841A8EAFD1406DEDBECCA79FC3
          EECCF52FDDFD1608BB214357EF59036D98D359F2EBE3C83C816A41165B6CFB45
          4238FF1C7A2CC6AA8922538532E521507AF6B085A5FDA409635951FF8B42F664
          08694683FDD9640DE1D958C6DCA98045C4B9097A1F632C77D1F5E0CCB32C3DBA
          A95530FA569EFB3D041DF3DBF69D660B781D8C79E5D6FB193C94318444BF1FE3
          99F85D4531E4E46758C9EE997ECCFE817E8F2CA72D3CBF86742C903E656DFBD1
          DE4FBB677D280E7BBED8DF9B0221E40554409077AE8D41AF4E20024E1545F72C
          E9835E0E18533C8F8F0D33D81396BCDD1165DA256CFBE1564E717FAD777C1F7C
          3742F80E1C5D2D031D5619EB00F28795F7AD698367416BDA303DC6ADAEEF3186
          39850B36E99D20CFD69E6F8A06C937F646E875216B1E22A4271681412B1D3E32
          B8D7D3F55012BAF73FF0ADC058B56B8CCD16D2FB8594037ADC2253BC6CC39CFF
          17C840DB3D011B6909157BED3F876DFFBB100B7DBB81F39DD2128CACB6F47F09
          52230E253DB4FCF0E2E2FEC278DDE4D04507C7102B18FBC7789861EA1C2E7607
          9187B4844A869619E98A8872E852EEAD0FC1FB17CE2627E8386ABAA32274B8B0
          E71F143E33FD9D184CC704C1DEADE7D463056F5F8C13A2608733CD60FB8774AF
          E11469F969A080F5CD63F6678E6BC4F37EDA5BD7C17AE39CB0EBDE2B8CEF212D
          1486F15CF8231870E4426B0E1520DC57BCFBF09581F7348CCEB2087BA0EC8E65
          41E7D3FB90D3B61FAABF8EFDBC70CB585F82E50F0C9FA207A699FEFF6E2D07B4
          F19EE8A7CCB4E71BC7D9417E8855F901E73C8C45D7D3FFD7D2B2977E078624A6
          58156F4B018CE55A86190E0C7EC72D22C0DE22468D28D3F4233FC005DF3EC5C8
          3E6F2DD4B8DDD1C4F78E36BD0C194CF754A065F9BA326BF56FD3FF1893C3B835
          9E03BCD8ADF11F1424CFABD8631FD7C1CB1CAA01858345A6B171FA8D7DE837C1
          410CE3C496D3186AC4F82D70DAC2FCE470E70DDAF30FBA86429D9E83DF92C961
          2409801F000A28E4CF57B423230234A06082834B6F753EEF0E76E8E2B43F7354
          060E87982E3C6703F928C4037B5E806108B58BFCDD7477562E730D7830D3B343
          77726F2D9611B955CBFBF479B3F41082D6F860BF47E1967F919479F686522495
          AE90D1CFF041ED178196B4D5BB83963B6C566F388AFA3A0EAA8CF7043D99A134
          7C50395A16A5CACE17DED8E90FDDFA47830836C1EAF5C0168D1994A3984DB3DD
          32D0980F595BEFDF4F1F5EEEEB1D1A05F6EBA4F93A918581BDA009D5B1C27E5E
          B8AD37FB430CD5F1C99E9E5370947B6DFB185B1DE8700E323C96EDFC203435A3
          C2FE1B5FA23487477BC1743322D33B74BFE0AC82A917E84EC28B8F026889EE39
          D812E81A3ED8F30F22A7DD1EAD8E090EE66B5A05290AC456CA794A1FA651BDE8
          70DCFECCD11355D45DF5628A3D2F603648A0F1F07088A961F187AE3CBD4CEF04
          DE3BF42C628AA5157C06E3A62BF4FB124E601FFB34C12BFD9EE58C3D6F845AC6
          5E65DB8F2A2054A8D0FD58A08D34CA029431E86247A3078E6068F85448CF1858
          C79E6FDAA607881A172F74EFC82CD215BE4D704683B31D9CA9D1D3835E0294A1
          E52C038D8C8E09F1C8A8E8F6C27CB1D75CD2C5DEE2C9E1F7ACE0A0C66C2D4587
          31A56BD3038464D3D80B9F0361A687B13E184BB4385003837354B020FEF6F432
          84C033CCB5AFDBE87F51FBC3781E5E4A6BCC05BF0F5D5EC37C5DEF7DB0D758B3
          F83D2B34ECE3E2D13C9B4CE85AEC06FADD301296B31EF4C57CE9708639DCCA3F
          098F61062919A2FF450185F0B870E0C2D002DE0B0CC3A08B148E6899A6BA6990
          CF50D14441709D11E3F56C5DC6CDBCE0E67B1415E9E6DC7B78B9CFD15305A769
          9DD0C2C6BCEF80217A7DB00FB315F47B9633F6FB5BD8EF5919F15BE6C5126DE0
          D640E89EC1431F5377F17BD1CD8E297CF62110CF9621FA77D81B35F81DB00918
          DAEB71913EE90BFA105D8FD6583282512018871BABCAD8E79B558DF422E966B0
          0978815A5DF170B0089671EDD3813E0F333D3825A0EBDFF2E4436DCDAFB79D43
          7ABE637F96513A3BDF4ED79E11DA0E2F62380132EC8E1B3982B4ECB3F9396E61
          774889F8D90422DD9C9F8C296ED6CB5B2DD0F90E60A803F70AF7A9708815B380
          2AD9F663ED25EF36C85FD6381F3C62DFA3ED50EDD07851283E0BDA49059555D4
          D2F13D8C593B0504F222AE94251A7B64C160CB8E4614302412E8F9BC81B9EBCA
          8C1D01E0CB118E81B60710729A551308947796E77B6ED2A308E913AC61137119
          EB167A7A651B75DE83DCB78C41BEB1A64E21DF84E3771137D0A8A1DF811E8115
          FA5075FB2038823F60FA055E5AB8DBA37BE56EFA52B49EC43054302AE80AA9A2
          BB1FB646782DB8F477D1FB08961128B67401DA34D0FF22D3650A8E1202A8B458
          061AD32166FA73DC30CCD0890FEA7F718E6F9838CB58A2E58271C3B313EDC399
          06A1CFFF89D28281C2DC75182DBCC0995E0C3A0735DB60C10ED628B34BEC6C88
          44FA4E71BA7E2C428BA26285F123E4B78B839C9B013D5EB346999547141C989B
          3E24E09702633762712B785DC2AE2FA63CC1409F0BC212C67590AF8BE97D3827
          258A81B6FB2F34D08153425ED8C407BBA77525BAD6554E5ECB741C437FBD7D8F
          C718FB728661BD2FCA0C5F6951D53063DF3B0E291966D4C51BD3F502337ADA14
          CA12CBB0A38CF5FBDBE95C18676B1C18B36DFCC6D08E03F68A84EF3D43BEB17C
          7A9A92DE4F86E8F4CB4186677FCE40C3681A66242F6B423F8CC8263A0677F0F9
          4EAD34FA0C057BE540A9E91A3B5A9E185F41371CA26EDD196802BC61460C3BE9
          108801EEE9E87E8791C31CB247E89C4C85B59ECF07672CABEBEAF5F410566272
          00A10BF1FB719F600807293356B86F7A18EBC15882351E030F4CDF886C2804AD
          28509FD07730FF143AC1D1E537BDC5180EA6C5AC0BD24A44A5C7F2194044A0FB
          EDE354DA9317DEBE01A7C5C0339FCE9DAB4CAF60183FB8FCDFEBCFDB5ACF99C7
          1C63CC473E6E3B8E3C80AEB8C1E9CEC127E06969E535BF91EA0280202956EFCE
          D394DE870E8E20763D0BD026879FB9A5F6EEAE1B230C98C185FD370FD53D1398
          1D80C2062DC25FF51695EA8D01F23CE655E17DC47B04CF61CC81F75B8135CC55
          D1CAEA163B1BA83CEACA5A0D650EC54DD1CE348EBD4F8619D80563B9B817BECE
          A9A834A2BB1F9ECB98CE06679D813EDF87373C5A5BAEF6B4D075D1FD7A8874F2
          E784645FF024ACF785AE890530107C04AD48BCAF88477E876F796298AB794D53
          A681B597137052B20CF4C38619EE7285F2C130C3954EB61D1A16CBA1124A0FB1
          F6619346F9995A689F4994E19EE9696D98268B720A7979BC9E7FECA8AFAEB8A0
          F2F1497A846B38F883AE8D688A98A933CE8FE36286DFE1EB468E38A47858D674
          2A74FDA0001F629813D2F1C3D1028101440D1E05AFDDB5DE9FE71F3C4FD1C58B
          56265AA43BE87A88CD8D2E090471C70B5040990E121828C78318A4BF770EDD95
          0123DD4D1F1AAC6B7158E1E8B0320D32BA3050F85863BB2794C3F4B05040F70E
          5D1F531E2CD77C18077858221A1A6AE0A8A955D6FA14D0E7C0EBB2A7CA0CF4BE
          43FF3E546C6A0548FA2F6D38FBFA6921A0E26019683C83F7F5FD8461452F087E
          3F0A1D74619750816BE118138671458B1C9510EBD97CA47FCBD9C84FCA0CA8DF
          505F0FF7D3BEFE37BE878A0B5693823185F734EEFB955A3F7BA526E0A45B3F20
          4C226AC170B2432508F34611521205078C10323AF2169E052268C1910A2D01DF
          308600060D9543CC71443E5EAA7546DEC13D4541B32E021D638ECEFF98A281D6
          008CEB2D2A4037A69EB203672ADFB0863BF533EEAEAFB340E7374C8BB30229A0
          1C40450F0523EE29F25686B8CD4C6075363C5B3C2FE4DBADBA4C4065EC7B7D1C
          BD4778F6C8AF3044E8DECCE0819E6E86D6C54211565CE40186B94A188273C0B0
          C1383FA4F711BCC277D5B3688017FE0DBAB53A49FF1E1802F8B9602687354F17
          EF7E240B3620AC2A5AD278B656798BF70EE501EE0F8607E1588832C2B7A1847C
          80461086F4601F966A4726BC83A8F8C179AC86327B322D4732BC2F513B980601
          69A297B7877EDE68E0A0D50EFB837CF0B83E0FBD974E650CCAE435CA2CCF70FF
          4BE97B824A2F2A2FB817E855B296D784FD4045295860937081BD426CF45EFA77
          E039A19C4579D440FF468006F124DFB9ACF87158A8022FF470757EA236326EB0
          40F9F8918E91BA3055C03003A2A35597534B306F6E7FD3B1FAE8EF5BDDD7F7AA
          8CDED176504BAE45E99F0A92562060C0F0FBAD39C2FFD6E2045A95759C5A2EE9
          66B42DB44030F7CD5A471A05215E98CBB558CF039908AD6D74BD55F76DE1A1E6
          0D1F0175FE1EDCA6322F0B878C874AC05115C040A3256C986BFAA2368F2E5414
          12C156D0F17D3687F51605F8D3CA398634404FCADC20D776D21153D4F052613A
          110C122A380FABC00BA038E61FED5B8078C056E5EF4E9571051C0C9B78D2406B
          30E3025DB1D7E8AD6594EC620123F5B1F604F65DDC043D4330C2B8AF28C8CF2D
          1BE98750A747C614DDD307472A3855C1690E15C6600EADFE7AA31056B8913A3F
          CDC52916C06C7D7D378701502EA197F046E5B392940D34767C974D0D09FA0E56
          1FB32AD1286BD0D01AE4E7F40CC360BAE282CA092AC4A894206FB4543EEB22D8
          40E5A2AE9F56AD9B1CD6DB022A70D8D697D31DD684A7639F19E692BA98DD8077
          040DCC604380D1F8BAF8E3B0DE626A58A0A13A4462DCE438119B3E986998EBEA
          627C0A19163569A7A90830306805A3E63D2F507700C6410C73E173D474D0A5EA
          34A91D5D552880666971BACE9F3A03B551664BAEA4C369A891A095F94A90B106
          BBE173D45D17E8C89CA84961A1EE720EA7E141A236FE92BFAE695DA88CD4FFE2
          9ED5F6BD5F8619B71CB5413C38184B44C0E9AA9C1F240A567848A3F56E8F3885
          6BC200FD27DD8CED8D1E8F2C2AC09C517405C3A59F7631C481DABBD3148BDFB5
          DE998C6CBA19EC1E853BEE4F4587EFA2B701013526F81BC30F86EE8E470F046A
          EEA80D3B452DC2B551B9447E1C13E07258F803AD7B7435DAE748A2C5B2D1F11B
          FEC13B607945FBCBFFD6BD4F57C1E7EE5AD740AF4086AE5BC35C0610BD06783E
          E8AAAF01074F9F739017300C81FB5D419F8B7C52CF7E9EAE30E299E13DEFAFCF
          7502D747EB69A49FCF7FF5B3EF84F5DB301CE3E4D08663C1EEA5554185BEE899
          416BC7292A19BE8F0AF1247F5DF3DAF114155B74EB3650191702420F1062514F
          D2F7DD9A41E2EF3706FB6D76F04EA332DF4665F683403A681D0EA4B437AB08A1
          EF0ED74EAEA86CFBBE93B8C76B485E74BA37E966C859E4A17E5AD7DCBEE728B3
          9281B9C76382746D8793F72D1F804C795F993D0DE869C5BB5F426506335F50E6
          F90D4F4A9FCDD58D4FE41B74353B79EFA3A7085ED528AB7CE39483A036C3768E
          535E40D98CFB8FDE2B274F79F86721DF9D5D5CC56FA4143D0E891A18C6BAD092
          862144FFFD255A313CA0FDE18C3BA49B93EE3109FB517D3DB8C5A3160C238AB1
          D77DA17833EBF17018C4297A2C05D74277258C088CC1AEF4D0E60EA2063D4D99
          2B71F95D8E4E1B95B395064A0F2D4C4C6B8131FDC3969EDF40087A4CC35AA905
          35E2079C2A337A9C6C8661AEB834471F468B319381D635D647E85C040541800A
          3C1BDCDFCFD333CE61CFAB750DE8ECA79D0131E604A710540C705F51D8E3D9A0
          15BE3F502D993EC398FFEBDA590EE35AC833F88D70DED817A961F64903F70586
          024B0822EF14D3BF0DCFFDEC1ADDFEC6CF7DAE83BCD19FAE815E1C541A9177D0
          CBB23D94FCE773AD3D741D0C0FA0EBDDDF3D46CD1D46F03787B1505F6A28B327
          E22707A725542CACCA532B5FE3ACF54181F0AE612ECB88E706A3E2D80DAE9F89
          F5DCD02B857C8DE786FB83FBB12F3D78A00C5498D01BF1BF207E13C05A04E6B4
          53C5590F2905BB97E7CEA54D4B3A1FDDB11812432F17CA26DCDFC32407432903
          F4EF6BACF36D459D36CAA20DD63B4DDBFDBA0CCC1240AFBAFAB7FD1C2C0FEACF
          91FF30E60D6383CAA6D5DDBCD5CFB056D8A49B4181DED63E1978A7F1DBF08C36
          074B23DD745E7DC130A74942471813546A9127E1487A30C4773A9CBC8F9E49C7
          BCAFCB7C54A4C6924E18C3455EC57B8B7C8415F40E87A00BAE834A0B1CC550A9
          B3F20D7A18A11B6CDA9781F20D5AE73A2FE079F98BB6E6379FEB3C851E99D7F4
          7381ED426F18F2C40EBB6F0F08299459BAE9D0F54928E786783D28B943659CE6
          13E9B530152CA2E9603A8385E5A54EDFC1CB7B2CE8891941EBD49ACAF15E0885
          9EFDF7F85BDED3D20719E0FD009FA33617B2139436825BB5848D36F4B18E218E
          74F0321D8AF21A2804A2CED7BAC0F55B28EB17FE84BFCF7DCEC5FD3FEEE763CB
          81E45B7FAD421B6861E35A305A419D9CD2CDA558C35A8E557F0F0567A8BF0DEF
          BDBFDF669D13F05E3A9C8F0AC906156517B4CEB77E23CF05332EA1FC3687EFE0
          DEEDD61233B4F13A1CE1775146EE51913977BA99F7EDE7A1E219D52A7FBA11E3
          B49A5728DF0D58110D352F84F25C123156712272856D3F94A5D2EC63EAA12C0A
          22243986B9908A35949105332882B4F6D11AB1BAEF250F09420222063A3EA0F6
          69CD03BE533B708CF42D60E9380A5474D9599E7CE8520E161C454801B4F30EC6
          D9D0258FAECAC9188EF0EDAAD453E1E0793DD5767852FC341504C12DC440C701
          ED7401A7253838A0008503CF93740C0E495FE963187BC134A16BADAFE17CA771
          462165C1183416BD477E81F3E6037A7E27864450D943DEC1708A7DC94DBF0E97
          8220781B31D0F103D35AE07803C710B480D0D57DA79F73D1E2C61C68B7E7E009
          090CE587F9649031A607E7CD02CAECC2F63755072D6BCC971EE986839E2008F1
          470C749CD0CE122F1AE67A9F1863466B19DE88189F86130F1C0F10771AAB58AD
          9342557082F2C522CA43988281E94130CC08CA01CF6E78A2C2E90D8E738834F7
          7E7A9861640541F016FF0FEFC3E40BC1DF888A0000000049454E44AE426082}
        PosX = 0
        PosY = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end>
    ListItems = <>
    ListItemsSettings.HTMLFont.Charset = DEFAULT_CHARSET
    ListItemsSettings.HTMLFont.Color = clWindowText
    ListItemsSettings.HTMLFont.Height = -11
    ListItemsSettings.HTMLFont.Name = 'Tahoma'
    ListItemsSettings.HTMLFont.Style = []
    Width = 488
    Height = 277
    TopLayerItems = <>
    OnClick = SplashClick
    Left = 264
    Top = 544
    TMSStyle = 0
  end
  object dsrAllPrepared: TDataSource
    DataSet = tabAllPrepared
    Left = 136
    Top = 176
  end
  object tabAllPrepared: TADOQuery
    Connection = adoDatas
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT [Factures pr'#233'par'#233'es].Modified, [Factures pr'#233'par'#233'es].FileN' +
        'ame, [Factures pr'#233'par'#233'es].FullPath, [Mandat] & IIf(IsNull([Sous-' +
        'Mandat]),""," ") & [Sous-Mandat] & " " & [D'#233'signation] AS M, Man' +
        'dats.Responsable, Mandats.Etat'
      
        'FROM Mandats INNER JOIN [Factures pr'#233'par'#233'es] ON Mandats.IDmandat' +
        ' = [Factures pr'#233'par'#233'es].IDmandat'
      'ORDER BY [Factures pr'#233'par'#233'es].Modified DESC;')
    Left = 136
    Top = 128
  end
  object tabTarifs: TADOTable
    Connection = adoDatas
    CursorType = ctStatic
    Filter = '(Classe>'#39'A'#39') And (Classe<'#39'H'#39') AND (Ann'#233'e=2015)'
    Filtered = True
    TableName = 'Tarifs'
    Left = 562
    Top = 123
  end
  object dsrTarifs: TDataSource
    DataSet = tabTarifs
    Left = 562
    Top = 179
  end
  object popHistory: TJvPopupMenu
    AutoHotkeys = maManual
    Style = msXP
    ImageMargin.Left = 0
    ImageMargin.Top = 0
    ImageMargin.Right = 0
    ImageMargin.Bottom = 0
    ImageSize.Height = 0
    ImageSize.Width = 0
    Left = 482
    Top = 544
  end
  object tabListeDesFactures: TADOTable
    Connection = adoDatas
    TableName = 'Factures pr'#233'par'#233'es'
    Left = 40
    Top = 276
  end
  object AppInfo: TExeInfo
    Version = '1.5.1.0'
    Left = 480
    Top = 608
  end
end
