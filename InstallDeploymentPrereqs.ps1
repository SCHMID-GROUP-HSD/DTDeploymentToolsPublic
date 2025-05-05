#### wird aufgerufen mit: 
#### Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('URL'))

$ProgressPreference = 'SilentlyContinue'
$erroractionpreference= 'Stop'

if ($null -eq (get-command pwsh -erroraction SilentlyContinue)) {
  Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi" -OutFile "$env:TEMP\pwsh.msi"
  Start-Process msiexec.exe -Wait -ArgumentList "/i `"$env:TEMP\pwsh.msi`" /qn /norestart"
}

if ($null -eq (get-command choco -erroraction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

if ($null -eq (get-command dvc -erroraction SilentlyContinue)) {
  choco install dvc -y | out-string -stream
}


