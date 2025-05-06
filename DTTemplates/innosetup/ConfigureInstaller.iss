procedure ConfigureInstaller;
begin
    ExecuteProgram2('powershell.exe','-ExecutionPolicy Unrestricted -noninteractive -file "C:\Program Files\Schmid\SCHMIDwatchInstaller\ConfigureInstaller.ps1" -srcexe "'+ExpandConstant('{#INSTALLEREXEPATH}')+'"',0,0,0) ;
    /////ExecuteProgram2('powershell.exe','-Command try { $p = [Environment]::GetEnvironmentVariable(''PSModulePath'',''Machine''); $added = ''C:\Program Files\Schmid\SCHMIDwatchInstaller\Modules''; if ($p.indexOf($added) -eq -1) { $p += '';''+$added; [Environment]::SetEnvironmentVariable(''PSModulePath'', $p,''Machine'') }} catch {$_; exit 888}',0,0,0) ;
end;
