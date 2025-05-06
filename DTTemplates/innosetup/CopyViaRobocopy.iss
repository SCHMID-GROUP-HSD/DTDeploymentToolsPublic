procedure CopyViaRobocopy(source:String;destination:String;parameters:String);
var
    ResultCode: Integer;
begin
 
    source := ExpandConstant(source);
    destination := ExpandConstant(destination);
    parameters := ExpandConstant(parameters);
    Log( 'CopyViaRobocopy: source: '+source + ', destination: '+ destination + ', parameters: '+ parameters );

    if ExecAndLogOutput('robocopy.exe', AddQuotes(source)+ ' ' + AddQuotes(destination) + ' ' + parameters, '', SW_HIDE,
            ewWaitUntilTerminated, ResultCode, @ExecAndGetFirstLineLog)
    then begin
        if (ResultCode >=8) then
        begin
            FlexibleMsgBox('Got wrong error code while executing robocopy.exe: ' + IntToStr(ResultCode) + #13#10 + SysErrorMessage(ResultCode), mbCriticalError, MB_OK);
            CloseInstaller(90);
        end;
      
        if not DelTree(source,True,True,True)
        then
        begin
            FlexibleMsgBox('Error occured while deleting "'+source+'"', mbCriticalError, MB_OK);
            CloseInstaller(87);
        end;
    end
    else
    begin
        FlexibleMsgBox('Got wrong error code while executing robocopy.exe: ' + IntToStr(ResultCode) + #13#10 + SysErrorMessage(ResultCode), mbCriticalError, MB_OK);
        CloseInstaller(91);
    end;
end;
