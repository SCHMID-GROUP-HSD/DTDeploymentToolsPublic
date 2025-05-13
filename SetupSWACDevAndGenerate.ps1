$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

$tmpDir = (New-TemporaryFile).FullName + ".d"
$oldpwd = $pwd

try {

  $ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

function restartPwsh {
& "C:\Program Files\PowerShell\7\pwsh.exe" -executionpolicy unrestricted -command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ("`$psscriptroot=`"$psscriptroot`";" +((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SCHMID-GROUP-HSD/DTDeploymentToolsPublic/refs/heads/main/SetupSWACDevAndGenerate.ps1')))" | out-string -stream
  exit $lastexitcode
}

$pwshInstalled=$false

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
if($pwshInstalled) {
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

if($null -eq (get-command gh -erroraction SilentlyContinue)) {
  $tmpExeFile =  "$env:TEMP\gh-setup.exe"
  Invoke-WebRequest -Uri "https://github.com/cli/cli/releases/download/v2.72.0/gh_2.72.0_windows_amd64.msi" -OutFile $tmpExeFile
  ### Start-Process -FilePath $tmpExeFile -ArgumentList "/SILENT", "/NORESTART", "/DIR=C:\Program Files\Git" -Wait -NoNewWindow
  #& $tmpExeFile "/SILENT" "/NORESTART" "/DIR=C:\Program Files\Git" | out-string -stream
  & $tmpExeFile "/SILENT" "/NORESTART" | out-string -stream
  Remove-item $tmpExeFile -erroraction SilentlyContinue
  if(0 -ne $lastexitcode) { throw "error. please see above" }
}

https://github.com/cli/cli/releases/download/v2.72.0/gh_2.72.0_windows_amd64.msi
  mkdir $tmpDir
  cd $tmpDir

  git clone --recurse-submodules https://github.com/SCHMID-GROUP-HSD/SCHMIDwatchAdminCenter | Out-String -Stream
  if (0 -ne $lastexitcode) {
      throw "error"
  }

  cd SCHMIDwatchAdminCenter
  $psscriptroot = $pwd

  if ((test-path env:DTSWACTagOrHash) -and ($null -ne $env:DTSWACTagOrHash)) {
      git checkout $env:DTSWACTagOrHash | Out-String -Stream
      if (0 -ne $lastexitcode) {
          throw "error"
      }
      git submodule update --init --recursive | Out-String -Stream
      if (0 -ne $lastexitcode) {
          throw "error"
      }
  }

  & "./dvc-fetch-files.ps1" | out-string -stream
  & "./generate.ps1" | out-string -stream

}
catch {
  write-host "error:"
  write-error $_
} finally {
}
