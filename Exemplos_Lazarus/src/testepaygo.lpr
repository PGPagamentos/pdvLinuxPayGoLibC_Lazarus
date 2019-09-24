program testepaygo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, principal, upgwlib, uenums, ulib, ulib02,fcaptura, uValor;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TTelprincipal, Telprincipal);
  Application.CreateForm(Ttelcaptura, telcaptura);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

