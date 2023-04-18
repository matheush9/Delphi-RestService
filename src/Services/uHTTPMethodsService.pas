unit uHTTPMethodsService;

interface

uses
  uRest.Interfaces,
  System.Generics.Collections,
  uAbstractAPI,
  uTypes;

type
  THTTPMethodsService<T: class, constructor> = class(TAbstractAPi<T>, IHTTPMethodsService<T>)
  private
    FParams: IParamsService;
  public
    function Get(const APath: string): T;
    function GetByID(const APath, AID: string): T;

    function Post(const APath: string; AObject: T): T;
    function Put(const APath: string; AObject: T): T;
    procedure Delete(const APath: string; AID: Integer);

    class function New(const Params: IParamsService): IHTTPMethodsService<T>;
    constructor Create(const Params: IParamsService);
    destructor Destroy; override;
  end;

implementation

uses
  REST.Json,
  System.SysUtils;

{ TBasicRest<T> }

constructor THTTPMethodsService<T>.Create(const Params: IParamsService);
begin
  Configure(Params);
end;

destructor THTTPMethodsService<T>.Destroy;
begin
  inherited;
end;

class function THTTPMethodsService<T>.New(const Params: IParamsService): IHTTPMethodsService<T>;
begin
  Result := Self.Create(Params);
end;

function THTTPMethodsService<T>.Get(const APath: string): T;
begin
  Result := Execute(APath);
end;

function THTTPMethodsService<T>.GetByID(const APath, AID: string): T;
begin
  Result := Execute(APath + '/' + AID);
end;

function THTTPMethodsService<T>.Post(const APath: string; AObject: T): T;
begin
  Result := Execute(APath, AObject, tmPost);
end;

function THTTPMethodsService<T>.Put(const APath: string; AObject: T): T;
begin
  Result := Execute(APath, AObject, tmUpdate);
end;

procedure THTTPMethodsService<T>.Delete(const APath: string; AID: Integer);
begin
  ExecuteDelete(APath + '/' + AID.ToString);
end;

end.
