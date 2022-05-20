unit UVendasPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, ComCtrls, DB,
  DBClient, uMessageUtil, UVendaController, UVendas, UCliente, UPessoaController;

type
  TfrmVendasPesq = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnLimpar: TBitBtn;
    btnSair: TBitBtn;
    grbGrid: TGroupBox;
    dbgVenda: TDBGrid;
    grbPesquisar: TGroupBox;
    lblPeriodoPesq: TLabel;
    lblTexto: TLabel;
    btnPesquisar: TBitBtn;
    edtDataInicio: TMaskEdit;
    edtDataFinal: TMaskEdit;
    dtsVendas: TDataSource;
    edtClienteID: TEdit;
    Label1: TLabel;
    cdsVendas: TClientDataSet;
    cdsVendasID: TIntegerField;
    cdsVendasID_Cliente: TIntegerField;
    cdsVendasClienteNome: TStringField;
    cdsVendasDataVenda: TDateField;
    cdsVendasTotalVenda: TFloatField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsVendasBeforeDelete(DataSet: TDataSet);
    procedure dbgVendaDblClick(Sender: TObject);
    procedure dbgVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtDataInicioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDataFinalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
     vKey :Word;

     vObjCliente: TCliente;

     procedure LimparTela;
     procedure ProcessaPesquisa;
     procedure ProcessaConfirmacao;
     function ProcessaConsultaCliente : Boolean;

     function ValidaData(pDataInicial : Boolean = True) : Boolean;

  public
    { Public declarations }
     mVendaID : Integer;
     mClienteID : Integer;
     mClienteNome : String;
  end;

var
  frmVendasPesq: TfrmVendasPesq;

implementation

uses
   UClassFuncoes, UPessoa;

{$R *.dfm}
procedure TfrmVendasPesq.FormKeyDown(Sender: TObject; var Key: Word;
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

         if (ActiveControl = dbgVenda) then
            Exit;

         Perform(WM_NextDlgCtl, 1, 0);
      end;
   end;
end;

procedure TfrmVendasPesq.FormShow(Sender: TObject);
begin
   if (edtDataInicio.CanFocus) then
      edtDataInicio.SetFocus;

   edtDataInicio.Text := DateTimeToStr(Date);
   edtDataFinal.Text := DateTimeToStr(Date);
end;

procedure TfrmVendasPesq.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmVendasPesq.cdsVendasBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmVendasPesq.dbgVendaDblClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendasPesq.dbgVendaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
      btnConfirmar.SetFocus;
end;

procedure TfrmVendasPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if (not cdsVendas.IsEmpty) then
      cdsVendas.EmptyDataSet;

   if (edtDataInicio.CanFocus) then
      edtDataInicio.SetFocus;
end;

procedure TfrmVendasPesq.ProcessaConfirmacao;
begin
   if (not cdsVendas.IsEmpty) then
   begin
      mVendaID   := cdsVendasID.Value;
      mClienteID := cdsVendasID_Cliente.Value;

      Self.ModalResult := mrOk;
      LimparTela;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma venda selecionada.');

      if (edtDataInicio.CanFocus) then
         edtDataInicio.SetFocus;
   end;
end;

procedure TfrmVendasPesq.ProcessaPesquisa;
var
   xListaVendas : TColVendas;
   xAux : Integer;
begin
   try
      try
         xListaVendas := TColVendas.Create;


         xListaVendas :=
            TVendaController.getInstancia.PesquisaVenda(
               edtDataInicio.Text, edtDataFinal.Text);

         cdsVendas.EmptyDataSet;

         if (edtClienteID.Text <> EmptyStr) and
            (xListaVendas <> nil) then
         begin
            for xAux := 0 to pred(xListaVendas.Count) do
            begin
               if (xListaVendas.Retorna(xAux).ID_Cliente = StrToInt(edtClienteID.Text)) then
               begin
                  cdsVendas.Append;
                  cdsVendasID.Value          := xListaVendas.Retorna(xAux).Id;
                  cdsVendasID_Cliente.Value  := xListaVendas.Retorna(xAux).ID_Cliente;

                  ProcessaConsultaCliente;

                  cdsVendasClienteNome.Value := mClienteNome;
                  cdsVendasDataVenda.Value   := xListaVendas.Retorna(xAux).DataVenda;
                  cdsVendasTotalVenda.Value  := xListaVendas.Retorna(xAux).TotalVenda;

                  cdsVendas.Post;
               end;
            end;
         end
         else if (xListaVendas <> nil) then
         begin
            for xAux := 0 to pred(xListaVendas.Count) do
            begin
               cdsVendas.Append;
               cdsVendasID.Value         := xListaVendas.Retorna(xAux).Id;
               cdsVendasID_Cliente.Value := xListaVendas.Retorna(xAux).ID_Cliente;

               ProcessaConsultaCliente;

               cdsVendasClienteNome.Value := mClienteNome;
               cdsVendasDataVenda.Value  := xListaVendas.Retorna(xAux).DataVenda;
               cdsVendasTotalVenda.Value := xListaVendas.Retorna(xAux).TotalVenda;

               cdsVendas.Post;
            end;
         end;

         if(cdsVendas.RecordCount = 0) then
         begin
            TMessageUtil.Alerta('Nenhuma venda encontrada para este filtro.');

            if(edtDataInicio.CanFocus) then
               edtDataInicio.SetFocus;
         end
         else
         begin
            cdsVendas.First;
            if(dbgVenda.CanFocus) then
               dbgVenda.SetFocus;
         end;

      finally
         if (xListaVendas <> nil) then
            FreeAndNil(xListaVendas);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao pesquisar os dados das vendas [View]: '#13+
            e.Message)
      end;

   end;
end;

procedure TfrmVendasPesq.btnPesquisarClick(Sender: TObject);
begin
   mVendaID   := 0;
   mClienteID := 0;
   if (not ValidaData) then
      Exit
   else if (not ValidaData(False)) then
      Exit;
   ProcessaPesquisa;
end;

procedure TfrmVendasPesq.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendasPesq.btnLimparClick(Sender: TObject);
begin
   mVendaID   := 0;
   mClienteID := 0;
   LimparTela;
end;

procedure TfrmVendasPesq.btnSairClick(Sender: TObject);
begin
   mVendaID   := 0;
   mClienteID := 0;
   LimparTela;
   Close;
end;

function TfrmVendasPesq.ProcessaConsultaCliente: Boolean;
begin
   try
      Result := False;

      vObjCliente :=
         TCliente( TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(cdsVendasID_Cliente.Text, 0)));


      if (vObjCliente <> nil) then
      begin
         mClienteNome := vObjCliente.Nome;


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

procedure TfrmVendasPesq.edtDataInicioKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (vKey = 13) then
      ValidaData;
end;

procedure TfrmVendasPesq.edtDataFinalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (vKey = 13) then
      ValidaData(False);
end;

function TfrmVendasPesq.ValidaData(pDataInicial : Boolean) : Boolean;
var
   xTamanho : Integer;
   xDataAtual : String;
   xDataAux  : String;
   xAux : String;
begin
   Result := False;

   xDataAtual := DateTimeToStr(Date);

   if (pDataInicial) then // Data Inicial
   begin
      xTamanho := Length(TFuncoes.SoNumero(edtDataInicio.Text));
   end
   else // Data Final
   begin
      xTamanho := Length(TFuncoes.SoNumero(edtDataFinal.Text));
   end;

   if (xTamanho = 0) then
   begin
      if (pDataInicial) then // Data Inicial
      begin
         edtDataInicio.Text := xDataAtual;
      end
      else // Data Final
      begin
         edtDataFinal.Text := xDataAtual;
      end;
      Exit;
   end;

   if (xTamanho = 2) then
   begin
      xAux := xDataAtual;

      if (pDataInicial) then // Data Inicial
      begin
         xAux[1] := edtDataInicio.Text[1];
         xAux[2] := edtDataInicio.Text[2];

         edtDataInicio.Text := xAux;
      end
      else // Data Final
      begin
         xAux[1] := edtDataFinal.Text[1];
         xAux[2] := edtDataFinal.Text[2];

         edtDataFinal.Text := xAux;
      end;

      xTamanho := 8;
   end;

   if (xTamanho = 8) then
   begin
      xDataAtual := FormatDateTime('yyyy/mm/dd', Date);

      if (pDataInicial) then // Data Inicial
      begin
         xAux := FormatDateTime('yyyy/mm/dd', StrToDate(edtDataInicio.Text));

         if (xAux > xDataAtual) then
         begin
            TMessageUtil.Alerta('Data inicial não pode ser maior que a data atual');

            if (edtDataInicio.CanFocus) then
               edtDataInicio.SetFocus;

            Exit;
         end;
      end
      else // Data Final
      begin
         xAux := FormatDateTime('yyyy/mm/dd', StrToDate(edtDataFinal.Text));
         xDataAux := FormatDateTime('yyyy/mm/dd', StrToDate(edtDataInicio.Text));

         if (xAux > xDataAtual) then
         begin
            TMessageUtil.Alerta('Data final não pode ser maior que a data atual');

            if (edtDataFinal.CanFocus) then
               edtDataFinal.SetFocus;

            Exit;
         end;

         if (xAux < xDataAux) then
         begin
            TMessageUtil.Alerta('Data final não pode ser menor que a data inicial');

            if (edtDataFinal.CanFocus) then
               edtDataFinal.SetFocus;

            Exit;
         end;
      end;

   end;
   Result := True;
end;

end.
