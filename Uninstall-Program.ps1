<#
.SYNOPSIS
	Remove (uninstall) a program via the WMI interface on a remote system
	
.DESCRIPTION
	Uninstall-Program.ps1 uninstalls a program from a remote system
	
.PARAMETER ComputerName
	[string] NetBIOS name of remote computer

.PARAMETER Progra,
	[string] name of application to uninstall

.PARAMETER ListOnly
	[switch] returns WMI table of installed program (product) names
#>


param (
	[parameter(Mandatory=$True)] [string] $ComputerName,
	[parameter(Mandatory=$False)] [string] $Program,
	[parameter(Mandatory=$False)] [switch] $ListOnly
)
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$ask = [Microsoft.VisualBasic.Interaction]::InputBox("Would you like to query $computer to see installed applications? Enter yes to search", "Search")

if ($ListOnly) {
	Get-WmiObject -Namespace "root\cimv2" -Class Win32_Product -Impersonation 3 -ComputerName $ComputerName
}
else {
	$app = Get-WmiObject -Class Win32_Product -ComputerName $ComputerName | Where-Object {$_.Name -match “$program”}
	$app.Uninstall()
}
