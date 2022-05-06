unit UUnidadeProdutosPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, ComCtrls, DB, DBClient,
  Buttons, UUnidadeProdutos, UUnidadeProdutosController, uMessageUtil;

type
  TfrmUnidadeProdutosPesq = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    grbGrid: TGroupBox;
    grbFiltrar: TGroupBox;
    dbgUnidadeProdutos: TDBGrid;
    lblUnidade: TLabel;
    edtUnidade: TEdit;
    lblInfo: TLabel;
    btnFiltrar: TBitBtn;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    btnConfirmar: TBitBtn;
    dtsUnidade: TDataSource;
    cdsUnidade: TClientDataSet;
    cdsUnidadeID: TIntegerField;
    cdsUnidadeAtivo: TIntegerField;
    cdsUnidadeDescricaoAtivo: TStringField;
    cdsUnidadeUnidade: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsUnidadeBeforeDelete(DataSet: TDataSet);
    procedure dbgUnidadeProdutosDblClick(Sender: TObject);
    procedure dbgUnidadeProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
     vKey :Word;

     procedure LimparTela;
     procedure ProcessaPesquisa;
     procedure ProcessaConfirmacao;

  public
    { Public declarations }
     mUnidadeID   : Integer;
     mUnidade : String;
  end;

var
  frmUnidadeProdutosPesq: TfrmUnidadeProdutosPesq;

implementation

uses Math, StrUtils, ComObj;

{$R *.dfm}


procedure TfrmUnidadeProdutosPesq.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NextDlgCtl, 0, 0);
      end;

      VK_ESCAPE:
      begin
         if TMessageUtil.Pergunta('Deseja sair da rotina?') then
            Close;
      end;

      VK_UP:
      begin
         vKey := VK_CLEAR;

         if (ActiveControl = dbgUnidadeProdutos) then
            Exit;

         Perform(WM_NextDlgCtl, 1, 0);
      end;
   end;
end;
procedure TfrmUnidadeProdutosPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsUnidade.IsEmpty) then
      cdsUnidade.EmptyDataSet;

   if (edtUnidade.CanFocus) then
      edtUnidade.SetFocus;
end;

procedure TfrmUnidadeProdutosPesq.ProcessaConfirmacao;
begin
   if (not cdsUnidade.IsEmpty) then
   begin
      mUnidadeID       := cdsUnidadeID.Value;
      mUnidade         := cdsUnidadeUnidade.Value;
      Self.ModalResult := mrOk;
      LimparTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma unidade selecionada.');

      if (edtUnidade.CanFocus) then
         edtUnidade.SetFocus;
   end;
end;

procedure TfrmUnidadeProdutosPesq.ProcessaPesquisa;
var
   xListaUnidadeProdutos : TColUnidadeProdutos;
   xAux : Integer;
begin
   try
      try
         xListaUnidadeProdutos := TColUnidadeProdutos.Create;

         xListaUnidadeProdutos :=
            TUnidadeProdutosController.getInstancia.PesquisaUnidadeProdutos(
               Trim(edtUnidade.Text));

         cdsUnidade.EmptyDataSet;

         if xListaUnidadeProdutos <> nil then
         begin
            for xAux := 0 to pred(xListaUnidadeProdutos.Count) do
            begin
               cdsUnidade.Append;
               cdsUnidadeID.Value   := xListaUnidadeProdutos.Retorna(xAux).Id;
               cdsUnidadeUnidade.Value := xListaUnidadeProdutos.Retorna(xAux).Unidade;
               cdsUnidadeAtivo.Value :=
                  IfThen(xListaUnidadeProdutos.Retorna(xAux).Ativo, 1, 0);
               cdsUnidadeDescricaoAtivo.Value :=
                  IfThen(xListaUnidadeProdutos.Retorna(xAux).Ativo, 'Sim', 'Não');
               cdsUnidade.Post;
            end;
         end;

         if(cdsUnidade.RecordCount = 0) then
         begin
            if(edtUnidade.CanFocus) then
               edtUnidade.SetFocus;

            TMessageUtil.Alerta('Nenhuma unidade encontrada para este filtro.');
         end
         else
         begin
            cdsUnidade.First;
            if(dbgUnidadeProdutos.CanFocus) then
               dbgUnidadeProdutos.SetFocus;
         end;

      finally
         if (xListaUnidadeProdutos <> nil) then
            FreeAndNil(xListaUnidadeProdutos);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao pesquisar os dados da unidade [View]: '#13+
            e.Message)
      end;

   end;
end;

procedure TfrmUnidadeProdutosPesq.btnFiltrarClick(Sender: TObject);
begin
   mUnidadeID := 0;
   mUnidade := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmUnidadeProdutosPesq.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmUnidadeProdutosPesq.btnLimparClick(Sender: TObject);
begin
   mUnidadeID := 0;
   mUnidade := EmptyStr;
   LimparTela;
end;

procedure TfrmUnidadeProdutosPesq.btnSairClick(Sender: TObject);
begin
   mUnidadeID := 0;
   mUnidade := EmptyStr;
   LimparTela;
   Close;
end;

procedure TfrmUnidadeProdutosPesq.cdsUnidadeBeforeDelete(
  DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmUnidadeProdutosPesq.dbgUnidadeProdutosDblClick(
  Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmUnidadeProdutosPesq.dbgUnidadeProdutosKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
      btnConfirmar.SetFocus;
end;

procedure TfrmUnidadeProdutosPesq.FormShow(Sender: TObject);
begin
   if (edtUnidade.CanFocus) then
      edtUnidade.SetFocus;
end;

procedure TfrmUnidadeProdutosPesq.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;


end.
