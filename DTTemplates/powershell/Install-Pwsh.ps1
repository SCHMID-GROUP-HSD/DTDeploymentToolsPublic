if ($null -eq (get-command pwsh -erroraction SilentlyContinue)) {
  $ErrorActionPreference = "Stop"
  $ProgressPreference = 'SilentlyContinue'
  $tmpPwshFile = "$env:TEMP\pwsh.msi"
  Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi" -OutFile $tmpPwshFile
  ###Start-Process msiexec.exe -Wait -ArgumentList "/i `"$tmpPwshFile`" /qn /norestart"
  msiexec.exe /i $tmpPwshFile /qn /norestart | out-string -stream
  Remove-item $tmpPwshFile -erroraction SilentlyContinue
  if(0 -ne $lastexitcode) { throw "error. please see above" }
  $pwshInstalled = $true
}
