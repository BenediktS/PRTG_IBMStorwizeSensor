unit uDevartSSHConnector;

interface

uses uISSHConnector, ScSSHClient, ScSSHUtils, ScSSHChannel, ScBridge;

  type TDevartSSHConnector = class(TInterfacedObject, ISSHConnector)
  private
    ScSSHShell: TScSSHShell;
    ScSSHClient: TScSSHClient;
    ScMemoryStorage: TScMemoryStorage;
    procedure ScSSHClient1ServerKeyValidate(Sender: TObject; NewServerKey: TScKey; var Accept: Boolean);
  public
    function ExecuteCommand(aCommand : string) : string;
    constructor Create(const host: string; const port: integer;  const username, password : string); reintroduce;
    destructor Destroy; override;
  end;

implementation

{ uDevartSSHConnector }

constructor TDevartSSHConnector.create(const host: string; const port: integer;  const username, password : string);
begin
  ScMemoryStorage := TScMemoryStorage.Create(nil);
  ScSSHClient := TScSSHClient.Create(nil);
  ScSSHShell := TScSSHShell.Create(nil);

  ScSSHClient.OnServerKeyValidate := ScSSHClient1ServerKeyValidate;
  ScSSHClient.KeyStorage := ScMemoryStorage;
  ScSSHClient.HostName := host;
  ScSSHClient.Port := port;
  ScSSHClient.User := username;
  ScSSHClient.Password := password;

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
