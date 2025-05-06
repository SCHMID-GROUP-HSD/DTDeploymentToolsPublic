function CreateFile(
    lpFileName             : String;
    dwDesiredAccess        : Cardinal;
    dwShareMode            : Cardinal;
    lpSecurityAttributes   : Cardinal;
    dwCreationDisposition  : Cardinal;
    dwFlagsAndAttributes   : Cardinal;
    hTemplateFile          : Integer
): THandle;
#ifdef UNICODE
 external 'CreateFileW@kernel32.dll stdcall';
#else
 external 'CreateFileA@kernel32.dll stdcall';
#endif
