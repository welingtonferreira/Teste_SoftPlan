unit uController;

interface

uses Classes, Datasnap.DBClient, //
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
   Data.DB;

type
  TContador=class(TThread)
  protected
    procedure Execute; override;
  end;

implementation



{ TContador }

uses ClienteServidor;

procedure TContador.Execute;
var
    i: Integer;
begin
{$WARNINGS OFF}
  inherited;
  Priority := tpLower;
  fClienteServidor.gauge.Progress:=0;
  for i := 0 to QTD_ARQUIVOS_ENVIADOS do
  begin
    fClienteServidor.gauge.Progress  :=  i;
  end;
{$WARNINGS ON}
end;

end.
