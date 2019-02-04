function New-ProductName {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True, HelpMessage="Vendor OS Platform")]
        [ValidateSet('Linux','MacOS','Windows','UNIX')]
        [string] $Platform,
        [parameter(Mandatory=$True, HelpMessage="Primary Market")]
        [ValidateSet('Business','Consumer','Education','Government')]
        [string] $Category,
        [parameter(Mandatory=$True, HelpMessage="Product Description")]
        [ValidateNotNullOrEmpty()]
        [string] $Description
    )
    $chunks = ""
    switch ($Platform) {
        'Linux' {
            $vendor = 'Ubuntu'
            $chunks = ('Albatross','Blustering Beaver','Dancing Duck','Eager Egglplant','Hilarious HouseFly','Ostentatious Otter','Whale','Zebra')
            $ver    = "0.0.1"
            $desc   = ""
            break;
        }
        'MacOS' {
            $vendor = 'Apple'
            $chunks = ('Clear Creek','Snow Mountain','Red Wolf','Cold River','Deep Canyon','Leopard Paw','Tiger Breath')
            $ver    = "1.0.0"
            $desc   = ""
            break;
        }
        'Windows' {
            $vendor = 'Microsoft'
            $chunks = ('365','Active','Live','One','Visual')
            $ver    = "1902.03.1 Build 1902 release 190119-1759"
            $desc   = $Description
            break;
        }
        'UNIX' {
            $vendor = 'IBM'
            $chunks = ('X14','Warp','Z45','0.0.0111.e','FSAR','DSAR','MPK','ZFT','0.0.0.1')
            $ver    = "0.0.0.1 a (19.0.00.01.a.1.0.11)"
            $desc   = ""
            break;
        }
        default {
            break;
        }
    }
    $output = "$vendor $($chunks | Get-Random) $desc $ver"
    Write-Output $output
}
