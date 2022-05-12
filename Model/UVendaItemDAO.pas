unit UVendaItemDAO;

interface
uses SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils,
     StdCtrls, UGenericDAO, UVendaItem;

type

   TEnderecoDAO = Class(TGenericDAO)
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

function TEnderecoDAO.Atualiza(pVendaItem: TVendaItem;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pVendaItem, pCondicao);
end;

constructor TEnderecoDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'VENDA_ITEM';
   vConexao  := pConexao;
   vClass    := TVendaItem;
end;

function TEnderecoDAO.Insere(pVendaItem: TVendaItem): Boolean;
begin
   Result := inherited Insere(pVendaItem, 'ID');
end;

function TEnderecoDAO.InsereLista(pColVendaItem: TColVendaItem): Boolean;
begin
   Result := inherited InsereLista(pColVendaItem);
end;

function TEnderecoDAO.Retorna(pCondicao: String): TVendaItem;
begin
   Result := TVendaItem (inherited Retorna(pCondicao));
end;

function TEnderecoDAO.RetornaLista(pCondicao: String): TColVendaItem;
begin
   Result := TColVendaItem(inherited RetornaLista(pCondicao));
end;

end.
 