function ConvertTo-HtmlPivot {
    <#
    .SYNOPSIS
        Convert Hashtable structure to vertical HTML table format
    .DESCRIPTION
        Convert Hashtable structure to vertical HTML table format. Yes, I said it twice
    .PARAMETER InputObject
        Hashtable object which will be converted to a vertical table format
    .PARAMETER DivID
        Optional Div style identifier
    .EXAMPLE 
        Get-WmiObject -Class Win32_OperatingSystem | 
            Select Caption,BuildNumber,Version,SystemDirectory,RegisteredUser,InstallDate | 
                ConvertTo-HtmlPivot
    .EXAMPLE
        Get-WmiObject -Class Win32_OperatingSystem | 
            Select Caption,BuildNumber,Version,SystemDirectory,RegisteredUser,InstallDate | 
                ConvertTo-HtmlPivot -DivID "table3"
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNull()]
        $InputObject,
        [parameter(Mandatory=$False)]
        [string] $DivID = ""
    )
    try {
        $columns = $InputObject.psobject.Properties.Name
        if ($DivID -ne "") {
            $output = "<table div=`"$DivID`">"
        }
        else {
            $output = "<table>"
        }
        foreach ($col in $columns) {
            $val = $InputObject.psobject.Properties.Item($col).Value 
            $output += "<tr><td>$col</td><td>$val</td></tr>"
        }
        $output += "</table>"
    }
    catch {}
    Write-Output $output
}
