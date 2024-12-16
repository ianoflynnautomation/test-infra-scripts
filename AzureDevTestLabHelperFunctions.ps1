Function  Set-Host-File-Entry-Lab-Vm {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$LabName,
        [Parameter(Mandatory = $true)]
        [string]$VmName,
        [Parameter(Mandatory = $true)]
        [string]$HostName
    )

    $ipAddress = az lab vm show `
        --lab-name $LabName `
        --name $VmName `
        --resource-group $ResourceGroupName `
        --expand '"properties($expand=computeVm,networkInterface)"' `
        --query networkInterface.privateIpAddress -o tsv `
        2>&1

    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n$($ipAddress)`$($HostName)" -Force

    if ($global:LASTEXITCODE -ne 0) {
        Write-Error "Failed to add host file entry to vm. Error: $output"
        Throw "Failed to add host file entry to vm. Error: $output"
    }

    Write-Information "Added host file entry to vm successfully"
}


Function  Get-Lab-Vm-Provisioning-Status {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$LabName,
        [Parameter(Mandatory = $true)]
        [string]$VmName
    )

    $output = az lab vm show `
        --resource-group $ResourceGroupName `
        --lab-name $LabName `
        --name $VmName `
        --query "[provisioningState]" -o tsv `
        2>&1

    if ($output -ne "Succeeded") {
        Write-Error "VM $($VmName) is not in Succeeded state. Current state: $($output)"
        Throw "VM $($VmName) is not in Succeeded state. Current state: $($output)"
    }

    Write-Information "VM $($VmName) is in Succeeded state"
}


Function  Get-Lab-Vm-Artifacts-Deployment-Status {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$LabName,
        [Parameter(Mandatory = $true)]
        [string]$VmName
    )

    $output = az lab vm show `
        --resource-group $ResourceGroupName `
        --lab-name $LabName `
        --name $VmName `
        --query "[artifactDeploymentStatus][0].[deploymentStatus]" -o tsv `
        2>&1

    if ($output -ne "Succeeded") {
        Write-Error "VM $($VmName) artifacts deployment is not in Succeeded state. Current state: $($output)"
        Throw "VM $($VmName) artifacts deployment is not in Succeeded state. Current state: $($output)"
    }

    Write-Information "VM $($VmName) artifacts deployment is in Succeeded state"
}


Function Remove-Lab-Vm {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$LabName,
        [Parameter(Mandatory = $true)]
        [string]$VmName
    )

    $output = az lab vm delete `
        --resource-group $ResourceGroupName `
        --lab-name $LabName `
        --name $VmName `
        --yes `
        2>&1

    if ($global:LASTEXITCODE -ne 0) {
        Write-Error "Failed to delete vm $($VmName). Error: $output"
        Throw "Failed to delete vm $($VmName). Error: $output"
    }

    Write-Information "Deleted vm $($VmName) successfully"
}


Function Remove-Deployment-Group {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$DeploymentGroupName
    )

    $output = az deployment group delete `
        --resource-group $ResourceGroupName `
        --name $DeploymentGroupName `
        2>&1

    if ($global:LASTEXITCODE -ne 0) {
        Write-Error "Failed to delete deployment group $($DeploymentGroupName). Error: $output"
        Throw "Failed to delete deployment group $($DeploymentGroupName). Error: $output"
    }

    Write-Information "Deleted deployment group $($DeploymentGroupName) successfully"
}