unit UPrincipalView;   //Nome da Unit

interface

uses  //frxUnicodeCtrls que serão utilizadas dentro desta classe
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, jpeg;

type
  TfrmPrincipal = class(TForm)  // Nome da Classe
    {
      Lista de components visuais que são adicionados no prótotipo da tela
      Lembre-se de renomear TODOS os components que forem adicionados
    }
    menMenu: TMainMenu;
    menCadastros: TMenuItem;
    menClientes: TMenuItem;
    menProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menRelVendas: TMenuItem;
    menMovimentos: TMenuItem;
    menVendas: TMenuItem;
    menSair: TMenuItem;
    stbBarraStatus: TStatusBar;
    imgLogo: TImage;
    menUnidadeProdutos: TMenuItem;
    //Métodos do formulário
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
    procedure menUnidadeProdutosClick(Sender: TObject);
    procedure menProdutosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UConexao, UClientesView, UUnidadeProdutosView, UProdutosView;

{$R *.dfm}

procedure TfrmPrincipal.menSairClick(Sender: TObject);
begin
   Close; // Fecha o Sistema
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
   stbBarraStatus.Panels[0].Text :=
      'Caminho do BD: '+ TConexao.get.getCaminhoBanco
end;

procedure TfrmPrincipal.menClientesClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmClientes = nil then
         frmClientes := TfrmClientes.Create(Application);

      frmClientes.Show;
   finally
      Screen.Cursor := crDefault;

   end;
end;


procedure TfrmPrincipal.menUnidadeProdutosClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmUnidadeProdutos = nil then
         frmUnidadeProdutos := TfrmUnidadeProdutos.Create(Application);
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfrmPrincipal.menProdutosClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmProdutos = nil then
         frmProdutos := TfrmProdutos.Create(Application);

      frmProdutos.Show;
   finally
      Screen.Cursor := crDefault;
   end;
end;

end.
