function GetBaseInstallVersion(): string;
var
  version: string;
  sqlSetupPath: string;
  BaseInstallVersionFromFile: AnsiString;
  BaseInstallVersionFromSQLExe: AnsiString;
begin
  Result := '#';
  if FileExists('C:\Install\Schmid\SCHMIDwatchInstaller\SW-BaseInstall-package\MetaInfo\Version.txt')
  then
  begin
    LoadStringFromFile('C:\Install\Schmid\SCHMIDwatchInstaller\SW-BaseInstall-package\MetaInfo\Version.txt', BaseInstallVersionFromFile);
    BaseInstallVersionFromFile := Trim(BaseInstallVersionFromFile);
    if BaseInstallVersionFromFile <> ''
    then
    begin
      Result := BaseInstallVersionFromFile;
    end
    else
    begin
      Result := '#empty_version_file';
    end;
  end
  else 
  begin
    sqlSetupPath := 'C:\Install\Schmid\SCHMIDwatchInstaller\SW-BaseInstall-package\SQLEXPR_x64_ENU\SETUP.EXE';
    if FileExists(sqlSetupPath)
    then
    begin
        BaseInstallVersionFromSQLExe := GetExeVersion(sqlSetupPath);
      //if BaseInstallVersionFromSQLExe = '16.0.1000' then
      if BaseInstallVersionFromSQLExe = '2022.160.1000' then
      begin
        Result := '1.0.12';
      end
        else
        begin
          //Result := '#running_baseinstall_needed';
          Result := '#old_sql_'+BaseInstallVersionFromSQLExe;
        end;
    end
    else
    begin
      Result := '#sql_setup_not_found';
    end;
  end;
end;
