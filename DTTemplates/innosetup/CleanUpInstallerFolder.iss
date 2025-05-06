procedure CleanUpInstallerFolder;
begin
    Log('CleanUpInstallerFolder');
    if DirExists('C:\Program Files\Schmid\SCHMIDwatchInstaller') then 
    begin 
        if not DelTree('C:\Program Files\Schmid\SCHMIDwatchInstaller', True, True, True)
        then
        begin
            FlexibleMsgBox('Not able to empty SCHMIDwatchInstaller directory', mbCriticalError, MB_OK);
            CloseInstaller(89);
        end;
    end;
end;
