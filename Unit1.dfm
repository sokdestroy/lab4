object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1058#1088#1072#1089#1089#1072' '#1048#1057#1047
  ClientHeight = 398
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 8
    Width = 236
    Height = 24
    Caption = #1055#1086#1089#1090#1088#1086#1077#1085#1080#1077' '#1090#1088#1072#1089#1089#1099' '#1048#1057#1047' '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 560
    Top = 56
    Width = 146
    Height = 22
    Caption = #1042#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 80
    Top = 56
    Width = 66
    Height = 22
    Caption = #1043#1088#1072#1092#1080#1082
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 424
    Top = 56
    Width = 115
    Height = 22
    Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 424
    Top = 85
    Width = 32
    Height = 19
    Caption = #1044#1072#1090#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 424
    Top = 159
    Width = 42
    Height = 19
    Caption = #1042#1088#1077#1084#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object aPole: TLabeledEdit
    Left = 576
    Top = 104
    Width = 121
    Height = 21
    EditLabel.Width = 68
    EditLabel.Height = 19
    EditLabel.Caption = '               a'
    EditLabel.Font.Charset = RUSSIAN_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 0
  end
  object ePole: TLabeledEdit
    Left = 576
    Top = 144
    Width = 121
    Height = 21
    EditLabel.Width = 67
    EditLabel.Height = 19
    EditLabel.Caption = '               e'
    EditLabel.Font.Charset = RUSSIAN_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 1
  end
  object iPole: TLabeledEdit
    Left = 576
    Top = 184
    Width = 121
    Height = 21
    EditLabel.Width = 64
    EditLabel.Height = 19
    EditLabel.Caption = '               i'
    EditLabel.Font.Charset = RUSSIAN_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 2
  end
  object OmPole: TLabeledEdit
    Left = 576
    Top = 224
    Width = 121
    Height = 21
    EditLabel.Width = 68
    EditLabel.Height = 19
    EditLabel.Caption = '              '#937
    EditLabel.Font.Charset = GREEK_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 3
  end
  object M0Pole: TLabeledEdit
    Left = 576
    Top = 312
    Width = 121
    Height = 21
    EditLabel.Width = 69
    EditLabel.Height = 19
    EditLabel.BiDiMode = bdLeftToRight
    EditLabel.Caption = '            M0'
    EditLabel.Font.Charset = RUSSIAN_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsItalic]
    EditLabel.ParentBiDiMode = False
    EditLabel.ParentFont = False
    TabOrder = 4
  end
  object wPole: TLabeledEdit
    Left = 576
    Top = 267
    Width = 121
    Height = 21
    EditLabel.Width = 67
    EditLabel.Height = 19
    EditLabel.Caption = '              '#969
    EditLabel.Font.Charset = GREEK_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 5
  end
  object startBtn: TButton
    Left = 424
    Top = 295
    Width = 121
    Height = 38
    Caption = #1055#1091#1089#1082
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = startBtnClick
  end
  object dateEdt: TMaskEdit
    Left = 424
    Top = 104
    Width = 118
    Height = 21
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    TabOrder = 7
    Text = '  .  .    '
  end
  object timeEdt: TMaskEdit
    Left = 424
    Top = 184
    Width = 120
    Height = 21
    EditMask = '!99/99/00;1;_'
    MaxLength = 8
    TabOrder = 8
    Text = '  .  .  '
  end
  object tObrPole: TLabeledEdit
    Left = 576
    Top = 361
    Width = 121
    Height = 21
    EditLabel.Width = 81
    EditLabel.Height = 19
    EditLabel.BiDiMode = bdLeftToRight
    EditLabel.Caption = '            T'#1086#1073#1088
    EditLabel.Font.Charset = RUSSIAN_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsItalic]
    EditLabel.ParentBiDiMode = False
    EditLabel.ParentFont = False
    TabOrder = 9
  end
end
