<#
Used to run tests on remote devices, this script will establish an SSH tunnel to the remote device 
and to allow Chrome to connect to the remote device for debugging.
#>
param (
    [Parameter(Mandatory = $true)]
    [string]$Username,
    [Parameter(Mandatory = $true)]
    [string]$HostName,
    [Parameter(Mandatory = $false)]
    [int]$LocalPort = 9222,
    [Parameter(Mandatory = $false)]
    [int]$RemotePort = 9222,
    [Parameter(Mandatory = $false)]
    [switch]$strictHostKeyChecking = $false
)

$sshOptions = "-o StrictHostKeyChecking=accept-new"

if ($strictHostKeyChecking) {
    $sshOptions = "-o StrictHostKeyChecking=yes"
}

$sshCommand = "ssh $sshOptions -L 127.0.0.1:$($LocalPort):127.0.0.1:$($RemotePort) $Username@$($HostName)"

try {
    Invoke-Expression $sshCommand
    Write-Host "SSH tunnel established successfully."
}
catch {
    Write-Error "Failed to establish SSH tunnel: $_"
}
