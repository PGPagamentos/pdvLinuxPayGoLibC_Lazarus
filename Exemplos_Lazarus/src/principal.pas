unit principal;

{$mode objfpc}{$H+}

interface

uses
  //Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType, LCLProc,LMessages, Menus, ExtCtrls, MaskEdit, uPGWLib, uEnums, ulib, ulib02;

type

  { TTelprincipal }

  TTelprincipal = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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


procedure TTelprincipal.Button5Click(Sender: TObject);
begin
      //
      PGWLib.Init;
end;

procedure TTelprincipal.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TTelprincipal.Button6Click(Sender: TObject);
begin
        // Instalar Ponto de Captura
    PGWLib.Instalacao();
end;

procedure TTelprincipal.Button7Click(Sender: TObject);
begin
      PGWLib.GetVersao;
end;

procedure TTelprincipal.Button8Click(Sender: TObject);
begin
   PGWLib.Libera_Lib;
   Application.Terminate;
end;




procedure TTelprincipal.FormCreate(Sender: TObject);
begin
    Label1.Caption := 'PWINFO_AUTNAME(21): ' + '  ' + PWEnums.PGWEBLIBTEST_AUTNAME;
    Label2.Caption := 'PWINFO_AUTVER (22) : ' + '  ' + PWEnums.PGWEBLIBTEST_VERSION;
    Label3.Caption := 'PWINFO_AUTDEV (23) : ' + '  ' + PWEnums.PGWEBLIBTEST_AUTDEV;
    Label4.Caption := 'PWINFO_AUTCAP (24) : ' + '  ' + PWEnums.PGWEBLIBTEST_AUTCAP;
end;


end.

