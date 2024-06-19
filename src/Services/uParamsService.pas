unit uParamsService;

interface

uses
  uRest.Interfaces, System.Classes, System.SysUtils;

type
  TParamsService = class(TInterfacedObject, IParamsService)
  private
    FUrl: string;
    FQueryParams: TStringList;
    FHeaders: TStringList;
    FAuthToken: string;
  public
    function SetUrl(const AValue: string): IParamsService;
    function GetUrl: string;
    function SetQueryParams(const AValue: TStringList)
      : IParamsService;
    function GetQueryParams: TStringList;
    function SetAuthorizationHeader(const AToken: string): IParamsService;
    function GetAuthorizationHeader: string;
    procedure CleanQueryParams;
    function AddHeader(AName, AValue: string): IParamsService;
    function GetHeaders: TStringList;

    class function New: IParamsService;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TBaseParams }

function TParamsService.AddHeader(AName, AValue: string): IParamsService;
begin
  FHeaders.AddPair(AName, AValue);
end;

constructor TParamsService.Create;
begin
  FHeaders := TStringList.Create;
end;

class function TParamsService.New: IParamsService;
begin
  Result := Self.Create;
end;

destructor TParamsService.Destroy;
begin
  FHeaders.Free;
  inherited;
end;

function TParamsService.GetUrl: string;
begin
  Result := FUrl;
end;

function TParamsService.SetUrl(const AValue: string): IParamsService;
begin
  Result := Self;
  FUrl := AValue;
end;

function TParamsService.GetQueryParams: TStringList;
begin
  Result := FQueryParams;
end;

function TParamsService.SetQueryParams(const AValue
  : TStringList): IParamsService;
begin
  Result := Self;
  FQueryParams := AValue;
end;

function TParamsService.GetAuthorizationHeader: string;
begin
  Result := FAuthToken;
end;

function TParamsService.GetHeaders: TStringList;
begin
  Result := FHeaders;
end;

function TParamsService.SetAuthorizationHeader(
  const AToken: string): IParamsService;
begin
  Result := Self;
  FAuthToken := AToken;
end;

procedure TParamsService.CleanQueryParams;
begin
  FreeAndNil(FQueryParams);
end;

end.
