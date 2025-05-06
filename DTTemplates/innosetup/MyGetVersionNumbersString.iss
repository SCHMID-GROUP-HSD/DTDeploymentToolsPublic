function MyGetVersionNumbersString(
  const Filename: String; var Version: String): Boolean;
var
  MS, LS: Cardinal;
  Major, Minor, Rev, Build: Cardinal;
begin
  Result := GetVersionNumbers(Filename, MS, LS);

  if Result then
  begin
    Major := MS shr 16;
    Minor := MS and $FFFF;
    Rev := LS shr 16;
    Build := LS and $FFFF;
    Version := Format('%d.%d.%d', [Major, Minor, Rev]);
  end
end;
