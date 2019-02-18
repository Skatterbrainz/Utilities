function ConvertTo-HtmlPivot {
    <#
    .SYNOPSIS
        Convert Hashtable structure to vertical HTML table format
    .DESCRIPTION
        Convert Hashtable structure to vertical HTML table format. Yes, I said it twice
    .PARAMETER InputObject
        Hashtable object which will be converted to a vertical table format
    .EXAMPLE 
        Get-WmiObject -Class Win32_OperatingSystem | 
            Select Caption,BuildNumber,Version,SystemDirectory,RegisteredUser,InstallDate | 
                ConvertTo-HtmlPivot
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNull()]
        $InputObject
    )
    try {
        $columns = $InputObject.psobject.Properties.Name
        $output = "<table>"
        foreach ($col in $columns) {
            $val = $InputObject.psobject.Properties.Item($col).Value 
            $output += "<tr><td>$col</td><td>$val</td></tr>"
        }
        $output += "</table>"
    }
    catch {}
    Write-Output $output
}
