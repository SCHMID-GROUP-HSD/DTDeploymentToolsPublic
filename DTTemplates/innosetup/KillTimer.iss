var
  SubmitPageTimer: LongWord;

function KillTimer(hWnd, nIDEvent: LongWord): LongWord;
  external 'KillTimer@User32.dll stdcall';
