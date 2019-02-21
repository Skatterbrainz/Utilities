function Remove-TurboDoucheware {
    [CmdletBinding(SupportsShouldProcess=$True)]
    param()
    try {
        Write-Host "getting provisioned doucheware..." -ForegroundColor Cyan
        $apps = @(Get-AppxProvisionedPackage -Online | 
            Select DisplayName,PackageName | 
                Sort-Object DisplayName | 
                    Out-GridView -Title "Select Provisioned Douche to Undouche" -OutputMode Multiple)
        if ($apps.Count -gt 0) {
            $apps | % { 
                Remove-AppxProvisionedPackage -PackageName $_.PackageName -AllUsers -Online -ErrorAction SilentlyContinue | Out-Null
                Write-Host "removed: $($_.DisplayName)" -ForegroundColor Cyan
            }
        }
    }
    catch {
        Write-Error $Error[0].Exception.Message
    }
    Write-Host "getting user doucheware..." -ForegroundColor Cyan
    try {
        $apps = @(Get-AppxPackage | 
            Select Name,PackageFullName,Status | 
                Sort-Object Name | 
                    Out-GridView -Title "Select User Douche to Undouche" -OutputMode Multiple)
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
