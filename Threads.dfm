object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 366
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 470
    Top = 306
    Width = 65
    Height = 13
    Caption = 'milissegundos'
  end
  object Label2: TLabel
    Left = 228
    Top = 308
    Width = 94
    Height = 13
    Caption = 'n'#250'mero de threads '
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 662
    Height = 264
    TabOrder = 0
  end
  object edtQtd: TEdit
    Left = 118
    Top = 306
    Width = 96
    Height = 21
    TabOrder = 1
  end
  object edtSleep: TEdit
    Left = 343
    Top = 306
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object btnListar: TButton
    Left = 271
    Top = 333
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 3
    OnClick = btnListarClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 270
    Width = 636
    Height = 17
    TabOrder = 4
  end
end
