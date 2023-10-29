unit uRest.Interfaces;

interface

uses
  System.Classes, Vcl.StdCtrls;

type
  IParamsService = interface
    ['{4CA08E97-EB6A-4D5C-9651-4F212D65CB65}']
    function SetUrl(const AValue: string): IParamsService;
    function GetUrl: string;
    function SetQueryParams(const AValue: TStringList): IParamsService;
    function GetQueryParams: TStringList;
    function SetAuthorizationHeader(const AToken: string): IParamsService;
    function GetAuthorizationHeader: string;
    procedure CleanQueryParams;
  end;

  IHTTPMethodsService = interface
    ['{61105668-021C-4160-9E1A-C56B7132EC88}']
    function Get(const APath: string): string;
    function GetByID(const APath, AID: string): string;
    function Post(const APath: string; AJSONRequestBody: string): string;
    function Put(const APath: string; AJSONRequestBody: string): string;
    function PutById(const APath: string; const AId: string; AJSONRequestBody: string): string;
    procedure Delete(const APath: string);
    procedure DeleteById(const APath: string; AID: Integer);
  end;

implementation

end.
