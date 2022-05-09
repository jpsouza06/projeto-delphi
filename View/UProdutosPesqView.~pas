unit UProdutosPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, ComCtrls, ExtCtrls, Grids, DBGrids, StdCtrls,
  Buttons, UProdutosController, UProdutos;

type
  TfrmProdutosPesq = class(TForm)
    grbFiltrar: TGroupBox;
    lblDescricao: TLabel;
    lblInfo: TLabel;
    edtDescricao: TEdit;
    btnFiltrar: TBitBtn;
    grbGrid: TGroupBox;
    dbgProdutos: TDBGrid;
    pnlBotoes: TPanel;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    btnConfirmar: TBitBtn;
    stbBarraStatus: TStatusBar;
    dtsProduto: TDataSource;
    cdsProduto: TClientDataSet;
    cdsProdutoID: TIntegerField;
    cdsProdutoDescricao: TStringField;
    cdsProdutoEstoque: TFloatField;
    cdsProdutoPrecoVenda: TFloatField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsProdutoBeforeDelete(DataSet: TDataSet);
    procedure dbgProdutosDblClick(Sender: TObject);
    procedure dbgProdutosKeyDown(Sender: TObject; var Key: Word;
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
     mProdutoID   : Integer;
     mProduto     : String;
  end;

var
  frmProdutosPesq: TfrmProdutosPesq;

implementation

uses
   uMessageUtil;

{$R *.dfm}

procedure TfrmProdutosPesq.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

         if (ActiveControl = dbgProdutos) then
            Exit;

         Perform(WM_NextDlgCtl, 1, 0);
      end;
   end;
end;

procedure TfrmProdutosPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsProduto.IsEmpty) then
      cdsProduto.EmptyDataSet;

   if (edtDescricao.CanFocus) then
      edtDescricao.SetFocus;
end;

procedure TfrmProdutosPesq.ProcessaConfirmacao;
begin
   if (not cdsProduto.IsEmpty) then
   begin
      mProdutoID       := cdsProdutoID.Value;
      mProduto         := cdsProdutoDescricao.Value;
      Self.ModalResult := mrOk;
      LimparTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhum produto selecionado.');

      if (edtDescricao.CanFocus) then
         edtDescricao.SetFocus;
   end;
end;

procedure TfrmProdutosPesq.ProcessaPesquisa;
var
   xListaProdutos : TColProdutos;
   xAux : Integer;
begin
   try
      try
         xListaProdutos := TColProdutos.Create;

         xListaProdutos :=
            TProdutosController.getInstancia.PesquisaProdutos(
               Trim(edtDescricao.Text));

         cdsProduto.EmptyDataSet;

         if xListaProdutos <> nil then
         begin
            for xAux := 0 to pred(xListaProdutos.Count) do
            begin
               cdsProduto.Append;
               cdsProdutoID.Value   := xListaProdutos.Retorna(xAux).Id;
               cdsProdutoDescricao.Value := xListaProdutos.Retorna(xAux).Descricao;
               cdsProdutoEstoque.Value := xListaProdutos.Retorna(xAux).QuantidadeEstoque;
               cdsProdutoPrecoVenda.Value := xListaProdutos.Retorna(xAux).PrecoVenda;

               cdsProduto.Post;
            end;
         end;

         if(cdsProduto.RecordCount = 0) then
         begin
            if(edtDescricao.CanFocus) then
               edtDescricao.SetFocus;

            TMessageUtil.Alerta('Nenhum produto encontrada para este filtro.');
         end
         else
         begin
            cdsProduto.First;
            if(dbgProdutos.CanFocus) then
               dbgProdutos.SetFocus;
         end;

      finally
         if (xListaProdutos <> nil) then
            FreeAndNil(xListaProdutos);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao pesquisar os dados do produto [View]: '#13+
            e.Message)
      end;

   end;
end;

procedure TfrmProdutosPesq.btnFiltrarClick(Sender: TObject);
begin
   mProdutoID := 0;
   mProduto := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmProdutosPesq.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmProdutosPesq.btnLimparClick(Sender: TObject);
begin
   mProdutoID := 0;
   mProduto := EmptyStr;
   LimparTela;
end;

procedure TfrmProdutosPesq.btnSairClick(Sender: TObject);
begin
   mProdutoID := 0;
   mProduto := EmptyStr;
   LimparTela;
   Close;
end;

procedure TfrmProdutosPesq.cdsProdutoBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmProdutosPesq.dbgProdutosDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmProdutosPesq.dbgProdutosKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
      btnConfirmar.SetFocus;
end;

procedure TfrmProdutosPesq.FormShow(Sender: TObject);
begin
   if (edtDescricao.CanFocus) then
      edtDescricao.SetFocus;
end;

procedure TfrmProdutosPesq.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

end.
