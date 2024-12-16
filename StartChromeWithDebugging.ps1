param (
    [Parameter(Mandatory = $false)]
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe", 
    [Parameter(Mandatory = $false)]
    [string]$Arguements
)

if (Test-Path $ChromePath) {

    try {
        Start-Process -FilePath $ChromePath -ArgumentList $Arguements -ErrorAction Stop
        Write-Host "Chrome launced and navigated to $Url"
    }
    catch {
        Write-Error "Failed to start Chrome: $_"
    }
}
else {
    Write-Error "Chrome not found at $ChromePath"
}
