$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

  if ($null -eq (get-command choco -erroraction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  }

  if (-not(choco list --lo -r -e dvc)) {
    choco install dvc -y | out-string -stream
    if(0 -ne $lastexitcode) { throw "error. please see above. chocolatey log: $(get-content 'C:\ProgramData\chocolatey\logs\chocolatey.log')" }
    $env:Path = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine);
  }

function restartPwsh {
  & "C:\Program Files\PowerShell\7\pwsh.exe" -executionpolicy unrestricted -encodedcommand "UwBlAHQALQBFAHgAZQBjAHUAdABpAG8AbgBQAG8AbABpAGMAeQAgAEIAeQBwAGEAcwBzACAALQBTAGMAbwBwAGUAIABQAHIAbwBjAGUAcwBzACAALQBGAG8AcgBjAGUAOwAgAFsAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAZQByAHYAaQBjAGUAUABvAGkAbgB0AE0AYQBuAGEAZwBlAHIAXQA6ADoAUwBlAGMAdQByAGkAdAB5AFAAcgBvAHQAbwBjAG8AbAAgAD0AIABbAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBTAGUAcgB2AGkAYwBlAFAAbwBpAG4AdABNAGEAbgBhAGcAZQByAF0AOgA6AFMAZQBjAHUAcgBpAHQAeQBQAHIAbwB0AG8AYwBvAGwAIAAtAGIAbwByACAAMwAwADcAMgA7ACAAaQBlAHgAIAAoACcAJABwAHMAcwBjAHIAaQBwAHQAcgBvAG8AdAA9ACIAJwArACQAcABzAHMAYwByAGkAcAB0AHIAbwBvAHQAKwAnACIAOwAnACsAKAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABTAHkAcwB0AGUAbQAuAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAKQAuAEQAbwB3AG4AbABvAGEAZABTAHQAcgBpAG4AZwAoACcAaAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAdQBzAGUAcgBjAG8AbgB0AGUAbgB0AC4AYwBvAG0ALwBTAEMASABNAEkARAAtAEcAUgBPAFUAUAAtAEgAUwBEAC8ARABUAEQAZQBwAGwAbwB5AG0AZQBuAHQAVABvAG8AbABzAFAAdQBiAGwAaQBjAC8AcgBlAGYAcwAvAGgAZQBhAGQAcwAvAG0AYQBpAG4ALwBTAGUAdAB1AHAAUwBXAEEAQwBEAGUAdgBBAG4AZABHAGUAbgBlAHIAYQB0AGUALgBwAHMAMQAnACkAKQApAA==" | out-string -stream
  #exit $lastexitcode
}

$pwshInstalled=$false

if (-not(test-path "C:\program files\just\just.exe")) {
  $ErrorActionPreference = "Stop"
  $ProgressPreference = 'SilentlyContinue'
$downloadUrl = "https://github.com/casey/just/releases/download/1.40.0/just-1.40.0-x86_64-pc-windows-msvc.zip"
$zipPath = "$env:TEMP\just.zip"
$extractPath = "$env:TEMP\just_extracted"

# Download the zip file
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

# Unzip
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
Remove-item $zipPath -force

# Find the just.exe
$justExePath = Get-ChildItem -Path $extractPath -Filter "just.exe" -Recurse | Select-Object -First 1

# Choose install path
$installDir = "C:\Program Files\just"
if (-not (Test-Path $installDir)) {
    New-Item -Path $installDir -ItemType Directory | Out-Null
}

# Move just.exe to install location
Move-Item -Path $justExePath.FullName -Destination "$installDir\just.exe" -Force

# Add to PATH if not already in PATH
if (-not ($env:Path -split ";" | Where-Object { $_ -eq $installDir })) {
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$installDir", [EnvironmentVariableTarget]::Machine)
    Write-Host "Added '$installDir' to PATH. You may need to restart your terminal or computer for changes to take effect."
} else {
    Write-Host "'$installDir' is already in PATH."
}

Remove-item $extractPath -force -recurse

Write-Host "✅ just.exe installed to: $installDir"

}
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
}if($pwshInstalled) {
  restartPwsh
}

if ($PSVersionTable.PSEdition -eq 'Core') { 
  if(-not(test-path "C:\Program Files\Git\cmd\git.exe")) {
    $tmpExeFile =  "$env:TEMP\git-setup.exe"
    Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe" -OutFile $tmpExeFile
    ### Start-Process -FilePath $tmpExeFile -ArgumentList "/SILENT", "/NORESTART", "/DIR=C:\Program Files\Git" -Wait -NoNewWindow
    & $tmpExeFile "/SILENT" "/NORESTART" "/DIR=C:\Program Files\Git" | out-string -stream
    Remove-item $tmpExeFile -erroraction SilentlyContinue
    if(0 -ne $lastexitcode) { throw "error. please see above" }
    $env:Path = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine);
  }



  if(-not(test-path "C:\Program Files\GitHub CLI\gh.exe")) {
    $tmpExeFile =  "$env:TEMP\gh-setup.msi"
    Invoke-WebRequest -Uri "https://github.com/cli/cli/releases/download/v2.72.0/gh_2.72.0_windows_amd64.msi" -OutFile $tmpExeFile
    & msiexec.exe /I $tmpExeFile "/quiet" "/norestart" | out-string -stream
    Remove-item $tmpExeFile -erroraction SilentlyContinue
    if(0 -ne $lastexitcode) { throw "error. please see above" }
    $env:Path = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine);

  }

  & "C:\Program Files\GitHub CLI\gh.exe" auth status | out-string
  if(1 -eq $lastexitcode) { 
    & "C:\Program Files\GitHub CLI\gh.exe" auth login --hostname GitHub.com --git-protocol SSH --skip-ssh-key --web
  }
} else { 
  write-host "note: code not run, because its not PS 7"
}
