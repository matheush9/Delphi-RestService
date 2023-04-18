unit uParamsService;

interface

uses
  uRest.Interfaces;

type
  TParamsService = class(TInterfacedObject, IParamsService)
  private
    FUrl: string;
  public
    function SetUrl(const AValue: string): IParamsService;
    function GetUrl: string;

    class function New: IParamsService;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TBaseParams }

constructor TParamsService.Create;
begin

end;

destructor TParamsService.Destroy;
begin

  inherited;
end;

function TParamsService.GetUrl: string;
begin
  Result := FUrl;
end;

class function TParamsService.New: IParamsService;
begin
  Result := Self.Create;
end;

function TParamsService.SetUrl(const AValue: string): IParamsService;
begin
  Result := Self;
  FUrl := AValue;
end;

end.
