## Installing SWAC dev environment

1. (Optional) Set a specific version of the SWAC:

```
$env:DTSWACTagOrHash="v2.0.10" # could also be a hash like "72743d9"
```

2. (Optional) Set a specific target path for the to-be-created `SCHMIDwatchAdminCenter`:

```
$env:DTSWACDevRoot = "C:\my"
```

3. Run following powershell snippet (as administrator): 

```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ('$psscriptroot="'+$psscriptroot+'";'+((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SCHMID-GROUP-HSD/DTDeploymentToolsPublic/refs/heads/main/SetupSWACDevAndGenerate.ps1')))
```
