unit uHTTPMethodsService;

interface

uses
  uRest.Interfaces,
  System.Generics.Collections,
  uHTTPHandlerService,
  uTypes;

type
  THTTPMethodsService = class(THTTPHandlerService, IHTTPMethodsService)
  private
    FParams: IParamsService;
  public
    function Get(const APath: string): string;
    function GetByID(const APath, AID: string): string;

    function Post(const APath: string; AJSONRequestBody: string): string;
    function Put(const APath: string; AJSONRequestBody: string): string;
    procedure Delete(const APath: string; AID: Integer);

    constructor Create(const Params: IParamsService);
    class function New(const Params: IParamsService): IHTTPMethodsService;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TBasicRest<T> }

constructor THTTPMethodsService.Create(const Params: IParamsService);
begin
  Configure(Params);
end;

destructor THTTPMethodsService.Destroy;
begin
  inherited;
end;

class function THTTPMethodsService.New(const Params: IParamsService): IHTTPMethodsService;
begin
  Result := Self.Create(Params);
end;

function THTTPMethodsService.Get(const APath: string): string;
begin
  Result := Execute(APath);
end;

function THTTPMethodsService.GetByID(const APath, AID: string): string;
begin
  Result := Execute(APath + '/' + AID);
end;

function THTTPMethodsService.Post(const APath: string; AJSONRequestBody: string): string;
begin
  Result := Execute(APath, AJSONRequestBody, tmPost);
end;

function THTTPMethodsService.Put(const APath: string; AJSONRequestBody: string): string;
begin
  Result := Execute(APath, AJSONRequestBody, tmUpdate);
end;

procedure THTTPMethodsService.Delete(const APath: string; AID: Integer);
begin
  ExecuteDelete(APath + '/' + AID.ToString);
end;

end.
