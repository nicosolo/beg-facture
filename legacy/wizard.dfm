object dlgWizard: TdlgWizard
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Assistant de BEGfacture'
  ClientHeight = 571
  ClientWidth = 894
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object pnlRight: TPanel
    Left = 248
    Top = 0
    Width = 646
    Height = 571
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Bevel3: TBevel
      Left = 2
      Top = 525
      Width = 642
      Height = 1
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitLeft = 1
      ExplicitTop = 441
      ExplicitWidth = 567
    end
    object pnlTitle: TPanel
      Left = 2
      Top = 2
      Width = 642
      Height = 48
      Align = alTop
      Caption = 'Titre'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object pglStep: TJvPageList
      AlignWithMargins = True
      Left = 10
      Top = 58
      Width = 626
      Height = 459
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      ActivePage = Page00
      PropagateEnable = False
      Align = alClient
      OnChange = pglStepChange
      OnChanging = pglStepChanging
      object Page00: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page00'
        OnShow = Page00Show
        object grdFactures: TXDBGrid
          AlignWithMargins = True
          Left = 16
          Top = 40
          Width = 594
          Height = 403
          Margins.Left = 16
          Margins.Top = 0
          Margins.Right = 16
          Margins.Bottom = 16
          Align = alClient
          DataColLineColor = clNone
          DataRowLineColor = clNone
          DataSource = frmMain.dsrFacture
          FillerButton = False
          FillerIndex = -1
          FixedStyle = fsMild
          FixedTheme = ftNone
          Gradient.Options = [goGradient, goHotButton, goHotTrack, goHotColor]
          GridStyle.VisualStyle = vsXPStyle
          HintOptions = [hoTitleHints, hoShowTitleHints, hoEditorHints]
          IndicatorWidth = 12
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgExtendedSelect, dgInternalSelect, dgRowResize, dgRowScroll, dgTitleWidthOff, dgMarkerAutoAlign]
          OptionsEx = [dgBlankRow, dgTotalHeaderBox, dgTotalValuesBox, dgTotalFieldsBox, dgAutoAscendOrder, dgAutoUpdateSequence, dgDelayUpdateSequence, dgAutoUpdateTotals, dgDelayUpdateTotals, dgCalcWholeDataSet, dgCalcSelectedRows, dgDelaySelectedRows, dgSelectedAutoHidden]
          ReadOnly = True
          ResizeOptions = [roColumnResize, roOptimalWidth, roDefaultWidth]
          TabOrder = 0
          WheelScrollRows = 1
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
              Width = 76
            end
            item
              Expanded = False
              FieldName = 'D'#233'signation'
              Title.Caption = 'Mandat'
              TotalFooter.TotalBox = tbFalse
              Visible = True
              Width = 256
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
              Width = 64
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
              Width = 80
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
              Width = 80
            end>
          OrderFields = 'N'
        end
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 626
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          BorderWidth = 8
          TabOrder = 1
          object Label3: TLabel
            AlignWithMargins = True
            Left = 16
            Top = 8
            Width = 72
            Height = 24
            Margins.Left = 8
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alLeft
            Caption = 'Responsable'
            Layout = tlCenter
            ExplicitHeight = 16
          end
          object edtResponsable: TJvDBLookupCombo
            Left = 96
            Top = 8
            Width = 56
            Height = 24
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            LookupField = 'Responsable'
            LookupDisplay = 'Responsable'
            LookupSource = frmMain.dsrResponsables
            TabOrder = 0
            OnChange = edtResponsableChange
          end
          object edtVisa: TAdvComboBox
            Tag = 99
            AlignWithMargins = True
            Left = 513
            Top = 8
            Width = 97
            Height = 24
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 0
            Color = clBtnFace
            Version = '1.5.1.0'
            Visible = True
            Align = alRight
            Style = csDropDownList
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = -1
            LabelCaption = 'Visa'
            LabelPosition = lpLeftCenter
            LabelMargin = 8
            LabelTransparent = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            ParentColor = True
            TabOrder = 1
            TabStop = False
          end
        end
      end
      object Page01: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page01'
        OnShow = Page01Show
        object grdOffres: TAdvColumnGrid
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 594
          Height = 427
          Cursor = crDefault
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 16
          Align = alClient
          ColCount = 5
          Constraints.MinHeight = 1
          Ctl3D = True
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
          ParentCtl3D = False
          ScrollBars = ssNone
          TabOrder = 0
          GridLineColor = 15527152
          GridFixedLineColor = 13947601
          HoverRowCells = [hcNormal, hcSelected]
          OnCanDeleteRow = grdOffresCanDeleteRow
          OnDblClickCell = grdDblClickCell
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
          FixedColWidth = 160
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = []
          FloatFormat = '%.2n'
          FloatingFooter.CalculateHiddenRows = False
          FloatingFooter.Column = 2
          HoverButtons.Buttons = <>
          HoverButtons.Position = hbLeftFromColumnLeft
          Look = glVista
          MouseActions.DirectDateDrop = True
          MouseActions.WheelIncrement = 1
          Navigation.AllowDeleteRow = True
          Navigation.AdvanceOnEnter = True
          Navigation.AdvanceAutoEdit = False
          Navigation.AdvanceAuto = True
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
          ShowSelection = False
          ShowDesignHelper = False
          SortSettings.DefaultFormat = ssAutomatic
          SortSettings.Column = 1
          SortSettings.Show = True
          SortSettings.HeaderColor = 16579058
          SortSettings.HeaderColorTo = 16579058
          SortSettings.HeaderMirrorColor = 16380385
          SortSettings.HeaderMirrorColorTo = 16182488
          VAlignment = vtaCenter
          Version = '3.1.3.6'
          Columns = <
            item
              AutoMinSize = 0
              AutoMaxSize = 0
              Alignment = taLeftJustify
              Borders = []
              BorderPen.Color = clSilver
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
              Width = 254
            end
            item
              AutoMinSize = 0
              AutoMaxSize = 0
              Alignment = taLeftJustify
              Borders = []
              BorderPen.Color = clSilver
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
          ExplicitTop = 24
          ExplicitWidth = 519
          ExplicitHeight = 145
          ColWidths = (
            160
            96
            80
            254
            0)
        end
      end
      object Page02: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page02'
        OnShow = Page02Show
        object grdAdjudications: TAdvColumnGrid
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 594
          Height = 427
          Cursor = crDefault
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 16
          Align = alClient
          ColCount = 5
          Ctl3D = True
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
          ParentCtl3D = False
          ScrollBars = ssNone
          TabOrder = 0
          GridLineColor = 15527152
          GridFixedLineColor = 13947601
          HoverRowCells = [hcNormal, hcSelected]
          OnDblClickCell = grdDblClickCell
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
          FixedColWidth = 160
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = []
          FloatFormat = '%.2n'
          FloatingFooter.CalculateHiddenRows = False
          FloatingFooter.Column = 2
          HoverButtons.Buttons = <>
          HoverButtons.Position = hbLeftFromColumnLeft
          Look = glVista
          MouseActions.DirectDateDrop = True
          MouseActions.WheelIncrement = 1
          Navigation.AllowDeleteRow = True
          Navigation.AdvanceOnEnter = True
          Navigation.AdvanceAutoEdit = False
          Navigation.AdvanceAuto = True
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
          ShowSelection = False
          ShowDesignHelper = False
          SortSettings.DefaultFormat = ssAutomatic
          SortSettings.Column = 1
          SortSettings.Show = True
          SortSettings.HeaderColor = 16579058
          SortSettings.HeaderColorTo = 16579058
          SortSettings.HeaderMirrorColor = 16380385
          SortSettings.HeaderMirrorColorTo = 16182488
          VAlignment = vtaCenter
          Version = '3.1.3.6'
          Columns = <
            item
              AutoMinSize = 0
              AutoMaxSize = 0
              Alignment = taLeftJustify
              Borders = []
              BorderPen.Color = clSilver
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
              Width = 254
            end
            item
              AutoMinSize = 0
              AutoMaxSize = 0
              Alignment = taLeftJustify
              Borders = []
              BorderPen.Color = clSilver
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
          ExplicitLeft = 24
          ExplicitTop = 24
          ExplicitWidth = 519
          ExplicitHeight = 352
          ColWidths = (
            160
            96
            80
            254
            0)
        end
      end
      object Page03: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page03'
        OnShow = Page03Show
        object grdDocuments: TAdvColumnGrid
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 594
          Height = 427
          Cursor = crDefault
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 16
          Align = alClient
          ColCount = 5
          Ctl3D = True
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goTabs]
          ParentCtl3D = False
          ScrollBars = ssNone
          TabOrder = 0
          GridLineColor = 15527152
          GridFixedLineColor = 13947601
          HoverRowCells = [hcNormal, hcSelected]
          OnDblClickCell = grdDblClickCell
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
          FixedColWidth = 200
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = []
          FloatFormat = '%.2n'
          FloatingFooter.CalculateHiddenRows = False
          FloatingFooter.Column = 2
          HoverButtons.Buttons = <>
          HoverButtons.Position = hbLeftFromColumnLeft
          Look = glVista
          MouseActions.DirectDateDrop = True
          MouseActions.WheelIncrement = 1
          Navigation.AllowDeleteRow = True
          Navigation.AdvanceOnEnter = True
          Navigation.AdvanceAutoEdit = False
          Navigation.AdvanceAuto = True
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
          ShowSelection = False
          ShowDesignHelper = False
          SortSettings.DefaultFormat = ssAutomatic
          SortSettings.Column = 1
          SortSettings.Show = True
          SortSettings.HeaderColor = 16579058
          SortSettings.HeaderColorTo = 16579058
          SortSettings.HeaderMirrorColor = 16380385
          SortSettings.HeaderMirrorColorTo = 16182488
          VAlignment = vtaCenter
          Version = '3.1.3.6'
          Columns = <
            item
              AutoMinSize = 0
              AutoMaxSize = 0
              Alignment = taLeftJustify
              Borders = []
              BorderPen.Color = clSilver
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
              Width = 294
            end
            item
              AutoMinSize = 0
              AutoMaxSize = 0
              Alignment = taLeftJustify
              Borders = []
              BorderPen.Color = clSilver
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
          ExplicitLeft = 24
          ExplicitTop = 24
          ExplicitWidth = 519
          ExplicitHeight = 352
          ColWidths = (
            200
            96
            0
            294
            0)
        end
      end
      object Page04: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page04'
        OnShow = Page04Show
        object btnCopyDocs: TSpeedButton
          AlignWithMargins = True
          Left = 16
          Top = 416
          Width = 338
          Height = 27
          Margins.Left = 16
          Margins.Top = 0
          Margins.Right = 272
          Margins.Bottom = 16
          Align = alBottom
          Caption = 'Ajouter la liste des documents '#224' la fin des prestations'
          OnClick = btnCopyDocsClick
          ExplicitTop = 428
          ExplicitWidth = 310
        end
        object edtPrestations: TCurvyMemo
          Tag = 99
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 594
          Height = 396
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 4
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
        end
      end
      object Page05: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page05'
        OnShow = Page05Show
        object btnGetInterval: TSpeedButton
          AlignWithMargins = True
          Left = 16
          Top = 88
          Width = 210
          Height = 25
          Margins.Left = 16
          Margins.Top = 32
          Margins.Right = 400
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Tout facturer'
          OnClick = btnGetIntervalClick
          ExplicitWidth = 135
        end
        object edtPériode: TAdvEdit
          Tag = 99
          AlignWithMargins = True
          Left = 16
          Top = 257
          Width = 594
          Height = 24
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 16
          EmptyTextStyle = []
          ReturnIsTab = True
          Precision = 2
          LabelCaption = 'P'#233'riode de facturation'
          LabelPosition = lpTopLeft
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
          ParentFont = False
          TabOrder = 0
          Text = ''
          Visible = True
          Version = '3.3.2.5'
          ExplicitTop = 273
        end
        object edtA: TAdvDateTimePicker
          AlignWithMargins = True
          Left = 16
          Top = 203
          Width = 210
          Height = 22
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 400
          Margins.Bottom = 16
          Align = alTop
          Date = 41932.705104166660000000
          Format = ''
          Time = 41932.705104166660000000
          DoubleBuffered = True
          Kind = dkDate
          ParentDoubleBuffered = False
          TabOrder = 1
          TabStop = True
          OnChange = edtDateChange
          BorderStyle = bsSingle
          Ctl3D = True
          DateTime = 41932.705104166660000000
          Version = '1.2.2.0'
          LabelCaption = 'Fin de la p'#233'riode de facturation'
          LabelPosition = lpTopLeft
          LabelTransparent = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
        end
        object edtDe: TAdvDateTimePicker
          AlignWithMargins = True
          Left = 16
          Top = 149
          Width = 210
          Height = 22
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 400
          Margins.Bottom = 16
          Align = alTop
          Date = 41932.705104166660000000
          Format = ''
          Time = 41932.705104166660000000
          DoubleBuffered = True
          Kind = dkDate
          ParentDoubleBuffered = False
          TabOrder = 2
          TabStop = True
          OnChange = edtDateChange
          BorderStyle = bsSingle
          Ctl3D = True
          DateTime = 41932.705104166660000000
          Version = '1.2.2.0'
          LabelCaption = 'D'#233'but de la p'#233'riode de facturation'
          LabelPosition = lpTopLeft
          LabelTransparent = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
        end
        object edtObjet: TAdvEdit
          Tag = 99
          AlignWithMargins = True
          Left = 16
          Top = 32
          Width = 594
          Height = 24
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 16
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
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Text = ''
          Visible = True
          Version = '3.3.2.5'
          ExplicitTop = 48
        end
      end
      object Page06: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page06'
        OnShow = Page06Show
        object Label6: TLabel
          AlignWithMargins = True
          Left = 16
          Top = 51
          Width = 594
          Height = 16
          Margins.Left = 16
          Margins.Top = 8
          Margins.Right = 16
          Margins.Bottom = 4
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
        object Label7: TLabel
          AlignWithMargins = True
          Left = 16
          Top = 255
          Width = 594
          Height = 16
          Margins.Left = 16
          Margins.Top = 8
          Margins.Right = 16
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Adresse d'#39'envoi de la facture'
          ExplicitWidth = 166
        end
        object edtAdresse: TCurvyMemo
          Tag = 99
          AlignWithMargins = True
          Left = 16
          Top = 71
          Width = 594
          Height = 160
          Margins.Left = 16
          Margins.Top = 0
          Margins.Right = 16
          Margins.Bottom = 16
          Align = alTop
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
        end
        object edtEnvoi: TCurvyMemo
          Tag = 99
          AlignWithMargins = True
          Left = 16
          Top = 275
          Width = 594
          Height = 160
          Margins.Left = 16
          Margins.Top = 0
          Margins.Right = 16
          Margins.Bottom = 16
          Align = alTop
          TabOrder = 1
          TabStop = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ImeName = ''
          ParentFont = False
          ScrollBars = ssVertical
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 594
          Height = 27
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object btnCopyAddress: TButton
            Left = 258
            Top = 0
            Width = 336
            Height = 27
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 8
            Align = alRight
            Caption = 'Recopie l'#39'adresse de facturation dans l'#39'adresse d'#39'envoi'
            TabOrder = 0
            TabStop = False
            OnClick = btnCopyAddressClick
          end
          object btnLocalCH: TButton
            Left = 0
            Top = 0
            Width = 80
            Height = 27
            Margins.Left = 0
            Margins.Top = 30
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            Caption = 'local.ch'
            TabOrder = 1
            TabStop = False
            OnClick = btnLocalCHClick
          end
        end
      end
      object Page07: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page07'
        OnShow = Page07Show
        object Label1: TLabel
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 594
          Height = 16
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Type de facture'
          ExplicitWidth = 90
        end
        object Label2: TLabel
          AlignWithMargins = True
          Left = 16
          Top = 180
          Width = 594
          Height = 16
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Mode de facturation'
          ExplicitWidth = 114
        end
        object edtType: TColumnListBox
          AlignWithMargins = True
          Left = 16
          Top = 36
          Width = 594
          Height = 68
          Margins.Left = 16
          Margins.Top = 0
          Margins.Right = 16
          Margins.Bottom = 4
          Align = alTop
          Columns = <
            item
              Color = clWindow
              ColumnType = ctText
              Ellipsis = etAtEnd
              Width = 180
              Alignment = taLeftJustify
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              Color = clWindow
              ColumnType = ctText
              Ellipsis = etAtEnd
              Width = 360
              Alignment = taLeftJustify
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
            end>
          ListBoxItems = <
            item
              ImageIndex = -1
              Strings.Strings = (
                'Facture'
                'Facture normale de l'#39'int'#233'gralit'#233' du mandat')
              Tag = 0
            end
            item
              ImageIndex = -1
              Strings.Strings = (
                'Facture finale'
                'Facture finale d'#39'un mandat d'#233'j'#224' partiellement factur'#233)
              Tag = 0
            end
            item
              ImageIndex = -1
              Strings.Strings = (
                'Situation'
                'Facturation des prestations faites '#224' ce jour')
              Tag = 0
            end
            item
              ImageIndex = -1
              Strings.Strings = (
                'Acompte'
                'Montant forfaitaire d'#39'une part des prestations')
              Tag = 0
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          GridLines = False
          IntegralHeight = True
          ItemIndex = 0
          LookupIncr = False
          LookupColumn = 0
          ParentFont = False
          ShowItemHint = False
          SortColumn = 0
          Sorted = False
          TabOrder = 0
          OnClick = edtTypeClick
          Version = '1.2.3.3'
        end
        object edtMode: TColumnListBox
          AlignWithMargins = True
          Left = 16
          Top = 200
          Width = 594
          Height = 68
          Margins.Left = 16
          Margins.Top = 0
          Margins.Right = 16
          Margins.Bottom = 4
          Align = alTop
          Columns = <
            item
              Color = clWindow
              ColumnType = ctText
              Ellipsis = etAtEnd
              Width = 180
              Alignment = taLeftJustify
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              Color = clWindow
              ColumnType = ctText
              Ellipsis = etAtEnd
              Width = 360
              Alignment = taLeftJustify
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
            end>
          ListBoxItems = <
            item
              ImageIndex = -1
              Strings.Strings = (
                'selon donn'#233'es pr'#233'sentes'
                'Le montant calcul'#233' par BEGfacture sert '#224' la facturation')
              Tag = 0
            end
            item
              ImageIndex = -1
              Strings.Strings = (
                'selon offre'
                'L'#39'offre est int'#233'gralement factur'#233'e sans modification')
              Tag = 0
            end
            item
              ImageIndex = -1
              Strings.Strings = (
                'selon facture annex'#233'e'
                'La facture a '#233't'#233' faite dans Excel et est jointe')
              Tag = 0
            end
            item
              ImageIndex = -1
              Strings.Strings = (
                'au forfait (voir notes)'
                'La facture est un montant forfaitaire')
              Tag = 0
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          GridLines = False
          IntegralHeight = True
          ItemIndex = 0
          LookupIncr = False
          LookupColumn = 0
          ParentFont = False
          ShowItemHint = False
          SortColumn = 0
          Sorted = False
          TabOrder = 1
          OnClick = edtModeClick
          Version = '1.2.3.3'
        end
        object lblType: TJvStaticText
          AlignWithMargins = True
          Left = 16
          Top = 112
          Width = 594
          Height = 48
          Margins.Left = 16
          Margins.Top = 4
          Margins.Right = 16
          Margins.Bottom = 4
          Align = alTop
          Alignment = taCenter
          AutoSize = False
          Color = clBtnFace
          Layout = tlCenter
          ParentColor = False
          TabOrder = 2
          TextMargins.X = 0
          TextMargins.Y = 0
          WordWrap = True
        end
      end
      object Page08: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page08'
        object HTMLabel1: THTMLabel
          AlignWithMargins = True
          Left = 32
          Top = 16
          Width = 562
          Height = 427
          Margins.Left = 32
          Margins.Top = 16
          Margins.Right = 32
          Margins.Bottom = 16
          Align = alClient
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          HTMLText.Strings = (
            
              'En principe c'#39'est tout bon, mais il reste encore un peu de trava' +
              'il:<br><br>Allez '#224' l'#39'onglet <b>Pr'#233'paration de la facture et heur' +
              'es r'#233'alis'#233'es</b><br><BR>Puis corrigez les cellules <B>vertes</B>' +
              ' si n'#233'cessaires:<BR><BR>- nombres d'#39'heures par cat'#233'gorie KBOB<BR' +
              '>- prestations compl'#233'mentaires avec les informations d'#233'taill'#233'es<' +
              'BR>- le rabais '#233'ventuel<BR>- les '#233'ventuels frais avec leurs just' +
              'ifications')
          ParentColor = False
          ParentFont = False
          Transparent = True
          Version = '1.9.1.0'
          ExplicitLeft = 9
          ExplicitTop = 56
          ExplicitWidth = 206
          ExplicitHeight = 111
        end
      end
      object Page09: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page09'
        object HTMLabel2: THTMLabel
          AlignWithMargins = True
          Left = 32
          Top = 16
          Width = 562
          Height = 427
          Margins.Left = 32
          Margins.Top = 16
          Margins.Right = 32
          Margins.Bottom = 16
          Align = alClient
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          HTMLText.Strings = (
            
              'En principe c'#39'est tout bon.<BR><BR>Assurez vous que l'#39'offre a bi' +
              'en '#233't'#233' ins'#233'r'#233'e dans la liste (<B>'#233'tape 2</B>), et s'#39'il y a en pl' +
              'usieurs qu'#39'il est bien indiqu'#233' '#224' la comptabilit'#233' la ou lesquelle' +
              's doivent '#234'tre utilis'#233'es.<BR><BR>Jetez quand m'#234'me un oeil  '#224' l'#39'o' +
              'nglet <b>Pr'#233'paration de la facture et heures r'#233'alis'#233'es</b> afin ' +
              'de v'#233'rifier si le buget a '#233't'#233' correctement respect'#233'.')
          ParentColor = False
          ParentFont = False
          Transparent = True
          Version = '1.9.1.0'
          ExplicitLeft = 24
          ExplicitTop = 24
          ExplicitWidth = 519
          ExplicitHeight = 351
        end
      end
      object Page10: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page10'
        OnShow = Page10Show
        object edtPrepare: TAdvEditBtn
          AlignWithMargins = True
          Left = 16
          Top = 48
          Width = 594
          Height = 24
          Margins.Left = 16
          Margins.Top = 32
          Margins.Right = 16
          Margins.Bottom = 16
          EditorEnabled = False
          EmptyTextStyle = []
          Flat = False
          LabelCaption = 'Facture pr'#233'par'#233'e'
          LabelPosition = lpTopLeft
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
          ParentFont = False
          ReadOnly = False
          TabOrder = 0
          Text = ''
          Visible = True
          OnDblClick = edtPrepareDblClick
          Version = '1.3.5.0'
          ButtonStyle = bsButton
          ButtonWidth = 16
          Etched = False
          ButtonCaption = #215
          OnClickBtn = edtPrepareClickBtn
          ExplicitTop = 64
          ExplicitWidth = 595
        end
      end
      object Page11: TJvStandardPage
        Left = 0
        Top = 0
        Width = 626
        Height = 459
        Caption = 'Page11'
        OnShow = Page11Show
        object Label4: TLabel
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 594
          Height = 16
          Margins.Left = 16
          Margins.Top = 16
          Margins.Right = 16
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Notes pour m'#233'moire et remarques '#224' la comptabilit'#233
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 332
        end
        object edtComment: TCurvyMemo
          Tag = 99
          AlignWithMargins = True
          Left = 16
          Top = 36
          Width = 594
          Height = 407
          Margins.Left = 16
          Margins.Top = 0
          Margins.Right = 16
          Margins.Bottom = 16
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
        end
      end
    end
    object pnlBottom: TPanel
      Left = 2
      Top = 526
      Width = 642
      Height = 43
      Align = alBottom
      BevelOuter = bvNone
      Color = 14737632
      ParentBackground = False
      TabOrder = 2
      object btnPrevious: TButton
        AlignWithMargins = True
        Left = 345
        Top = 8
        Width = 75
        Height = 27
        Margins.Left = 0
        Margins.Top = 8
        Margins.Right = 24
        Margins.Bottom = 8
        Align = alRight
        Caption = '<<<'
        TabOrder = 0
        OnClick = btnPreviousClick
      end
      object btnNext: TButton
        AlignWithMargins = True
        Left = 444
        Top = 8
        Width = 75
        Height = 27
        Margins.Left = 0
        Margins.Top = 8
        Margins.Right = 24
        Margins.Bottom = 8
        Align = alRight
        Caption = '>>>'
        TabOrder = 1
        OnClick = btnNextClick
      end
      object btnCancel: TButton
        AlignWithMargins = True
        Left = 543
        Top = 8
        Width = 75
        Height = 27
        Margins.Left = 0
        Margins.Top = 8
        Margins.Right = 24
        Margins.Bottom = 8
        Align = alRight
        Caption = 'Annuler'
        ModalResult = 2
        TabOrder = 2
      end
      object btnExplorer: TButton
        AlignWithMargins = True
        Left = 24
        Top = 8
        Width = 75
        Height = 27
        Margins.Left = 24
        Margins.Top = 8
        Margins.Right = 0
        Margins.Bottom = 8
        Align = alLeft
        Caption = 'Explorer'
        TabOrder = 3
        TabStop = False
        OnClick = btnExplorerClick
      end
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 248
    Height = 571
    Align = alLeft
    BevelInner = bvLowered
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object lblStep: TLabel
      Left = 2
      Top = 2
      Width = 244
      Height = 47
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Etape'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 222
    end
    object lblHelp: THTMLabel
      AlignWithMargins = True
      Left = 10
      Top = 49
      Width = 228
      Height = 264
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 32
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clInfoBk
      GradientType = gtFullVertical
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      HTMLText.Strings = (
        'Explications<UL>Ligne 1</UL><UL>Ligne 2</UL><UL>Ligne 3</UL>')
      ParentColor = False
      ParentFont = False
      Transparent = False
      Version = '1.9.1.0'
      ExplicitLeft = 9
      ExplicitTop = 56
      ExplicitWidth = 206
      ExplicitHeight = 111
    end
    object trvStep: TJvPageListTreeView
      AlignWithMargins = True
      Left = 10
      Top = 345
      Width = 228
      Height = 224
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      AutoExpand = False
      ShowLines = True
      PageDefault = 0
      PageList = pglStep
      Align = alBottom
      HideSelection = False
      HotTrack = True
      ShowRoot = False
      BorderStyle = bsNone
      Indent = 19
      ParentColor = True
      RowSelect = True
      TabOrder = 0
      OnCollapsing = trvStepCollapsing
      Items.Links = {00000000}
    end
  end
  object dftFile: TDropFileTarget
    DragTypes = [dtCopy, dtLink]
    GetDataOnEnter = True
    OnEnter = dftFileEnter
    OnDrop = dftFileDrop
    WinTarget = 0
    MultiTarget = True
    OptimizedMove = True
    Left = 29
    Top = 440
  end
  object dlgMsg: THTMLDialog
    Caption = 'Assistant de BEGfacture'
    CenterButton.Caption = 'Ok'
    CenterButton.Default = True
    CenterButton.ModalResult = 1
    CenterButton.Visible = False
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Height = 200
    LeftButton.ModalResult = 0
    LeftButton.Visible = False
    Position = poScreenCenter
    RightButton.Cancel = True
    RightButton.Caption = 'Ok'
    RightButton.Default = True
    RightButton.ModalResult = 1
    RightButton.Visible = True
    Width = 400
    Version = '1.4.0.0'
    Left = 80
    Top = 440
  end
end
