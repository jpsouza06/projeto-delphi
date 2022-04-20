unit UUnidadeProdutosView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, UEnumerationUtil,
  UUnidadeProdutos, UUnidadeProdutosController;

type
  TfrmUnidadeProdutos = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlArea: TPanel;
    pnlBotoes: TPanel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConsultar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    chkAtivo: TCheckBox;
    lblUnidade: TLabel;
    edtUnidade: TEdit;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSairClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
  private
    { Private declarations }
     vKey : Word;

     vEstadoTela : TEstadoTela;
     vObjUnidadeProdutos: TUnidadeProdutos;

     procedure CamposEnabled(pOpcao : Boolean);
     procedure LimpaTela;
     procedure DefineEstadoTela;

     procedure CarregaDadosTela;

     function ProcessaConfirmacao     : Boolean;
     function ProcessaInclusao        : Boolean;
     function ProcessaAlteracao       : Boolean;
     function ProcessaConsulta        : Boolean;
     function ProcessaUnidadeProdutos : Boolean;

     function ProcessaUnidade         : Boolean;

     function ValidaUnidade           : Boolean;



  public
    { Public declarations }
  end;

var
  frmUnidadeProdutos: TfrmUnidadeProdutos;

implementation

uses
   uMessageUtil;


{$R *.dfm}

procedure TfrmUnidadeProdutos.DefineEstadoTela;
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

          if (frmUnidadeProdutos<> nil) and
             (frmUnidadeProdutos.Active) and
             (btnIncluir.CanFocus) then
             btnIncluir.SetFocus;

          Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Inclusão';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         chkAtivo.Checked := True;

         if (edtUnidade.CanFocus) then
            edtUnidade.SetFocus
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

            if (chkAtivo.CanFocus) then
               chkAtivo.SetFocus;
         end
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
  end;
end;
procedure TfrmUnidadeProdutos.CarregaDadosTela;
begin
   if (vObjUnidadeProdutos = nil) then
      Exit;

   edtCodigo.Text    := IntToStr(vObjUnidadeProdutos.Id);
   edtUnidade.Text   := vObjUnidadeProdutos.Unidade;
   edtDescricao.Text := vObjUnidadeProdutos.Descricao;
   chkAtivo.Checked  := vObjUnidadeProdutos.Ativo;
end;


procedure TfrmUnidadeProdutos.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmUnidadeProdutos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmUnidadeProdutos := nil;
end;

procedure TfrmUnidadeProdutos.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Variável para auxiliar o comando de repetição
begin
   for i := 0 to pred(ComponentCount) do
   begin
      // Se o campo for do tipo EDIT
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

         // Se o campo for do tipo CHECKBOX
      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;
   end;
end;


procedure TfrmUnidadeProdutos.LimpaTela;
var
   i : Integer;
begin
   try
      for i := 0 to pred(ComponentCount) do
      begin
         if (Components[i] is TEdit) then
            (Components[i] as TEdit).Text := EmptyStr;

         if (Components[i] is TCheckBox) then
            (Components[i] as TCheckBox).Checked := False;
      end;
   finally
      if (vObjUnidadeProdutos <> nil) then
         FreeAndNil(vObjUnidadeProdutos);
   end;
end;

procedure TfrmUnidadeProdutos.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmUnidadeProdutos.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmUnidadeProdutos.btnSairClick(Sender: TObject);
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

procedure TfrmUnidadeProdutos.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

function TfrmUnidadeProdutos.ProcessaConfirmacao: Boolean;
begin
   Result := False;
   try
      case vEstadoTela of
         etIncluir: Result := ProcessaInclusao;
         etAlterar: Result := ProcessaAlteracao;
//         etExcluir: Result := ProcessaExclusao;
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


function TfrmUnidadeProdutos.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaUnidadeProdutos then
      begin
         TMessageUtil.Informacao('Unidade cadastrada com sucesso.'#13+
         'Código cadastrado: '+ IntToStr(vObjUnidadeProdutos.Id));

         vEstadoTela := etPadrao;
         DefineEstadoTela;

         Result := True;
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao incluir a unidade [View]: '#13+
         e.Message);
      end;
   end;
end;

function TfrmUnidadeProdutos.ProcessaUnidadeProdutos: Boolean;
begin
   try
      Result := False;
      if (ProcessaUnidade) then
      begin
         // Gravação no BD
         TUnidadeProdutosController.getInstancia.GravaUnidadeProdutos(
            vObjUnidadeProdutos);

         Result := True;
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao gravar a unidade [View]: '#13+
            e.Message);
      end;
   end;
end;
function TfrmUnidadeProdutos.ProcessaUnidade: Boolean;
begin
   try
      Result := False;

      if not ValidaUnidade then
         Exit;

      if vEstadoTela = etIncluir then
      begin
         if vObjUnidadeProdutos = nil then
            vObjUnidadeProdutos := TUnidadeProdutos.Create;
      end
      else
      if vEstadoTela = etAlterar then
      begin
         if vObjUnidadeProdutos = nil then
            Exit;
      end;
      if (vObjUnidadeProdutos = nil) then
         Exit;

      vObjUnidadeProdutos.Unidade   := edtUnidade.Text;
      vObjUnidadeProdutos.Descricao := edtDescricao.Text;
      vObjUnidadeProdutos.Ativo     := chkAtivo.Checked;


      Result := True;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao processar os dados da unidade [View]. '#13+
         e.Message);
      end;
   end;
end;

function TfrmUnidadeProdutos.ValidaUnidade: Boolean;
begin
   Result := False;
   if (edtUnidade.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Unidade não pode ficar em branco.');

      if (edtUnidade.CanFocus) then
         edtUnidade.SetFocus;

      Exit;
   end;

   if (edtDescricao.Text = EmptyStr) then
   begin
      TMessageUtil.Alerta('Descrição não pode ficar em branco.');

      if (edtDescricao.CanFocus) then
         edtDescricao.SetFocus;

      Exit;
   end;

   Result := True;
end;

procedure TfrmUnidadeProdutos.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

function TfrmUnidadeProdutos.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Código da Unidade não pode ficar em branco.');

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjUnidadeProdutos :=
         TUnidadeProdutos(TUnidadeProdutosController.getInstancia.BuscaUnidadeProdutos(
            StrToIntDef(edtCodigo.Text, 0)));

      if (vObjUnidadeProdutos <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhuma Unidade encontrada para o código informado.');

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
            'Falha ao consultar os dados da unidade [View]: '#13+
            e.Message);
      end;
   end;
end;

procedure TfrmUnidadeProdutos.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

function TfrmUnidadeProdutos.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if (edtUnidade.Text = EmptyStr) then
      begin
         ProcessaConsulta;
         Exit;
      end;

      if ProcessaUnidadeProdutos then
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
         'Falha ao alterar os dados da unidade [View]: '#13+
         e.Message)
      end;
   end;
end;

procedure TfrmUnidadeProdutos.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

end.
