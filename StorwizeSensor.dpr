program StorwizeSensor;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uIBMStorwizeSensor in 'uIBMStorwizeSensor.pas',
  uPRTGResult in 'uPRTGResult.pas',
  uISSHConnector in 'uISSHConnector.pas',
  uDevartSSHConnector in 'uDevartSSHConnector.pas';

var
  prtgError : TPRTGResult;
  host, user, pass, command : string;
  port : integer;
  i : integer;
  FieldNrs : TArray<integer>;
  sshConnector : ISSHConnector;
begin
  try
    if ParamCount < 5 then raise Exception.Create('Too few arguments! Usage: StorwizeSensor.exe <host> <port> <username> <password> <IBMCommand> <optional: 1..n : FieldNrs that should be returned>');


    host := ParamStr(1);
    port := strToInt(ParamStr(2));
    user := ParamStr(3);
    pass := ParamStr(4);
    command := ParamStr(5);

    sshConnector := TDevartSSHConnector.create(host, port, user, pass);

    SetLength(FieldNrs, ParamCount-5);
    for I := 6 to ParamCount do
        FieldNrs[i-6] := StrToInt(ParamStr(i));

    writeln( TIBMStorwize.execute(sshConnector, command, FieldNrs) );

  except
    on E: Exception do
      Writeln( prtgError.Error( E.ClassName+': '+E.Message));
  end;
end.
