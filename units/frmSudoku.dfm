inherited FmSudoku: TFmSudoku
  Width = 466
  Height = 326
  ExplicitWidth = 466
  ExplicitHeight = 326
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 266
    Width = 466
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
    ExplicitLeft = -259
    ExplicitTop = 235
    ExplicitWidth = 579
  end
  inherited ScrollBox1: TScrollBox
    Width = 466
    Height = 266
    ExplicitWidth = 466
    ExplicitHeight = 266
  end
  object pTools: TPanel [2]
    Left = 0
    Top = 271
    Width = 466
    Height = 55
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      466
      55)
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 19
      Height = 55
      Anchors = [akLeft, akTop, akBottom]
      Shape = bsFrame
    end
    object bntHidePanel: TSpeedButton
      Left = 1
      Top = 1
      Width = 16
      Height = 16
      Hint = #1057#1082#1088#1099#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1080#1085#1089#1090#1088#1091#1084#1077#1085#1090#1086#1074
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B6008E8484FF665653FF665653FF8E8484FF665653FF665653FF8E84
        84FFBAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600665653FF0000E7FF0000E7FF665653FF0000E7FF0000E7FF6656
        53FFBAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B6008E8484FF665653FF0000E7FF0000E7FF0000E7FF665653FF8E84
        84FFBAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B6008E8484FF665653FF0000E7FF665653FF8E8484FFBAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B6008E8484FF665653FF0000E7FF0000E7FF0000E7FF665653FF8E84
        84FFBAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600665653FF0000E7FF0000E7FF665653FF0000E7FF0000E7FF6656
        53FFBAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B6008E8484FF665653FF665653FF8E8484FF665653FF665653FF8E84
        84FFBAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6
        B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600BAB6B600}
      ParentShowHint = False
      ShowHint = True
      OnClick = bntHidePanelClick
    end
    object chbOverwriteCells: TCheckBox
      Left = 24
      Top = 4
      Width = 96
      Height = 17
      Hint = 
        #1055#1088#1080' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1080' '#1089#1083#1091#1095#1072#1081#1085#1099#1084#1080' '#1079#1085#1072#1095#1077#1085#1080#1103#1084#1080#13#10#1079#1072#1087#1086#1083#1085#1103#1090#1100' '#1074#1089#1077' '#1103#1095#1077#1081#1082#1080' '#1080#1083#1080' '#1090 +
        #1086#1083#1100#1082#1086' '#1087#1091#1089#1090#1099#1077'.'
      Caption = #1047#1072#1087#1086#1083#1085#1103#1090#1100' '#1074#1089#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      WordWrap = True
      OnClick = chbOverwriteCellsClick
    end
  end
  inherited frxPrintList: TfrxReport
    Datasets = <>
    Variables = <>
    Style = <>
  end
end