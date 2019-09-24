unit fcaptura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, upgwlib;

type

  { Ttelcaptura }

  Ttelcaptura = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
  private

  public
    PGWLib  : TPGWLib;

  end;

var
  telcaptura: Ttelcaptura;

implementation

{$R *.lfm}

{ Ttelcaptura }

procedure Ttelcaptura.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure Ttelcaptura.Button2Click(Sender: TObject);
var
nome:string;
begin

  label4.Visible := True;
  Label4.Caption := '';
  label4.Visible := False;
  Application.ProcessMessages;
  if (ComboBox1.ItemIndex < 0)then
     begin
       ShowMessage('Escolha Uma Mensagem Válida');
       Exit;
     end;
  nome := combobox1.items[combobox1.ItemIndex];
  PGWLib.CapturaPinPad(nome,ComboBox1.ItemIndex+1,ComboBox2.ItemIndex+1,ComboBox3.ItemIndex+1);

end;

procedure Ttelcaptura.ComboBox1Change(Sender: TObject);
begin

end;

procedure Ttelcaptura.RadioButton1Change(Sender: TObject);
begin
     if (RadioButton1.Checked = True) then
      begin
        ComboBox1.Enabled := True;
        Label4.Caption := '';
        Label4.Visible := False;
      end;

end;

procedure Ttelcaptura.RadioButton2Change(Sender: TObject);
begin
     if (RadioButton2.Checked = True) then
      begin
        ComboBox1.Enabled := False;
        Label4.Caption := '';
        Label4.Visible := False;
      end;

end;



end.

