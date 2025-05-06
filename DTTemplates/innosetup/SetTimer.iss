function SetTimer(hWnd, nIDEvent, uElapse, lpTimerFunc: LongWord): LongWord;
  external 'SetTimer@User32.dll stdcall';
