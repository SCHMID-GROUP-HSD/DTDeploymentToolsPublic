procedure ExecAndGetFirstLineLog(const S: String; const Error, FirstLine: Boolean);
begin
  if Trim(S) <> '' then
    Log(S);
end;
