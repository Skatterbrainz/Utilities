$nac = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where {![string]::IsNullOrEmpty($_.DefaultIPGateway)}
$($nac).DefaultIPGateway
