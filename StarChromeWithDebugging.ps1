param (
    [Parameter(Mandatory = $false)]
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe", # Path to chrome.exe  
    [Parameter(Mandatory = $false)]
    [int]$RemoteDebuggingPort = 9222
)

if (Test-Path $ChromePath) {
    $arguments = @(
        "--remote-debugging-port=$RemoteDebuggingPort",
        # "--user-data-dir=C:\temp\chrome-debugging", # Uncomment if user data directory is needed
        "--no-sandbox"
    )

    try {
        Start-Process -FilePath $ChromePath -ArgumentList $arguments -ErrorAction Stop
        Write-Host "Chrome started successfully with remote debugging on port $RemoteDebuggingPort"
    }
    catch {
        Write-Error "Failed to start Chrome: $_"
    }
}
else {
    Write-Error "Chrome not found at $ChromePath"
}
