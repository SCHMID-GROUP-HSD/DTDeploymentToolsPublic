function SetFileModifyTime(hFile:THandle; CreationTimeNil:Cardinal; LastAccessTimeNil:Cardinal; LastWriteTime:TFileTime): BOOL;
external 'SetFileTime@kernel32.dll';
