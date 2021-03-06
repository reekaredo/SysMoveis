unit uColecaoProdutos;

interface
uses uProduto;
  type ColecaoProduto = class

    protected
    colecao : array[1..50] of Produto;
    qtd   : integer;

    public
    constructor CrieObjeto;
    destructor destrua_se;
    function cheia : boolean;
    function vazia : boolean;
    function getQtd : integer;
    function getObj(pPos : integer) : Produto;
    procedure setQtd (pQtd : integer);
    procedure setObj (pProduto : Produto; pPos : integer);
    procedure inserefim( pProduto : Produto);
    procedure insere( pProduto : Produto; pPos : integer);
    procedure remove( pProduto : Produto; pPos : integer);
    function pesquisa (chave : string; quero : boolean) : integer;
  end;

implementation

{ ColecaoProduto }

function ColecaoProduto.cheia: boolean;
begin
     if qtd = 50 then
        Result := True
     else
        Result := False;
end;

constructor ColecaoProduto.CrieObjeto;
begin
   self.qtd := 0;
end;

destructor ColecaoProduto.destrua_se;
begin

end;

function ColecaoProduto.getObj(pPos: integer): Produto;
begin
  Result := colecao[pPos];
end;

function ColecaoProduto.getQtd: integer;
begin
  Result := qtd;
end;

procedure ColecaoProduto.insere(pProduto: Produto; pPos: integer);
  var k : integer;
    begin
    if pPos = qtd + 1 then
      inserefim (pProduto)
    else
      begin
        qtd := qtd+1;
        for k:= qtd downto pPos do
          colecao[k] := colecao[k-1];
        colecao[pPos] := pProduto;
      end;
    end;

procedure ColecaoProduto.inserefim(pProduto: Produto);
begin
      qtd := qtd+1;
      colecao[qtd] := pProduto;
end;

function ColecaoProduto.pesquisa(chave: string; quero: boolean): integer;
var k : integer;
    oProduto : Produto;
begin
    if self.qtd > 0 then
    begin
      k := 1;
      while (k <= qtd) and (chave > colecao[k].getNome) do
      k := k+1;
      oProduto := Produto(colecao[k]);
      if quero then
        begin
          if chave = oProduto.getNome then
            Result := k
          else
            Result := 0
        end
      else
        begin
          if chave = oProduto.getNome then
            Result := 0
          else
            Result := k
        end;
    end
    else
    begin
      result := 1;
    end;
end;

procedure ColecaoProduto.remove(pProduto: Produto; pPos: integer);
  var k : integer;
    begin
      pProduto := colecao[pPos];
      for k:= pPos to qtd-1 do
        colecao[k] := colecao[k-1];
      qtd := qtd-1;
    end;

procedure ColecaoProduto.setObj(pProduto: Produto; pPos: integer);
begin
      colecao[pPos] := pProduto;
end;

procedure ColecaoProduto.setQtd(pQtd: integer);
begin
  self.qtd := pQtd;
end;

function ColecaoProduto.vazia: boolean;
begin
      if qtd = 0 then
        result := true
      else
        result := false;
end;

end.
