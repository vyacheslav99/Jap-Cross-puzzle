object CommonFrame: TCommonFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  TabStop = True
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Color = clWindow
    Ctl3D = True
    ParentColor = False
    ParentCtl3D = False
    TabOrder = 0
    OnMouseWheelDown = ScrollBox1MouseWheelDown
    OnMouseWheelUp = ScrollBox1MouseWheelUp
    OnResize = ScrollBox1Resize
  end
  object OpenDialog: TOpenDialog
    Left = 240
    Top = 38
  end
  object frxPrintList: TfrxReport
    Version = '4.7.91'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbZoom, pbOutline, pbPageSetup, pbNavigator, pbExportQuick]
    PreviewOptions.Maximized = False
    PreviewOptions.Modal = False
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 39891.492531041660000000
    ReportOptions.LastChange = 39891.492531041660000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 208
    Top = 38
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
    end
  end
  object tmrResize: TTimer
    Enabled = False
    OnTimer = tmrResizeTimer
    Left = 145
    Top = 38
  end
  object OpenPicDialog: TOpenPictureDialog
    Left = 270
    Top = 38
  end
  object mtStat: TMemTableEh
    Params = <>
    Left = 176
    Top = 39
    object mtStatGAME: TIntegerField
      FieldName = 'GAME'
    end
    object mtStatDIFF: TIntegerField
      FieldName = 'DIFF'
    end
    object mtStatSZW: TIntegerField
      FieldName = 'SZW'
    end
    object mtStatSZH: TIntegerField
      FieldName = 'SZH'
    end
    object mtStatUSER: TStringField
      FieldName = 'USER'
      Size = 255
    end
    object mtStatNAME: TStringField
      FieldName = 'NAME'
      Size = 255
    end
    object mtStatTIME: TFloatField
      FieldName = 'TIME'
    end
    object mtStatLAST: TIntegerField
      FieldName = 'LAST'
    end
    object mtStatSCORE: TIntegerField
      FieldName = 'SCORE'
    end
  end
end
