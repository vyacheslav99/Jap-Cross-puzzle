object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 480
  ClientWidth = 663
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    663
    480)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 3
    Top = 439
    Width = 656
    Height = 5
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsFrame
  end
  object pGame: TPanel
    Left = 229
    Top = 23
    Width = 429
    Height = 412
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 5
    Visible = False
    object Label24: TLabel
      Left = 15
      Top = 18
      Width = 100
      Height = 13
      Hint = 
        #1059#1088#1086#1074#1077#1085#1100' '#1089#1083#1086#1078#1085#1086#1089#1090#1080' '#1085#1086#1074#1086#1081' '#1080#1075#1088#1099' ('#1085#1077' '#1091#1095#1080#1090#1099#1074#1072#1077#1090#1089#1103' '#1076#1083#1103' '#1071#1087#1086#1085#1089#1082#1086#1075#1086' '#1082#1088#1086#1089#1089 +
        #1074#1086#1088#1076#1072')'
      Caption = #1059#1088#1086#1074#1077#1085#1100' '#1089#1083#1086#1078#1085#1086#1089#1090#1080
      ParentShowHint = False
      ShowHint = True
    end
    object Bevel6: TBevel
      Left = 10
      Top = 48
      Width = 410
      Height = 5
      Shape = bsFrame
    end
    object chbAutosave: TCheckBox
      Left = 16
      Top = 69
      Width = 166
      Height = 15
      Caption = #1040#1074#1090#1086#1089#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1080#1075#1088#1099
      TabOrder = 1
      OnClick = chbAutosaveClick
    end
    object cbDifficulty: TComboBox
      Left = 127
      Top = 15
      Width = 145
      Height = 21
      Hint = #1059#1088#1086#1074#1077#1085#1100' '#1089#1083#1086#1078#1085#1086#1089#1090#1080' '#1085#1086#1074#1086#1081' '#1080#1075#1088#1099
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Items.Strings = (
        #1054#1095#1077#1085#1100' '#1083#1077#1075#1082#1072#1103
        #1051#1077#1075#1082#1072#1103
        #1053#1086#1088#1084#1072#1083#1100#1085#1072#1103
        #1057#1083#1086#1078#1085#1072#1103
        #1057#1074#1077#1088#1093#1089#1083#1086#1078#1085#1072#1103)
    end
    object edAutosaveInterval: TSpinEdit
      Left = 182
      Top = 66
      Width = 50
      Height = 22
      MaxValue = 100
      MinValue = 1
      TabOrder = 2
      Value = 1
      Visible = False
    end
  end
  object pGeneral: TPanel
    Left = 229
    Top = 23
    Width = 429
    Height = 412
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 10
    Visible = False
    object chbFirstRun: TCheckBox
      Left = 15
      Top = 16
      Width = 202
      Height = 15
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1079#1072#1089#1090#1072#1074#1082#1091' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077
      TabOrder = 0
    end
    object GroupBox4: TGroupBox
      Left = 15
      Top = 66
      Width = 270
      Height = 120
      Caption = ' '#1051#1080#1085#1077#1081#1082#1080' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label9: TLabel
        Left = 13
        Top = 19
        Width = 66
        Height = 13
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 135
        Top = 19
        Width = 80
        Height = 13
        Caption = #1057#1090#1080#1083#1100' '#1083#1080#1085#1077#1081#1082#1080':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Panel2: TPanel
        Left = 13
        Top = 35
        Width = 107
        Height = 77
        BevelOuter = bvNone
        TabOrder = 0
        object rbnRANone: TRadioButton
          Left = 15
          Top = 3
          Width = 68
          Height = 17
          Caption = #1053#1080#1082#1086#1075#1076#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object rbnRAGame: TRadioButton
          Left = 15
          Top = 21
          Width = 68
          Height = 17
          Caption = #1042' '#1080#1075#1088#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object rbnRAEditor: TRadioButton
          Left = 15
          Top = 40
          Width = 88
          Height = 17
          Caption = #1042' '#1088#1077#1076#1072#1082#1090#1086#1088#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object rbnRABoth: TRadioButton
          Left = 15
          Top = 59
          Width = 68
          Height = 17
          Caption = #1042#1077#1079#1076#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
      object Panel3: TPanel
        Left = 135
        Top = 35
        Width = 133
        Height = 75
        BevelOuter = bvNone
        TabOrder = 1
        object rbnRSLine: TRadioButton
          Left = 13
          Top = 3
          Width = 68
          Height = 17
          Caption = #1051#1080#1085#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object rbnRSStroke: TRadioButton
          Left = 13
          Top = 21
          Width = 68
          Height = 17
          Caption = #1055#1091#1085#1082#1090#1080#1088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object rbnRSDot: TRadioButton
          Left = 13
          Top = 40
          Width = 60
          Height = 17
          Caption = #1058#1086#1095#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object rbnRSInversDot: TRadioButton
          Left = 13
          Top = 59
          Width = 116
          Height = 17
          Caption = #1048#1085#1074#1077#1088#1089#1085#1099#1077' '#1090#1086#1095#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
    end
    object chbShowCellsHint: TCheckBox
      Left = 15
      Top = 37
      Width = 235
      Height = 17
      Caption = #1042#1089#1087#1083#1099#1074#1072#1102#1097#1080#1077' '#1087#1086#1076#1089#1082#1072#1079#1082#1080' '#1085#1072#1076' '#1103#1095#1077#1081#1082#1072#1084#1080
      TabOrder = 1
    end
    object bntCreateShortcut: TBitBtn
      Left = 15
      Top = 196
      Width = 111
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1103#1088#1083#1099#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FF000000FF000000FF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFF000000FF000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFF000000FF000000FF000000FFFFFFFFFF0000
        00FFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFFFFFFFFFF000000FF000000FF000000FF0000
        00FFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF000000FF0000
        00FFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFFFFFFFFFF000000FF000000FF000000FF0000
        00FFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
        80FF808080FF808080FF000000FFD2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CA
        BF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00D2CABF00}
      ParentFont = False
      TabOrder = 3
      OnClick = bntCreateShortcutClick
    end
  end
  object pNone: TPanel
    Left = 229
    Top = 23
    Width = 429
    Height = 412
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 4
    object lblPartDescr: TLabel
      Left = 23
      Top = 18
      Width = 68
      Height = 16
      Caption = 'lblPartDescr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object pColors: TPanel
    Left = 229
    Top = 23
    Width = 429
    Height = 412
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 6
    Visible = False
    object GroupBox9: TGroupBox
      Left = 15
      Top = 15
      Width = 306
      Height = 97
      Caption = ' '#1048#1075#1088#1086#1074#1086#1077' '#1087#1086#1083#1077' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label6: TLabel
        Left = 13
        Top = 22
        Width = 55
        Height = 13
        Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 13
        Top = 44
        Width = 91
        Height = 13
        Caption = #1062#1074#1077#1090' '#1083#1080#1085#1080#1081' '#1089#1077#1090#1082#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 13
        Top = 66
        Width = 65
        Height = 13
        Caption = #1062#1074#1077#1090' '#1083#1080#1085#1077#1077#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edRulerColor: TEdit
        Left = 190
        Top = 63
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnClick = edBackgroundColorClick
      end
      object edBackgroundColor: TEdit
        Left = 190
        Top = 19
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        OnClick = edBackgroundColorClick
      end
      object edLinesColor: TEdit
        Left = 190
        Top = 41
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        OnClick = edBackgroundColorClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 15
      Top = 261
      Width = 306
      Height = 97
      Caption = ' '#1056#1080#1089#1091#1085#1086#1082' ('#1071#1087#1086#1085#1089#1082#1080#1081' '#1082#1088#1086#1089#1089#1074#1086#1088#1076') '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label7: TLabel
        Left = 12
        Top = 22
        Width = 95
        Height = 13
        Caption = #1047#1072#1082#1088#1072#1096#1077#1085#1085#1086#1077' '#1087#1086#1083#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 12
        Top = 46
        Width = 107
        Height = 13
        Caption = #1053#1077#1079#1072#1082#1088#1072#1096#1077#1085#1085#1086#1077' '#1087#1086#1083#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 12
        Top = 70
        Width = 90
        Height = 13
        Caption = #1053#1077#1086#1090#1082#1088#1099#1090#1086#1077' '#1087#1086#1083#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edImgPaintColor: TEdit
        Left = 190
        Top = 19
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        OnClick = edBackgroundColorClick
      end
      object edImgNoPaintColor: TEdit
        Left = 190
        Top = 43
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        OnClick = edBackgroundColorClick
      end
      object edImgGrayedColor: TEdit
        Left = 190
        Top = 67
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnClick = edBackgroundColorClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 15
      Top = 123
      Width = 306
      Height = 124
      Caption = ' '#1071#1095#1077#1081#1082#1080' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object Label13: TLabel
        Left = 13
        Top = 22
        Width = 114
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072' '#1086#1089#1085#1086#1074#1085#1086#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 13
        Top = 46
        Width = 154
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 13
        Top = 71
        Width = 105
        Height = 13
        Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1086#1089#1085#1086#1074#1085#1086#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 13
        Top = 95
        Width = 145
        Height = 13
        Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edCapOpenBackColor: TEdit
        Left = 190
        Top = 91
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
        OnClick = edBackgroundColorClick
      end
      object edCapBackColor: TEdit
        Left = 190
        Top = 67
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnClick = edBackgroundColorClick
      end
      object edCapOpenColor: TEdit
        Left = 190
        Top = 43
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        OnClick = edBackgroundColorClick
      end
      object edCapFontColor: TEdit
        Left = 190
        Top = 19
        Width = 100
        Height = 21
        Cursor = crHandPoint
        Hint = #1053#1072#1078#1084#1080' '#1089#1102#1076#1072' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1094#1074#1077#1090#1072
        TabStop = False
        AutoSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        OnClick = edBackgroundColorClick
      end
    end
  end
  object pStyles: TPanel
    Left = 229
    Top = 23
    Width = 429
    Height = 412
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 8
    Visible = False
    object Label27: TLabel
      Left = 21
      Top = 158
      Width = 35
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Bevel4: TBevel
      Left = 10
      Top = 92
      Width = 410
      Height = 5
      Shape = bsFrame
    end
    object Label28: TLabel
      Left = 15
      Top = 104
      Width = 78
      Height = 13
      Caption = #1064#1088#1080#1092#1090' '#1103#1095#1077#1077#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel5: TBevel
      Left = 10
      Top = 185
      Width = 410
      Height = 5
      Shape = bsFrame
    end
    object Label29: TLabel
      Left = 19
      Top = 129
      Width = 42
      Height = 13
      Caption = ' '#1064#1088#1080#1092#1090' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblFontExample: TLabel
      Left = 131
      Top = 104
      Width = 286
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1069#1090#1086' '#1087#1088#1080#1084#1077#1088' '#1096#1088#1080#1092#1090#1072
    end
    object chbAutoCellSize: TCheckBox
      Left = 15
      Top = 14
      Width = 242
      Height = 15
      Hint = #1055#1086#1076#1075#1086#1085#1103#1090#1100' '#1088#1072#1079#1084#1077#1088#1099' '#1103#1095#1077#1077#1082' '#1074' '#1079#1072#1074#1080#1089#1080#1084#1086#1089#1090#1080' '#1086#1090' '#1088#1072#1079#1084#1077#1088#1086#1074' '#1086#1082#1085#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      Caption = #1055#1086#1076#1075#1086#1085#1103#1090#1100' '#1088#1072#1079#1084#1077#1088#1099' '#1103#1095#1077#1077#1082' '#1087#1086#1076' '#1088#1072#1079#1084#1077#1088' '#1086#1082#1085#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = chbAutoCellSizeClick
    end
    object GroupBox2: TGroupBox
      Left = 30
      Top = 35
      Width = 239
      Height = 46
      Caption = ' '#1056#1072#1079#1084#1077#1088#1099' '#1103#1095#1077#1077#1082' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label4: TLabel
        Left = 14
        Top = 20
        Width = 44
        Height = 13
        Caption = #1064#1080#1088#1080#1085#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 133
        Top = 20
        Width = 41
        Height = 13
        Caption = #1042#1099#1089#1086#1090#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edCellWidth: TSpinEdit
        Left = 63
        Top = 17
        Width = 50
        Height = 22
        MaxValue = 100
        MinValue = 8
        TabOrder = 0
        Value = 8
      end
      object edCellHeight: TSpinEdit
        Left = 179
        Top = 16
        Width = 50
        Height = 22
        MaxValue = 100
        MinValue = 8
        TabOrder = 1
        Value = 8
        OnChange = edCellHeightChange
      end
    end
    object GroupBox6: TGroupBox
      Left = 15
      Top = 199
      Width = 328
      Height = 68
      Caption = ' '#1057#1077#1090#1082#1072' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      object Label17: TLabel
        Left = 17
        Top = 41
        Width = 190
        Height = 13
        Caption = #1058#1086#1083#1097#1080#1085#1072' '#1083#1080#1085#1080#1081', '#1088#1072#1079#1076#1077#1083#1103#1102#1097#1080#1093' '#1073#1083#1086#1082#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 17
        Top = 20
        Width = 110
        Height = 13
        Caption = #1058#1086#1083#1097#1080#1085#1072' '#1083#1080#1085#1080#1081' '#1089#1077#1090#1082#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edLinesWidth: TSpinEdit
        Left = 269
        Top = 16
        Width = 50
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxValue = 5
        MinValue = 1
        ParentFont = False
        TabOrder = 0
        Value = 5
      end
      object edFatLineWidth: TSpinEdit
        Left = 269
        Top = 38
        Width = 50
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxValue = 5
        MinValue = 1
        ParentFont = False
        TabOrder = 1
        Value = 5
      end
    end
    object GroupBox7: TGroupBox
      Left = 15
      Top = 279
      Width = 402
      Height = 121
      Caption = ' '#1071#1095#1077#1081#1082#1080' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      object Label20: TLabel
        Left = 17
        Top = 19
        Width = 149
        Height = 13
        Caption = #1057#1090#1080#1083#1100' '#1103#1095#1077#1077#1082' '#1096#1072#1087#1082#1080' '#1086#1089#1085#1086#1074#1085#1086#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label21: TLabel
        Left = 17
        Top = 67
        Width = 190
        Height = 13
        Caption = #1057#1090#1080#1083#1100' '#1103#1095#1077#1077#1082' '#1080#1075#1088#1086#1074#1086#1075#1086' '#1087#1086#1083#1103' '#1086#1089#1085#1086#1074#1085#1086#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 17
        Top = 43
        Width = 189
        Height = 13
        Caption = 'C'#1090#1080#1083#1100' '#1103#1095#1077#1077#1082' '#1096#1072#1087#1082#1080' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label23: TLabel
        Left = 17
        Top = 91
        Width = 230
        Height = 13
        Caption = #1057#1090#1080#1083#1100' '#1103#1095#1077#1077#1082' '#1080#1075#1088#1086#1074#1086#1075#1086' '#1087#1086#1083#1103' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object cbCapCellStyle: TComboBox
        Left = 272
        Top = 16
        Width = 119
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Items.Strings = (
          #1055#1083#1086#1089#1082#1080#1081
          #1042#1099#1087#1091#1082#1083#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1099#1087#1091#1082#1083#1099#1081
          #1042#1086#1075#1085#1091#1090#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1086#1075#1085#1091#1090#1099#1081
          #1042#1086#1075#1085#1091#1090#1072#1103' '#1088#1072#1084#1082#1072
          #1042#1099#1087#1091#1082#1083#1072#1103' '#1088#1072#1084#1082#1072)
      end
      object cbFieldCellStyle: TComboBox
        Left = 272
        Top = 64
        Width = 119
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Items.Strings = (
          #1055#1083#1086#1089#1082#1080#1081
          #1042#1099#1087#1091#1082#1083#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1099#1087#1091#1082#1083#1099#1081
          #1042#1086#1075#1085#1091#1090#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1086#1075#1085#1091#1090#1099#1081
          #1042#1086#1075#1085#1091#1090#1072#1103' '#1088#1072#1084#1082#1072
          #1042#1099#1087#1091#1082#1083#1072#1103' '#1088#1072#1084#1082#1072)
      end
      object cbCapCellChStyle: TComboBox
        Left = 272
        Top = 40
        Width = 119
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Items.Strings = (
          #1053#1077#1090
          #1055#1083#1086#1089#1082#1080#1081
          #1042#1099#1087#1091#1082#1083#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1099#1087#1091#1082#1083#1099#1081
          #1042#1086#1075#1085#1091#1090#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1086#1075#1085#1091#1090#1099#1081
          #1042#1086#1075#1085#1091#1090#1072#1103' '#1088#1072#1084#1082#1072
          #1042#1099#1087#1091#1082#1083#1072#1103' '#1088#1072#1084#1082#1072)
      end
      object cbFieldCellChStyle: TComboBox
        Left = 272
        Top = 88
        Width = 119
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Items.Strings = (
          #1053#1077#1090
          #1055#1083#1086#1089#1082#1080#1081
          #1042#1099#1087#1091#1082#1083#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1099#1087#1091#1082#1083#1099#1081
          #1042#1086#1075#1085#1091#1090#1099#1081
          #1057#1080#1083#1100#1085#1086' '#1074#1086#1075#1085#1091#1090#1099#1081
          #1042#1086#1075#1085#1091#1090#1072#1103' '#1088#1072#1084#1082#1072
          #1042#1099#1087#1091#1082#1083#1072#1103' '#1088#1072#1084#1082#1072)
      end
    end
    object cbFontName: TComboBox
      Left = 66
      Top = 126
      Width = 152
      Height = 21
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnChange = cbFontNameChange
    end
    object GroupBox10: TGroupBox
      Left = 229
      Top = 122
      Width = 190
      Height = 56
      Caption = ' '#1057#1090#1080#1083#1100' '
      TabOrder = 4
      object chbFontBold: TCheckBox
        Left = 10
        Top = 14
        Width = 73
        Height = 17
        Caption = #1046#1080#1088#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbFontNameChange
      end
      object chbFontItalic: TCheckBox
        Left = 10
        Top = 33
        Width = 73
        Height = 17
        Caption = #1050#1091#1088#1089#1080#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsItalic]
        ParentFont = False
        TabOrder = 1
        OnClick = cbFontNameChange
      end
      object chbFontUnderline: TCheckBox
        Left = 85
        Top = 14
        Width = 97
        Height = 17
        Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 2
        OnClick = cbFontNameChange
      end
      object chbFontStrikeout: TCheckBox
        Left = 85
        Top = 33
        Width = 93
        Height = 17
        Caption = #1047#1072#1095#1077#1088#1082#1085#1091#1090#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsStrikeOut]
        ParentFont = False
        TabOrder = 3
        OnClick = cbFontNameChange
      end
    end
    object edFontSize: TSpinEdit
      Left = 66
      Top = 154
      Width = 50
      Height = 22
      MaxValue = 70
      MinValue = 8
      TabOrder = 3
      Value = 8
    end
  end
  object pConfirmations: TPanel
    Left = 229
    Top = 23
    Width = 429
    Height = 412
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 9
    Visible = False
    object Bevel2: TBevel
      Left = 10
      Top = 184
      Width = 410
      Height = 5
      Shape = bsFrame
    end
    object Label1: TLabel
      Left = 15
      Top = 15
      Width = 143
      Height = 13
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 26
      Top = 41
      Width = 115
      Height = 13
      Caption = #1055#1088#1080' '#1089#1090#1072#1088#1090#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    end
    object Label3: TLabel
      Left = 15
      Top = 200
      Width = 99
      Height = 13
      Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox8: TGroupBox
      Left = 26
      Top = 72
      Width = 382
      Height = 74
      Hint = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1080' '#1089#1084#1077#1085#1077' '#1080#1075#1088#1099
      Caption = ' '#1055#1088#1080' '#1074#1099#1073#1086#1088#1077' ('#1089#1084#1077#1085#1077') '#1080#1075#1088#1099' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      object rbnNew: TRadioButton
        Left = 21
        Top = 22
        Width = 129
        Height = 17
        Hint = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1080' '#1089#1084#1077#1085#1077' '#1080#1075#1088#1099
        Caption = #1057#1088#1072#1079#1091' '#1085#1072#1095#1072#1090#1100' '#1085#1086#1074#1091#1102
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object rbnLoad: TRadioButton
        Left = 21
        Top = 43
        Width = 184
        Height = 17
        Hint = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1080' '#1089#1084#1077#1085#1077' '#1080#1075#1088#1099
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1088#1072#1085#1077#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1091#1102
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object rbnRequest: TRadioButton
        Left = 236
        Top = 22
        Width = 72
        Height = 17
        Hint = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1080' '#1089#1084#1077#1085#1077' '#1080#1075#1088#1099
        Caption = #1057#1087#1088#1086#1089#1080#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object rbnNone: TRadioButton
        Left = 236
        Top = 43
        Width = 120
        Height = 17
        Hint = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1080' '#1089#1084#1077#1085#1077' '#1080#1075#1088#1099
        Caption = #1053#1080#1095#1077#1075#1086' '#1085#1077' '#1076#1077#1083#1072#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object cbStartAction: TComboBox
      Left = 161
      Top = 38
      Width = 246
      Height = 21
      Hint = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Items.Strings = (
        #1053#1080#1095#1077#1075#1086' '#1085#1077' '#1076#1077#1083#1072#1090#1100
        #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1102#1102' '#1080#1075#1088#1091
        #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1071#1087#1086#1085#1089#1082#1080#1081' '#1082#1088#1086#1089#1089#1074#1086#1088#1076
        #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1057#1091#1076#1086#1082#1091
        #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1062#1074#1077#1090#1085#1086#1081' '#1071#1087#1086#1085#1089#1082#1080#1081' '#1082#1088#1086#1089#1089#1074#1086#1088#1076)
    end
    object chbCloseGameConfirm: TCheckBox
      Left = 26
      Top = 222
      Width = 263
      Height = 17
      Caption = #1057#1087#1088#1086#1089#1080#1090#1100' '#1087#1088#1080' '#1079#1072#1082#1088#1099#1090#1080#1080' '#1085#1077#1089#1086#1093#1088#1072#1085#1077#1085#1085#1086#1081' '#1080#1075#1088#1099
      TabOrder = 3
    end
    object chbCloseEditorConfirm: TCheckBox
      Left = 26
      Top = 246
      Width = 287
      Height = 17
      Caption = #1057#1087#1088#1086#1089#1080#1090#1100' '#1087#1088#1080' '#1079#1072#1082#1088#1099#1090#1080#1080' '#1085#1077#1089#1086#1093#1088#1072#1085#1077#1085#1085#1086#1075#1086' '#1088#1077#1076#1072#1082#1090#1086#1088#1072
      TabOrder = 4
    end
    object chbFastSudoku: TCheckBox
      Left = 26
      Top = 156
      Width = 231
      Height = 17
      Caption = #1047#1072#1087#1091#1089#1082#1072#1090#1100' '#1089#1091#1076#1086#1082#1091' '#1073#1077#1079' '#1083#1080#1096#1085#1080#1093' '#1074#1086#1087#1088#1086#1089#1086#1074
      TabOrder = 2
    end
  end
  object pImgAnalyse: TPanel
    Left = 229
    Top = 23
    Width = 429
    Height = 412
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 3
    Visible = False
    object Label30: TLabel
      Left = 12
      Top = 301
      Width = 249
      Height = 13
      Hint = 
        #1063#1077#1084' '#1074#1099#1096#1077' '#1079#1085#1072#1095#1077#1085#1080#1077', '#1090#1077#1084' '#1084#1077#1085#1100#1096#1077' '#1087#1088#1086#1084#1077#1078#1091#1090#1086#1095#1085#1099#1093' '#1086#1090#1090#1077#1085#1082#1086#1074' '#1086#1089#1090#1072#1085#1077#1090#1089#1103' (' +
        '1 - '#1086#1089#1090#1072#1074#1080#1090#1100' '#1080#1089#1093#1086#1076#1085#1091#1102')'
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1075#1072#1084#1084#1099' (1 - '#1085#1077' '#1080#1079#1084#1077#1085#1103#1090#1100')'
      ParentShowHint = False
      ShowHint = True
    end
    object Label31: TLabel
      Left = 12
      Top = 326
      Width = 207
      Height = 13
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1075#1083#1091#1073#1080#1085#1099' '#1094#1074#1077#1090#1072' '#1088#1080#1089#1091#1085#1082#1072
    end
    object Label25: TLabel
      Left = 12
      Top = 14
      Width = 318
      Height = 13
      Caption = #1040#1083#1075#1086#1088#1080#1090#1084' '#1072#1085#1072#1083#1080#1079#1072' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' '#1087#1088#1080' '#1089#1086#1079#1076#1072#1085#1080#1080' '#1095'/'#1073' '#1082#1088#1086#1089#1089#1074#1086#1088#1076#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Bevel3: TBevel
      Left = 23
      Top = 34
      Width = 307
      Height = 230
      Shape = bsFrame
    end
    object Label26: TLabel
      Left = 43
      Top = 206
      Width = 270
      Height = 13
      Caption = 
        #1063#1077#1088#1085#1099#1081'                               |                          ' +
        '        '#1041#1077#1083#1099#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object chbOverwriteCells: TCheckBox
      Left = 12
      Top = 350
      Width = 378
      Height = 17
      Hint = 
        #1045#1089#1083#1080' '#1085#1077' '#1086#1090#1084#1077#1095#1077#1085#1086', '#1090#1086' '#1087#1088#1080' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1080' '#1089#1083#1091#1095#1072#1081#1085#1099#1084#1080' '#1079#1085#1072#1095#1077#1085#1080#1103#1084#1080' '#1073#1091#1076#1091#1090' ' +
        #1079#1072#1087#1086#1083#1085#1103#1090#1100#1089#1103' '#1090#1086#1083#1100#1082#1086' '#1087#1091#1089#1090#1099#1077' '#1103#1095#1077#1081#1082#1080' ('#1080#1085#1072#1095#1077' '#1074#1089#1077')'
      Caption = #1055#1077#1088#1077#1079#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1085#1077#1087#1091#1089#1090#1099#1077' '#1103#1095#1077#1081#1082#1080' '#1087#1088#1080' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1080' '#1089#1083#1091#1095#1072#1081#1085#1099#1084' '#1086#1073#1088#1072#1079#1086#1084
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
    end
    object chbNegative: TCheckBox
      Left = 12
      Top = 276
      Width = 257
      Height = 17
      Hint = #1055#1088#1080' '#1080#1084#1087#1086#1088#1090#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1089#1086#1079#1076#1072#1074#1072#1090#1100' '#1082#1088#1086#1089#1089#1074#1086#1088#1076' '#1080#1079' '#1085#1077#1075#1072#1090#1080#1074#1072
      Caption = #1055#1086#1083#1091#1095#1072#1090#1100' '#1085#1077#1075#1072#1090#1080#1074' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1087#1088#1080' '#1080#1084#1087#1086#1088#1090#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object chbPxFormat: TComboBox
      Left = 252
      Top = 323
      Width = 78
      Height = 21
      Style = csDropDownList
      TabOrder = 10
      Items.Strings = (
        #1084#1086#1085#1086
        '16 '#1094#1074#1077#1090#1086#1074
        '256 '#1094#1074#1077#1090#1086#1074
        '32 '#1073#1080#1090#1072)
    end
    object rbnLightness: TRadioButton
      Left = 34
      Top = 42
      Width = 176
      Height = 17
      Caption = #1040#1085#1072#1083#1080#1079' '#1103#1088#1082#1086#1089#1090#1080' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = rbnLightnessClick
    end
    object rbnSaturation: TRadioButton
      Left = 34
      Top = 64
      Width = 176
      Height = 17
      Caption = #1040#1085#1072#1083#1080#1079' '#1085#1072#1089#1099#1097#1077#1085#1085#1086#1089#1090#1080' '#1094#1074#1077#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbnLightnessClick
    end
    object rbnRed: TRadioButton
      Left = 34
      Top = 87
      Width = 192
      Height = 17
      Caption = #1040#1085#1072#1083#1080#1079' '#1082#1088#1072#1089#1085#1086#1075#1086' '#1082#1072#1085#1072#1083#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = rbnLightnessClick
    end
    object rbnGreen: TRadioButton
      Left = 34
      Top = 111
      Width = 192
      Height = 17
      Caption = #1040#1085#1072#1083#1080#1079' '#1079#1077#1083#1077#1085#1086#1075#1086' '#1082#1072#1085#1072#1083#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = rbnLightnessClick
    end
    object rbnBlue: TRadioButton
      Left = 34
      Top = 135
      Width = 192
      Height = 17
      Caption = #1040#1085#1072#1083#1080#1079' '#1089#1080#1085#1077#1075#1086' '#1082#1072#1085#1072#1083#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = rbnLightnessClick
    end
    object chbLightnessBorder: TCheckBox
      Left = 34
      Top = 185
      Width = 229
      Height = 17
      Caption = #1047#1072#1076#1072#1090#1100' '#1087#1086#1088#1086#1075' '#1103#1088#1082#1086#1089#1090#1080' '#1087#1088#1080' '#1072#1085#1072#1083#1080#1079#1077' '
      TabOrder = 6
      OnClick = chbLightnessBorderClick
    end
    object trbLightness: TTrackBar
      Left = 34
      Top = 221
      Width = 289
      Height = 32
      Max = 255
      Min = 1
      Frequency = 10
      Position = 128
      PositionToolTip = ptRight
      TabOrder = 8
      OnChange = trbLightnessChange
    end
    object rbnMonoPal: TRadioButton
      Left = 34
      Top = 158
      Width = 182
      Height = 17
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1087#1072#1083#1080#1090#1088#1099' '#1074' '#1095'/'#1073
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object chbInvertBg: TCheckBox
      Left = 12
      Top = 374
      Width = 185
      Height = 17
      Hint = 
        #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1092#1086#1085' '#1074#1084#1077#1089#1090#1077'  '#1089' '#1088#1080#1089#1091#1085#1082#1086#1084' '#1080#1083#1080' '#1090#1086#1083#1100#1082#1086' '#1088#1080#1089#1091#1085#1086#1082' ('#1094#1074#1077#1090#1085#1086#1081 +
        ' '#1082#1088#1086#1089#1089#1074#1086#1088#1076')'
      Caption = #1048#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1084#1077#1089#1090#1077' '#1089' '#1092#1086#1085#1086#1084
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
    end
    object edLightnessBorder: TSpinEdit
      Left = 267
      Top = 182
      Width = 50
      Height = 22
      MaxValue = 255
      MinValue = 1
      TabOrder = 7
      Value = 1
      OnChange = edLightnessBorderChange
    end
    object edGammaCoeff: TDBNumberEditEh
      Left = 267
      Top = 298
      Width = 63
      Height = 21
      DecimalPlaces = 3
      DynProps = <>
      EditButton.Style = ebsUpDownEh
      EditButton.Visible = True
      EditButtons = <>
      MaxValue = 10.000000000000000000
      MinValue = -10.000000000000000000
      TabOrder = 13
      Value = 1.000000000000000000
      Visible = True
    end
  end
  object tvPartition: TTreeView
    Left = 3
    Top = 3
    Width = 220
    Height = 432
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HideSelection = False
    Images = ilSetTree
    Indent = 19
    ParentFont = False
    ReadOnly = True
    RightClickSelect = True
    RowSelect = True
    ShowButtons = False
    ShowLines = False
    TabOrder = 0
    OnChange = tvPartitionChange
    OnCustomDrawItem = tvPartitionCustomDrawItem
    Items.NodeData = {
      03030000002E0000000200000001000000FFFFFFFFFFFFFFFFFFFFFFFF000000
      000300000001081E0441043D043E0432043D044B043504280000000000000001
      000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000001051E043104490438
      043504260000000000000001000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000
      00000001041804330440043004300000000000000001000000FFFFFFFFFFFFFF
      FFFFFFFFFF000000000000000001091F043E0432043504340435043D04380435
      04320000000200000001000000FFFFFFFFFFFFFFFFFFFFFFFF00000000020000
      00010A1E0444043E0440043C043B0435043D04380435043C0000000000000001
      000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000010F2104420438043B
      0438042000380420004004300437043C04350440044B04280000000000000001
      000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000010526043204350442
      0430042E0000000200000001000000FFFFFFFFFFFFFFFFFFFFFFFF0000000001
      000000010820043504340430043A0442043E0440044400000000000000010000
      00FFFFFFFFFFFFFFFFFFFFFFFF000000000000000001131D0430044104420440
      043E0439043A043804200040043504340430043A0442043E0440043004}
  end
  object btnSave: TBitBtn
    Left = 487
    Top = 448
    Width = 83
    Height = 27
    Anchors = [akRight, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF003194100052A539004A9C2900318C0800FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00319C210052A54200C6F7DE00B5EFC600429C21003194
      1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0039A531004AAD4200ADEFCE009CFFEF009CFFE7009CE7AD00429C
      2100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0039AD4A004AB5520094EFB5008CFFD6007BFFCE007BFFC6008CFFCE0084DE
      9C00399C2100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0042BD
      5A004ABD5A0084E7A5007BF7BD007BF7BD007BEFB5007BF7BD007BF7B50084F7
      BD0073D68400399C2900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0042BD
      630063DE8C006BEF9C0073EFAD007BE7AD004ABD5A005AC66B0084EFB5007BEF
      AD0073EFA5005ACE6B0039A52900FF00FF00FF00FF00FF00FF00FF00FF004AC6
      6B0052DE7B006BE7940073E79C0052C66B0039AD420039AD42005ACE730084EF
      AD0073E79C0063DE8C0042C6520039A53100FF00FF00FF00FF00FF00FF0042C6
      6B004ACE730063DE8C0052CE730042B55200FF00FF00FF00FF0039B54A0063CE
      7B0084E79C006BDE84004AD66B0039BD420039A53900FF00FF00FF00FF00FF00
      FF004AC673004ACE730042C66B00FF00FF00FF00FF00FF00FF00FF00FF0042B5
      520063CE7B0073DE8C0052D66B0031C6420039AD3900FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0042BD5A005ACE73005AD66B0042BD520042AD4A00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0042BD63004AC6630042BD5A00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    ParentFont = False
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnCancel: TBitBtn
    Left = 575
    Top = 448
    Width = 83
    Height = 27
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF000000B5001821BD000808B500FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF000808B5002129BD000000B500FF00FF00FF00FF00FF00FF00FF00FF000008
      C6003142D6008CADFF005A73E7000008BD00FF00FF00FF00FF00FF00FF000808
      BD005A73E7008CB5FF003142D6000008C600FF00FF00FF00FF00FF00FF002131
      D6007394FF007B9CFF007B9CFF005263EF000818CE00FF00FF000818CE00526B
      EF007B9CFF007B9CFF007B9CFF002931D600FF00FF00FF00FF00FF00FF001021
      DE00425AF700526BFF005263FF005A73FF00425AEF001021DE00425AEF00637B
      FF005263FF005A6BFF004A63F7001021DE00FF00FF00FF00FF00FF00FF00FF00
      FF001021E7003142F7003942FF003142FF003952FF00425AFF004252FF003139
      FF003942FF00314AF7001021E700FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF001829EF002131F7001821FF001818F7001821FF001818F7001821
      FF002131F7001829EF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF001831FF001829FF002121F7002129F7002129F7001821
      F7001831FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF001831FF003142FF004A5AFF005263FF005A6BFF005A6BFF005263
      FF00394AFF001831FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF001831FF00394AFF005263FF006373FF00637BFF006373FF006B7BFF00637B
      FF005A6BFF003952FF001831FF00FF00FF00FF00FF00FF00FF00FF00FF002131
      FF00394AFF005A63FF006373FF00738CFF00526BFF002139FF00526BFF007B94
      FF006B84FF006373FF004252FF002131FF00FF00FF00FF00FF00FF00FF002139
      FF00525AFF006373FF00738CFF00526BFF001831FF00FF00FF001831FF005A73
      FF008494FF007384FF005A6BFF002939FF00FF00FF00FF00FF00FF00FF001831
      FF00314AFF006B7BFF00526BFF001831FF00FF00FF00FF00FF00FF00FF001831
      FF005A73FF00738CFF00394AFF001831FF00FF00FF00FF00FF00FF00FF00FF00
      FF001831FF00314AFF002139FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF002139FF00314AFF001831FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    ParentFont = False
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnReset: TBitBtn
    Left = 5
    Top = 448
    Width = 94
    Height = 27
    Anchors = [akRight, akBottom]
    Caption = #1057#1090#1072#1085#1076#1072#1088#1090#1085#1099#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = btnResetClick
  end
  object pCaption: TPanel
    Left = 230
    Top = 3
    Width = 428
    Height = 17
    BevelOuter = bvSpace
    Caption = 'Section title'
    TabOrder = 11
  end
  object ilSetTree: TImageList
    Left = 192
    Top = 8
    Bitmap = {
      494C010103000400080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008425200085263000842520000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008520800086308000852080000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242004242420000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFCE
      CE0000000000007B9C0000B5EF0000C6FF0000B5EF00007B9C00000000000000
      000000000000000000000000000000000000000000000000000000000000EFCE
      FF0000000000009C000000EF000000FF000000EF0000009C0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C8C8C00C6C6C600C6C6C6008C8C8C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008293900189CE70018ADFF0018ADFF0018ADFF00189CE700002131000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000839080018E7310018FF390018FF390018FF390018E73100003100000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000039393900B5B5B500B5B5B500B5B5B500B5B5B500393939000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008314200219CFF0029A5FF00219CFF00219CFF00189CFF00002942000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000842080021FF4A0029FF520021FF520021FF520018F74A00004208000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A4A4A00A5A5A500A5A5A5009C9C9C00A5A5A5004A4A4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000002942001884F700319CFF002194FF00188CFF001884F700002942000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000042080018F7520031FF5A0021FF5A0018FF5A0018F75200004208000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001818180084848400D6D6D600848484007B7B7B00181818000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000182100086BCE0039A5F7002184EF001073EF000863CE00001821000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000021000008CE420039F7630021EF5A0010EF520008CE4200002100000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000292929006B6B6B006B6B6B0029292900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000213100105A9400105AA500184A8C0000183100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000003108001094290010A53900188C390000311000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000393939003939390000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000031313100313939003131310000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000031313100393931003131310000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFC7FFC7F0000FE7FE83FE83F0000
      FC3FF01FF01F0000F81FF01FF01F0000F81FF01FF01F0000F81FF01FF01F0000
      FC3FF83FF83F0000FE7FFC7FFC7F0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object ColorDialog: TColorDialog
    Color = clGray
    CustomColors.Strings = (
      'ColorA=FFFFFFFF'
      'ColorB=FFFFFFFF'
      'ColorC=FFFFFFFF'
      'ColorD=FFFFFFFF'
      'ColorE=FFFFFFFF'
      'ColorF=FFFFFFFF'
      'ColorG=FFFFFFFF'
      'ColorH=FFFFFFFF'
      'ColorI=FFFFFFFF'
      'ColorJ=FFFFFFFF'
      'ColorK=FFFFFFFF'
      'ColorL=FFFFFFFF'
      'ColorM=FFFFFFFF'
      'ColorN=FFFFFFFF'
      'ColorO=FFFFFFFF'
      'ColorP=FFFFFFFF')
    Left = 192
    Top = 40
  end
end
