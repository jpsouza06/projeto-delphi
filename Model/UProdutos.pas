unit UProdutos;

interface

uses SysUtils, Classes;

type
   TProdutos = class(TPersistent)
      private
         vId         : Integer;
         vDescricao  : String;
         vQuantidadeEstoque    : Double;
         vPrecoVenda : Double;

      public
         constructor Create;
      published
         property Id         : Integer read vID         write vID;
         property Descricao  : String  read vDescricao  write vDescricao;
         property QuantidadeEstoque    : Double  read vQuantidadeEstoque    write vQuantidadeEstoque;
         property PrecoVenda : Double  read vPrecoVenda write vPrecoVenda;

   end;

   TColProdutos = class(Tlist)
      public
         function Retorna(pIndex : Integer) : TProdutos;
         procedure Adiciona(pProdutos : TProdutos);
   end;

implementation

constructor TProdutos.Create;
begin
   Self.vId         := 0;
   Self.vDescricao  := EmptyStr;
   Self.vQuantidadeEstoque    := 0;
   Self.vPrecoVenda := 0;
end;

{ TColProdutos }

procedure TColProdutos.Adiciona(pProdutos: TProdutos);
begin
   Self.Add(TProdutos(pProdutos));
end;

function TColProdutos.Retorna(pIndex: Integer): TProdutos;
begin
   Result := TProdutos(Self[pIndex]);
end;

end.


