function Get-SWIExecutionEnvironment {
    
    $result = ""
    if (-not([string]::isnullorempty([Environment]::GetEnvironmentVariable('SWIEXECUTIONENVIRONMENT')))) {
        $result = $env:SWIEXECUTIONENVIRONMENT
    }
    
    return $result
}
