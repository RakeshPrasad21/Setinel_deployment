param (
    [Parameter(Mandatory=$true)]$OnboardingFile
)

#Adding AzSentinel module
$AzSentinelModule=Get-Module -Name AzSentinel -ListAvailable
if(!$AzSentinelModule)
{
 Write-Host "Installing AzSentinel Module"
 Install-Module AzSentinel -Scope CurrentUser -Force -AllowClobber
}
else
{
 Write-Host "AzSentinel module exist."
}

Import-Module AzSentinel

$artifactName = "OnboardingFile"

#Build the full path for the onboarding file
$artifactPath = Join-Path $env:Pipeline_Workspace $artifactName 
$onboardingFilePath = Join-Path $artifactPath $OnboardingFile

$workspaces = Get-Content -Raw -Path $onboardingFilePath | ConvertFrom-Json

foreach ($item in $workspaces.deployments){
    Write-Host "Processing workspace $($item.workspace) ..."
    $solutions = Get-AzOperationalInsightsIntelligencePack -resourcegroupname $item.resourcegroup -WorkspaceName $item.workspace -WarningAction:SilentlyContinue

    if (($solutions | Where-Object Name -eq 'SecurityInsights').Enabled) {
        Write-Host "SecurityInsights solution is already enabled for workspace $($item.workspace)"
    }
    else {
        Set-AzSentinel -WorkspaceName $item.workspace -Confirm:$false
    }
}
