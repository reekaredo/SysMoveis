unit uControllerCliente;

interface
  uses uDaoCliente, DB, sysutils, DBAccess, MyAccess, MemDS, uCliente;
  type controllerCliente = class

  private

  protected
    umDao : DaoCliente;

  public
      constructor CrieObj;
      destructor destrua_se;

// ------------- M�TODOS DE CLIENTE ------------------
    function getDsCliente : TMyDataSource;
    procedure carregaCliente (pCliente : Cliente);
    function salvaCliente (pCliente : Cliente) : string;
    function excluiCliente(pCliente : Cliente) : string;
    function pesquisaCliente(chave: string): string;
    function pesquisaSalvar(chave : string) : string;
    
end;

implementation

{ controllerCliente }

constructor controllerCliente.CrieObj;
begin
   umDao := DaoCliente.CrieObjeto;
end;

destructor controllerCliente.destrua_se;
begin
  umDao.destrua_se;
end;

procedure controllerCliente.carregaCliente(pCliente: Cliente);
begin
   umDao.carregaCliente (pCliente);
end;

function controllerCliente.excluiCliente(pCliente: Cliente): string;
begin
   Result := umDao.ExcluiCliente(pCliente);
end;

function controllerCliente.getDsCliente: TMyDataSource;
begin
   result := umDao.getDSCliente;
end;

function controllerCliente.pesquisaCliente(chave: string): string;
var mSQL : string;
aux : integer;
begin
  if (chave = 'ORDENAR CODIGO CONTRARIO') then
    begin
      mSQL := 'select * from clientes order by cli_id desc'
    end
  else if (chave = 'ORDENAR CODIGO') then
    begin
      mSQL := 'select * from clientes order by cli_id'
    end
  else if chave = '' then
    mSQL := 'select * from clientes order by cli_nome'
  else if (chave = 'ORDENAR NOME CONTRARIO') then
    begin
      mSQL := 'select * from clientes order by cli_nome desc'
    end
  else
    begin
        mSQL := 'select * from clientes where cli_nome like ' +
        quotedstr('%' + chave + '%') +
        'or cli_apelido like ' + quotedstr('%' + chave + '%') +
        'or cli_cpf like ' + quotedstr('%' + chave + '%') +
        'or cli_celular like ' + quotedstr('%' + chave + '%') +
        'or cli_rg like ' + quotedstr('%' + chave + '%') +
        ' order by cli_nome';
    end;
      aux := umDao.sqlCliente(mSQL);
      if aux = 0 then
        begin
         Result := 'NADA';
        end;
end;

function controllerCliente.salvaCliente(pCliente: Cliente): string;
begin
   Result := umDao.SalvarCliente (pCliente);
end;

function controllerCliente.pesquisaSalvar(chave: string): string;
var mSQL : string;
aux : integer;
begin
  // pesquisa na tabela clientes - tipo 1 de pesquisa  - CPF
      mSQL := 'select * from clientes where cli_cpf = ' + chave;
        aux := umDao.sqlSalvar(mSQL,1);
        if aux = 0 then
            Result := 'OK'
        else
          begin
            Result := 'EXISTE';
           end;  
end;

end.
