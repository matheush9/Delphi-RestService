unit uHTTPHandlerService;

interface

uses
  System.Classes,
  REST.Types,
  REST.Client,
  uRest.Interfaces,
  uTypes;

type
  THTTPHandlerService = class(TInterfacedObject)
  private
    FParams: IParamsService;
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;

    procedure SetContentType;
    procedure LoadQueryParams;
    procedure RaiseHTTPError(Sender: TCustomRESTRequest);
    procedure SetAuthorizationHeader;
  public
    procedure Configure(const AParams: IParamsService);
    function Execute(const AUrl: string): string; overload;
    function Execute(const AUrl: string; const AJSONRequestBody: string;
      const AMethod: THTTPTypeMethod): string; overload;
    procedure ExecuteDelete(const AUrl: string);

    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, System.StrUtils, REST.Json;

{ THTTPHandlerService }

procedure THTTPHandlerService.Configure(const AParams: IParamsService);
begin
  FParams := AParams;
  FRESTClient := TRESTClient.Create(nil);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);

  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.OnHTTPProtocolError := RaiseHTTPError;
  SetAuthorizationHeader;
end;

destructor THTTPHandlerService.Destroy;
begin
  FRESTClient.Free;
  FRESTRequest.Free;
  FRESTResponse.Free;
  inherited;
end;

function THTTPHandlerService.Execute(const AUrl: string): string;
begin
  FRESTClient.BaseURL := FParams.GetUrl + AUrl;
  FRESTRequest.Method := rmGET;
  LoadQueryParams;
  FRESTRequest.Execute;
  Result := FRESTRequest.Response.Content;
end;

function THTTPHandlerService.Execute(const AUrl: string;
  const AJSONRequestBody: string; const AMethod: THTTPTypeMethod): string;
begin
  FRESTClient.BaseURL := FParams.GetUrl + AUrl;
  FRESTClient.ContentType := 'application/json';
  LoadQueryParams;

  if AMethod = tmPost then
    FRESTRequest.Method := rmPOST
  else
    FRESTRequest.Method := rmPUT;

  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind := pkREQUESTBODY;
    Name := 'body';
    Value := AJSONRequestBody.Trim;
  end;

  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind := pkHTTPHEADER;
    Name := 'Content-Type';
    Value := 'application/json;charset=UTF-8';
  end;
  
  FRESTRequest.Execute;
  Result := FRESTRequest.Response.JSONText;
end;

procedure THTTPHandlerService.ExecuteDelete(const AUrl: string);
begin
  FRESTClient.BaseURL := FParams.GetUrl + AUrl;
  FRESTClient.ContentType := 'application/json';
  LoadQueryParams;
  FRESTRequest.Method := rmDELETE;
  FRESTRequest.Execute;
end;

procedure THTTPHandlerService.LoadQueryParams;
begin
  if Assigned(FParams.GetQueryParams) then
  begin
    for var I := 0 to Pred(FParams.GetQueryParams.Count) do
    begin
      FRESTRequest.AddParameter(FParams.GetQueryParams.Names[I],
        FParams.GetQueryParams.Values[FParams.GetQueryParams.Names[I]]);
    end;
  end;
end;

procedure THTTPHandlerService.RaiseHTTPError(Sender: TCustomRESTRequest);
begin
  if Sender.Response.StatusCode >= 400 then
  begin
    raise Exception.Create(Concat(Format('%s: %d %s'
                                        ,['StatusCode'
                                         ,Sender.Response.StatusCode
                                         ,Sender.Response.StatusText])
                                 ,sLineBreak
                                 ,ifThen(not Sender.Response.ErrorMessage.IsEmpty, Sender.Response.ErrorMessage + sLineBreak)
                                 ,Sender.Response.Content, sLineBreak
                                 ));
  end;
end;

procedure THTTPHandlerService.SetContentType;
begin
  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind := pkHTTPHEADER;
    Name := 'Content-Type';
    Value := 'application/json;charset=UTF-8';
  end;
end;

procedure THTTPHandlerService.SetAuthorizationHeader;
begin
  if not FParams.GetAuthorizationHeader.IsEmpty then
    FRESTRequest.AddAuthParameter('Authorization', 'Bearer ' +
      FParams.GetAuthorizationHeader, pkHTTPHEADER, [poDoNotEncode]);
end;
end.
