unit UModel4;

interface

uses
  DataValidator,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.JSON;

type
  TForm1 = class(TForm)
    MemoJSON: TMemo;
    MemoResult: TMemo;
    PanelTop: TPanel;
    btnValidate: TButton;
    MemoJSONResult: TMemo;
    procedure btnValidateClick(Sender: TObject);
  private
    { Private declarations }
    function SchemaNome(const AField: string): IDataValidatorSchema;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.btnValidateClick(Sender: TObject);
var
  LJO: TJsonObject;
begin
  LJO := TJsonObject.ParseJSONValue(MemoJSON.Text) as TJsonObject;

  if not Assigned(LJO) then
    raise Exception.Create('JSON inv�lido!');

  try
    MemoResult.Text :=

      TDataValidator.JSON(LJO)

        .Validate('nome')
          .&Not.IsEmpty.WithMessage('NOME - N�o pode ser vazio')
          .IsAlpha().ToUpperCase
          .AddSchema(SchemaNome('Nome'))
          .RemoveAccents
        .&End

        .Validate('base64')
          .&Not.IsEmpty.WithMessage('BASE64 - N�o pode ser vazio')
          .IsBase64.WithMessage('BASE64 - N�o � um base 64')
          .ToBase64Decode.WithMessage('BASE64 - ToBase64Decode')
        .&End

        .Validate('casa')
          .IsOptionalKey
          .&Not.IsEmpty.WithMessage('CASA - N�o pode ser vazio')
        .&End

        .Validate('casa2')
          .IsRequiredKey.WithMessage('� necess�rio a field casa2')
//          .&Not.IsEmpty.WithMessage('CASA2 - N�o pode ser vazio')
          .IsAlpha()
        .&End

      .CheckedAll
      .Informations.Message;

    MemoJSONResult.Text := LJO.ToString;
  finally
    LJO.DisposeOf;
  end;
end;

function TForm1.SchemaNome(const AField: string): IDataValidatorSchema;
begin
  Result :=
    TDataValidator
    .Schema
      .Trim
      .&Not.IsEmpty.WithMessage(Format('Preencha o campo %s !', [AField])) // N�o pode ser vazio
      .IsLength(0, 10).WithMessage(Format('O campo %s deve conter no m�ximo 10 caracteres!', [AField]))
      .IsAlpha(TDataValidatorLocaleLanguage.tl_pt_BR).WithMessage(Format('O campo %s possui caracteres inv�lidos!', [AField]))
    .&End;
end;

end.
