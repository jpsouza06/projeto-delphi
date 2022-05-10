unit UVendasView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Mask, Buttons, DB, DBClient,
  Grids, DBGrids, NumEdit, UEnumerationUtil, UCliente, UVendas, ToolEdit,
  UClientesPesqView, UPessoaController, UProdutosPesqView, UProdutosController;

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
    edtDataVenda: TEdit;
    lblCliente: TLabel;
    edtClienteID: TEdit;
    btnCliente: TBitBtn;
    edtClienteNome: TEdit;
    dbgVenda: TDBGrid;
    dtsVenda: TDataSource;
    cdsVenda: TClientDataSet;
    cdsVendaID: TIntegerField;
    cdsVendaDescricao: TStringField;
    cdsVendaUnidade: TStringField;
    cdsVendaQuantidade: TIntegerField;
    cdsVendaPreco: TFloatField;
    cdsVendaTotalProduto: TFloatField;
    btnLimpar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    lblTotalGeral: TLabel;
    btnConsultar: TBitBtn;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnSair: TBitBtn;
    edtTotalVenda: TNumEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnClienteClick(Sender: TObject);
    procedure edtClienteIDExit(Sender: TObject);
    procedure dbgVendaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
     vKey : Word;

     vEstadoTela : TEstadoTela;
     vObjVendas: TVendas;
     vObjCliente: TCliente;

     procedure CamposEnabled(pOpcao : Boolean);
     procedure LimpaTela;
     procedure DefineEstadoTela;

     procedure CarregaDadosTela;

     function PesquisaCliente         : Boolean;
     function ProcessaConsultaCliente : Boolean;

     function PesquisaProduto         : Boolean;
     function ProcessaConsultaProduto : Boolean;

  public
    { Public declarations }
  end;

var
  frmVendas: TfrmVendas;

implementation

uses UMessageUtil, UProdutos;

{$R *.dfm}


procedure TfrmVendas.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Vari�vel para auxiliar o comando de repeti��o
begin
   for i := 0 to pred(ComponentCount) do
   begin
      // Se o campo for do tipo EDIT
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

   end;

   edtDataVenda.Enabled := False;
end;

procedure TfrmVendas.CarregaDadosTela;
begin
   if (vObjVendas <> nil) then
   begin
      edtNVenda.Text      := IntToStr(vObjVendas.Id);
      edtDataVenda.Text   := FloatToStr(vObjVendas.DataVenda);
      edtTotalVenda.Text  := FloatToStr(vObjVendas.TotalVenda);
   end;

   if (vObjCliente <> nil) then
   begin
      edtClienteID.Text   := IntToStr(vObjCliente.Id);
      edtClienteNome.Text := vObjCliente.Nome;
   end;
end;

procedure TfrmVendas.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etConsultar];
   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etConsultar];
   btnLimpar.Enabled := vEstadoTela in [etIncluir, etAlterar];
   btnCliente.Enabled := vEstadoTela in [etIncluir, etAlterar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnabled(False);
         LimpaTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

          if (frmVendas<> nil) and
             (frmVendas.Active) and
             (btnIncluir.CanFocus) then
             btnIncluir.SetFocus;

          Application.ProcessMessages;
      end;

       etIncluir:
       begin
         stbBarraStatus.Panels[0].Text := 'Inclus�o';
         CamposEnabled(True);

         edtNVenda.Enabled := False;

         if edtClienteId.CanFocus then
            edtClienteId.SetFocus;
       end;
   end;

end;

procedure TfrmVendas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
   frmVendas := nil;
end;

procedure TfrmVendas.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmVendas.FormShow(Sender: TObject);
begin
   DefineEstadoTela;

   edtDataVenda.Text := DateTimeToStr(Date);
end;

procedure TfrmVendas.LimpaTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;

      if (Components[i] is TNumEdit) then
         (Components[i] as TNumEdit).Text := EmptyStr;
   end;

   if (vObjVendas <> nil) then
     FreeAndNil(vObjVendas);

   if (vObjCliente <> nil) then
     FreeAndNil(vObjCliente);

   if (not cdsVenda.IsEmpty) then
      cdsVenda.EmptyDataSet;

end;

procedure TfrmVendas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := Key;
   case vKey of
      VK_RETURN: //Corresponde a tecla <ENTER>
      begin
         // Comando respons�vel para passar para o pr�ximo campo do formul�rio
         Perform(WM_NextDlgCtl, 0, 0)
      end;

      VK_ESCAPE:  // Correspondente a tecla <ESC>
      begin
         if (vEstadoTela <> etPadrao) then
         begin
            if (TMessageUtil.Pergunta(
               'Deseja realmente abortar est� opera��o?')) then
            begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
            end;
         end
         else
         begin
             if (TMessageUtil.Pergunta(
                'Deseja sair da rotina?')) then
                Close; // Fechar o formul�rio
         end;
      end;
   end;
end;

procedure TfrmVendas.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmVendas.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmVendas.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if (TMessageUtil.Pergunta('Deseja realmente abortar est� opera��o')) then
         begin
           vEstadoTela := etPadrao;
           DefineEstadoTela;
         end;
   end
   else
      Close;
end;

function TfrmVendas.PesquisaCliente: Boolean;
begin
   stbBarraStatus.Panels[1].Text := 'Pesquisa de cliente';

   if (frmClientesPesq = nil) then
   frmClientesPesq := TfrmClientesPesq.Create(Application);

   frmClientesPesq.ShowModal;

   if (frmClientesPesq.mClienteID <> 0) then
   begin
      edtClienteID.Text := IntToStr(frmClientesPesq.mClienteID);
      edtClienteNome.Text := frmClientesPesq.mClienteNome;

      if (dbgVenda.CanFocus) then
         dbgVenda.SetFocus;
   end
   else
   begin
      if (edtClienteID.CanFocus) then
         edtClienteID.SetFocus;
   end;

   frmClientesPesq.mClienteID   := 0;
   frmClientesPesq.mClienteNome := EmptyStr;

   stbBarraStatus.Panels[1].Text := EmptyStr;
end;

procedure TfrmVendas.btnClienteClick(Sender: TObject);
begin
   PesquisaCliente;
end;

procedure TfrmVendas.edtClienteIDExit(Sender: TObject);
begin
   if (vKey = VK_RETURN) then
   begin
      if (edtClienteID.Text = EmptyStr) then
      begin
         PesquisaCliente;
         Exit;
      end;
      ProcessaConsultaCliente;
   end;

   vKey := VK_CLEAR;
end;

function TfrmVendas.ProcessaConsultaCliente: Boolean;
begin
   try
      Result := False;

      vObjCliente :=
         TCliente( TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(edtClienteId.Text, 0)));


      if (vObjCliente <> nil) then
      begin
         CarregaDadosTela;

         if (dbgVenda.CanFocus) then
            dbgVenda.SetFocus;
      end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum cliente encontrado para o c�digo informado.');

         if (edtClienteId.CanFocus) then
            edtClienteId.SetFocus;

         Exit;
      end;

      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao consultar os dados do cliente [View]. '#13+
            e.Message);
      end;
   end;
end;

function TfrmVendas.PesquisaProduto: Boolean;
begin
   stbBarraStatus.Panels[1].Text := 'Pesquisa de produtos';

   if (frmProdutosPesq = nil) then
   frmProdutosPesq := TfrmProdutosPesq.Create(Application);

   frmProdutosPesq.ShowModal;

   if (frmProdutosPesq.mProdutoID <> 0) then
   begin
      cdsVenda.Append;
      cdsVendaDescricao.Value := frmProdutosPesq.mProduto;
      cdsVendaPreco.Value     := frmProdutosPesq.mProdutoPrecoVenda;
      cdsVenda.Post;
   end
   else
   begin
      if (dbgVenda.CanFocus) then
         dbgVenda.SetFocus;
   end;

   frmProdutosPesq.mProdutoID   := 0;
   frmProdutosPesq.mProduto := EmptyStr;
   frmProdutosPesq.mProdutoPrecoVenda := 0;

   stbBarraStatus.Panels[1].Text := EmptyStr;
end;

function TfrmVendas.ProcessaConsultaProduto: Boolean;
begin

end;

procedure TfrmVendas.dbgVendaKeyPress(Sender: TObject; var Key: Char);
begin
   if (vKey = VK_RETURN) then
   begin
      if (cdsVendaId.Value = 0) then
      begin
         PesquisaProduto;
         Exit;
      end;
      ProcessaConsultaProduto;
   end;

   vKey := VK_CLEAR;
end;

end.
