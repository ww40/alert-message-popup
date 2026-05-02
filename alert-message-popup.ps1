#██     ██ ███████ ██████  ██████   ██████ 
#██     ██ ██      ██   ██ ██   ██ ██    ██
#██  █  ██ █████   ██████  ██████  ██    ██
#██ ███ ██ ██      ██   ██ ██   ██ ██    ██
 #███ ███  ███████ ██████  ██████   ██████ 



Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Track last mouse position
$lastPos = [System.Windows.Forms.Cursor]::Position
$shown = $false

while ($true) {
    Start-Sleep -Milliseconds 100

    $currentPos = [System.Windows.Forms.Cursor]::Position

    if (($currentPos.X -ne $lastPos.X -or $currentPos.Y -ne $lastPos.Y) -and -not $shown) {

        $shown = $true

        # Create form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Reboot Reminder"
        $form.Size = New-Object System.Drawing.Size(350,200)
        $form.StartPosition = "CenterScreen"

        # Always on top
        $form.TopMost = $true
        $form.FormBorderStyle = 'FixedDialog'
        $form.ControlBox = $false
        $form.ShowInTaskbar = $false

        # Label
        $label = New-Object System.Windows.Forms.Label
        $label.Text = "Reboot your damn PC!"
        $label.AutoSize = $true
        $label.Location = New-Object System.Drawing.Point(80,30)

        # OK Button
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Text = "OK"
        $okButton.Size = New-Object System.Drawing.Size(80,30)
        $okButton.Location = New-Object System.Drawing.Point(60,80)
        $okButton.Add_Click({ $form.Close() })

        # Reboot Button
        $rebootButton = New-Object System.Windows.Forms.Button
        $rebootButton.Text = "Sorry, reboot now"
        $rebootButton.Size = New-Object System.Drawing.Size(160,60)
        $rebootButton.Location = New-Object System.Drawing.Point(160,80)
        $rebootButton.Add_Click({
            $form.Close()
            Restart-Computer   # safe reboot (no -Force)
        })

        $form.Controls.Add($label)
        $form.Controls.Add($okButton)
        $form.Controls.Add($rebootButton)

        # Force focus
        $form.Add_Shown({
            $form.Activate()
            $form.TopMost = $true
        })

        $form.ShowDialog() | Out-Null
    }

    $lastPos = $currentPos
}