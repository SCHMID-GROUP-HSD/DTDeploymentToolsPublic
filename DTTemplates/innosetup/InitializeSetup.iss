function InitializeSetup(): Boolean;
var
    ErrorCode : Integer;
begin
    CustomExitCode := 0;
    CheckDependentVersionsAgain := false;
    Result:=CheckDependentVersions();
    if CheckDependentVersionsAgain
    then
    begin
        Result:=false
        Log('forking powershell.exe to restart InnoSetup exe');
        if not Exec('powershell.exe', '-Command try { start-sleep 1; & "'+ExpandConstant('{srcexe}')+'"; } catch {$_; exit 888}', '', SW_HIDE, ewNoWait, ErrorCode)
        then
        begin
            FlexibleMsgBox('Failed to restart Inno Setup exe. Error code: ' + IntToStr(ErrorCode) + '.', mbError, MB_OK);
        end
        else 
        begin
            Log('powershell.exe forked');
        end;
        if ErrorCode = 888 then
        begin
            FlexibleMsgBox('Failed while restarting Inno Setup exe. Error code: ' + IntToStr(ErrorCode) + '.', mbError, MB_OK);
        end;
    end
    else
    begin

    if CustomExitCode = 101 then
        Result := false;

    end

    {
    repeat
    until CheckDependentVersionsAgain = false;
    }
end;
