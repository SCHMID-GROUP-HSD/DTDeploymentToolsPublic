function Get-PSModuleVersion($modulepath) {
    $contents = Get-Content -Raw $modulepath
    if ($contents -match "(?mi)^\s*moduleversion\s*=\s*'([^']*)'") {
        $matches[1]
    }
    else {
        throw "no ModuleVersion found"
    }
}
