function GetBaseInstallUpdatePackageVersion(): string;
var
  version: string;
  sqlSetupPath: string;
  BaseInstallUpdatePackageVersionFromFile: AnsiString;
begin
  Result := '#';
  if FileExists('C:\Install\Schmid\SCHMIDwatchInstaller\SW-BaseInstall-package\MetaInfo\BaseInstallUpdatePackageVersion.txt')
  then
  begin
    LoadStringFromFile('C:\Install\Schmid\SCHMIDwatchInstaller\SW-BaseInstall-package\MetaInfo\BaseInstallUpdatePackageVersion.txt', BaseInstallUpdatePackageVersionFromFile);
    BaseInstallUpdatePackageVersionFromFile := Trim(BaseInstallUpdatePackageVersionFromFile);
    if BaseInstallUpdatePackageVersionFromFile <> ''
    then
    begin
      Result := BaseInstallUpdatePackageVersionFromFile;
    end
    else
    begin
      Result := '#empty_version_file';
    end;
  end
  else 
  begin
      Result := '#BaseInstallUpdatePackageVersion_not_found';
  end;
end;
