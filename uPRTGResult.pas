unit uPRTGResult;

interface

type TPRTGResult = record
  private
    JSON : string;
  public
    procedure Add(ChannelName, Value: string);
    procedure clear;
    function serialize : string;
    function Error(aErrorMEssage : string) : string;
end;


implementation

uses SysUtils;


{ TPRTGResult }

procedure TPRTGResult.Add(ChannelName, Value: string);
begin
  if JSON <> '' then JSON := JSON + ',';
  JSON := Format('%s{"channel": "%s", "value":"%s"}',[JSON, ChannelName, Value]);
end;

procedure TPRTGResult.clear;
begin
  JSON := '';
end;

function TPRTGResult.Error(aErrorMEssage: string): string;
begin
  result := format('{"prtg":{ "error" : 1, "text": "%s" }}',[aErrorMessage]);
end;

function TPRTGResult.serialize: string;
begin
  result := Format('{"prtg": { "result" : [%s] } }'  ,[JSON]);
end;


end.
