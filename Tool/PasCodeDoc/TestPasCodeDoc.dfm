object FormPasDoc: TFormPasDoc
  Left = 192
  Top = 107
  Width = 979
  Height = 551
  Caption = 'Pascal Document'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnExtractFromFile: TButton
    Left = 16
    Top = 16
    Width = 305
    Height = 25
    Caption = 'Open a Pas to Extract'
    TabOrder = 0
    OnClick = btnExtractFromFileClick
  end
  object mmoResult: TMemo
    Left = 336
    Top = 24
    Width = 601
    Height = 481
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnCombineInterface: TButton
    Left = 16
    Top = 480
    Width = 305
    Height = 25
    Caption = 'Combine Interface from Directory'
    TabOrder = 2
    OnClick = btnCombineInterfaceClick
  end
  object tvPas: TTreeView
    Left = 16
    Top = 56
    Width = 305
    Height = 409
    Indent = 19
    TabOrder = 3
    OnDblClick = tvPasDblClick
  end
  object dlgOpen1: TOpenDialog
    Left = 232
    Top = 40
  end
  object dlgSave1: TSaveDialog
    Left = 272
    Top = 40
  end
end
