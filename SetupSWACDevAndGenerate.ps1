$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

if($null -eq (get-command git -erroraction SilentlyContinue)) {
  $tmpExeFile =  "$env:TEMP\git-setup.exe"
  Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe" -OutFile $tmpExeFile
  Start-Process -FilePath $tmpExeFile -ArgumentList "/SILENT", "/NORESTART", "/DIR=C:\Program Files\Git" -Wait -NoNewWindow
  Remove-item $tmpExeFile -erroraction SilentlyContinue
}

if ($null -eq (get-command pwsh -erroraction SilentlyContinue)) {
$tmpPwshFile = "$env:TEMP\pwsh.msi"
  Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi" -OutFile $tmpPwshFile
  Start-Process msiexec.exe -Wait -ArgumentList "/i `"$tmpPwshFile`" /qn /norestart"
  Remove-item $tmpPwshFile -erroraction SilentlyContinue
}

if ($null -eq (get-command choco -erroraction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

if ($null -eq (get-command dvc -erroraction SilentlyContinue)) {
  choco install dvc -y | out-string -stream
}



$tmpDir = (New-TemporaryFile).FullName + ".d"
mkdir $tmpDir
cd $tmpDir

git clone --recurse-submodules https://github.com/SCHMID-GROUP-HSD/SCHMIDwatchAdminCenter | Out-String -Stream
if (0 -ne $lastexitcode) {
    throw "error"
}

cd SCHMIDwatchAdminCenter

if ((test-path variable:DTSWACTagOrHash) -and ($null -ne $env:DTSWACTagOrHash)) {
    git checkout $env:DTSWACTagOrHash | Out-String -Stream
    if (0 -ne $lastexitcode) {
        throw "error"
    }
}

& "./dvc-fetch-files.ps1"
& "./generate.ps1"

