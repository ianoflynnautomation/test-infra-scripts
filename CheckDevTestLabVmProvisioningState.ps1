param (
    [Parameter(Mandatory = $true)][string]$subscriptionId,
    [Parameter(Mandatory = $true)][string]$labName,
    [Parameter(Mandatory = $true)][string]$resourceGroupName,
    [Parameter(Mandatory = $true)][string]$vmName,
    [Parameter(Mandatory = $false)][string]$agentPoolPat
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$vmUrl = "https://management.azure.com/subscriptions/$(subscriptionId)/resourceGroups/$(resourceGroupName)/providers/Microsoft.DevTestLab/labs/$(labName)/virtualmachines/$(vmName)?api-version=2018-09-15"
try {
    if ($agentPoolPat) {
        $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$($agentPoolPat)"))
        $authorizationHeader = "Basic $($encodedPat)"
    }
    $vms = (Invoke-RestMethod -Uri $vmUrl -Method 'Get' -Headers @{Authorization = $authorizationHeader }).value
    if ($vms) {
        $vmId = ($vms | Where-Object { $_.name -eq "$($vmName)" }).id
        if ($vmId) {
            $vmStatusUrl = "https://management.azure.com/subscriptions/$(subscriptionId)/resourceGroups/$(resourceGroupName)/providers/Microsoft.DevTestLab/labs/$(labName)/virtualmachines/$(vmName)/providers/Microsoft.Compute/virtualMachines/$(vmName)/instanceView?api-version=2018-09-15"
            $vmStatus = (Invoke-RestMethod -Uri $vmStatusUrl -Method 'Get' -Headers @{Authorization = $authorizationHeader }).statuses
            $vmStatus = ($vmStatus | Where-Object { $_.code -eq "ProvisioningState/succeeded" }).displayStatus
            if ($vmStatus) {
                Write-Host "VM status: $($vmStatus)"
                if ($vmStatus -ne "Succeeded") {
                    Write-Error "VM status is not Succeeded. Status: $($vmStatus)"
                }
                else {
                    Write-Host "VM status is Succeeded"
                }
            }
            else {
                Write-Error "VM with name $($vmName) not found in lab $($labName)"
            }
        }
        else {
            Write-Error "No VMs found in lab $($labName)"
        }
    }
    else {
        Write-Error "Lab with name $($labName) not found"
    }
}
catch {
    Write-Error ("Error: {0}" -f $_.Exception.ToString())
}
