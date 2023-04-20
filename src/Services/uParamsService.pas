unit uParamsService;

interface

uses
  uRest.Interfaces, System.Classes;

type
  TParamsService = class(TInterfacedObject, IParamsService)
  private
    FUrl: string;
    FQueryParams: TStringList;
  public
    function SetUrl(const AValue: string): IParamsService;
    function GetUrl: string;
    function SetQueryParams(const AValue: TStringList)
      : IParamsService;
    function GetQueryParams: TStringList;

    class function New: IParamsService;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TBaseParams }

constructor TParamsService.Create;
begin

end;

class function TParamsService.New: IParamsService;
begin
  Result := Self.Create;
end;

destructor TParamsService.Destroy;
begin

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

end.
