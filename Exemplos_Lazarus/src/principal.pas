//*****************************************************************************/
{
 Formulario Main da Aplicação

 Data de criação  : 15/09/2019
 Autor            :
 }
//*****************************************************************************/
unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLType, LCLProc, LMessages, Menus, ExtCtrls, MaskEdit, uPGWLib,
  uEnums, ulib, ulib02, fcaptura, uValor;

type

  { TTelprincipal }

  TTelprincipal = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button15: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private

  public

    PWEnums : TCEnums;
    PGWLib  : TPGWLib;

  end;

var
  Telprincipal: TTelprincipal;


implementation

{$R *.lfm}

{ TTelprincipal }


procedure TTelprincipal.Button9Click(Sender: TObject);
begin
      // Inicializa a Lib
      PGWLib.Init;
end;



procedure TTelprincipal.FormCreate(Sender: TObject);
begin
    // Atualiza Informações da Aplicação Nome/Versão
    Label1.Caption := 'PWINFO_AUTNAME(21): ' + '  ' + PWEnums.PGWEBLIBTEST_AUTNAME;
    Label2.Caption := 'PWINFO_AUTVER (22) : ' + '  ' + PWEnums.PGWEBLIBTEST_VERSION;
    Label3.Caption := 'PWINFO_AUTDEV (23) : ' + '  ' + PWEnums.PGWEBLIBTEST_AUTDEV;
    Label4.Caption := 'PWINFO_AUTCAP (24) : ' + '  ' + PWEnums.PGWEBLIBTEST_AUTCAP;
end;

procedure TTelprincipal.Panel1Click(Sender: TObject);
begin

end;


procedure TTelprincipal.Button10Click(Sender: TObject);
begin
    // Instalar Ponto de Captura
    PGWLib.Instalacao();
end;

procedure TTelprincipal.Button11Click(Sender: TObject);
begin
      // executa Método de Transação Venda
      PGWLib.venda;
end;

procedure TTelprincipal.Button12Click(Sender: TObject);
begin
      // Retorna Versão atual da Lib
      PGWLib.GetVersao;
end;


procedure TTelprincipal.Button15Click(Sender: TObject);
begin
      // Reimpressão do Recibo da ultima transação de Venda
      PGWLib.Reimpressao();
end;

procedure TTelprincipal.Button1Click(Sender: TObject);
begin
      // Confirmação de Transação
      PGWLib.ConfirmaTrasacao();
end;

procedure TTelprincipal.Button2Click(Sender: TObject);
begin
   // Relatório de Vendas/Cancelamentos por Data/Hora
   PGWLib.Relatorios();
end;

procedure TTelprincipal.Button3Click(Sender: TObject);
begin
  // Cancelamento de Transação de Venda
  PGWLib.Cancelamento();
end;

procedure TTelprincipal.Button4Click(Sender: TObject);
begin
  // Executa Método Administrativo
  PGWLib.Admin();
end;

procedure TTelprincipal.Button5Click(Sender: TObject);
begin
  // Executa Metodo de Auto Atendimento
  PGWLib.TesteAA();
end;

procedure TTelprincipal.Button6Click(Sender: TObject);
begin
      // Finaliza aplicação e Libera Lib da Memória
      PGWLib.Libera_Lib;
      Application.Terminate;
end;

procedure TTelprincipal.Button7Click(Sender: TObject);
begin
   // Limpa Tela de Log da Aplicação
   Memo1.Clear;
end;

procedure TTelprincipal.Button8Click(Sender: TObject);
begin
  // Executa Captura de PinPad
  telcaptura.ShowModal;
end;


end.

