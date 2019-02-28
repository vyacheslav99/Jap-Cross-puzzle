object frmPrompt: TfrmPrompt
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  ClientHeight = 328
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
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
    Width = 328
    Height = 328
    Align = alClient
    BevelOuter = bvNone
    Caption = '<'#1085#1077#1090'>'
    TabOrder = 0
    object sgPreview: TStringGrid
      Left = 0
      Top = 0
      Width = 328
      Height = 328
      Align = alClient
      ColCount = 9
      DefaultColWidth = 35
      DefaultRowHeight = 35
      Enabled = False
      FixedCols = 0
      RowCount = 9
      FixedRows = 0
      Options = [goVertLine, goHorzLine]
      ScrollBars = ssNone
      TabOrder = 0
      Visible = False
    end
  end
end
