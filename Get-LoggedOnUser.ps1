function Get-LoggedOnUser {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $ComputerName
    ) 
    try {
        $regexa = '.+Domain="(.+)",Name="(.+)"$' 
        $regexd = '.+LogonId="(\d+)"$'
        $logontype = @{ 
            "0"="Local System" 
            "2"="Interactive" #(Local logon) 
            "3"="Network" # (Remote logon) 
            "4"="Batch" # (Scheduled task) 
            "5"="Service" # (Service account logon) 
            "7"="Unlock" #(Screen saver) 
            "8"="NetworkCleartext" # (Cleartext network logon) 
            "9"="NewCredentials" #(RunAs using alternate credentials) 
            "10"="RemoteInteractive" #(RDP\TS\RemoteAssistance) 
            "11"="CachedInteractive" #(Local w\cached credentials) 
        }
        $logon_sessions = @(Get-WmiObject Win32_LogonSession -ComputerName $ComputerName -ErrorAction SilentlyContinue) 
        $logon_users    = @(Get-WmiObject Win32_LoggedOnUser -ComputerName $ComputerName -ErrorAction SilentlyContinue) 
        $session_user = @{}
        $logon_users |% { 
            $_.antecedent -match $regexa > $nul 
            $username = $matches[1] + "\" + $matches[2] 
            $_.dependent -match $regexd > $nul 
            $session = $matches[1] 
            $session_user[$session] += $username 
        }
        $logon_sessions | ForEach-Object { 
            $starttime = [Management.ManagementDateTimeConverter]::ToDateTime($_.StartTime)
            $props = [ordered]@{
                Session = $_.logonid
                User    = $session_user[$_.logonid] 
                Type    = $logontype[$_.logontype.ToString()]
                Auth    = $_.authenticationpackage
                StartTime = $starttime
            }
            New-Object PSObject -Property $props
        }
    }
    catch {}
}
