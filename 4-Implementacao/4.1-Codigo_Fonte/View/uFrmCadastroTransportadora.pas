unit uFrmCadastroTransportadora;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmCadastroPai, StdCtrls, Mask, uTransportadora, uController, uFrmConsultaCidade;

type
  TFrmCadastroTransportadora = class(TFrmCadastroPai)
    lbl_nome: TLabel;
    lbl_fone2: TLabel;
    lbl_email: TLabel;
    lbl1: TLabel;
    label_bairro: TLabel;
    edt_nome: TEdit;
    edt_veiculoUF: TEdit;
    edt_antt: TEdit;
    edt_endereco: TEdit;
    edt_placa: TEdit;
    label_logradouro: TLabel;
    edt_fone1: TMaskEdit;
    lbl_fone1: TLabel;
    edt_codCidade: TEdit;
    edt_cidade: TEdit;
    lbl_cidade: TLabel;
    btn_buscar: TButton;
    label_cpf: TLabel;
    edt_cnpj: TMaskEdit;
    label_RG: TLabel;
    edt_insc: TEdit;
    btn_habilitar: TButton;
    edt_UF: TEdit;
    procedure btn_buscarClick(Sender: TObject);
    procedure btn_habilitarClick(Sender: TObject);
  private
    { Private declarations }
    umaTransportadora : Transportadora;
    umFrmConsultaCidade : TFrmConsultaCidade;
  protected
        umController : controller;
        procedure Sair;  override;
        procedure Salvar; override;
        procedure CarregaEdit; override;
        procedure LimparCampos; override;
        function validaCampos: Boolean;
        function isCNPJ(CNPJ: string): boolean;
        function isNumerico(texto: string): Boolean;      
  public
    { Public declarations }
        procedure ConhecaObj(pObj : TObject; pController: controller); override;
        procedure SetConsultaCidade (pObj : TForm);
        procedure DesabilitaCampos;
        procedure HabilitaCampos;
  end;

var
  FrmCadastroTransportadora: TFrmCadastroTransportadora;

implementation

uses uControllerTransportadora;

{$R *.dfm}

{ TFrmCadastroTransportadora }

procedure TFrmCadastroTransportadora.CarregaEdit;
begin
  self.edt_cod.Text := inttostr(umaTransportadora.getCodigo);
  self.edt_nome.Text := umaTransportadora.getNome;
  self.edt_antt.Text := umaTransportadora.getAntt;
  self.edt_cnpj.Text := umaTransportadora.getCNPJ;
  self.edt_endereco.Text := umaTransportadora.getEndereco;
  self.edt_codCidade.Text := IntToStr(umaTransportadora.getUmaCidade.getCodigo);
  self.edt_cidade.Text := umaTransportadora.getUmaCidade.getCidade;
  self.edt_insc.Text := umaTransportadora.getInscEst;
  self.edt_placa.Text := umaTransportadora.getPlaca;
  self.edt_veiculoUF.Text := umaTransportadora.getUFveiculo;
  self.edt_UF.Text := umaTransportadora.getUF;
  self.edt_fone1.Text := umaTransportadora.getFone;
end;

procedure TFrmCadastroTransportadora.ConhecaObj(pObj: TObject;
  pController: controller);
begin
  umaTransportadora := Transportadora (pObj);
  umController := pController;

    Self.LimparCampos;
      if umaTransportadora.getCodigo <> 0 then
                begin
                  Self.CarregaEdit;
                end;
      if self.btn_salvar.Caption = '&Salvar' then
          HabilitaCampos
      else
          DesabilitaCampos;
end;

procedure TFrmCadastroTransportadora.DesabilitaCampos;
begin
  self.btn_buscar.Enabled := false;
  self.edt_cod.Enabled := false;
  self.edt_nome.Enabled := false;
  self.edt_antt.Enabled := false;
  self.edt_cnpj.Enabled := false;
  self.edt_endereco.Enabled := false;
  self.edt_codCidade.Enabled := false;
  self.edt_cidade.Enabled := false;
  self.edt_insc.Enabled := false;
  self.edt_placa.Enabled := false;
  self.edt_veiculoUF.Enabled := false;
  self.edt_UF.Enabled := false;
  self.edt_fone1.Enabled := false;
end;

procedure TFrmCadastroTransportadora.HabilitaCampos;
begin
  self.btn_buscar.Enabled := true;
  self.edt_cod.Enabled := true;
  self.edt_nome.Enabled := true;
  self.edt_antt.Enabled := true;
  self.edt_cnpj.Enabled := true;
  self.edt_endereco.Enabled := true;
  self.edt_codCidade.Enabled := true;
  self.edt_cidade.Enabled := true;
  self.edt_insc.Enabled := true;
  self.edt_placa.Enabled := true;
  self.edt_veiculoUF.Enabled := true;
  self.edt_UF.Enabled := true;
  self.edt_fone1.Enabled := true;
end;

function TFrmCadastroTransportadora.isCNPJ(CNPJ: string): boolean;
var   dig13, dig14: string;
    sm, i, r, peso: integer;
begin
// length - retorna o tamanho da string do CNPJ (CNPJ � um n�mero formado por 14 d�gitos)
  if ((CNPJ = '00000000000000') or (CNPJ = '11111111111111') or
      (CNPJ = '22222222222222') or (CNPJ = '33333333333333') or
      (CNPJ = '44444444444444') or (CNPJ = '55555555555555') or
      (CNPJ = '66666666666666') or (CNPJ = '77777777777777') or
      (CNPJ = '88888888888888') or (CNPJ = '99999999999999') or
      (length(CNPJ) <> 14))
     then begin
            isCNPJ := false;
            exit;
          end;

// "try" - protege o c�digo para eventuais erros de convers�o de tipo atrav�s da fun��o "StrToInt"
  try
{ *-- C�lculo do 1o. Digito Verificador --* }
    sm := 0;
    peso := 2;
    for i := 12 downto 1 do
    begin
// StrToInt converte o i-�simo caractere do CNPJ em um n�mero
      sm := sm + (StrToInt(CNPJ[i]) * peso);
      peso := peso + 1;
      if (peso = 10)
         then peso := 2;
    end;
    r := sm mod 11;
    if ((r = 0) or (r = 1))
       then dig13 := '0'
    else str((11-r):1, dig13); // converte um n�mero no respectivo caractere num�rico

{ *-- C�lculo do 2o. Digito Verificador --* }
    sm := 0;
    peso := 2;
    for i := 13 downto 1 do
    begin
      sm := sm + (StrToInt(CNPJ[i]) * peso);
      peso := peso + 1;
      if (peso = 10)
         then peso := 2;
    end;
    r := sm mod 11;
    if ((r = 0) or (r = 1))
       then dig14 := '0'
    else str((11-r):1, dig14);

{ Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig13 = CNPJ[13]) and (dig14 = CNPJ[14]))
       then isCNPJ := true
    else isCNPJ := false;
  except
    isCNPJ := false
  end;
end;

function TFrmCadastroTransportadora.isNumerico(texto: string): Boolean;
var
valor :  string; 
nr : integer;
c : integer;
tam, k: integer;
begin
     tam:= length(texto);
     for k:= 1 to tam do
       begin
         val(texto[k],nr,c);
            if c<>0 then
               begin
                  Result:= false;
                  exit;
               end;
         Result:= true;
       end;
 {     val(texto,nr,c);
      if c=0 then
      result := true
      else
      Result := false;   }
end;

procedure TFrmCadastroTransportadora.LimparCampos;
begin
  self.edt_cod.clear;
  self.edt_nome.clear;
  self.edt_antt.clear;
  self.edt_cnpj.clear;
  self.edt_endereco.clear;
  self.edt_codCidade.clear;
  self.edt_cidade.clear;
  self.edt_insc.clear;
  self.edt_placa.clear;
  self.edt_veiculoUF.clear;
  self.edt_UF.clear;
  self.edt_fone1.clear;
end;

procedure TFrmCadastroTransportadora.Sair;
begin
  inherited;
end;

procedure TFrmCadastroTransportadora.Salvar;
var incluido, excluido, permitir : string;
selected : integer;
men : TForm;
begin
        if self.btn_salvar.Caption = '&Salvar' then
          begin
                 if validaCampos = True then
                    begin
                        umaTransportadora.setNome(self.edt_nome.Text);
                        umaTransportadora.setAntt(self.edt_antt.Text);
                        umaTransportadora.setCNPJ(self.edt_cnpj.Text);
                        umaTransportadora.setEndereco(self.edt_endereco.Text);
                        umaTransportadora.setInscEst(self.edt_insc.Text);
                        umaTransportadora.setPlaca(self.edt_placa.Text);
                        umaTransportadora.setUFveiculo(self.edt_veiculoUF.Text);
                        umaTransportadora.setUF(self.edt_UF.Text);
                        umaTransportadora.setfone(self.edt_fone1.Text);


                        incluido :=  umController.getControllerTransportadora.salvaTransportadora(umaTransportadora);
                             if incluido = 'OK' then
                                if umaTransportadora.getCodigo = 0 then
                                  ShowMessage(umaTransportadora.getNome + ' inclu�da com sucesso!')
                                else
                                  ShowMessage(umaTransportadora.getNome + ' alterada com sucesso!');
                      inherited;
                    end;
          end
          else
            begin
               men := CreateMessageDialog('Deseja mesmo excluir a transportadora ' + QuotedStr(umaTransportadora.getNome) + '?',mtCustom,[mbYes,mbAbort]);
               men.Caption := 'Confirma��o';
               men.Position := poDesktopCenter;
               selected := men.ShowModal;

                if selected = mrYes then
                  begin
                       permitir := umController.getControllerTransportadora.pesquisaDependencia(umaTransportadora.getCodigo);
                          if permitir = 'OK' then
                            begin
                              excluido :=  umController.getControllerTransportadora.excluiTransportadora(umaTransportadora);
                              ShowMessage(QuotedStr(umaTransportadora.getNome) + ' exclu�da com sucesso!');
                            end
                            else
                                Showmessage('N�o foi poss�vel excluir a transportadora! H� compras vinculados a ela!');
                  inherited;
                  end;
            end;
end;

procedure TFrmCadastroTransportadora.SetConsultaCidade(pObj: TForm);
begin
    umFrmConsultaCidade := TFrmConsultaCidade (pObj);
end;

function TFrmCadastroTransportadora.validaCampos: Boolean;
begin
    Result := False;
        if (self.edt_nome.Text = '') then
            begin
                ShowMessage('O campo Nome � obrigat�rio');
                edt_nome.SetFocus;
            end
        else if (self.edt_cidade.Text = '') then
            begin
                ShowMessage('O campo Cidade � obrigat�rio');
                btn_buscar.SetFocus;
            end
        else if (self.edt_UF.Text = '') then
            begin
                ShowMessage('O campo UF � obrigat�rio');
                edt_UF.SetFocus;
            end
        else
           begin
           if (Self.edt_cnpj.Text <> '') then
                begin
                  if isCNPJ(edt_cnpj.Text) = False then
                    begin
                     ShowMessage('CNPJ Inv�lido!');
                     Result := False;
                     Exit;
                    end
                  else
                      Result := True;
                end;
           Result := True;
           end;
end;

procedure TFrmCadastroTransportadora.btn_buscarClick(Sender: TObject);
begin
  umFrmConsultaCidade.ConhecaObj(umaTransportadora.getUmaCidade,umController);
  umFrmConsultaCidade.btn_Sair.Caption := 'Selecionar';
  umFrmConsultaCidade.ShowModal;
  Self.edt_codCidade.Text := IntToStr(umaTransportadora.getUmaCidade.getCodigo);
  Self.edt_cidade.Text := umaTransportadora.getUmaCidade.getCidade;
  umFrmConsultaCidade.btn_Sair.Caption := 'Sair';        
end;

procedure TFrmCadastroTransportadora.btn_habilitarClick(Sender: TObject);
begin
  inherited;
  self.HabilitaCampos;
  self.btn_salvar.Enabled := true;
  self.btn_habilitar.Enabled := False;
  Self.btn_buscar.Enabled := True;
end;

end.
