$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

function restartPwsh {
& "C:\Program Files\PowerShell\7\pwsh.exe" -executionpolicy unrestricted -command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SCHMID-GROUP-HSD/DTDeploymentToolsPublic/refs/heads/main/SetupSWACDevAndGenerate.ps1'))
" | out-string -stream
  exit $lastexitcode
}

if ($null -eq (get-command pwsh -erroraction SilentlyContinue)) {
  $tmpPwshFile = "$env:TEMP\pwsh.msi"
  Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi" -OutFile $tmpPwshFile
  ###Start-Process msiexec.exe -Wait -ArgumentList "/i `"$tmpPwshFile`" /qn /norestart"
  msiexec.exe /i $tmpPwshFile /qn /norestart | out-string -stream
  Remove-item $tmpPwshFile -erroraction SilentlyContinue
  if(0 -ne $lastexitcode) { throw "error. please see above" }

  restartPwsh
}

if($null -eq (get-command git -erroraction SilentlyContinue)) {
  $tmpExeFile =  "$env:TEMP\git-setup.exe"
  Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe" -OutFile $tmpExeFile
  ### Start-Process -FilePath $tmpExeFile -ArgumentList "/SILENT", "/NORESTART", "/DIR=C:\Program Files\Git" -Wait -NoNewWindow
  & $tmpExeFile "/SILENT" "/NORESTART" "/DIR=C:\Program Files\Git" | out-string -stream
  Remove-item $tmpExeFile -erroraction SilentlyContinue
  if(0 -ne $lastexitcode) { throw "error. please see above" }
}


if ($null -eq (get-command choco -erroraction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

if (-not(choco list --lo -r -e dvc)) {
  choco install dvc -y | out-string -stream
  if(0 -ne $lastexitcode) { throw "error. please see above" }
}


$item = (Get-ChildItem "C:\python*" -ErrorAction SilentlyContinue | foreach-object { set-location $_; Get-ChildItem "Scripts\dvc.exe" -ErrorAction SilentlyContinue })
if($item -eq $null) {
  throw "dvc path not found"
} else {
  set-alias -name "dvc" $item.FullName
}




