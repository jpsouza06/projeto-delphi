unit UVendasView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Mask, Buttons;

type
  TfrmVendas = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    grbFinalizarVenda: TGroupBox;
    grbGrid: TGroupBox;
    pnlArea: TPanel;
    lblNVenda: TLabel;
    edtNVenda: TEdit;
    lblData: TLabel;
    edtData: TEdit;
    lblCliente: TLabel;
    edtClienteID: TEdit;
    btnCliente: TBitBtn;
    edtNome: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVendas: TfrmVendas;

implementation

{$R *.dfm}


end.
