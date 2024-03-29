unit uISSHConnector;

interface

uses Classes;

type ISSHConnector = Interface
  function ExecuteCommand(aCommand : string) : string;
  procedure DownloadFileToStream(const SourceName:string; destination : TStream; FileOffset : Int64 = 0);
  procedure UploadFileFromStream(aStream : TStream; aDestName : string );
end;


implementation

end.
