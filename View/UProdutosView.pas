unit UProdutosView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, UEnumerationUtil, UProdutos,
  UProdutosController, UProdutosPesqView;

type
  TfrmProdutos = class(TForm)
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    btnExcluir: TBitBtn;
    btnPesquisar: TBitBtn;
    btnAlterar: TBitBtn;
    btnIncluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnSair: TBitBtn;
    btnCancelar: TBitBtn;
    btnConfirmar: TBitBtn;
    stbBarraStatus: TStatusBar;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    lblEstoque: TLabel;
    edtEstoque: TEdit;
    lblPrecoVenda: TLabel;
    edtPrecoVenda: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtEstoqueKeyPress(Sender: TObject; var Key: Char);
    procedure edtPrecoVendaKeyPress(Sender: TObject; var Key: Char);
    procedure btnConsultarClick(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
      vKey : Word;

     vEstadoTela : TEstadoTela;
     vObjProdutos: TProdutos;

     procedure CamposEnabled(pOpcao : Boolean);
     procedure LimpaTela;
     procedure DefineEstadoTela;

     procedure CarregaDadosTela;

     function ProcessaConfirmacao : Boolean;
     function ProcessaInclusao    : Boolean;
     function ProcessaAlteracao   : Boolean;
     function ProcessaExclusao    : Boolean;
     function ProcessaConsulta    : Boolean;

     function ProcessaProdutos    : Boolean;

     function ProcessaProduto     : Boolean;
     function ValidaProduto       : Boolean;

  public
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;

implementation

uses
   uMessageUtil, UClassFuncoes;

{$R *.dfm}

procedure TfrmProdutos.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Variável para auxiliar o comando de repetição
begin
   for i := 0 to pred(ComponentCount) do
   begin
      // Se o campo for do tipo EDIT
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

   end;
end;

procedure TfrmProdutos.CarregaDadosTela;
begin
   if (vObjProdutos = nil) then
      Exit;

   edtCodigo.Text     := IntToStr(vObjProdutos.Id);
   edtDescricao.Text  := vObjProdutos.Descricao;
   edtEstoque.Text    := FloatToStr(vObjProdutos.QuantidadeEstoque);
   edtPrecoVenda.Text := FloatToStr(vObjProdutos.PrecoVenda)

end;

procedure TfrmProdutos.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];
   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnabled(False);
         LimpaTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

          if (frmProdutos<> nil) and
             (frmProdutos.Active) and
             (btnIncluir.CanFocus) then
             btnIncluir.SetFocus;

          Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         if (edtDescricao.CanFocus) then
            edtDescricao.SetFocus
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text := 'Alteração';
         CamposEnabled(False);

         if (edtCodigo.Text <> EmptyStr) then
         begin
            CamposEnabled(True);

            edtCodigo.Enabled    := False;
            btnAlterar.Enabled   := False;
            btnConfirmar.Enabled := True;

            if (edtDescricao.CanFocus) then
               edtDescricao.SetFocus;
         end
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               edtCodigo.SetFocus;
         end;
      end;

      etExcluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Exclusão';

         CamposEnabled(False);

         if (edtCodigo.Text <> EmptyStr) then
            ProcessaExclusao
         else
         begin
         lblCodigo.Enabled := True;
         edtCodigo.Enabled := True;

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;
         end;
      end;

      etConsultar:
       begin
         stbBarraStatus.Panels[0].Text := 'Consulta';

         CamposEnabled(False);

         if (edtCodigo.Text <> EmptyStr) then
         begin
            edtCodigo.Enabled := False;
            btnAlterar.Enabled := True;
            btnExcluir.Enabled := True;
            btnConfirmar.Enabled := False;

            if (btnAlterar.CanFocus) then
               btnAlterar.SetFocus;
         end
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if (edtCodigo.CanFocus) then
               edtCodigo.SetFocus;
         end;
      end;

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';

         if(frmProdutosPesq = nil) then
            frmProdutosPesq := TfrmProdutosPesq.Create(Application);

         frmProdutosPesq.ShowModal;

         if(frmProdutosPesq.mProdutoID <> 0) then
         begin
            edtCodigo.Text := IntToStr(frmProdutosPesq.mProdutoID);
            vEstadoTela := etConsultar;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;

         frmProdutosPesq.mProdutoID := 0;
         frmProdutosPesq.mProduto    := EmptyStr;
      end;

   end;
end;

procedure TfrmProdutos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmProdutos := nil;
end;

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmProdutos.LimpaTela;
var
   i : Integer;
begin
   try
      for i := 0 to pred(ComponentCount) do
      begin
         if (Components[i] is TEdit) then
            (Components[i] as TEdit).Text := EmptyStr;

      end;
   finally
      if (vObjProdutos <> nil) then
         FreeAndNil(vObjProdutos);
   end;
end;
procedure TfrmProdutos.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmProdutos.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmProdutos.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnSairClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if(TMessageUtil.Pergunta('Deseja realmente abortar esta operação?')) then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end
   else
      Close;
end;

procedure TfrmProdutos.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmProdutos.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

function TfrmProdutos.ProcessaConfirmacao: Boolean;
begin
   Result := False;
   try
      case vEstadoTela of
         etIncluir: Result := ProcessaInclusao;
         etAlterar: Result := ProcessaAlteracao;
         etExcluir: Result := ProcessaExclusao;
         etConsultar: Result := ProcessaConsulta;

      end;

      if not Result then
         Exit;
   except
      on E: Exception do
         TMessageUtil.Alerta(E.Message)
   end;

   Result := True;
end;

function TfrmProdutos.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaProdutos then
      begin
         TMessageUtil.Informacao('Produto cadastrado com sucesso.'#13+
         'Código cadastrado: '+ IntToStr(vObjProdutos.Id));

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao incluir o produto [View]: '#13+
         e.Message);
      end;
   end;
end;

function TfrmProdutos.ProcessaProdutos: Boolean;
begin
   try
      Result := False;
      if (ProcessaProduto) then
      begin
         // Gravação no BD
         TProdutosController.getInstancia.GravaProdutos(vObjProdutos);

         Result := True;
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao gravar o produto [View]: '#13+
            e.Message);
      end;
   end;
end;
function TfrmProdutos.ProcessaProduto: Boolean;
begin
   try
      Result := False;

      if not ValidaProduto then
         Exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjProdutos = nil then
            vObjProdutos := TProdutos.Create;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjProdutos = nil then
            Exit;
      end;
      if (vObjProdutos = nil) then
         Exit;

      vObjProdutos.Descricao         := edtDescricao.Text;
      vObjProdutos.QuantidadeEstoque := StrToFloat(edtEstoque.Text);
      vObjProdutos.PrecoVenda        := StrToFloat(edtPrecoVenda.Text);

      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao processar os dados do produto [View]. '#13+
         e.Message);
      end;
   end;
end;

function TfrmProdutos.ValidaProduto: Boolean;
begin
   Result := False;
   if (edtDescricao.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Descrição não pode ficar em branco.');

      if (edtDescricao.CanFocus) then
         edtDescricao.SetFocus;

      Exit;
   end;

   if (edtEstoque.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Estoque não pode ficar em branco.');

      if (edtEstoque.CanFocus) then
         edtEstoque.SetFocus;

      Exit;
   end;

   if (edtPrecoVenda.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Preço de venda não pode ficar em branco.');

      if (edtPrecoVenda.CanFocus) then
         edtPrecoVenda.SetFocus;

      Exit;
   end;


   Result := True;
end;
procedure TfrmProdutos.edtEstoqueKeyPress(Sender: TObject; var Key: Char);
begin
   if (not (Key in ['0'..'9', ',', '.', #8, #13, #27])) then
   begin
      TMessageUtil.Alerta('Estoque so pode conter números.');

      Key := #0;

      if (edtEstoque.CanFocus) then
         edtEstoque.SetFocus;
   end;
end;

procedure TfrmProdutos.edtPrecoVendaKeyPress(Sender: TObject;
  var Key: Char);
begin
   if (not (Key in ['0'..'9', ',', '.', #8, #13, #27])) then
   begin
      TMessageUtil.Alerta('Preço de venda so pode conter números.');

      Key := #0;

      if (edtPrecoVenda.CanFocus) then
         edtPrecoVenda.SetFocus;
   end;
end;

function TfrmProdutos.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if (edtDescricao.Text = EmptyStr) then
      begin
         ProcessaConsulta;
         Exit;
      end;

      if ProcessaProdutos then
      begin
         TMessageUtil.Informacao('Dados alterados com sucesso.');

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao alterar os dados do produto [View]: '#13+
         e.Message)
      end;
   end;
end;
function TfrmProdutos.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Código do produto não pode ficar em branco.');

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjProdutos :=
         TProdutos(TProdutosController.getInstancia.BuscaProdutos(
            StrToIntDef(edtCodigo.Text, 0)));

      if (vObjProdutos <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto encontrada para o código informado.');

         LimpaTela;

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

         Exit;
      end;

      DefineEstadoTela;

      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao consultar os dados do produto [View]: '#13+
            e.Message);
      end;
   end;
end;

procedure TfrmProdutos.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmProdutos.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

procedure TfrmProdutos.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

function TfrmProdutos.ProcessaExclusao: Boolean;
begin
   try
      Result := False;

      if (edtDescricao.Text = EmptyStr) then
      begin
         ProcessaConsulta;
         Exit;
      end;

      if (vObjProdutos = nil) then
      begin
         TMessageUtil.Alerta(
            'Não foi possivel carregar todos os dados do produto.');

         LimpaTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;
      try
         if (TMessageUtil.Pergunta('Confirma a exclusão do produto?')) then
         begin
            Screen.Cursor := crHourGlass;

            TProdutosController.getInstancia.ExcluiProdutos(
               vObjProdutos);

            TMessageUtil.Informacao('Produto excluido com sucesso.')
         end
         else
         begin
            LimpaTela;
            vEstadoTela := etPadrao;
            DefineEstadoTela;
            Exit;
         end;
      finally
         Screen.Cursor := crDefault;
         Application.ProcessMessages;
      end;

      Result := True;

      LimpaTela;
      vEstadoTela := etPadrao;
      DefineEstadoTela;
      Exit;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao excluir o produto [View]: '#13+
         e.Message);
      end;
   end;
end;

procedure TfrmProdutos.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;


end.
