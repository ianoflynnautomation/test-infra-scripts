param (
    [Parameter(Mandatory = $true)][string]$organizationName,
    [Parameter(Mandatory = $true)][string]$apiVersion,
    [Parameter(Mandatory = $true)][string]$poolName,
    [Parameter(Mandatory = $true)][string]$accessToken,
    [Parameter(Mandatory = $false)][string]$agentPoolPat,
    [Parameter(Mandatory = $true)][string]$agentName
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$poolsUrl = "https://dev.azure.com/$($organizationName)/_apis/distributedtask/pools?api-version=$($apiVersion)"
try {
    if ($agentPoolPat) {
        $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$($agentPoolPat)"))
        $authorizationHeader = "Basic $($encodedPat)"
    }
    else {
        $authorizationHeader = "Bearer $($accessToken)"
    }

    $pools = (Invoke-RestMethod -Uri $poolsUrl -Method 'Get' -Headers @{Authorization = $authorizationHeader }).value
    if ($pools) {
        $poolId = ($pools | Where-Object { $_.name -eq "$($poolName)" }).id
        if ($poolId) {
            $agentsUrl = "https://dev.azure.com/$($organizationName)/_apis/distributedtask/pools/$($poolId)/agents?api-version=$($apiVersion)"
            $agents = (Invoke-RestMethod -Uri $agentsUrl -Method 'Get' -Headers @{Authorization = $authorizationHeader }).value
            $agentId = ($agents | Where-Object { $_.name -eq "$($agentName)" }).id
            if ($agentId) {
                Write-Host "Delete agent with name $($agentName) from pool $($poolName)"
                $deleteAgentUrl = "https://dev.azure.com/$($organizationName)/_apis/distributedtask/pools/$($poolId)/agents/$($agentId)?api-version=$($apiVersion)"
                Invoke-RestMethod -Uri $deleteAgentUrl -Method 'Delete' -Headers @{Authorization = $authorizationHeader }
            }
            else {
                Write-Error "Agent with name $($agentName) not found in pool $($poolName)"
            }
        }
        else {
            Write-Error "No agents found in pool $($poolName)"
        }
    }
    else {
        Write-Error "Pool with name $($poolName) not found"
    }
}
catch {
    Write-Error ("Error: {0}" -f $_.Exception.ToString())
}
