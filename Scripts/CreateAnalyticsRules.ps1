param(
    [Parameter(Mandatory=$true)]$Workspace,
    [Parameter(Mandatory=$true)]$RulesFile
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

#Name of the Azure DevOps artifact
$artifactName = "RulesFile"

#Build the full path for the analytics rule file
$artifactPath = Join-Path $env:Pipeline_Workspace $artifactName 
$rulesFilePath = Join-Path $artifactPath $RulesFile

try {
    Import-AzSentinelAlertRule -WorkspaceName $Workspace -SettingsFile $rulesFilePath
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Error "Rule import failed with message: $ErrorMessage" 
}
