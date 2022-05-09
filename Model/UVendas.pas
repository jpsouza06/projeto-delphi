unit UVendas;

interface

uses SysUtils, Classes;

type
   TVendas = class(TPersistent)
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

   TColProdutos = class(Tlist)
      public
         function Retorna(pIndex : Integer) : TVendas;
         procedure Adiciona(pVendas : TVendas);
   end;

implementation

{ TColProdutos }

constructor TVendas.Create;
begin
   Self.vId         := 0;
   Self.vID_Cliente := 0;
   Self.vDataVenda  := 0;
   Self.vTotalVenda := 0;

end;

procedure TColProdutos.Adiciona(pVendas: TVendas);
begin
   Self.Add(TVendas(pVendas));
end;

function TColProdutos.Retorna(pIndex: Integer): TVendas;
begin
   Result := TVendas(Self[pIndex]);
end;

end.
 