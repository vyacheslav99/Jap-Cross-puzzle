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
