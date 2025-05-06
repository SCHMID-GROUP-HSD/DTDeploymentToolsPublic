procedure CurPageChanged(CurPageID: Integer);
begin
  if ExpandConstant('{param:skipwelcome|}') = 'yes' then
  begin
    if CurPageID = wpReady then
    begin
      SubmitPageTimer := SetTimer(0, 0, 100, CreateCallback(@SubmitPageProc));
    end
    else
    begin
      if SubmitPageTimer <> 0 then
      begin
        KillSubmitPageTimer;
      end;
    end;

  end;
end;
