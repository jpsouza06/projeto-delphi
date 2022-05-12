unit UVendasView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Mask, Buttons, DB, DBClient,
  Grids, DBGrids, NumEdit, UEnumerationUtil, UCliente, UVendas, ToolEdit,
  UClientesPesqView, UPessoaController, UProdutosPesqView, UProdutosController,
  UProdutos, UVendaController;

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
    cdsVenda: TClientDataSet;
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
    procedure btnLimparClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
  private
    { Private declarations }
     vKey : Word;

     vEstadoTela : TEstadoTela;
     vObjVenda: TVenda;
     vObjCliente: TCliente;
     vObjProdutos: TProdutos;

     procedure CamposEnabled(pOpcao : Boolean);
     procedure LimpaTela;
     procedure DefineEstadoTela;
     procedure LimpaGridVenda;

     procedure CarregaDadosTela;

     procedure ProcessaTotalGeral;

     function ProcessaConfirmacao     : Boolean;
     function ProcessaInclusao        : Boolean;

     function ProcessaVenda_Item      : Boolean;
     function ProcessaVenda           : Boolean;
     function ProcessaItem            : Boolean;
     function ValidaVenda             : Boolean;

     function PesquisaCliente         : Boolean;
     function ProcessaConsultaCliente : Boolean;

     function PesquisaProduto         : Boolean;
     function ProcessaConsultaProduto : Boolean;

  public
    { Public declarations }
     mTotalVenda : Double;
  end;

var
  frmVendas: TfrmVendas;

implementation

uses UMessageUtil;

{$R *.dfm}


procedure TfrmVendas.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Variável para auxiliar o comando de repetição
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
   if (vObjVenda <> nil) then
   begin
      edtNVenda.Text      := IntToStr(vObjVenda.Id);
      edtDataVenda.Text   := FloatToStr(vObjVenda.DataVenda);
      edtTotalVenda.Text  := FloatToStr(vObjVenda.TotalVenda);
   end;

   if (vObjCliente <> nil) then
   begin
      edtClienteID.Text   := IntToStr(vObjCliente.Id);
      edtClienteNome.Text := vObjCliente.Nome;
   end;

   if (vObjProdutos <> nil) then
   begin
      cdsVendaDescricao.Value    := vObjProdutos.Descricao;
      cdsVendaUnidade.Value      := 'UN';
      cdsVendaQuantidade.Value   := 1;
      cdsVendaPreco.Value        := vObjProdutos.PrecoVenda;
      cdsVendaTotalProduto.Value := vObjProdutos.PrecoVenda;

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

          if (frmVendas <> nil) and
             (frmVendas.Active) and
             (btnIncluir.CanFocus) then
             btnIncluir.SetFocus;

          Application.ProcessMessages;
      end;

       etIncluir:
       begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnabled(True);

         edtNVenda.Enabled := False;
         edtDataVenda.Text := DateTimeToStr(Date);

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

   if (vObjVenda <> nil) then
     FreeAndNil(vObjVenda);

   if (vObjCliente <> nil) then
     FreeAndNil(vObjCliente);

   if (vObjProdutos <> nil) then
      FreeAndNil(vObjProdutos);

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
         // Comando responsável para passar para o próximo campo do formulário
         Perform(WM_NextDlgCtl, 0, 0)
      end;

      VK_ESCAPE:  // Correspondente a tecla <ESC>
      begin
         if (vEstadoTela <> etPadrao) then
         begin
            if (TMessageUtil.Pergunta(
               'Deseja realmente abortar está operação?')) then
            begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
            end;
         end
         else
         begin
             if (TMessageUtil.Pergunta(
                'Deseja sair da rotina?')) then
                Close; // Fechar o formulário
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
      if (TMessageUtil.Pergunta('Deseja realmente abortar está operação')) then
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
  try
     Result := False;
     stbBarraStatus.Panels[1].Text := 'Pesquisa de cliente';

     if (frmClientesPesq = nil) then
     frmClientesPesq := TfrmClientesPesq.Create(Application);

     frmClientesPesq.ShowModal;

     if (frmClientesPesq.mClienteID <> 0) then
     begin
        edtClienteID.Text := IntToStr(frmClientesPesq.mClienteID);
        edtClienteNome.Text := frmClientesPesq.mClienteNome;

        dbgVenda.SelectedIndex := 0;
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
     Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao consultar os dados do cliente [View]. '#13+
            e.Message);
      end;
   end
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


         dbgVenda.SelectedIndex := 0;
         if (dbgVenda.CanFocus) then
            dbgVenda.SetFocus;
      end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum cliente encontrado para o código informado.');

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
   try
      Result := False;
      stbBarraStatus.Panels[1].Text := 'Pesquisa de produtos';

      if (frmProdutosPesq = nil) then
      frmProdutosPesq := TfrmProdutosPesq.Create(Application);

      frmProdutosPesq.ShowModal;

       if (frmProdutosPesq.mProdutoID <> 0) then
       begin
          if (cdsVenda.RecordCount = 0) then
          begin
             cdsVenda.Append;
             cdsVendaId.Value           := frmProdutosPesq.mProdutoId;
             cdsVendaDescricao.Value    := frmProdutosPesq.mProduto;
             cdsVendaUnidade.Value      := 'UN';
             cdsVendaQuantidade.Value   := 1;
             cdsVendaPreco.Value        := frmProdutosPesq.mProdutoPrecoVenda;
             cdsVendaTotalProduto.Value := frmProdutosPesq.mProdutoPrecoVenda;
             cdsVenda.Post;

          end
          else
          begin
             cdsVenda.Edit;
             cdsVendaId.Value           := frmProdutosPesq.mProdutoId;
             cdsVendaDescricao.Value    := frmProdutosPesq.mProduto;
             cdsVendaUnidade.Value      := 'UN';
             cdsVendaQuantidade.Value   := 1;
             cdsVendaPreco.Value        := frmProdutosPesq.mProdutoPrecoVenda;
             cdsVendaTotalProduto.Value := frmProdutosPesq.mProdutoPrecoVenda;
             cdsVenda.Post;
          end;

          dbgVenda.SelectedIndex := 3;
          if (dbgVenda.CanFocus) then
             dbgVenda.SetFocus;
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
       Result := True;
   except
   on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao consultar os dados do produto [View]. '#13+
            e.Message);
      end;
   end;
end;

function TfrmVendas.ProcessaConsultaProduto: Boolean;
begin
    try
      Result := False;

      vObjProdutos :=
         TProdutos(TProdutosController.getInstancia.BuscaProdutos(
            cdsVendaID.Value));


      if (vObjProdutos <> nil) then
      begin
         CarregaDadosTela;

         dbgVenda.SelectedIndex := 3;
         if (dbgVenda.CanFocus) then
            dbgVenda.SetFocus;
      end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto encontrado para o código informado.');

         if (dbgVenda.CanFocus) then
            dbgVenda.SetFocus;

         Exit;
      end;

      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao consultar os dados do produto [View]. '#13+
            e.Message);
      end;
   end;
end;

procedure TfrmVendas.dbgVendaKeyPress(Sender: TObject; var Key: Char);
   begin
   if (vKey = VK_RETURN) and
      (dbgVenda.SelectedIndex = 0) then
   begin
      if (cdsVendaId.Value = 0) then
      begin
         PesquisaProduto;
         ProcessaTotalGeral;
         Exit;
      end;
      ProcessaConsultaProduto;

      ProcessaTotalGeral;
      Exit;
   end;

   if (vKey = VK_RETURN) and
      (dbgVenda.SelectedIndex = 3) then
   begin

      cdsVenda.Edit;
      cdsVendaTotalProduto.Value :=
      (cdsVendaPreco.Value * cdsVendaQuantidade.Value);
      cdsVenda.Post;

      ProcessaTotalGeral;

      cdsVenda.Last;

      if (cdsVendaId.Value <> 0) then
      begin
         cdsVenda.Append;
         cdsVenda.Post;
      end;

      dbgVenda.SelectedIndex := 0;

      if (dbgVenda.CanFocus) then
         dbgVenda.SetFocus;

   end;

   vKey := VK_CLEAR;
end;

procedure TfrmVendas.LimpaGridVenda;
begin
      mTotalVenda := 0;
      edtTotalVenda.Value := 0;

      if (not cdsVenda.IsEmpty) then
      cdsVenda.EmptyDataSet;

      dbgVenda.SelectedIndex := 0;
      if (dbgVenda.CanFocus) then
         dbgVenda.SetFocus;
end;

procedure TfrmVendas.btnLimparClick(Sender: TObject);
begin
   LimpaGridVenda;
end;

procedure TfrmVendas.ProcessaTotalGeral;
var
   xAux : Integer;
begin
   mTotalVenda := 0;
   cdsVenda.First;
   if (not cdsVenda.IsEmpty) then
   begin
      for xAux := 0 to pred(cdsVenda.RecordCount) do
      begin
         mTotalVenda := mTotalVenda + cdsVendaTotalProduto.Value;
         cdsVenda.Next;
      end;

      edtTotalVenda.Text := FloatToStr(mTotalVenda);
   end;
end;

procedure TfrmVendas.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmVendas.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

function TfrmVendas.ProcessaConfirmacao: Boolean;
begin
   Result := False;
   try
      case vEstadoTela of
         etIncluir: Result := ProcessaInclusao;
//         etAlterar: Result := ProcessaAlteracao;
//         etExcluir: Result := ProcessaExclusao;
//         etConsultar: Result := ProcessaConsulta;
      end;

      if not Result then
         Exit;
   except
      on E: Exception do
         TMessageUtil.Alerta(E.Message)
   end;

   Result := True;
end;

function TfrmVendas.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaVenda_Item then
      begin
         TMessageUtil.Informacao('Venda cadastrada com sucesso.'#13+
         'Codigo cadastrado: '+ IntToStr(vObjVenda.Id));

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao incluir os dados da venda [View]: '#13+
         e.Message);
      end;
   end;
end;

function TfrmVendas.ProcessaVenda_Item: Boolean;
begin
   try
      Result := False;
      if (ProcessaVenda) and
         (ProcessaItem) then
      begin
         // Gravação no BD
         TVendaController.getInstancia.GravaVenda(vObjVenda);

         Result := True;
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao gravar os dados da venda [View]: '#13+
            e.Message);
      end;
   end;
end;

function TfrmVendas.ProcessaVenda: Boolean;
begin
   try
      Result := False;

      if not ValidaVenda then
         Exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjVenda = nil then
            vObjVenda := TVenda.Create;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjVenda = nil then
            Exit;
      end;
      if (vObjVenda = nil) then
         Exit;

      vObjVenda.ID_Cliente := StrToInt(edtClienteID.Text);
      vObjVenda.DataVenda  := StrToDate(edtDataVenda.Text);
      vObjVenda.TotalVenda := mTotalVenda;

      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao processar os dados da Venda [View]. '#13+
         e.Message);
      end;
   end;
end;

function TfrmVendas.ValidaVenda: Boolean;
begin
   Result := False;

   if (edtClienteID.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Código do cliente não pode ficar em branco.');

      if edtClienteID.CanFocus then
         edtClienteID.SetFocus;
      Exit;
   end;

   if (edtClienteNome.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Nome do cliente não pode ficar em branco.');

      if edtClienteNome.CanFocus then
         edtClienteNome.SetFocus;
      Exit;
   end;
   Result := True;
end;
function TfrmVendas.ProcessaItem: Boolean;
begin
   
end;

end.
