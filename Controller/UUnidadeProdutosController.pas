unit UUnidadeProdutosController;

interface

uses SysUtils, Math, StrUtils, UConexao, UUnidadeProdutos;

type
     TUnidadeProdutosController = class
       public
          constructor Create;
          function GravaUnidadeProdutos(
                      pUnidadeProdutos : TUnidadeProdutos) : Boolean;

//          function ExcluiPessoa(pPessoa : TPessoa) : Boolean;
//
          function BuscaUnidadeProdutos(pID : Integer) : TUnidadeProdutos;
//          function PesquisaPessoa(pNome : String) : TColPessoa;

          function RetornaCondicaoUnidadeProdutos(
             pID_UnidadeProdutos : Integer) : String;
       published
          class function getInstancia : TUnidadeProdutosController;
   end;

implementation

uses UUnidadadeProdutosDAO;

var
   _instance: TUnidadeProdutosController;

{ TUnidadeProdutosController }

function TUnidadeProdutosController.BuscaUnidadeProdutos(pID: Integer): TUnidadeProdutos;
var
   xUnidadeProdutosDAO : TUnidadeProdutosDAO;
begin
   try
      try
         Result := nil;

         xUnidadeProdutosDAO := TUnidadeProdutosDAO.Create(
            TConexao.getInstance.getConn);

         Result :=
            xUnidadeProdutosDAO.Retorna(RetornaCondicaoUnidadeProdutos(pID))

      finally
         if (xUnidadeProdutosDAO <> nil) then
         FreeAndNil(xUnidadeProdutosDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da unidade [Controller]. '#13+
            e.Message)
      end;
   end;

end;

constructor TUnidadeProdutosController.Create;
begin
   inherited Create;
end;

class function TUnidadeProdutosController.getInstancia: TUnidadeProdutosController;
begin
   if _instance = nil then
      _instance := TUnidadeProdutosController.Create;

      Result := _instance;
end;

function TUnidadeProdutosController.GravaUnidadeProdutos(
  pUnidadeProdutos: TUnidadeProdutos): Boolean;
var
   xUnidadeProdutosDAO : TUnidadeProdutosDAO;
begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xUnidadeProdutosDAO :=
            TUnidadeProdutosDAO.Create(TConexao.get.getConn);

         if (pUnidadeProdutos.Id = 0) then
         begin
            xUnidadeProdutosDAO.Insere(pUnidadeProdutos);
         end
         else
         begin
            xUnidadeProdutosDAO.Atualiza(
            pUnidadeProdutos,
            RetornaCondicaoUnidadeProdutos(pUnidadeProdutos.Id));

//            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
         end;

         TConexao.get.confirmaTransacao;
      finally
         if (xUnidadeProdutosDAO <> nil) then
            FreeAndNil(xUnidadeProdutosDAO);
      end;
   except
      on E: Exception do
      begin
         TConexao.get.CancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados da unidade [Controller]: '#13+
         e.Message);
      end;
   end;
end;

function TUnidadeProdutosController.RetornaCondicaoUnidadeProdutos(
  pID_UnidadeProdutos: Integer): String;
var
   xChave : String;
begin
   xChave := 'ID';

   Result :=
   'WHERE '#13+
   ' '+xChave+' = '+ QuotedStr(IntToStr(pID_UnidadeProdutos))+ ' '#13;
end;

end.
