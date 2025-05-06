var
  CancelWithoutPrompt: boolean;

procedure CloseInstaller(exitCode: Integer);
begin
    if ExpandConstant('{param:Mode|Normal}') = 'Unattended' then
    begin
        ExitProcess(exitCode);
    end
    else
        CancelWithoutPrompt := true;
        WizardForm.Close;
        ExitProcess(exitCode);
    begin
    end;
end;
