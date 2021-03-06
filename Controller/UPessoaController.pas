unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa, UEndereco;

type
   TPessoaController = class
       public
          constructor Create;
          function GravaPessoa(
                      pPessoa : TPessoa;
                      pColEndereco : TColEndereco) : Boolean;

          function ExcluiPessoa(pPessoa : TPessoa) : Boolean;

          function BuscaPessoa(pID : Integer) : TPessoa;
          function PesquisaPessoa(pNome : String) : TColPessoa;
          function BuscaEnderecoPessoa(pID_Pessoa : Integer) : TColEndereco;

          function RetornaCondicaoPessoa(
             pID_Pessoa : Integer;
             pRelacionada : Boolean = False) : String;
       published
          class function getInstancia : TPessoaController;
   end;

implementation

uses UPessoaDAO, UEnderecoDAO;

var
   _instance: TPessoaController;

{ TPessoaController }

function TPessoaController.BuscaEnderecoPessoa(
  pID_Pessoa: Integer): TColEndereco;
var
   xEnderecoDAO : TEnderecoDAO;
begin
   try
      try
         Result := nil;

         xEnderecoDAO :=
            TEnderecoDAO.Create(TConexao.getInstance.getConn);

            Result :=
               xEnderecoDAO.RetornaLista(RetornaCondicaoPessoa(pID_Pessoa, True));
      finally
         if(xEnderecoDAO <> nil) then
            FreeAndNil(xEnderecoDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao retornar dados de endere?o da pessoa [Controller]: '#13+
         e.Message)
      end;
   end;
end;

function TPessoaController.BuscaPessoa(pID: Integer): TPessoa;
var
   xPessoaDAO : TPessoaDAO;
begin
   try
      try
         Result := nil;

         xPessoaDAO := TPessoaDAO.Create(TConexao.getInstance.getConn);
         Result := xPessoaDAO.Retorna(RetornaCondicaoPessoa(pID));
      finally
         if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da pessoa [Controller]. '#13+
            e.Message)
      end;

   end;
end;

constructor TPessoaController.Create;
begin
   inherited Create
end;

function TPessoaController.ExcluiPessoa(pPessoa: TPessoa): Boolean;
var
   xPessoaDAO : TPessoaDAO;
   xEnderecoDAO : TEnderecoDAO;
begin
   try
      try
         Result := False;

         TConexao.get.iniciaTransacao;

         xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

         xEnderecoDAO := TEnderecoDAO.Create(TConexao.get.getConn);

         if (pPessoa.Id = 0) then
            Exit
         else
         begin
            xPessoaDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id));
            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
         end;

         TConexao.get.confirmaTransacao;

         Result := True;
      finally
         if xPessoaDAO <> nil then
            FreeAndNil(xPessoaDAO);

         if xEnderecoDAO <> nil then
            FreeAndNil(xEnderecoDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao excluir os dados da pessoa [Controller]: '#13+
            e.Message)
      end;
   end;
end;

class function TPessoaController.getInstancia: TPessoaController;
begin
   if _instance = nil then
      _instance := TPessoaController.Create;

   Result := _instance;
end;

function TPessoaController.GravaPessoa(
   pPessoa: TPessoa;
   pColEndereco : TColEndereco) : Boolean;
var
   xPessoaDAO  : TPessoaDAO;
   xEnderecoDAO : TEnderecoDAO;
   xAux : Integer;
 begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xPessoaDAO :=
            TPessoaDAO.Create(TConexao.get.getConn);

         xEnderecoDAO :=
            TEnderecoDAO.Create(TConexao.get.getConn);

         if pPessoa.Id = 0 then
         begin
            xPessoaDAO.Insere(pPessoa);

            for xAux := 0 to pred(pColEndereco.Count) do
               pColEndereco.Retorna(xAux).ID_Pessoa := pPessoa.Id;

            xEnderecoDAO.InsereLista(pColEndereco);
         end
         else
         begin
            xPessoaDAO.Atualiza(pPessoa, RetornaCondicaoPessoa(pPessoa.Id));

            xEnderecoDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id, True));
            xEnderecoDAO.InsereLista(pColEndereco);
         end;

         TConexao.get.confirmaTransacao;
      finally
         if xPessoaDAO <> nil then
            FreeAndNil(xPessoaDAO);

         if xEnderecoDAO <> nil then
            FreeAndNil(xEnderecoDAO);

      end;
   except
      on E : Exception do
      begin
         TConexao.get.CancelaTransacao;
         Raise Exception.Create(
            'Falha ao gravar os dados da pessoa [Controller]. '#13+
            e.Message);
      end;

   end;
end;

function TPessoaController.PesquisaPessoa(pNome: String): TColPessoa;
var
   xPessoaDAO : TPessoaDAO;
   xCondicao : String;
begin
   try
      try
         Result := nil;

         xPessoaDAO := TPessoaDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pNome <> EmptyStr,
               'WHERE                                    '#13+
               '    (NOME LIKE UPPER(''%'+ pNOME + '%''))'#13+
               'ORDER BY NOME, ID', EmptyStr);

         Result := xPessoaDAO.RetornaLista(xCondicao);
      finally
         if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da pessoa [Controller]: '#13+
            e.Message);
      end;

   end;
end;

function TPessoaController.RetornaCondicaoPessoa(
  pID_Pessoa: Integer;
  pRelacionada : Boolean): String;
var
   xChave : String;
begin
   if (pRelacionada) then
      xChave := 'ID_PESSOA'
   else
      xChave := 'ID';

   Result :=
   'WHERE '#13+
   ' '+xChave+' = '+ QuotedStr(IntToStr(pID_Pessoa))+ ' '#13;
end;

end.
 