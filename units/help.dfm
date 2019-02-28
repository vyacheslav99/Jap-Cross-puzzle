object frmHelp: TfrmHelp
  Left = 0
  Top = 0
  Caption = #1055#1086#1084#1086#1097#1100
  ClientHeight = 334
  ClientWidth = 474
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WBrouser: TWebBrowser
    Left = 0
    Top = 0
    Width = 474
    Height = 334
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000FD300000852200000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object ActionList1: TActionList
    Left = 336
    Top = 24
    object aExit: TAction
      Caption = 'aExit'
      ShortCut = 27
      OnExecute = aExitExecute
    end
  end
end
