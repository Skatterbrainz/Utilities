<#
.SYNOPSIS
	Add a user to an Exchange Online distribution group.
.DESCRIPTION
	This script will prompt for a distribution group and a user to add to the group.
	If the -ApplyChanges switch is used, the change will be made.
.PARAMETER ApplyChanges
	Actually make the change.
.EXAMPLE
	.\Add-DLMember.ps1

	This will prompt for a distribution group and a user to add to the group, but will only
	display what would have been done without actually making the change.
.EXAMPLE
	.\Add-DLMember.ps1 -ApplyChanges

	This will prompt for a distribution group and a user to add to the group, and will actually
	make the change.
#>
[CmdletBinding()]
param (
	[parameter()][switch]$ApplyChanges
)
Import-Module ExchangeOnlineManagement

function Get-GridSelection {
	param (
		[parameter(Mandatory=$True)] $DataSet,
		[parameter(Mandatory=$True)][string] $Title,
		[parameter()][string][ValidateSet('Single','Multiple')] $OutputMode = 'Single'
	)
	if ($IsLinux) {
		if (Get-Module microsoft.powershell.consoleguitools -listavailable) {
			@($DataSet | Out-ConsoleGridView -Title $Title -OutputMode $OutputMode)
		} else {
			Write-Warning "Linux platforms require module: microsoft.powershell.consoleguitools"
		}
	} else {
		if (Get-Module microsoft.powershell.consoleguitools -listavailable) {
			@($DataSet | Out-ConsoleGridView -Title $Title -OutputMode $OutputMode)
		} else {
			@($DataSet | Out-GridView -Title $Title -OutputMode $OutputMode)
		}
	}
}

try {
	if (!(Get-ConnectionInformation)) {
		Connect-ExchangeOnline -ShowBanner:$false
	}

	[array]$mailUsers = Get-Recipient -ResultSize Unlimited -ErrorAction Stop |
		Where-Object {$_.RecipientType -in ("MailUser","UserMailbox")} |
			Select-Object -Property PrimarySmtpAddress, DisplayName, RecipientType, Name
	Write-Host "Found $($mailUsers.Count) mail users"

	[array]$dlGroups = Get-DistributionGroup -ResultSize Unlimited -ErrorAction Stop | Select-Object -Property DisplayName, Alias
	Write-Host "Found $($dlGroups.Count) distribution groups"

	$group = Get-GridSelection -DataSet $dlGroups -Title "Select a Distribution Group to add the user to"
	if ($group) {
		# filter out users who are already members of the selected distribution group
		$users = $mailUsers | Where-Object {$_.Name -notin (Get-DistributionGroupMember -Identity $group.Alias | Select-Object -ExpandProperty Name)}
		$user  = Get-GridSelection -DataSet $users -Title "Select a user to add to Distribution Group: $($group.DisplayName)"
		if ($user) {
			if ($ApplyChanges.IsPresent) {
				Add-DistributionGroupMember -Identity $group.Alias -Member $user.PrimarySmtpAddress -ErrorAction Stop
				Write-Host "Added $($user.PrimarySmtpAddress) to $($group.Alias)"
			} else {
				Write-Host "Would have added $($user.DisplayName) to $($group.Alias)"
			}
		}
	}
} catch {
	Write-Error $_.Exception.Message
}