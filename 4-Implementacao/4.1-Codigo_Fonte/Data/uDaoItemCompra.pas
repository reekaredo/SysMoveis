unit uDaoItemCompra;

interface
  uses Windows, Messages, SysUtils, DB, uDm, uDao, uItemCompra, DBAccess, MyAccess, MemDS;

  type DaoItemCompra = class(Dao)

  private
  protected
  public
    constructor CrieObjeto;
    destructor destrua_se;

// ------------- M�TODOS DE PARCELAS ------------------
    function getDSItemCompra : TMyDataSource;
    procedure carregaItemCompra(pItemCompra : ItemCompra);
    function SalvarItemCompra(pItemCompra : ItemCompra) : string;
    function ExcluiItemCompra(pItemCompra : ItemCompra) : string;
    function sqlItemCompra(pSQL: string) : Integer;
end;

implementation

{ DaoItemCompra }
constructor DaoItemCompra.CrieObjeto;
begin
    inherited;
end;

destructor DaoItemCompra.destrua_se;
begin
   inherited;
end;

procedure DaoItemCompra.carregaItemCompra(pItemCompra: ItemCompra);
var nome: string;
begin
  if not umDM.SQL_itenscompra.Active then
    begin
      umDM.SQL_itenscompra.Open;
    end;

    pItemCompra.setCodProduto(umdm.SQL_itenscompraitemC_codProduto.Value);
    pItemCompra.setCodCompra(umdm.SQL_itenscompraitemC_codCompra.value);
    pItemCompra.setNumero(umdm.SQL_itenscompraitemC_numero.value);
    pItemCompra.setNome(umdm.SQL_itenscompraitemC_nome.value);
    pItemCompra.setValorUnitario(umdm.SQL_itenscompraitemC_valorUnitario.value);
    pItemCompra.setNCM(umdm.SQL_itenscompraitemC_ncm.value);
    pItemCompra.setCST(umdm.SQL_itenscompraitemC_cst.value);
    pItemCompra.setCFOP(umdm.SQL_itenscompraitemC_cfop.value);
    pItemCompra.setUnidade(umdm.SQL_itenscompraitemC_unidade.value);
    pItemCompra.setQtde(umdm.SQL_itenscompraitemC_qtde.value);
    pItemCompra.setVTotal(umdm.SQL_itenscompraitemC_vTotal.value);
    pItemCompra.setValorICMS(umdm.SQL_itenscompraitemC_valorICMS.value);
    pItemCompra.setBaseICMS(umdm.SQL_itenscompraitemC_baseICMS.value);
    pItemCompra.setValorIPI(umdm.SQL_itenscompraitemC_valorIPI.value);
    pItemCompra.setAliqICMS(umdm.SQL_itenscompraitemC_aliqICMS.value);
    pItemCompra.setAliqIPI(umdm.SQL_itenscompraitemC_aliqIPI.value);

end;

function DaoItemCompra.ExcluiItemCompra(pItemCompra: ItemCompra): string;
var inteiro1, inteiro2: string;
begin
  if not umDM.con_banco.Connected then
    begin
      umDM.con_banco.Connected := True;
    end;

      if not umDM.SQL_itenscompra.Active then
        begin
          umDM.SQL_itenscompra.Open;
        end;

        inteiro1 := IntToStr(pItemCompra.getCodCompra);
        inteiro2 := IntToStr(pItemCompra.getNumero);

   umDM.SQL_itenscompra.Active := False;
   umDM.SQL_itenscompra.SQL.Text := 'select * from itenscompra where itemC_codCompra like ' + inteiro1 + ' and itemC_Numero like ' + inteiro2;
      if not umDM.SQL_itenscompra.Active then
            umDM.SQL_itenscompra.Open;

      umDM.SQL_itenscompra.Edit;

        try
            umDM.SQL_itenscompra.Delete;
            Result := 'OK';
        except
            Result := 'NO';
        end;

      umDM.SQL_itenscompra.Active := False;
      umDM.SQL_itenscompra.SQL.Text := 'select * from itenscompra';
        if not umDM.SQL_itenscompra.Active then
            umDM.SQL_itenscompra.Open;
end;

function DaoItemCompra.getDSItemCompra: TMyDataSource;
begin
   Result := umDM.ds_itenscompra;
end;

function DaoItemCompra.SalvarItemCompra(pItemCompra: ItemCompra): string;
begin
  if not umDM.con_banco.Connected then
    begin
      umDM.con_banco.Connected := True;
    end;

      if not umDM.SQL_itenscompra.Active then
        begin
          umDM.SQL_itenscompra.Open;
        end;
        
     //verificar se existe edi��o de itens
    {  if pItemCompra.getCodigo = 0 then }
        umDM.SQL_itenscompra.Insert;
    {  else
         umDM.SQL_itenscompra.Edit; }

  {  umDM.strngfldSQL_parcelaparc_codigo.Value := pParcela.getCode;  }

    umdm.SQL_itenscompraitemC_codProduto.Value := pItemCompra.getCodProduto;
    umdm.SQL_itenscompraitemC_codCompra.value  := pItemCompra.getCodCompra;
    umdm.SQL_itenscompraitemC_numero.value     := pItemCompra.getNumero;
    umdm.SQL_itenscompraitemC_nome.value       := pItemCompra.getNome;
    umdm.SQL_itenscompraitemC_valorUnitario.value := pItemCompra.getValorUnitario;
    umdm.SQL_itenscompraitemC_ncm.value        := pItemCompra.getNCM;
    umdm.SQL_itenscompraitemC_cst.value        := pItemCompra.getCST;
    umdm.SQL_itenscompraitemC_cfop.value       := pItemCompra.getCFOP;
    umdm.SQL_itenscompraitemC_unidade.value    := pItemCompra.getUnidade;
    umdm.SQL_itenscompraitemC_qtde.value       := pItemCompra.getQtde;
    umdm.SQL_itenscompraitemC_vTotal.value     := pItemCompra.getVTotal;
    umdm.SQL_itenscompraitemC_valorICMS.value  := pItemCompra.getValorICMS;
    umdm.SQL_itenscompraitemC_baseICMS.value   := pItemCompra.getBaseICMS;
    umdm.SQL_itenscompraitemC_valorIPI.value   := pItemCompra.getValorIPI;
    umdm.SQL_itenscompraitemC_aliqICMS.value   := pItemCompra.getAliqICMS;
    umdm.SQL_itenscompraitemC_aliqIPI.value    := pItemCompra.getAliqIPI;

      umDM.SQL_itenscompra.Post;
      Result := 'OK';
end;

function DaoItemCompra.sqlItemCompra(pSQL: string): Integer;
begin
  umDM.SQL_itenscompra.Active := False;
  umDM.SQL_itenscompra.SQL.Text := pSQL;
    if not umDM.SQL_itenscompra.Active then
      umDM.SQL_itenscompra.Open;

  if umDM.SQL_itenscompra.RecordCount = 0 then
    result :=  0
  else
    result := umDM.SQL_itenscompra.RecordCount;
end;

end.
