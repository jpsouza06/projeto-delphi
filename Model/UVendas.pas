unit UVendas;

interface

uses SysUtils, Classes;

type
   TVenda = class(TPersistent)
      private
         vId         : Integer;
         vID_Cliente : Integer;
         vDataVenda  : TDateTime;
         vTotalVenda : Double;

      public
         constructor Create;
      published
         property Id         : Integer   read vID         write vID;
         property ID_Cliente : Integer   read vID_Cliente write vID_Cliente;
         property DataVenda  : TDateTime read vDataVenda  write vDataVenda;
         property TotalVenda : Double    read vTotalVenda write vTotalVenda;

   end;

   TColVendas = class(Tlist)
      public
         function Retorna(pIndex : Integer) : TVenda;
         procedure Adiciona(pVendas : TVenda);
   end;

implementation

{ TColProdutos }

constructor TVenda.Create;
begin
   Self.vId         := 0;
   Self.vID_Cliente := 0;
   Self.vDataVenda  := 0;
   Self.vTotalVenda := 0;

end;

procedure TColVendas.Adiciona(pVendas: TVenda);
begin
   Self.Add(TVenda(pVendas));
end;

function TColVendas.Retorna(pIndex: Integer): TVenda;
begin
   Result := TVenda(Self[pIndex]);
end;

end.
 