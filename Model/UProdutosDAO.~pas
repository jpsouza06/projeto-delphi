unit UProdutosDAO;

interface
uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UProdutos;

type

   TProdutosDAO = Class(TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere(pProdutos : TProdutos) : Boolean;
         function InsereLista(pColProdutos : TColProdutos) : Boolean;
         function Atualiza(pProdutos : TProdutos; pCondicao : String) : Boolean;
         function Retorna(pCondicao : String) : TProdutos;
         function RetornaLista(pCondicao : String = '') : TColProdutos;
   end;

implementation


{ TProdutosDAO }

function TProdutosDAO.Atualiza(pProdutos: TProdutos;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pProdutos, pCondicao);
end;

constructor TProdutosDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'PRODUTO';
   vConexao  := pConexao;
   vClass    := TProdutos;
end;

function TProdutosDAO.Insere(pProdutos: TProdutos): Boolean;
begin
   Result := inherited Insere(pProdutos, 'ID');
end;

function TProdutosDAO.InsereLista(pColProdutos: TColProdutos): Boolean;
begin
   Result := inherited InsereLista(pColProdutos);
end;

function TProdutosDAO.Retorna(pCondicao: String): TProdutos;
begin
   Result := TProdutos(inherited Retorna(pCondicao));
end;

function TProdutosDAO.RetornaLista(pCondicao: String): TColProdutos;
begin
   Result := TColProdutos(inherited RetornaLista(pCondicao));
end;

end.
