unit UProdutosController;

interface

uses SysUtils, Math, StrUtils, UConexao, UProdutos;

type
     TProdutosController = class
       public
          constructor Create;
          function GravaProdutos(
                      pProdutos : TProdutos) : Boolean;

          function ExcluiProdutos(
             pProdutos : TProdutos) : Boolean;

          function BuscaProdutos(pID : Integer) : TProdutos;
          function PesquisaProdutos(pProdutos : String) : TColProdutos;

          function RetornaCondicaoProdutos(
             pID_Produtos : Integer) : String;
       published
          class function getInstancia : TProdutosController;
   end;

implementation

uses UProdutosDAO;

var
   _instance: TProdutosController;

{ TProdutosController }

function TProdutosController.BuscaProdutos(pID: Integer): TProdutos;
   var
   xProdutosDAO : TProdutosDAO;
begin
   try
      try
         Result := nil;

         xProdutosDAO := TProdutosDAO.Create(
            TConexao.getInstance.getConn);

         Result :=
            xProdutosDAO.Retorna(RetornaCondicaoProdutos(pID))

      finally
         if (xProdutosDAO <> nil) then
         FreeAndNil(xProdutosDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados do produto [Controller]. '#13+
            e.Message)
      end;
   end;
end;

constructor TProdutosController.Create;
begin
   inherited Create;
end;

function TProdutosController.ExcluiProdutos(pProdutos: TProdutos): Boolean;
var
   xProdutosDAO :TProdutosDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xProdutosDAO :=
            TProdutosDAO.Create(TConexao.get.getConn);

         if (pProdutos.Id = 0) then
            Exit
         else
         begin
            xProdutosDAO.Deleta(
               RetornaCondicaoProdutos(pProdutos.Id));
         end;

         TConexao.get.confirmaTransacao;

         Result := True;
      finally
         if (xProdutosDAO <> nil) then
            FreeAndNil(xProdutosDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao excluir o produto [Controller]: '#13+
         e.Message);
      end;
   end;
end;

class function TProdutosController.getInstancia: TProdutosController;
begin
   if _instance = nil then
      _instance := TProdutosController.Create;

      Result := _instance;
end;

function TProdutosController.GravaProdutos(pProdutos: TProdutos): Boolean;
var
   xProdutosDAO : TProdutosDAO;
begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xProdutosDAO :=
            TProdutosDAO.Create(TConexao.get.getConn);

         if (pProdutos.Id = 0) then
         begin
            xProdutosDAO.Insere(pProdutos);
         end
         else
         begin
            xProdutosDAO.Atualiza(
            pProdutos,
            RetornaCondicaoProdutos(pProdutos.Id));
         end;

         TConexao.get.confirmaTransacao;
      finally
         if (xProdutosDAO <> nil) then
            FreeAndNil(xProdutosDAO);
      end;
   except
      on E: Exception do
      begin
         TConexao.get.CancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados do produto [Controller]: '#13+
         e.Message);
      end;
   end;
end;

function TProdutosController.PesquisaProdutos(
  pProdutos: String): TColProdutos;
var
   xProdutosDAO : TProdutosDAO;
   xCondicao    : String;
begin
   try
      try
         Result := nil;

         xProdutosDAO := TProdutosDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pProdutos <> EmptyStr,
            'WHERE                                            '#13+
            '    (DESCRICAO LIKE UPPER(''%'+ pProdutos + '%''))'#13+
            'ORDER BY DESCRICAO, ID', EmptyStr);

         Result := xProdutosDAO.RetornaLista(xCondicao);
      finally
         if (xProdutosDAO <> nil) then
            FreeAndNil(xProdutosDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados do produto [Controller]: '#13+
            e.Message);
      end;
   end;
end;

function TProdutosController.RetornaCondicaoProdutos(
  pID_Produtos: Integer): String;
var
   xChave : String;
begin
   xChave := 'ID';

   Result :=
   'WHERE '#13+
   ' '+xChave+' = '+ QuotedStr(IntToStr(pID_Produtos))+ ' '#13;
end;

end.
 