program Model8;

uses
  DataValidator,
  Horse, Horse.Jhonson, System.JSON, System.SysUtils, System.DateUtils;

function ValidateRegister(const AJSON: TJSONObject): IDataValidatorResult;
begin
  Result :=
  TDataValidator.JSON(AJSON)
    .Validate('nome')
      .IsRequiredKey
      .Trim
      .&Not.IsEmpty.WithMessage('O campo nome n�o foi preenchido!')
      .IsAlpha(TDataValidatorLocaleLanguage.tl_pt_BR).WithMessage('O campo nome n�o pode possuir caracters especiais!')
      .IsLength(3, 100).WithMessage('O campo nome deve ter no m�nimo 3 caracters e no m�zimo 100')
    .&End

    .Validate('email')
      .IsRequiredKey
      .Trim
      .&Not.IsEmpty.WithMessage('Informe o e-mail!')
      .IsLength(6, 100).WithMessage('Informe um e-mail maior que 5 caracteres!')
      .NormalizeEmail.IsEmail.WithMessage('E-mail inv�lido!')
      .Custom(
      function(const AValue: string): Boolean
      begin
        // Consulta no banco verifica se esse email j� existe;
        Result := True;
      end)
    .&End

    .Validate('data_nascimento')
      .IsRequiredKey
      .Trim
      .&Not.IsEmpty.WithMessage('Informe a data de nascimento!')
      .IsDate.WithMessage('Data de nascimento inv�lido!')
      .IsDateLessThan(Now).WithMessage('A data de nascimento n�o pode ser maior que a data atual!')
      .IsDateGreaterThan(IncYear(Now, -100)).WithMessage('A data de nascimento n�o pode ser menor que 100 anos atr�s!')
    .&End

    .Validate('telefone')
      .IsRequiredKey
      .Trim
      .&Not.IsEmpty.WithMessage('Informe o telefone!')
      .IsPhoneNumber(TDataValidatorLocaleLanguage.tl_pt_BR).WithMessage('N�mero de telefone inv�lido!')
    .&End

    .Validate('cpf')
      .IsRequiredKey
      .Trim
      .&Not.IsEmpty.WithMessage('Informe o CPF!')
      .IsLength(14, 14).WithMessage('Informe corretamente todos os d�gitos do CPF!')
      .OnlyNumbers.IsCPF.WithMessage('CPF inv�lido!')
    .&End

    .CheckedAll;
end;

begin
// JSON Test
{
    "nome":"Danilo Lucas",
    "email":"developer.dlio@gmail.com",
    "data_nascimento":"23/08/1994",
    "telefone":"48999999999",
    "cpf":"012.345.678-90"
}

 THorse.Use(Jhonson());

  THorse.Post('/register',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LBody: TJSONObject;
      LValidatorResult: IDataValidatorResult;
      LResponseError: TJsonObject;
      LReponseErrorCause: TJsonArray;
      I: Integer;
    begin
      try
        LBody := Req.Body<TJSONObject>;
      except
        LBody := nil;
      end;

      if not Assigned(LBody) then
      begin
        Res.Status(401).Send('N�o foi informado o JSON no body corretamente!');
        raise EHorseCallbackInterrupted.Create;
      end;

      // faz a valida��o completa
      LValidatorResult := ValidateRegister(LBody);

      // Se tive tudo ok, j� faz o retorno
      if LValidatorResult.OK then
      begin
        Res.Status(201).Send('OK, registro feito com sucesso!');
        raise EHorseCallbackInterrupted.Create;
      end;

      // Faz a exibi��o da mensagem de erro!
      LReponseErrorCause := TJsonArray.Create;
      for I := 0 to Pred(LValidatorResult.Informations.Count) do
        LReponseErrorCause.Add(LValidatorResult.Informations.GetItem(I).Message);

      LResponseError := TJsonObject.Create;
      LResponseError.AddPair('error', TJSONBool.Create(True));
      LResponseError.AddPair('causes', LReponseErrorCause);

      Res.Send<TJSONObject>(LResponseError);
    end);

  THorse.Listen(9000);

end.
