unit UVendaItemDAO;

interface
uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UVendaItem;

type

   TVendaItemDAO = Class(TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere(pVendaItem : TVendaItem) : Boolean;
         function InsereLista(pColVendaItem : TColVendaItem) : Boolean;
         function Atualiza(pVendaItem : TVendaItem; pCondicao : String) : Boolean;
         function Retorna(pCondicao : String) : TVendaItem;
         function RetornaLista(pCondicao : String = '') : TColVendaItem;
   end;

implementation

{ TEnderecoDAO }

function TVendaItemDAO.Atualiza(pVendaItem: TVendaItem;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pVendaItem, pCondicao);
end;

constructor TVendaItemDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'VENDA_ITEM';
   vConexao  := pConexao;
   vClass    := TVendaItem;
end;

function TVendaItemDAO.Insere(pVendaItem: TVendaItem): Boolean;
begin
   Result := inherited Insere(pVendaItem, 'ID');
end;

function TVendaItemDAO.InsereLista(pColVendaItem: TColVendaItem): Boolean;
begin
   Result := inherited InsereLista(pColVendaItem);
end;

function TVendaItemDAO.Retorna(pCondicao: String): TVendaItem;
begin
   Result := TVendaItem (inherited Retorna(pCondicao));
end;

function TVendaItemDAO.RetornaLista(pCondicao: String): TColVendaItem;
begin
   Result := TColVendaItem(inherited RetornaLista(pCondicao));
end;

end.
 