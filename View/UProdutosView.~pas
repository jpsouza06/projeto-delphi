unit UProdutosView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, UEnumerationUtil, UProdutos,
  UProdutosController;

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

    if (TFuncoes.IsNumero(edtEstoque.Text) = False) then
   begin
      TMessageUtil.Alerta('Estoque so pode conter números.');

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

    if (TFuncoes.IsNumero(edtPrecoVenda.Text) = False) then
   begin
      TMessageUtil.Alerta('Preço de venda so pode conter números.');

      if (edtPrecoVenda.CanFocus) then
         edtPrecoVenda.SetFocus;

      Exit;
   end;

   Result := True;
end;

end.
