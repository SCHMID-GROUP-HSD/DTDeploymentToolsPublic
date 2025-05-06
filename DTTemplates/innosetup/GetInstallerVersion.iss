function GetInstallerVersion(): string;
var
  version: string;
  InstallerVersionFromFile: AnsiString;
  InstallerVersionFromExe: AnsiString;
  installerExePath: string;
  installerVersionFilePath: string;
begin
  Result := '#';
  installerExePath:= 'C:\Program Files\SCHMID\SCHMIDwatchInstaller\SCHMIDwatchInstaller.exe'
installerVersionFilePath:= 'C:\Program Files\SCHMID\SCHMIDwatchInstaller\MetaInfo\Version.txt'
  if FileExists(installerVersionFilePath)
  then
  begin
    LoadStringFromFile(installerVersionFilePath, InstallerVersionFromFile);
    InstallerVersionFromFile := Trim(InstallerVersionFromFile);
    if InstallerVersionFromFile <> ''
    then
    begin
      Result := InstallerVersionFromFile;
    end
    else
    begin
      Result := '#empty_version_file';
    end;
  end
  else 
  begin
    if FileExists(installerExePath)
    then
    begin
        InstallerVersionFromExe := GetExeVersion(installerExePath);
      if InstallerVersionFromExe <> '' then
      begin
        Result := InstallerVersionFromExe;
      end
        else
        begin
          Result := '#not_able_to_read_version_from_exe';
        end;
    end
    else
    begin
      Result := '#installer_exe_not_found';
    end;
  end;
end;
