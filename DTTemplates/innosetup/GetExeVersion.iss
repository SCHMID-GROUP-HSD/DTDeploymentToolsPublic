function GetExeVersion(path: string): string;
var
  version: string;
begin
  Result := '';
  if MyGetVersionNumbersString(path, version) then
  begin
    Result := version;
  end;
end;
