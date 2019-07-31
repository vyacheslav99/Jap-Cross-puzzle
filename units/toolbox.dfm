object FToolBox: TFToolBox
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1080#1084#1087#1086#1088#1090#1072
  ClientHeight = 385
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  DesignSize = (
    305
    385)
  PixelsPerInch = 96
  TextHeight = 13
  object pGSCross: TPanel
    Left = 0
    Top = 0
    Width = 305
    Height = 248
    BevelOuter = bvNone
    TabOrder = 0
    object Label25: TLabel
      Left = 8
      Top = 6
      Width = 96
      Height = 13
      Caption = #1040#1083#1075#1086#1088#1080#1090#1084' '#1072#1085#1072#1083#1080#1079#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Bevel3: TBevel
      Left = 19
      Top = 23
      Width = 277
      Height = 144
      Shape = bsFrame
    end
    object Label26: TLabel
      Left = 17
      Top = 196
      Width = 273
      Height = 13
      Caption = 
        #1063#1077#1088#1085#1099#1081'                                |                         ' +
        '         '#1041#1077#1083#1099#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object rbnLightness: TRadioButton
      Left = 30
      Top = 32
      Width = 257
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
      Left = 30
      Top = 53
      Width = 257
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
      Left = 30
      Top = 75
      Width = 257
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
      Left = 30
      Top = 97
      Width = 257
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
      Left = 30
      Top = 118
      Width = 257
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
    object rbnMonoPal: TRadioButton
      Left = 30
      Top = 140
      Width = 257
      Height = 17
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1087#1072#1083#1080#1090#1088#1099' '#1074' '#1095'/'#1073
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = rbnLightnessClick
    end
    object chbLightnessBorder: TCheckBox
      Left = 8
      Top = 175
      Width = 202
      Height = 17
      Caption = #1047#1072#1076#1072#1090#1100' '#1087#1086#1088#1086#1075' '#1103#1088#1082#1086#1089#1090#1080' '#1087#1088#1080' '#1072#1085#1072#1083#1080#1079#1077' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = chbLightnessBorderClick
    end
    object trbLightness: TTrackBar
      Left = 8
      Top = 211
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
    object edLightnessBorder: TSpinEdit
      Left = 246
      Top = 173
      Width = 50
      Height = 22
      MaxValue = 255
      MinValue = 1
      TabOrder = 7
      Value = 1
      OnChange = edLightnessBorderChange
    end
  end
  object pColorCross: TPanel
    Left = 0
    Top = 248
    Width = 305
    Height = 52
    BevelOuter = bvNone
    TabOrder = 1
    object Label30: TLabel
      Left = 8
      Top = 6
      Width = 160
      Height = 13
      Hint = 
        #1063#1077#1084' '#1074#1099#1096#1077' '#1079#1085#1072#1095#1077#1085#1080#1077', '#1090#1077#1084' '#1084#1077#1085#1100#1096#1077' '#1087#1088#1086#1084#1077#1078#1091#1090#1086#1095#1085#1099#1093' '#1086#1090#1090#1077#1085#1082#1086#1074' '#1086#1089#1090#1072#1085#1077#1090#1089#1103' (' +
        '1 - '#1086#1089#1090#1072#1074#1080#1090#1100' '#1080#1089#1093#1086#1076#1085#1091#1102')'
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1075#1072#1084#1084#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label31: TLabel
      Left = 8
      Top = 30
      Width = 207
      Height = 13
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1075#1083#1091#1073#1080#1085#1099' '#1094#1074#1077#1090#1072' '#1088#1080#1089#1091#1085#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object chbPxFormat: TComboBox
      Left = 218
      Top = 27
      Width = 78
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
        #1084#1086#1085#1086
        '16 '#1094#1074#1077#1090#1086#1074
        '256 '#1094#1074#1077#1090#1086#1074
        '32 '#1073#1080#1090#1072)
    end
    object edGammaCoeff: TDBNumberEditEh
      Left = 218
      Top = 3
      Width = 78
      Height = 21
      DecimalPlaces = 3
      DynProps = <>
      EditButton.Style = ebsUpDownEh
      EditButton.Visible = True
      EditButtons = <>
      MaxValue = 10.000000000000000000
      MinValue = -10.000000000000000000
      TabOrder = 1
      Value = 1.000000000000000000
      Visible = True
    end
  end
  object pAllCross: TPanel
    Left = 0
    Top = 300
    Width = 305
    Height = 48
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 101
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1082#1088#1086#1089#1089#1074#1086#1088#1076#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label3: TLabel
      Left = 112
      Top = 24
      Width = 40
      Height = 13
      Caption = #1064#1080#1088#1080#1085#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label4: TLabel
      Left = 207
      Top = 24
      Width = 37
      Height = 13
      Caption = #1042#1099#1089#1086#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object chbNegative: TCheckBox
      Left = 8
      Top = 1
      Width = 153
      Height = 17
      Hint = #1055#1086#1089#1083#1077' '#1080#1084#1087#1086#1088#1090#1072' '#1087#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1087#1086#1083#1091#1095#1077#1085#1085#1099#1081' '#1082#1088#1086#1089#1089#1074#1086#1088#1076' '#1074' '#1077#1075#1086' '#1085#1077#1075#1072#1090#1080#1074
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' '#1085#1077#1075#1072#1090#1080#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object edWidth: TSpinEdit
      Left = 154
      Top = 21
      Width = 50
      Height = 22
      MaxValue = 0
      MinValue = 1
      TabOrder = 1
      Value = 0
      OnChange = edLightnessBorderChange
    end
    object edHeight: TSpinEdit
      Left = 246
      Top = 21
      Width = 50
      Height = 22
      MaxValue = 0
      MinValue = 1
      TabOrder = 2
      Value = 0
      OnChange = edLightnessBorderChange
    end
  end
  object btnOK: TBitBtn
    Left = 112
    Top = 354
    Width = 80
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
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
    TabOrder = 3
    OnClick = btnOKClick
  end
end
