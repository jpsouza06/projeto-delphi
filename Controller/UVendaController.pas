unit UVendaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVendas, UVendaItem;

type
   TVendaController = class
       public
          constructor Create;
          function GravaVenda(
                      pVenda : TVenda;
                      pVendaItem : TVendaItem) : Boolean;

//          function ExcluiVenda(pVenda : TVenda) : Boolean;

          function BuscaVenda(pID : Integer) : TVenda;
          function PesquisaVenda(pVendaId : String) : TColVendas;
          function BuscaVendaItem(pID_Venda : Integer) : TColVendaItem;

          function RetornaCondicaoVenda(
             pID_Venda : Integer;
             pRelacionada : Boolean = False) : String;
       published
          class function getInstancia : TVendaController;
   end;

implementation

uses UVendaDAO, UVendaItemDAO;

var
   _instance: TVendaController;

{ TVendaController }

function TVendaController.BuscaVenda(pID: Integer): TVenda;
   var
   xVendaDAO : TVendaDAO;
begin
   try
      try
         Result := nil;

         xVendaDAO := TVendaDAO.Create(
            TConexao.getInstance.getConn);

         Result :=
            xVendaDAO.Retorna(RetornaCondicaoVenda(pID))

      finally
         if (xVendaDAO <> nil) then
         FreeAndNil(xVendaDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da venda [Controller]. '#13+
            e.Message)
      end;
   end;
end;


function TVendaController.BuscaVendaItem(
  pID_Venda: Integer): TColVendaItem;
var
   xVendaItemDAO : TVendaItemDAO;
begin
   try
      try
         Result := nil;

         xVendaItemDAO :=
            TVendaItemDAO.Create(TConexao.getInstance.getConn);

            Result :=
               xVendaItemDAO.RetornaLista(RetornaCondicaoVenda(pID_Venda, True));
      finally
         if(xVendaItemDAO <> nil) then
            FreeAndNil(xVendaItemDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao retornar dados dos itens da venda [Controller]: '#13+
         e.Message)
      end;
   end;
end;


constructor TVendaController.Create;
begin
   inherited Create;
end;

//function TVendaController.ExcluiVenda(pVenda: TVenda): Boolean;
//var
//   xVendaDAO :TVendaDAO;
//begin
//   try
//      try
//         Result := False;
//
//         TConexao.get.iniciaTransacao;
//
//         xVendaDAO :=
//            TVendaDAO.Create(TConexao.get.getConn);
//
//         if (pVenda.Id = 0) then
//            Exit
//         else
//         begin
//            xVendaDAO.Deleta(
//               RetornaCondicaoVenda(pVenda.Id));
//         end;
//
//         TConexao.get.confirmaTransacao;
//
//         Result := True;
//      finally
//         if (xVendaDAO <> nil) then
//            FreeAndNil(xVendaDAO);
//      end;
//   except
//      on E: Exception do
//      begin
//         Raise Exception.Create(
//         'Falha ao excluir a venda [Controller]: '#13+
//         e.Message);
//      end;
//   end;
//end;

class function TVendaController.getInstancia: TVendaController;
begin
   if _instance = nil then
      _instance := TVendaController.Create;

      Result := _instance;
end;

function TVendaController.GravaVenda(
   pVenda: TVenda;
   pVendaItem : TVendaItem): Boolean;
var
   xVendaDAO : TVendaDAO;
begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xVendaDAO :=
            TVendaDAO.Create(TConexao.get.getConn);

         if (pVenda.Id = 0) then
         begin
            xVendaDAO.Insere(pVenda);
         end
         else
         begin
            xVendaDAO.Atualiza(
            pVenda,
            RetornaCondicaoVenda(pVenda.Id));
         end;

         TConexao.get.confirmaTransacao;
      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);
      end;
   except
      on E: Exception do
      begin
         TConexao.get.CancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados da venda [Controller]: '#13+
         e.Message);
      end;
   end;
end;

function TVendaController.PesquisaVenda(pVendaId: String): TColVendas;
var
   xVendaDAO : TVendaDAO;
   xCondicao    : String;
begin
   try
      try
         Result := nil;

         xVendaDAO := TVendaDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pVendaId <> EmptyStr,
            'WHERE                                            '#13+
            '    (ID LIKE(''%'+ pVendaId + '%''))'#13+
            'ORDER BY ID', EmptyStr);

         Result := xVendaDAO.RetornaLista(xCondicao);
      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);
      end;
   except
      on E: Exception do
      begin
         Raise Exception.Create(
            'Falha ao buscar os dados da venda [Controller]: '#13+
            e.Message);
      end;
   end;
end;

function TVendaController.RetornaCondicaoVenda(pID_Venda: Integer): String;
var
   xChave : String;
begin
   xChave := 'ID';

   Result :=
   'WHERE '#13+
   ' '+xChave+' = '+ QuotedStr(IntToStr(pID_Venda))+ ' '#13;
end;

end.
 