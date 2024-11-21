[CmdletBinding()]
param (
	[parameter(Mandatory=$true)][string]$ModuleName,
	[parameter(Mandatory=$false)][string]$SourcePath = "~/Documents/github_personal",
	[parameter(Mandatory=$false)][string]$DestinationPath = "~/Documents/github_clean",
	[parameter(Mandatory=$false)][switch]$Publish
)
try {
	$source = Resolve-Path -Path $SourcePath -ErrorAction Stop | Select-Object -ExpandProperty Path
	$dest   = Resolve-Path -Path $DestinationPath -ErrorAction Stop | Select-Object -ExpandProperty Path

	$modulePath = Resolve-Path -Path $(Join-Path -Path $source -ChildPath $ModuleName) -ErrorAction Stop | Select-Object -ExpandProperty Path

	Copy-Item -Path $modulePath -Destination $dest -Recurse
	if (Test-Path (Join-Path $dest $ModuleName ".git")) {
		Write-Host "Cleaning up .git folder" -ForegroundColor Cyan
		Remove-Item -Path (Join-Path $dest $ModuleName ".git") -Recurse -Force
	}

	Write-Output "Module files copied to $dest"

	if ($Publish.IsPresent) {
		$publishPath = Resolve-Path -Path (Join-Path $dest $ModuleName) -ErrorAction Stop | Select-Object -ExpandProperty Path
		Publish-PSResource -Path $publishPath -ApiKey $env:PSAPIKey -Repository PSGallery
	}
} catch {
	Write-Error $_.Exception.Message
}