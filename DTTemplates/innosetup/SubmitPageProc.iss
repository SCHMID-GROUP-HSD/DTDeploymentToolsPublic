procedure SubmitPageProc(
  H: LongWord; Msg: LongWord; IdEvent: LongWord; Time: LongWord);
begin
  WizardForm.NextButton.OnClick(WizardForm.NextButton);
  KillSubmitPageTimer;
end;
