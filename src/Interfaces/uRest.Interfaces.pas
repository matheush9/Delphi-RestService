unit uRest.Interfaces;

interface

uses
  System.Generics.Collections, Vcl.StdCtrls;

type
  IParamsService = interface
    ['{4CA08E97-EB6A-4D5C-9651-4F212D65CB65}']
    function SetUrl(const AValue: string): IParamsService;
    function GetUrl: string;
  end;

  IHTTPMethodsService<T> = interface
    ['{61105668-021C-4160-9E1A-C56B7132EC88}']
    function Get(const APath: string): T;
    function GetByID(const APath, AID: string): T;
    function Post(const APath: string; AObject: T): T;
    function Put(const APath: string; AObject: T): T;
    procedure Delete(const APath: string; AID: Integer);
  end;

implementation

end.
