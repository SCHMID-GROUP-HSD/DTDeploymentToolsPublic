procedure ExecuteProgram(path:String; parameters:String; okExitCode1:Integer; okExitCode2: Integer; okExitCode3: Integer);
var
    ResultCode: Integer;
begin
 
    Log( 'ExecuteProgram: path: '+path + ', parameters: '+ parameters + ', okExitCodes: '+ IntToStr(okExitCode2) + ', ' + IntToStr(okExitCode2) + ', ' + IntToStr(okExitCode3));

    if ExecAndLogOutput(ExpandConstant(path), ExpandConstant(parameters), '', SW_SHOW,
            ewWaitUntilTerminated, ResultCode, @ExecAndGetFirstLineLog)
    then begin
        if (ResultCode = okExitCode1) then
        begin
        end
        else if (ResultCode = okExitCode2) then
        begin
        end
        else if (ResultCode = okExitCode3) then
        begin
        end
        else
        begin
                    FlexibleMsgBox('Got wrong error code: ' + IntToStr(ResultCode) +'. Allowed error codes: ' + IntToStr(okExitCode1) +', '+IntToStr(okExitCode2)+', '+IntToStr(okExitCode3) + #13#10 + SysErrorMessage(ResultCode), mbCriticalError, MB_OK);
CloseInstaller(92);
        end
    end
    else
    begin
                    FlexibleMsgBox('Got wrong error code: ' + IntToStr(ResultCode) +'. Allowed error codes: ' + IntToStr(okExitCode1) +', '+IntToStr(okExitCode2)+', '+IntToStr(okExitCode3) + #13#10 + SysErrorMessage(ResultCode), mbCriticalError, MB_OK);
CloseInstaller(93);
    end;
end;

{
