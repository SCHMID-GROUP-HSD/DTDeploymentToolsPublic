function GetUpdatePackageVersion(): string;
var
  version: string;
  UpdatePackageVersionFromFile: AnsiString;
  UpdatePackageVersionFromExe: AnsiString;
  UpdatePackageExePath: string;
  UpdatePackageVersionFilePath: string;
begin
  Result := '#';
  UpdatePackageExePath:= 'C:\Program Files\SCHMID\SCHMIDwatchServer\SCHMIDwatchServer.exe'
UpdatePackageVersionFilePath:= 'C:\Program Files\SCHMID\SCHMIDwatchServer\MetaInfo\Version.txt'
  if FileExists(UpdatePackageVersionFilePath)
  then
  begin
    LoadStringFromFile(UpdatePackageVersionFilePath, UpdatePackageVersionFromFile);
    UpdatePackageVersionFromFile := Trim(UpdatePackageVersionFromFile);
    if UpdatePackageVersionFromFile <> ''
    then
    begin
      Result := UpdatePackageVersionFromFile;
    end
    else
    begin
      Result := '#empty_version_file';
    end;
  end
  else 
  begin
    if FileExists(UpdatePackageExePath)
    then
    begin
        UpdatePackageVersionFromExe := GetExeVersion(UpdatePackageExePath);
      if UpdatePackageVersionFromExe <> '' then
      begin
        Result := UpdatePackageVersionFromExe;
      end
        else
        begin
          Result := '#not_able_to_read_version_from_exe';
        end;
    end
    else
    begin
      Result := '#schmidwatchserver_exe_not_found';
    end;
  end;
end;
