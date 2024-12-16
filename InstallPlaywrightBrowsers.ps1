param(
    [Parameter(Mandatory = $true)]
    [string]$TestFolder,
    [Parameter(Mandatory = $true)]
    [string]$ProjectPattern,
    [Parameter(Mandatory = $true)]
    [string]$Arguments = "install --with-deps"
)

$scriptPath = Join-Path -Path $TestFolder -ChildPath "$ProjectPattern\playwright.ps1"

try{
    pwsh $scriptPath -Arguments $Arguments
    Write-Host "Playwright browsers installed successfully."
}
catch{
    Write-Error "Failed to install Playwright browsers: $_"
}