unit UVendaItem;

interface

uses SysUtils, Classes;

type
   TVendaItem = Class(TPersistent)
      private
         vId            : Integer;
         vID_Venda      : Integer;
         vID_Produto    : Integer;
         vQuantidade    : Integer;
         vValorUnitario : Double;
         vTotalItem     : Double;

      public
         constructor Create;
      published
         property Id            : Integer read vID             write vID;
         property ID_Venda      : Integer read vID_Venda       write vID_Venda;
         property ID_Produto    : Integer read vID_Produto     write vID_Produto;
         property Quantidade    : Integer  read vQuantidade     write vQuantidade;
         property ValorUnitario : Double  read vValorUnitario  write vValorUnitario;
         property TotalItem     : Double  read vTotalItem      write vTotalItem;
   end;

   TColVendaItem = Class(TList)
      public
         function  Retorna(pIndex : Integer) : TVendaItem;
         procedure Adiciona(pVendaItem : TVendaItem);
   end;
implementation

{ TEndereco }

constructor TVendaItem.Create;
begin
   Self.vID             := 0;
   Self.vID_Venda       := 0;
   Self.vID_Produto     := 0;
   Self.vQuantidade     := 0;
   Self.vValorUnitario  := 0;
   Self.vTotalItem      := 0;

end;

{ TColVendaItem }

procedure TColVendaItem.Adiciona(pVendaItem: TVendaItem);
begin
   Self.Add(TVendaItem (pVendaItem));
end;

function TColVendaItem.Retorna(pIndex: Integer): TVendaItem;
begin
   Result := TVendaItem(Self[pIndex]);
end;

end.
