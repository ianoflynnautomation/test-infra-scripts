<#
Used to run tests on remote devices, this script will establish an SSH tunnel to the remote device 
and to allow Chrome to connect to the remote device via chrome devtools protocol.
#>
param (
    [Parameter(Mandatory = $true)]
    [string]$HostName,
    [Parameter(Mandatory = $false)]
    [string]$Username = "root",
    [Parameter(Mandatory = $false)]
    [int]$LocalPort = 9222,
    [Parameter(Mandatory = $false)]
    [int]$RemotePort = 9222
)


$arguments = "-t -t -o StrictHostKeyChecking=accept-new -L 127.0.0.1:$($LocalPort):127.0.0.1:$($RemotePort) $Username@$($HostName)"

try {
    Start-Process ssh -ArgumentList $arguments -NoNewWindow -RedirectStandardOutput $null -RedirectStandardError $null
    Write-Host "SSH tunnel established successfully."
}
catch {
    Write-Error "Failed to establish SSH tunnel: $_"
}
