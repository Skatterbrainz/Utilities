function Remove-Doucheware {
    [CmdletBinding(SupportsShouldProcess=$True)]
    param ()
    try {
        $apps = @(Get-AppxPackage | 
            Select Name,PackageFullName,Status | 
                Sort-Object Name | 
                    Out-GridView -Title "Select Doucheware to Undouche" -OutputMode Multiple)
        if ($apps.Count -gt 0) {
            $apps | Select-Object -ExpandProperty PackageFullName | % {
                Write-Verbose "removing: $_"
                Remove-AppxPackage -Package $_ -AllUsers -Confirm:$False -ErrorAction SilentlyContinue
                Write-Host "undouched: $_" -ForegroundColor Cyan 
            }
        }
    }
    catch {
        $errmsg = $Error[0].Exception.Message
        if ($errmsg -match '0x80070032') {
            Write-Warning "This Appx doucheware cannot be undouched because it has been super-douched"
        }
        else {
            Write-Error $errmsg
        }
    }
}
