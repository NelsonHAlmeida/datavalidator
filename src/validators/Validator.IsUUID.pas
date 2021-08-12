{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit Validator.IsUUID; // UUID (Universally Unique Identifier)

interface

uses
  DataValidator.ItemBase,
  System.SysUtils, System.RegularExpressions;

type
  TTypeUUID = (tuAll, tuV1, tuV2, tuV3, tuV4, tuV5);

  TValidatorIsUUID = class(TDataValidatorItemBase, IDataValidatorItem)
  private
    FVersion: TTypeUUID;
    function GetPattern: string;
  public
    function Check: IDataValidatorResult;
    constructor Create(const AVersion: TTypeUUID; const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
  end;

implementation

{ TValidatorIsUUID }

constructor TValidatorIsUUID.Create(const AVersion: TTypeUUID; const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
begin
  FVersion := AVersion;
  FMessage := AMessage;
  FExecute := AExecute;
end;

function TValidatorIsUUID.Check: IDataValidatorResult;
var
  LValue: string;
  R: Boolean;
begin
  LValue := GetValueAsString;
  R := False;

  if not Trim(LValue).IsEmpty then
    R := TRegEx.IsMatch(LValue, GetPattern);

  if FIsNot then
    R := not R;

  Result := TDataValidatorResult.Create(R, TDataValidatorInformation.Create(LValue, FMessage, FExecute));
end;

function TValidatorIsUUID.GetPattern: string;
var
  LVersion: string;
begin
  if FVersion = tuAll then
    LVersion := Format('[1-%d]', [Integer(High(TTypeUUID))])
  else
    LVersion := Format('%d', [Integer(FVersion)]);

  Result := Format('^[0-9a-fA-F]{8}-?[0-9a-fA-F]{4}-?%s[0-9a-fA-F]{3}-?[89aAbB][0-9a-fA-F]{3}-?[0-9a-fA-F]{12}$', [LVersion]);
end;

end.
