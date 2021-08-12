{
  *************************************
  Created by Danilo Lucas
  Github - https://github.com/dliocode
  *************************************
}

unit Validator.IsBTCAddress; // BTC (Bitcoin) Adddress

interface

uses
  DataValidator.ItemBase,
  System.SysUtils, System.RegularExpressions;

type
  TValidatorIsBTCAddress = class(TDataValidatorItemBase, IDataValidatorItem)
  private
    function GetPattern: string;
  public
    function Check: IDataValidatorResult;
    constructor Create(const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
  end;

implementation

{ TValidatorIsBTCAddress }

constructor TValidatorIsBTCAddress.Create(const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
begin
  FMessage := AMessage;
  FExecute := AExecute;
end;

function TValidatorIsBTCAddress.Check: IDataValidatorResult;
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

function TValidatorIsBTCAddress.GetPattern: string;
const
  BECH32 = '^(bc1)[a-z0-9]{25,39}$';
  BECH58 = '^(1|3)[A-HJ-NP-Za-km-z1-9]{25,39}$';
begin
  if GetValueAsString.StartsWith('bc1') then
    Result := BECH32
  else
    Result := BECH58;
end;

end.
