procedure TouchFile(FileName: String);
{
const
  GENERIC_WRITE        = $40000000;
  OPEN_EXISTING        = 3;
  INVALID_HANDLE_VALUE = -1;
}
var
  FileTime: TFileTime;
  FileHandle: THandle;
  res: Boolean;
begin
  {Result := False;}
  FileHandle := CreateFile(FileName, $40000000, 0, 0, 3, $80, 0);
  if FileHandle <> -1 then
  try
    GetSystemTimeAsFileTime(FileTime);
    res := SetFileModifyTime(FileHandle, 0, 0, FileTime);
    if res <> True then
    begin
        FlexibleMsgBox('Not able to set modification time on zip archive. Continuing processing.', mbCriticalError, MB_OK);
    end;
  finally
    CloseHandle(FileHandle);
  end;      
end;

//<versioncheck>
