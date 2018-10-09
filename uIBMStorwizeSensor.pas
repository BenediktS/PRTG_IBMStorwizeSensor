unit uIBMStorwizeSensor;

interface

uses sysUtils, uPRTGResult, Classes, uISSHConnector;


type TIBMStorwize = class(TObject)
  private
    sshConnector: ISSHConnector;
    PRTGResult : TPRTGResult;
    FieldCaptionArray : TArray<string>;
    procedure AddLineToResult(aLine : string; const catchFieldNrs : TArray<integer>);
    function GetFieldsFromIBMLine(aLine: string): TArray<string>;
  public
    class function execute(const aSSHConnector: ISSHConnector; const command: string; const CatchFieldNrs : TArray<integer>): string;
    constructor Create(const aSSHConnector: ISSHConnector); reintroduce;
    function GetCommandResult(const aCommand: string; const catchFieldNrs : TArray<integer>): string;
end;


implementation

{ TIBMStorwize }



function TIBMStorwize.GetCommandResult(const aCommand: string; const catchFieldNrs : TArray<integer>): string;
var
  IBMResult : TStringList;
  i : integer;
begin
  PRTGResult.clear;

  try
    IBMResult := TStringList.Create;
    try
      IBMResult.Text := sshConnector.ExecuteCommand(aCommand);

      if IBMResult.Count = 0
        then exit(PRTGResult.Error('Storwize system didn''t send any answer.'));
      if IBMResult.Count = 1
        then exit(PRTGResult.Error(IBMResult.text));

      FieldCaptionArray := GetFieldsFromIBMLine(IBMResult.Strings[0]);
      for i := 1 to IBMResult.Count-1
        do AddLineToResult(IBMResult.Strings[i], catchFieldNrs);

    finally
      IBMResult.Free;
    end;
  except
    on e : Exception do exit('Error TIBMStorwize.GetCommandResult : '+PRTGResult.Error(e.Message)) ;
  end;

  result := PRTGResult.serialize;
end;

function TIBMStorwize.GetFieldsFromIBMLine(aLine : string) : TArray<string>;
begin
  while aLine.Contains('  ')
    do aLine := aLine.Replace('  ', ' ');
  result := aLine.Split([' ']);
end;

procedure TIBMStorwize.AddLineToResult(aLine : string; const catchFieldNrs : TArray<integer>);
var
  Fields : TArray<string>;
  Ident : integer;
  i : integer;
  prefix : string;
begin
  Fields := GetFieldsFromIBMLine(aLine);

  Ident := -1;
  if (length(FieldCaptionArray) > 1) and ((FieldCaptionArray[0].toLower = 'id') or FieldCaptionArray[0].toLower.contains('name') )
    then Ident := 0;
  if (length(FieldCaptionArray) > 2) and FieldCaptionArray[1].toLower.contains('name')
    then Ident := 1;

  if Ident > -1
    then prefix := Fields[ident]+'_'
    else prefix := '';

  if length(catchFieldNrs) > 0 then
  begin
    for I in catchFieldNrs do
      PRTGResult.add(prefix+FieldCaptionArray[i], Fields[i]);
  end
   else
  begin
    for I := Ident+1 to High(FieldCaptionArray) do
      PRTGResult.add(prefix+FieldCaptionArray[i], Fields[i]);
  end;
end;


constructor TIBMStorwize.Create(const aSSHConnector: ISSHConnector);
begin
  sshConnector := aSSHConnector;
end;


class function TIBMStorwize.execute(const aSSHConnector: ISSHConnector; const command: string; const CatchFieldNrs : TArray<integer>): string;
begin
  with TIBMStorwize.Create(aSSHConnector) do
  try
    result := GetCommandResult(command, catchFieldNrs);
  finally
    Free;
  end;
end;



end.
