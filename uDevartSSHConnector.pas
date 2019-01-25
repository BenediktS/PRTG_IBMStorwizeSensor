unit uDevartSSHConnector;

interface

uses uISSHConnector, ScSSHClient, ScSSHUtils, ScSSHChannel, ScBridge, Types,
     SysUtils;

  type TDevartSSHConnector = class(TInterfacedObject, ISSHConnector)
  private
    ScSSHShell: TScSSHShell;
    ScSSHClient: TScSSHClient;
    ScMemoryStorage: TScMemoryStorage;
    procedure ScSSHClient1ServerKeyValidate(Sender: TObject; NewServerKey: TScKey; var Accept: Boolean);
    procedure OnAuth(Sender: TObject; const Name, Instruction: string; const Prompts: TStringDynArray; var Responses: TStringDynArray);
  public
    function ExecuteCommand(aCommand : string) : string;
    constructor Create(const host: string; const port: integer;  const username, password : string; UseKeyBoardInteractive : boolean = false); reintroduce;
    destructor Destroy; override;
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

end;

destructor TDevartSSHConnector.Destroy;
begin
  ScSSHShell.Free;
  ScSSHClient.Free;
  ScMemoryStorage.Free;
  inherited;
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

end.
