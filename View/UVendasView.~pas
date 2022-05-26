unit UVendasView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Mask, Buttons, DB, DBClient,
  Grids, DBGrids, NumEdit, UEnumerationUtil, UCliente, UVendas, ToolEdit,
  UClientesPesqView, UPessoaController, UProdutosPesqView, UProdutosController,
  UProdutos, UVendaController, UVendaItem, UVendasPesqView, frxClass,
  frxDBSet;

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
    btnListar: TBitBtn;
    cdsListagemVenda: TClientDataSet;
    frxListagemVenda: TfrxReport;
    frxDBVenda: TfrxDBDataset;
    cdsListagemVendaData: TStringField;
    cdsListagemVendaID_Cliente: TStringField;
    cdsListagemVendaClienteNome: TStringField;
    cdsListagemVendaTotalVenda: TFloatField;
    cdsListagemVendaID: TStringField;
    frxDBVendaItens: TfrxDBDataset;
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
    procedure btnAlterarClick(Sender: TObject);
    procedure edtNVendaExit(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure dbgVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnListarClick(Sender: TObject);
  private
    { Private declarations }
     vKey : Word;

     vEstadoTela : TEstadoTela;
     vObjVenda: TVenda;
     vObjColVendaItem : TColVendaItem;
     vObjCliente: TCliente;
     vObjProdutos: TProdutos;

     procedure CamposEnabled(pOpcao : Boolean);
     procedure LimpaTela;
     procedure DefineEstadoTela;
     procedure LimpaGridVenda;

     procedure CarregaDadosVenda;
     procedure CarregaDadosCliente;
     procedure CarregaDadosProduto;

     procedure ProcessaTotalGeral;

     function ProcessaConfirmacao     : Boolean;
     function ProcessaInclusao        : Boolean;
     function ProcessaAlteracao       : Boolean;
     function ProcessaConsulta        : Boolean;
     function ProcessaListagem        : Boolean;

     function ProcessaVenda_Item      : Boolean;
     function ProcessaVenda           : Boolean;
     function ProcessaItem            : Boolean;

     function ValidaVenda             : Boolean;
     function ValidaItem              : Boolean;

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
   dbgVenda.Enabled := pOpcao;
end;

procedure TfrmVendas.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);
   btnListar.Enabled    := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etConsultar, etListar];
   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etConsultar, etListar];
   btnLimpar.Enabled := vEstadoTela in [etIncluir];
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

       etAlterar:
       begin
          stbBarraStatus.Panels[0].Text := 'Alteração';

          if (edtNVenda.Text <> EmptyStr) then
          begin
             CamposEnabled(True);

             edtNVenda.Enabled    := False;
             btnAlterar.Enabled   := False;
             btnConfirmar.Enabled := True;

             dbgVenda.SelectedIndex := 0;
             if (dbgVenda.CanFocus) then
                dbgVenda.SetFocus;
          end
          else
          begin
             lblNVenda.Enabled := True;
             edtNVenda.Enabled := True;

             if (edtNVenda.CanFocus) then
                edtNVenda.SetFocus;
          end;
       end;

       etConsultar:
       begin
          stbBarraStatus.Panels[0].Text := 'Consulta';

          CamposEnabled(False);

          if (edtNVenda.Text <> EmptyStr) then
          begin
             edtNVenda.Enabled  := False;
             btnAlterar.Enabled := True;
             btnConfirmar.Enabled := False;

             if (btnAlterar.CanFocus) then
                btnAlterar.SetFocus;
          end
          else
          begin
             lblNVenda.Enabled := True;
             edtNVenda.Enabled := True;

             if (edtNVenda.CanFocus) then
                edtNVenda.SetFocus;
          end;
       end;

       etPesquisar:
       begin
          stbBarraStatus.Panels[0].Text := 'Pesquisa';

          if (frmVendasPesq = nil) then
             frmVendasPesq := TfrmVendasPesq.Create(Application);

          frmVendasPesq.ShowModal;

          if (frmVendasPesq.mVendaID <> 0) then
          begin
             edtNVenda.Text := IntToStr(frmVendasPesq.mVendaID);

             if (frmVendasPesq.mClienteID <> 0) then
                edtClienteID.Text := IntToStr(frmVendasPesq.mClienteID);

             vEstadoTela := etConsultar;
             ProcessaConsulta;
          end
          else
          begin
             vEstadoTela := etPadrao;
             DefineEstadoTela;
          end;

          frmVendasPesq.mVendaID   := 0;
          frmVendasPesq.mClienteID := 0;

       end;

       etListar:
       begin
          stbBarraStatus.Panels[0].Text := 'Listar';

          if (edtNVenda.Text <> EmptyStr) then
             ProcessaListagem
          else
          begin
             lblNVenda.Enabled := True;
             edtNVenda.Enabled := True;

             if edtNVenda.CanFocus then
                edtNVenda.SetFocus;
          end;
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

     if(frmClientesPesq = nil) then
     begin
       if(edtClienteID.CanFocus) then
          edtClienteID.SetFocus;

          Exit;
     end;

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

     if (frmClientesPesq = nil ) then
        Exit;

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

         vKey := VK_CLEAR;
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
         CarregaDadosCliente;


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

      if(frmProdutosPesq = nil) then
      begin
          cdsVenda.First;

          if (dbgVenda.CanFocus) then
             dbgVenda.SetFocus;

         Exit;
      end;


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
         CarregaDadosProduto;

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
         etAlterar: Result := ProcessaAlteracao;
         etConsultar: Result := ProcessaConsulta;
         etListar: Result := ProcessaListagem;
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

         edtNVenda.Text := IntToStr(vObjVenda.Id);

         if (TMessageUtil.Pergunta('Deseja imprimir a nota?')) then
            ProcessaListagem;

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
         TVendaController.getInstancia.GravaVenda(
            vObjVenda, vObjColVendaItem);

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
var
   xVendaItem : TVendaItem;
   xID_Venda : Integer;
   i : Integer;
begin
   try
      Result := False;

      xID_Venda := 0;

      if (not ValidaItem) then
         Exit;

      if (vObjColVendaItem <> nil) then
         FreeAndNil(vObjColVendaItem);

      vObjColVendaItem := TColVendaItem.Create;

      if vEstadoTela = etAlterar then
         xID_Venda := StrToIntDef(edtNVenda.Text, 0);

      cdsVenda.Last;
      if (cdsVendaID.Value = 0) then
         cdsVenda.Delete;

      cdsVenda.First;
      for i := 0 to pred(cdsVenda.RecordCount) do
      begin
         xVendaItem               := TVendaItem.Create;
         xVendaItem.ID_Venda      := xID_Venda;
         xVendaItem.ID_Produto    := cdsVendaId.Value;
         xVendaItem.Quantidade    := cdsVendaQuantidade.Value;
         xVendaItem.ValorUnitario := cdsVendaPreco.Value;
         xVendaItem.TotalItem     := cdsVendaTotalProduto.Value;

         cdsVenda.Next;
         vObjColVendaItem.Add(xVendaItem);
      end;

      cdsVenda.Last;

      if (cdsVendaID.Value = 0) then
      begin
         cdsVenda.Delete;
      end;

      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao preencher os dados de endereço do cliente [View]. '#13+
         e.Message)
      end;
   end;
end;

procedure TfrmVendas.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmVendas.edtNVendaExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

function TfrmVendas.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtNVenda.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Código da venda não pode ficar em branco.');

         if (edtNVenda.CanFocus) then
            edtNVenda.SetFocus;

         Exit;
      end;

      vObjVenda :=
         TVenda(TVendaController.getInstancia.BuscaVenda(
            StrToIntDef(edtNVenda.Text, 0)));

      vObjColVendaItem :=
         TVendaController.getInstancia.BuscaVendaItem(
            StrToIntDef(edtNVenda.Text, 0));


      if (vObjVenda <> nil) then
      begin
         CarregaDadosVenda;
         ProcessaConsultaCliente;
      end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhuma venda encontrada para o código informado.');

         LimpaTela;

         if (edtNVenda.CanFocus) then
            edtNVenda.SetFocus;

         Exit;
      end;

      DefineEstadoTela;

      if (vObjColVendaItem <> nil) then
         FreeAndNil(vObjColVendaItem);

      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao consultar os dados da venda [View]. '#13+
            e.Message);
      end;
   end;
end;

procedure TfrmVendas.CarregaDadosCliente;
begin
   if (vObjCliente <> nil) then
   begin
      edtClienteID.Text   := IntToStr(vObjCliente.Id);
      edtClienteNome.Text := vObjCliente.Nome;
   end;
end;

procedure TfrmVendas.CarregaDadosProduto;
begin
   if (vObjColVendaItem <> nil) and
      (vObjProdutos <> nil) then
   begin
      cdsVenda.Edit;
      cdsVendaDescricao.Value    := vObjProdutos.Descricao;
      cdsVendaUnidade.Value      := 'UN';
      cdsVendaPreco.Value        := vObjProdutos.PrecoVenda;
      cdsVenda.Post;
   end
   else if(vObjProdutos <> nil) then
   begin
      cdsVenda.Edit;
      cdsVendaDescricao.Value    := vObjProdutos.Descricao;
      cdsVendaUnidade.Value      := 'UN';
      cdsVendaQuantidade.Value   := 1;
      cdsVendaPreco.Value        := vObjProdutos.PrecoVenda;
      cdsVendaTotalProduto.Value := cdsVendaPreco.Value * cdsVendaQuantidade.Value;
      cdsVenda.Post;
   end;
end;

procedure TfrmVendas.CarregaDadosVenda;
var
   i : Integer;
begin
   if (vObjVenda <> nil) then
   begin
      edtNVenda.Text      := IntToStr(vObjVenda.Id);
      edtDataVenda.Text   := DateToStr(vObjVenda.DataVenda);
      edtTotalVenda.Text  := FloatToStr(vObjVenda.TotalVenda);
      edtClienteID.Text   := IntToStr(vObjVenda.ID_Cliente);
   end;

   if (vObjColVendaItem <> nil) then
   begin
      cdsVenda.First;
      for  i:= 0 to pred(vObjColVendaItem.Count) do
      begin
         cdsVenda.Edit;

         cdsVendaID.Value           := vObjColVendaItem.Retorna(i).Id_Produto;
         cdsVendaQuantidade.Value   := vObjColVendaItem.Retorna(i).Quantidade;
         cdsVendaTotalProduto.Value := vObjColVendaItem.Retorna(i).TotalItem;
         ProcessaConsultaProduto;

         cdsVenda.Append;
      end;

      Exit;
   end;
end;

function TfrmVendas.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if (edtNVenda.Text = EmptyStr) then
      begin
         ProcessaConsulta;
         Exit;
      end;

      if ProcessaVenda_Item then
      begin
        TMessageUtil.Informacao('Dados alterados com sucesso.');

        vEstadoTela := etPadrao;
        DefineEstadoTela;
        Result := True
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao alterar os dados da venda [View]: '#13+
            e.Message)
      end;
   end;
end;

procedure TfrmVendas.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmVendas.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

function TfrmVendas.ValidaItem: Boolean;
begin
   Result := False;

   cdsVenda.First;
   if (cdsVendaID.Value = 0) then
   begin
      TMessageUtil.Alerta('Venda não pode ser cadastrada sem produtos');

      if (dbgVenda.CanFocus) then
         dbgVenda.SetFocus;

      Exit;
   end;

   Result := True;
end;

procedure TfrmVendas.dbgVendaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (vKey = 46) then
   begin
      cdsVenda.Delete;

      dbgVenda.SelectedIndex := 0;
      cdsVenda.Last;
      if (dbgVenda.CanFocus) then
         dbgVenda.SetFocus;
   end;
end;

function TfrmVendas.ProcessaListagem: Boolean;
begin
   try
      Result := False;
      if (not cdsListagemVenda.Active) then
         Exit;

      cdsVenda.Open;
      cdsVenda.First;

      if (cdsVendaID.Value = 0) then
      begin
         ProcessaConsulta;
         Exit;
      end;

      cdsListagemVenda.Append;

      cdsListagemVendaID.Value         := edtNVenda.Text;
      cdsListagemVendaData.Value       := edtDataVenda.Text;
      cdsListagemVendaID_Cliente.Value := edtClienteID.Text;
      cdsListagemVendaClienteNome.Text := edtClienteNome.Text;
      cdsListagemVendaTotalVenda.Value := edtTotalVenda.Value;

      cdsListagemVenda.Post;




      frxListagemVenda.Variables['DATAHORA']    :=
         QuotedStr(FormatDateTime('DD/MM/YYYY hh:mm', Date + Time));

      frxListagemVenda.ShowReport();

   finally
      vEstadoTela := etPadrao;
      DefineEstadoTela;
      cdsListagemVenda.EmptyDataSet;

      Result := True;
   end;
end;

procedure TfrmVendas.btnListarClick(Sender: TObject);
begin
   vEstadoTela := etListar;
   DefineEstadoTela;
end;

end.
