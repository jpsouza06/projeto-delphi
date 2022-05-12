unit UVendaItem;

interface

uses SysUtils, Classes;

type
   TEndereco = Class(TPersistent)
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
         property vID_Produto   : Integer read vID_Venda       write vID_Venda;
         property vID_Produto   : Integer read vID_Produto     write vID_Produto;
         property Quantidade    : String  read vQuantidade     write vQuantidade;
         property ValorUnitario : String  read vValorUnitario  write vValorUnitario;
         property TotalItem     : String  read vTotalItem      write vTotalItem;
   end;

   TColVendaItem = Class(TList)
      public
         function  Retorna(pIndex : Integer) : TVendaItem;
         procedure Adiciona(pVendaItem : TVendaItem);
   end;
implementation

{ TEndereco }

constructor TEndereco.Create;
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
