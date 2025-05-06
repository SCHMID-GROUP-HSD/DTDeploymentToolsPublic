function IsBaseInstallFinished(): Boolean;
var
  contents: AnsiString;
  doneJsonPath: string;
begin
  Result := false;
  doneJsonPath := 'C:\ProgramData\Schmid\SCHMIDwatchInstaller\done.json';
  if FileExists(doneJsonPath)
  then
  begin
    LoadStringFromFile(doneJsonPath, contents);
    if Pos('b40d9ec6-f2c2-4264-88d5-3d3144c876af',contents) <> 0
    then
    begin
      Result := true;
    end
  end
end;
