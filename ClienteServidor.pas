unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Datasnap.DBClient, Data.DB, Vcl.Samples.Gauges;

type
  TServidor = class
  private
    FPath: AnsiString;
  public
    constructor Create;
    // Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    Gauge: TGauge;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
  private
    FPath: AnsiString;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;
  QTD_ARQUIVOS_ENVIADOS = 9999999999;

implementation

uses
  IOUtils,uController;

{$R *.dfm}

procedure LogException(NomeArquivo: string; E: Exception);
var
  Arquivo: TextFile;
begin
  AssignFile(Arquivo, NomeArquivo);
  if FileExists(NomeArquivo) then
    Append(Arquivo)
  else
    ReWrite(Arquivo);
  try
    WriteLn(Arquivo, 'Data: ' + DateTimeToStr(Now));
    WriteLn(Arquivo, 'Erro: ' + E.Message);
    WriteLn(Arquivo, '------------------------------------------- ');
  finally
    CloseFile(Arquivo);
  end;
end;

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
{$WARNINGS OFF}
  cds := InitDataset;
  try
    for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      cds.Append;
      TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
      cds.Post;
{$REGION Simulação de erro, não alterar}
      if i = (QTD_ARQUIVOS_ENVIAR / 2) then
        FServidor.SalvarArquivos(NULL);
        deletefile(FPath);
{$ENDREGION}
    end;
  except
    on E: Exception do
    begin
      LogException(ChangeFileExt(Application.Exename, '.log'), E);
      ShowMessage(E.Message);
    end;
{$WARNINGS ON}
  end;

  FServidor.SalvarArquivos(cds.Data);
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
var
  ThreadContador: TContador;
begin
{$WARNINGS OFF}
  ThreadContador := TContador.Create(True);
  ThreadContador.FreeOnTerminate := True;
  ThreadContador.Resume;
{$WARNINGS ON}
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
{$WARNINGS OFF}
  try
    Gauge.Progress := 0;
    cds := InitDataset;
    for i := 0 to QTD_ARQUIVOS_ENVIAR do
      begin
      cds.Append;
      TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
      cds.Post;
      cds.EmptyDataSet;
      Gauge.Progress := Gauge.Progress + i;
      cds.Next;
    end;
      FServidor.SalvarArquivos(cds.Data);
  except
      on E: Exception do 
  end;
{$WARNINGS OFF}
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
  FServidor := TServidor.Create;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataset;
  FileName: string;
begin
  try
    cds := TClientDataset.Create(Nil);
    cds.Data := AData;

{$REGION Simulação de erro, não alterar}
    if cds.RecordCount = 0 then
      Exit;
{$ENDREGION}
    cds.First;

    while not cds.Eof do
    begin
      FileName := FPath + cds.RecNo.ToString + '.pdf';
      if TFile.Exists(FileName) then
        TFile.Delete(FileName);

      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
      cds.Next;
    end;

    Result := True;
  finally
    cds.Free;
  end;
end;

end.
