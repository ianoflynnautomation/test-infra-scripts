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