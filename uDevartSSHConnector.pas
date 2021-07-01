unit uDevartSSHConnector;

interface

uses uISSHConnector, ScSSHClient, ScSFTPClient, ScSSHUtils, ScSSHChannel, ScBridge, Types,
     SysUtils, Classes, ScSFTPUtils;

  type TDevartSSHConnector = class(TInterfacedObject, ISSHConnector)
  private
    ScSSHShell: TScSSHShell;
    ScSSHClient: TScSSHClient;
    SFTPClient : TScSFTPClient;
    ScMemoryStorage: TScMemoryStorage;
    procedure ScSSHClient1ServerKeyValidate(Sender: TObject; NewServerKey: TScKey; var Accept: Boolean);
    procedure OnAuth(Sender: TObject; const Name, Instruction: string; const Prompts: TStringDynArray; var Responses: TStringDynArray);
    procedure DoOnVersionSelect(Sender: TObject;
      const Versions: TScSFTPVersions; var Version: TScSFTPVersion);
  public
    function ExecuteCommand(aCommand : string) : string;
    constructor Create(const host: string; const port: integer;  const username, password : string; UseKeyBoardInteractive : boolean = false); reintroduce;
    destructor Destroy; override;
    procedure DownloadFileToStream(const SourceName:string; destination : TStream; FileOffset : Int64 = 0);
    procedure UploadFileFromStream(aStream : TStream; aDestName : string );
  end;

implementation

{ uDevartSSHConnector }

procedure TDevartSSHConnector.OnAuth(Sender: TObject; const Name, Instruction: string; const Prompts: TStringDynArray; var Responses: TStringDynArray);
var
  i : integer;
begin
  for i := 0 to High(Prompts) do
  begin
    if Prompts[i].toLower.trim = 'password:' then Responses[0] := ScSSHClient.Password;
  end;

end;

constructor TDevartSSHConnector.create(const host: string; const port: integer;  const username, password : string; UseKeyBoardInteractive : boolean = false);
begin
  ScMemoryStorage := TScMemoryStorage.Create(nil);

  ScSSHClient := TScSSHClient.Create(nil);
  ScSSHClient.OnServerKeyValidate := ScSSHClient1ServerKeyValidate;
  ScSSHClient.OnAuthenticationPrompt := OnAuth;
  ScSSHClient.KeyStorage := ScMemoryStorage;
  ScSSHClient.HostName := host;
  ScSSHClient.Port := port;
  ScSSHClient.User := username;
  ScSSHClient.Password := password;
  if UseKeyBoardInteractive then
    ScSSHClient.Authentication := atKeyboardInteractive;

  ScSSHShell := TScSSHShell.Create(nil);
  ScSSHShell.UseUnicode := True;
  ScSSHShell.Client := ScSSHClient;

  SFTPClient := TScSFTPClient.create(nil);
  SFTPClient.UseUnicode := True;
  SFTPClient.SSHClient := ScSSHClient;
  SFTPClient.OnVersionSelect := DoOnVersionSelect;
end;

procedure TDevartSSHConnector.DoOnVersionSelect(Sender: TObject; const Versions: TScSFTPVersions; var Version: TScSFTPVersion);
begin
  for var v in Versions
    do if v > Version then Version := v;
end;

destructor TDevartSSHConnector.Destroy;
begin
  try
    if SFTPClient.Active
      then SFTPClient.Disconnect;
  except
  end;

  SFTPClient.free;
  ScSSHShell.Free;
  ScSSHClient.Free;
  ScMemoryStorage.Free;
  inherited;
end;

procedure TDevartSSHConnector.DownloadFileToStream(const SourceName: string;  destination: TStream; FileOffset: Int64 = 0);
begin
  if not SFTPClient.Active
    then SFTPClient.Initialize;

  SFTPClient.DownloadToStream(SourceName, destination, FileOffset);
end;

function TDevartSSHConnector.ExecuteCommand(aCommand: string): string;
begin
  result := ScSSHShell.ExecuteCommand(acommand);
end;

procedure TDevartSSHConnector.ScSSHClient1ServerKeyValidate(Sender: TObject;
  NewServerKey: TScKey; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TDevartSSHConnector.UploadFileFromStream(aStream: TStream;
  aDestName: string);
begin
  if not SFTPClient.Active
    then SFTPClient.Initialize;

  SFTPClient.UploadFromStream(aStream, aDestName, True, 0);
end;

end.
