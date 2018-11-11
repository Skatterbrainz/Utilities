$icon = "<path>\<filename>.ico"

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$FrmMain = New-Object System.Windows.Forms.Form
$FrmMain.Text = "My Title"
$FrmMain.Size = New-Object System.Drawing.Size(600,400) 
$FrmMain.StartPosition = "CenterScreen"
$FrmMain.Icon = $icon
[void] $FrmMain.ShowDialog()
