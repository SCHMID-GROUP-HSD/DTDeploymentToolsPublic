function PrepareToInstall(var NeedsRestart: Boolean): String;
var
ErrorCode: Integer;
begin
      ShellExec('open',  'taskkill.exe', '/f /im SCHMIDwatchInstaller.exe','',SW_HIDE,ewNoWait,ErrorCode);
end;
