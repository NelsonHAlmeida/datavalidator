{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit Validator.IsLowercase;

interface

uses
  DataValidator.ItemBase,
  System.SysUtils, System.RegularExpressions;

type
  TValidatorIsLowercase = class(TDataValidatorItemBase, IDataValidatorItem)
  private
  public
    function Check: IDataValidatorResult;
    constructor Create(const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
  end;

implementation

{ TValidatorIsLowercase }

constructor TValidatorIsLowercase.Create(const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
begin
  FMessage := AMessage;
  FExecute := AExecute;
end;

function TValidatorIsLowercase.Check: IDataValidatorResult;
var
  LValue: string;
  R: Boolean;
begin
  LValue := GetValueAsString;
  R := False;

  if not Trim(LValue).IsEmpty then
    R := TRegEx.IsMatch(LValue, '^[a-z\s]+$');

  if FIsNot then
    R := not R;

  Result := TDataValidatorResult.Create(R, TDataValidatorInformation.Create(LValue, FMessage, FExecute));
end;

end.
