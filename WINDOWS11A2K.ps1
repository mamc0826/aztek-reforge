#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows 11 Fresh Install Auto-Setup Script
.DESCRIPTION
    Automates software installation, bloatware removal, and system configuration
.NOTES
    Run this script as Administrator
    Author: Custom Setup Script
    Date: 2026-02-05
#>

# ============================================================================
# CONFIGURATION
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Windows 11 Auto-Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# PART 1: SOFTWARE INSTALLATION USING WINGET
# ============================================================================

Write-Host "[1/3] Installing Software..." -ForegroundColor Yellow
Write-Host ""

# List of programs to install with their winget IDs
$programs = @(
    @{Name="Google Chrome"; ID="Google.Chrome"},
    @{Name="Mozilla Firefox"; ID="Mozilla.Firefox"},
    @{Name="Brave Browser"; ID="Brave.Brave"},
    @{Name="7-Zip"; ID="7zip.7zip"},
    @{Name="BCUninstaller"; ID="Klocman.BulkCrapUninstaller"},
    @{Name="Revo Uninstaller"; ID="RevoUninstaller.RevoUninstaller"},
    @{Name="EarTrumpet"; ID="File-New-Project.EarTrumpet"},
    @{Name="HandBrake"; ID="HandBrake.HandBrake"},
    @{Name="MicMute"; ID="CADbloke.MicMute"},
    @{Name="MiniTool Partition Wizard Free"; ID="MiniTool.PartitionWizard.Free"},
    @{Name="Notepad++"; ID="Notepad++.Notepad++"},
    @{Name="PotPlayer"; ID="Daum.PotPlayer"},
    @{Name="Python 3.14"; ID="Python.Python.3.14"},
    @{Name="Rufus"; ID="Rufus.Rufus"},
    @{Name="WizTree"; ID="AntibodySoftware.WizTree"},
    @{Name="Chrome Remote Desktop"; ID="Google.ChromeRemoteDesktop"},
    @{Name="GGPoker"; ID="GGPoker.GGPoker"},
    @{Name="Scrcpy"; ID="Genymobile.scrcpy"},
    @{Name="Grub2Win"; ID="Grub2Win.Grub2Win"},
    @{Name="VLC Media Player"; ID="VideoLAN.VLC"},
    @{Name="YouTube Music Desktop App"; ID="th-ch.YouTubeMusic"},
    @{Name="VMware Workstation Pro"; ID="VMware.WorkstationPro"},
    @{Name="Sumatra PDF"; ID="SumatraPDF.SumatraPDF"},
    @{Name="Android SDK Platform Tools"; ID="Google.PlatformTools"}
    # Note: Office Tool Plus, UI.Vision XModule, Simp Music, SFWTool, and Universal ADB Driver may need manual installation
)

foreach ($program in $programs) {
    Write-Host "Installing $($program.Name)..." -ForegroundColor Green
    try {
        winget install --id $program.ID --silent --accept-package-agreements --accept-source-agreements
        Write-Host "  ✓ $($program.Name) installed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Failed to install $($program.Name)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "NOTE: The following may require manual installation:" -ForegroundColor Yellow
Write-Host "  - Office Tool Plus (https://otp.landian.vip/)" -ForegroundColor Yellow
Write-Host "  - UI.Vision XModule (https://ui.vision/)" -ForegroundColor Yellow
Write-Host "  - Simp Music (https://github.com/Simp-Music/Simp-Music)" -ForegroundColor Yellow
Write-Host "  - SFWTool (https://github.com/SFW-FreeDevelopment/SFWTool)" -ForegroundColor Yellow
Write-Host "  - Universal ADB Driver (https://adb.clockworkmod.com/)" -ForegroundColor Yellow
Write-Host ""

# ============================================================================
# PART 2: REMOVE BLOATWARE
# ============================================================================

Write-Host "[2/3] Removing Bloatware..." -ForegroundColor Yellow
Write-Host ""

# List of bloatware to remove
$bloatware = @(
    # Xbox apps
    "Microsoft.GamingApp",
    "Microsoft.XboxApp",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    
    # Games
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    
    # Microsoft 365
    "Microsoft.Office.OneNote",
    "Microsoft.MicrosoftOfficeHub",
    
    # Teams
    "MicrosoftTeams",
    "Microsoft.Teams"
)

foreach ($app in $bloatware) {
    Write-Host "Removing $app..." -ForegroundColor Green
    try {
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        Write-Host "  ✓ $app removed" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Could not remove $app (may not be installed)" -ForegroundColor Yellow
    }
}

Write-Host ""

# ============================================================================
# PART 3: WINDOWS CONFIGURATION
# ============================================================================

Write-Host "[3/3] Configuring Windows Settings..." -ForegroundColor Yellow
Write-Host ""

# Enable Dark Mode
Write-Host "Enabling Dark Mode..." -ForegroundColor Green
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord -Force

# Disable Transparency Effects
Write-Host "Disabling Transparency Effects..." -ForegroundColor Green
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord -Force

# Set "No Sounds" audio scheme
Write-Host "Setting audio scheme to 'No Sounds'..." -ForegroundColor Green
# Set the current scheme to .None (No Sounds)
Set-ItemProperty -Path "HKCU:\AppEvents\Schemes" -Name "(Default)" -Value ".None" -Type String -Force
# Apply no sounds to all events
$soundEvents = Get-ChildItem -Path "HKCU:\AppEvents\Schemes\Apps\*\*\.Current"
foreach ($event in $soundEvents) {
    Set-ItemProperty -Path $event.PSPath -Name "(Default)" -Value "" -Type String -Force
}

# Show File Extensions
Write-Host "Showing file extensions..." -ForegroundColor Green
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Type DWord -Force

# Show Hidden Files
Write-Host "Showing hidden files..." -ForegroundColor Green
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Type DWord -Force

# Disable Telemetry
Write-Host "Disabling Telemetry..." -ForegroundColor Green
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Disable Cortana
Write-Host "Disabling Cortana..." -ForegroundColor Green
If (!(Test-Path "HKCU:\Software\Microsoft\Personalization\Settings")) {
    New-Item -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 0 -Type DWord -Force
If (!(Test-Path "HKCU:\Software\Microsoft\InputPersonalization")) {
    New-Item -Path "HKCU:\Software\Microsoft\InputPersonalization" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1 -Type DWord -Force
If (!(Test-Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore")) {
    New-Item -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 0 -Type DWord -Force

# Remove Search Box from Taskbar (Show icon only)
Write-Host "Configuring Taskbar Search..." -ForegroundColor Green
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type DWord -Force

# Hide People icon from Taskbar
Write-Host "Hiding People icon from Taskbar..." -ForegroundColor Green
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Value 0 -Type DWord -Force

# Set Chrome as Default Browser (requires Chrome to be installed first)
Write-Host "Setting Chrome as default browser (will apply after restart)..." -ForegroundColor Green
# Note: This requires user interaction in Windows 11 due to restrictions
# The script will attempt to set associations, but user may need to confirm
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    Start-Process $chromePath -ArgumentList "--make-default-browser" -Wait -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "NOTE: Windows 11 requires manual confirmation to set default browser." -ForegroundColor Yellow
Write-Host "Please open Settings > Apps > Default apps and set Chrome manually." -ForegroundColor Yellow
Write-Host ""

# ============================================================================
# COMPLETION
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer for all changes to take effect" -ForegroundColor White
Write-Host "2. Manually install Office Tool Plus, UI.Vision XModule, Simp Music, SFWTool, and Universal ADB Driver" -ForegroundColor White
Write-Host "3. Set Chrome as default browser in Settings > Apps > Default apps" -ForegroundColor White
Write-Host "4. Check that all programs installed correctly" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
