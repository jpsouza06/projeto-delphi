object frmVendas: TfrmVendas
  Left = 387
  Top = 137
  Width = 729
  Height = 602
  Caption = 'Vendas'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  KeyPreview = True
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object stbBarraStatus: TStatusBar
    Left = 0
    Top = 544
    Width = 713
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 463
    Width = 713
    Height = 81
    Align = alBottom
    TabOrder = 1
  end
  object grbFinalizarVenda: TGroupBox
    Left = 0
    Top = 384
    Width = 713
    Height = 79
    Align = alBottom
    Caption = 'Finalizar Venda'
    TabOrder = 2
  end
  object grbGrid: TGroupBox
    Left = 0
    Top = 112
    Width = 713
    Height = 272
    Align = alBottom
    TabOrder = 3
  end
  object pnlArea: TPanel
    Left = 0
    Top = 0
    Width = 713
    Height = 112
    Align = alClient
    TabOrder = 4
    object lblNVenda: TLabel
      Left = 24
      Top = 24
      Width = 49
      Height = 17
      Caption = 'N'#170' Venda'
    end
    object lblData: TLabel
      Left = 24
      Top = 66
      Width = 23
      Height = 13
      Caption = 'Data'
    end
    object lblCliente: TLabel
      Left = 168
      Top = 45
      Width = 32
      Height = 13
      Caption = 'Cliente'
    end
    object edtNVenda: TEdit
      Left = 80
      Top = 21
      Width = 62
      Height = 21
      TabOrder = 0
    end
    object edtData: TEdit
      Left = 80
      Top = 63
      Width = 62
      Height = 21
      TabOrder = 1
    end
    object edtClienteID: TEdit
      Left = 209
      Top = 42
      Width = 62
      Height = 21
      TabOrder = 2
    end
    object btnCliente: TBitBtn
      Left = 280
      Top = 39
      Width = 25
      Height = 25
      TabOrder = 3
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFBAE3C170CE8426B7461DB9401DB94026B74670CE84BAE3C1FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FDFA4EB86119C1401FCE4C24DC5827
        DD5C27DD5C24DC581FCE4C19C1404EB861F9FDFAFFFFFFFFFFFFFFFFFFFAFDFB
        21A93A1ED04E22D55521D35503B82C00A71200A71203B82C21D35522D5551ED0
        4E21A93AFAFDFBFFFFFFFFFFFF4DB15A1ECE4D21D3541FCC4D0FCC4500AD13FF
        FFFFFFFFFF00AD130FCC451FCC4D21D3541ECE4D4DB15AFFFFFFBCDEBE17BA3F
        21DA5A1ECC5120D0530DC74200BE25FFFFFFFFFFFF00BE250DC74220D0531ECC
        5121DA5A17BA3FBCDEBE6ABB7317D15120D45F0BCC4A04CA4300C13300BC22FF
        FFFFFFFFFF00BD2700C23B10CA4B0ECC4C20D45F17D1516ABB7330A03E33E67A
        00B62D00AD1300AD1300AD1300AD13FFFFFFFFFFFF00AD1300BD2700BD2300AD
        1300B62D33E67A30A14030A34281FCC300AF21FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00AF2181FCC430A04122943685FDCC
        2AC262FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF2AC26285FDCC22943532923C7BFAC33CD07D71C7801EBF5921C05B0ABA4DFF
        FFFFFFFFFF10BC5122C05C1EBF5971C7803CD07D7BFAC332923C67AA668AE5B9
        65EAB050DF9756DF9C41DB8D22C05CFFFFFFFFFFFF22C05C49DC9356DF9C50DF
        9765EAB08AE5B967AA66B9D3B94EB068AFFFEA5EE0A156E19F45DE9766D589FF
        FFFFFFFFFF23C05B50E09E56E19F5EE0A1AFFFEA4EB068B9D3B9FFFFFF458845
        7BDCA8B6FFEF76E5B551DFA366D589FFFFFFFFFFFF24BF5956E2A876E5B5B6FF
        EF7BDCA8458845FFFFFFFFFFFFFAFCFA1572156DD6A3B7FFF5AAF7E370E0B022
        C05C22C05C74E2B3ABF7E4B7FFF56DD6A3157215FAFCFAFFFFFFFFFFFFFFFFFF
        F9FBF945854538A75E7FE1B8A9FFECB9FFFBB9FFFBA9FFEC7FE1B838A75E4585
        45F9FBF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB7CDB767A567247C3228
        8637288637247C3267A567B7CDB7FFFFFFFFFFFFFFFFFFFFFFFF}
    end
    object edtNome: TEdit
      Left = 320
      Top = 42
      Width = 345
      Height = 21
      TabOrder = 4
    end
  end
end
