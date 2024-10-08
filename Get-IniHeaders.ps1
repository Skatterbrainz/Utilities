function Get-IniHeaders {
	param (
		[parameter(Mandatory = $True, ValueFromPipeline = $True, HelpMessage = "Text Stream Value")]
		[ValidateNotNullOrEmpty()]
		[string] $Content,
		[parameter(Mandatory = $False, HelpMessage = "Remove brackets within returned values")]
		[switch] $NoBrackets
	)
	if (!$NoBrackets) {
		$Content.Split([Environment]::NewLine) | Where-Object { $_.StartsWith('[') }
	} else {
		$Content.Split([Environment]::NewLine) | Where-Object { $_.StartsWith('[') } | ForEach-Object { ($_.Replace('[', '')).Replace(']', '') }
	}
}
