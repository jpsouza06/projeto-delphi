unit UUnidadeProdutos;

interface

uses SysUtils, Classes;

type
   TUnidadeProdutos = class(TPersistent)
      private
         vId        : Integer;
         vUnidade   : String;
         vDescricao : String;
         vAtivo     : Boolean;

      public
         constructor Create;
      published
         property Id        : Integer read vID        write vID;
         property Unidade   : String  read vUnidade   write vUnidade;
         property Descricao : String  read vDescricao write vDescricao;
         property Ativo     : Boolean read vAtivo     write vAtivo;

   end;

   TColUnidadeProdutos = class(Tlist)
      public
         function Retorna(pIndex : Integer) : TUnidadeProdutos;
         procedure Adiciona(pUnidadeProdutos : TUnidadeProdutos);
   end;

implementation

constructor TUnidadeProdutos.Create;
begin
   Self.vId        := 0;
   Self.vUnidade   := EmptyStr;
   Self.vDescricao := EmptyStr;
   Self.vAtivo     := False;


end;

{ TColUnidadePessoa }

procedure TColUnidadeProdutos.Adiciona(pUnidadeProdutos: TUnidadeProdutos);
begin
   Self.Add(TUnidadeProdutos(pUnidadeProdutos));
end;

function TColUnidadeProdutos.Retorna(pIndex: Integer): TUnidadeProdutos;
begin
   Result := TUnidadeProdutos(Self[pIndex]);
end;

end.


