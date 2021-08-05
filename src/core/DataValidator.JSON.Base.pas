{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit DataValidator.JSON.Base;

interface

uses
  DataValidator.Intf, DataValidator.JSON.Context,
  System.JSON;

type
  TDataValidatorJSONBase = class(TDataValidatorJSONContext<IDataValidatorJSONBase>, IDataValidatorJSONBase, IDataValidatorJSONValueName)
  private
    [weak]
    FResult: IDataValidatorJSONResult;
    FName: string;
  public
    function &End(): IDataValidatorJSONResult;
    function GetName: string;

    constructor Create(const AResult: IDataValidatorJSONResult; const AName: string; const AValue: TJSONPair); reintroduce;
    destructor Destroy; override;
  end;

implementation

{ TDataValidatorJSONBase }

constructor TDataValidatorJSONBase.Create(const AResult: IDataValidatorJSONResult; const AName: string; const AValue: TJSONPair);
begin
  inherited Create(Self, AValue);
  FResult := AResult;
  FName := AName;
end;

destructor TDataValidatorJSONBase.Destroy;
begin
  inherited Destroy;
end;

function TDataValidatorJSONBase.&End(): IDataValidatorJSONResult;
begin
  Result := FResult;
end;

function TDataValidatorJSONBase.GetName: string;
begin
  Result := FName;
end;

end.
