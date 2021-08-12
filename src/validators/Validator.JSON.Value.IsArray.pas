{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit Validator.JSON.Value.IsArray;

interface

uses
  DataValidator.ItemBase,
  System.JSON, System.SysUtils;

type
  TDataValidatorJSONValueIsArray = class(TDataValidatorItemBase, IDataValidatorItem)
  private
  public
    function Check: IDataValidatorResult;
    constructor Create(const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
  end;

implementation

{ TDataValidatorJSONValueIsArray }

constructor TDataValidatorJSONValueIsArray.Create(const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
begin
  FMessage := AMessage;
  FExecute := AExecute;
end;

function TDataValidatorJSONValueIsArray.Check: IDataValidatorResult;
var
  LValue: string;
  R: Boolean;
  LJSONPair: TJSONPair;
begin
  LValue := GetValueAsString;
  R := False;

  if not Trim(LValue).IsEmpty then
    if FValue.IsType<TJSONPair> then
    begin
      LJSONPair := FValue.AsType<TJSONPair>;

      if Assigned(LJSONPair) then
        R := LJSONPair.JsonValue is TJSONArray;
    end;

  if FIsNot then
    R := not R;

  Result := TDataValidatorResult.Create(R, TDataValidatorInformation.Create(LValue, FMessage, FExecute));
end;

end.
