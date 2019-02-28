object fmPrompt: TfmPrompt
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  ClientHeight = 310
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pPreviewArea: TPanel
    Left = 0
    Top = 0
    Width = 340
    Height = 310
    Align = alClient
    BevelOuter = bvNone
    Caption = '<'#1085#1077#1090'>'
    TabOrder = 0
    object bmPreview: TImage
      Left = 0
      Top = 0
      Width = 650
      Height = 650
    end
  end
end
