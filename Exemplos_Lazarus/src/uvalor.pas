//*****************************************************************************/
{
 Form1
 Formulario auxiliar para Digitação de Valores com Mascara

 Data de criação  : 23/09/2019
 Autor            :
}
//*****************************************************************************/
unit uValor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

    retornado:String;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin

  retornado:= 'VALOR';

  Close;

end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  retornado:= 'CANCELA';
  Close;
end;

procedure TForm1.Edit1Change(Sender: TObject);
var
 s : string;
 v : double;
 I : integer;
 Texto, Texto2: string;
begin


  // se o edit estiver vazio, nada pode ser feito.
   if TEdit(Sender).Text = EmptyStr then
      TEdit(Sender).Text := '0,00';

   //obter o texto do edit, SEM a virgula e SEM o ponto decimal:
   s := '';
   for I := 1 to length(TEdit(Sender).Text) do
   if (TEdit(Sender).Text[I] in ['0'..'9']) then
      s := s + TEdit(Sender).Text[I];

   //fazer com que o conteúdo do edit apresente 2 casas decimais:
   v := strtofloat(s);
   v := (v /100); // para criar 2 casa decimais

   //Formata o valor de (V) para aceitar valores do tipo 0,10.
   TEdit(Sender).Text := FormatFloat('###,##0.00',v);
   TEdit(Sender).SelStart := 0;




end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
var
 Texto, Texto2: string;
 i: byte;
begin

   if NOT (Key in ['0'..'9', #8, #9]) then
     key := #0;
     //Função para posicionar o cursor sempre na direita
     TEdit(Sender).SelStart := Length(TEdit(Sender).Text);


end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.Text:= '0.00';
end;


end.

