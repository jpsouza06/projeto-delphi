program NovoSistema;

uses
  Forms,
  UPrincipalView in 'View\UPrincipalView.pas' {frmPrincipal},
  UConexao in 'Model\BD\UConexao.pas',
  UCriptografiaUtil in 'Model\Util\UCriptografiaUtil.pas',
  UClassFuncoes in 'Model\Util\UClassFuncoes.pas',
  UClientesView in 'View\UClientesView.pas' {frmClientes},
  uMessageUtil in 'Model\Util\uMessageUtil.pas',
  Consts in 'Model\Util\Consts.pas',
  UEnumerationUtil in 'Model\Util\UEnumerationUtil.pas',
  UPessoa in 'Model\UPessoa.pas',
  UPessoaDAO in 'Model\UPessoaDAO.pas',
  UGenericDAO in 'Model\BD\UGenericDAO.pas',
  UCliente in 'Model\UCliente.pas',
  UPessoaController in 'Controller\UPessoaController.pas',
  UEndereco in 'Model\UEndereco.pas',
  UEnderecoDAO in 'Model\UEnderecoDAO.pas',
  UClientesPesqView in 'View\UClientesPesqView.pas' {frmClientesPesq},
  UUnidadeProdutosView in 'View\UUnidadeProdutosView.pas' {frmUnidadeProdutos},
  UUnidadeProdutos in 'View\UUnidadeProdutos.pas',
  UUnidadadeProdutosDAO in 'View\UUnidadadeProdutosDAO.pas',
  UUnidadeProdutosController in 'Controller\UUnidadeProdutosController.pas',
  UUnidadeProdutosPesqView in 'View\UUnidadeProdutosPesqView.pas' {frmUnidadeProdutosPesq},
  UProdutosView in 'View\UProdutosView.pas' {frmProdutos},
  UProdutos in 'Model\UProdutos.pas',
  UProdutosDAO in 'Model\UProdutosDAO.pas',
  UProdutosController in 'Controller\UProdutosController.pas',
  UProdutosPesqView in 'View\UProdutosPesqView.pas' {frmProdutosPesq},
  UVendasView in 'View\UVendasView.pas' {frmVendas},
  UVendas in 'Model\UVendas.pas',
  UVendaDAO in 'Model\UVendaDAO.pas',
  UVendaController in 'Controller\UVendaController.pas',
  UVendaItemDAO in 'Model\UVendaItemDAO.pas',
  UVendaItem in 'Model\UVendaItem.pas',
  UVendasPesqView in 'View\UVendasPesqView.pas' {frmVendasPesq};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
