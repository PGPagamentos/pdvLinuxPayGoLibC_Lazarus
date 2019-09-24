//*****************************************************************************
  {
   unit:   uLib
   Classe: uLib

   Data de criação  : 20/05/2019
   Autor            :
   Descrição        : Lib contendo estruturas Auxiliares da Aplicação
   }
//*****************************************************************************/
unit ulib;

{$mode objfpc}{$H+}



interface
uses
  SysUtils, Variants, Classes, StrUtils, LCLType,LCLIntf,Types,
  Graphics,Controls, Forms, Dialogs, StdCtrls,MaskEdit;


function GetAveCharSize(Canvas: TCanvas): TPoint;
function vInputQuery(const ACaption, APrompt: string; var Value: string;Altura:Integer): Boolean;
function vInputBox(const ACaption, APrompt, ADefault: string; Altura:Integer): string;
//function vInputBox(const ACaption, APrompt, ADefault: string; x,y: integer): string;

function KeyIsDown(const Key: integer): boolean;


function GetMAveCharSize(Canvas: TCanvas): TPoint;
function vMInputQuery(const ACaption, APrompt: string; var Value: string;Altura:Integer;Tipo:Integer): Boolean;
//function vMInputBox(const ACaption, APrompt, ADefault: string; x,y: integer): string;
function vMInputBox(const ACaption, APrompt, ADefault: string;Altura:Integer;Tipo:Integer): string;

Function tirapontos(texto : String) : String;

var
x:Integer;


implementation




//==========================================================
  {
    Auxliar para capturar tamanho dos caracteres de InputBox
  }
//==========================================================
function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;

end;


//==========================================================
  {
    Cria Formulário para entrada de dados
  }
//==========================================================
function vInputQuery(const ACaption, APrompt: string; var Value: string;Altura:Integer): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  X:Integer;
  Y:Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  Y := 250;
  X := 600;
with Form do
try
  FormStyle := fsStayOnTop;
  BorderIcons := BorderIcons - [biSystemMenu] - [biMaximize]; // Tira Maximizar
  Canvas.Font := Font;
  DialogUnits := GetAveCharSize(Canvas);
  BorderStyle := bsSingle;
  Caption := ACaption;
  ClientWidth := MulDiv(180, DialogUnits.X, 4);
  //ClientWidth := 360;  //360
  Position := poDesigned;
  Top := Y;   // 250
  Left := X;  // 600
  Prompt := TLabel.Create(Form);
with Prompt do
begin
  Font.Name := 'Ubuntu';
  Parent := Form;
  Caption := APrompt;
  Left := MulDiv(8, DialogUnits.X, 4);
  Top := MulDiv(18, DialogUnits.Y, 18);     // 8
  Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
  WordWrap := True;
end;
Edit := TEdit.Create(Form);
with Edit do
begin
  Parent := Form;
  Left := Prompt.Left;
  //ShowMessage('15+altura: ' + IntToStr(15+Altura) );
  Top := Prompt.Top + Prompt.Height + (15 * Altura);   //170;     //5   // Altura do Label Para Varias Linhas
  Width := MulDiv(164, DialogUnits.X, 4);
  MaxLength := 255;
  // PassWordChar := ´*´;
  Text := Value;
  SelectAll;
end;
  ButtonTop := Edit.Top + Edit.Height + 15;
  ButtonWidth := MulDiv(50, DialogUnits.X, 4);
  ButtonHeight := MulDiv(14, DialogUnits.Y, 8); //14
with TButton.Create(Form) do
begin
  Parent := Form;
  Caption := 'Ok';
  ModalResult := mrOk;
  Default := True;
  SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
  ButtonHeight);
end;

with TButton.Create(Form) do
begin
  Parent := Form;
  Caption := 'Cancelar';
  ModalResult := mrCancel;
  Cancel := True;
  //Enabled := False;
  Visible := True;       // Esconde Botão Cancelar
  SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
  ButtonWidth, ButtonHeight);
  Form.ClientHeight := Top + Height + 13;
end;

if ShowModal = mrOk then
begin
  Value := Edit.Text;
  Result := True;
end
else if ShowModal = mrCancel then
   begin
     value  := 'CANCELA';
     Result := True;
   end;

finally
  Form.Free;
end;
end;



//==========================================================
  {
    Executa ImputBox
  }
//==========================================================
function vInputBox(const ACaption, APrompt, ADefault: string;Altura:Integer): string;
begin
  Result := ADefault;
  vInputQuery(ACaption, APrompt, Result,Altura);
end;



function KeyIsDown(const Key: integer): boolean;
begin
  //Result := GetKeyState(Key) and 128 > 0;
end;





//==========================================================
  {
    Mascara Auxliar para capturar tamanho dos caracteres de InputBox
  }
//==========================================================
function GetMAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;



end;



//==========================================================
  {
    Cria Formulário com Mascara para entrada de dados
  }
//==========================================================
function vMInputQuery(const ACaption, APrompt: string; var Value: string; Altura:Integer;Tipo:Integer): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit:TMaskEdit;
  aux:string;
  //Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  X:Integer;
  Y:Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  Y := 250;
  X := 600;
with Form do
try
  FormStyle := fsStayOnTop;
  BorderIcons := BorderIcons - [biSystemMenu] - [biMaximize]; // Tira Maximizar
  Canvas.Font := Font;
  DialogUnits := GetAveCharSize(Canvas);
  BorderStyle := bsDialog;
  Caption := ACaption;
  //ClientWidth := MulDiv(180, DialogUnits.X, 4);
  ClientWidth := 360;
  Position := poDesigned;
  Top := Y;   // 250
  Left := X;  // 600
  //Top := 250;   // 750
  //Left := 600;  // 140
  Prompt := TLabel.Create(Form);
with Prompt do
begin
  Parent := Form;
  Caption := APrompt;
  Left := MulDiv(8, DialogUnits.X, 4);
  Top := MulDiv(18, DialogUnits.Y, 18);   // 8
  Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
  WordWrap := True;
end;
Edit := TMaskEdit.Create(Form);
with Edit do
begin
  Parent := Form;
  Left := Prompt.Left;
  //Top := Prompt.Top + Prompt.Height + 35;  //5
  Top := Prompt.Top + Prompt.Height + (15 * Altura);   //170;     //5   // Altura do Label Para Varias Linhas
  Width := MulDiv(164, DialogUnits.X, 4);
  MaxLength := 255;

  if Tipo = 1 then         // Data com ano de 4 digitos
  begin
    EditMask := '!99/99/0000;0;_';
  end;


  if Tipo = 2 then        // Valor
  begin
      //EditMask :=  '!990.990;1;_';
      EditMask :=  '000,00;0;_';
  end;

  if Tipo = 3 then       // Horário
  begin
    EditMask :=  '!90:00;0;_';
  end;

 if Tipo = 4 then         // Data com ano  de 2 digitos
  begin
    EditMask := '!99/99/00;0;_';
  end;


  // PassWordChar := ´*´;
  Text := Value;
  SelectAll;
end;
  ButtonTop := Edit.Top + Edit.Height + 15;
  ButtonWidth := MulDiv(50, DialogUnits.X, 4);
  ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
with TButton.Create(Form) do
begin
  Parent := Form;
  Caption := 'Ok';
  ModalResult := mrOk;
  Default := True;
  SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
  ButtonHeight);
end;

with TButton.Create(Form) do
begin
  Parent := Form;
  Caption := 'Cancelar';
  ModalResult := mrCancel;
  Cancel := True;
  //Enabled := False;
  Visible := True;       // Esconde Botão Cancelar
  SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
  ButtonWidth, ButtonHeight);
  Form.ClientHeight := Top + Height + 13;
end;

if ShowModal = mrOk then
begin
  Value := Edit.Text;
  Result := True;
end
else if ShowModal = mrCancel then
   begin
     value  := 'CANCELA';
     Result := True;
   end;
finally
  Form.Free;
end;
end;




//==========================================================
  {
    Executa ImputBox Com Mascara
  }
//==========================================================
function vMInputBox(const ACaption, APrompt, ADefault: String; Altura:Integer;Tipo:Integer): string;
begin
  Result := ADefault;
  vMInputQuery(ACaption, APrompt, Result,Altura,Tipo);
end;





//================================================================


Function tirapontos(texto : String) : String;
Begin

  While pos('-', Texto) <> 0 Do
    delete(Texto,pos('-', Texto),1);

  While pos('.', Texto) <> 0 Do
    delete(Texto,pos('.', Texto),1);

  While pos('/', Texto) <> 0 Do
    delete(Texto,pos('/', Texto),1);

  While pos(',', Texto) <> 0 Do
    delete(Texto,pos(',', Texto),1);

  Result := Texto;
End;



end.

interface

uses
  Classes, SysUtils;

implementation

end.

