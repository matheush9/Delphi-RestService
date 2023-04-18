unit uAbstractAPI;

interface

uses
  System.Generics.Collections,
  REST.Types,
  REST.Client,
  uRest.Interfaces,
  uTypes;

type
  TAbstractAPI<T: class, constructor> = class abstract (TInterfacedObject)
  private
    FParams: IParamsService;
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    procedure SetContentType;
  public
    procedure Configure(const AParams: IParamsService);

    function Execute(const AUrl: string): T; overload;
    function Execute(const AUrl: string; const AObject: T;
      const AMethod: THTTPTypeMethod): T; overload;
    procedure ExecuteDelete(const AUrl: string);

    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, REST.Json;

{ TAbstractAPi }

procedure TAbstractAPI<T>.Configure(const AParams: IParamsService);
begin
  FParams := AParams;
  FRESTClient    := TRESTClient.Create(nil);
  FRESTRequest   := TRESTRequest.Create(nil);
  FRESTResponse  := TRESTResponse.Create(nil);

  FRESTRequest.Client   := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
end;

destructor TAbstractAPI<T>.Destroy;
begin
  FRESTClient.Free;
  FRESTRequest.Free;
  FRESTResponse.Free;
  inherited;
end;

function TAbstractAPI<T>.Execute(const AUrl: string): T;
begin
  FRESTClient.BaseURL := Format(FParams.GetUrl, [AUrl]);
  FRESTRequest.Method := rmGET;
  FRESTRequest.Execute;
  Result := TJson.JsonToObject<T>(FRESTRequest.Response.Content);
end;

function TAbstractAPI<T>.Execute(const AUrl: string; const AObject: T;
  const AMethod: THTTPTypeMethod): T;
begin
  FRESTClient.BaseURL := Format(FParams.GetUrl, [AUrl]);
  FRESTClient.ContentType := 'application/json';

  if AMethod = tmPost then
    FRESTRequest.Method := rmPOST
  else
    FRESTRequest.Method := rmPUT;

  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkREQUESTBODY;
    Name  := 'body';
    Value := TJson.ObjectToJsonString(AObject).Trim;
  end;

  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkHTTPHEADER;
    Name  := 'Content-Type';
    Value := 'application/json;charset=UTF-8';
  end;

  FRESTRequest.Execute;
  Result := TJson.JsonToObject<T>(FRESTRequest.Response.JSONText);
end;

procedure TAbstractAPI<T>.ExecuteDelete(const AUrl: string);
begin
  FRESTClient.BaseURL := Format(FParams.GetUrl, [AUrl]);;
  FRESTClient.ContentType := 'application/json';
  FRESTRequest.Method := rmDELETE;
  FRESTRequest.Execute;
end;

procedure TAbstractAPI<T>.SetContentType;
begin
  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkHTTPHEADER;
    Name  := 'Content-Type';
    Value := 'application/json;charset=UTF-8';
  end;
end;

end.
