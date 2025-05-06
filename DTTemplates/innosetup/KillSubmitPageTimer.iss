procedure KillSubmitPageTimer;
begin
  KillTimer(0, SubmitPageTimer);
  SubmitPageTimer := 0;
end;
