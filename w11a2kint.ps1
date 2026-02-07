#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows 11 Fresh Install Auto-Setup Script (Interactive Menu Version)
.DESCRIPTION
    Automates software installation, bloatware removal, and system configuration with interactive menu
.NOTES
    Run this script as Administrator
    Author: Custom Setup Script
    Date: 2026-02-05
#>

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Show-Header {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Windows 11 Auto-Setup Script" -ForegroundColor Cyan
    Write-Host "Interactive Menu Edition" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    Show-Header
    Write-Host "Please choose an option:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. RUN EVERYTHING (Recommended - Install all, remove bloatware, configure settings)" -ForegroundColor Green
    Write-Host "  2. Quick Start with Confirmation (Review summary before proceeding)" -ForegroundColor Cyan
    Write-Host "  3. Custom Installation (Choose what to install/configure)" -ForegroundColor Magenta
    Write-Host "  4. Exit" -ForegroundColor Red
    Write-Host ""
    Write-Host -NoNewline "Enter your choice (1-4): " -ForegroundColor White
}

function Get-YesNo {
    param([string]$Question)
    Write-Host ""
    Write-Host -NoNewline "$Question (Y/N): " -ForegroundColor Yellow
    $response = Read-Host
    return $response -eq 'Y' -or $response -eq 'y'
}

function Show-Summary {
    param(
        [bool]$InstallSoftware,
        [bool]$RemoveBloatware,
        [bool]$ConfigureSettings
    )
    
    Show-Header
    Write-Host "=== INSTALLATION SUMMARY ===" -ForegroundColor Cyan
    Write-Host ""
    
    if ($InstallSoftware) {
        Write-Host "✓ Software Installation: ENABLED" -ForegroundColor Green
        Write-Host "  - 27 programs will be installed via winget" -ForegroundColor Gray
        Write-Host "  - Browsers: Chrome, Firefox, Brave" -ForegroundColor Gray
        Write-Host "  - Dev Tools: Python, Android SDK, Scrcpy" -ForegroundColor Gray
        Write-Host "  - Media: VLC, PotPlayer, YouTube Music" -ForegroundColor Gray
        Write-Host "  - And more..." -ForegroundColor Gray
    } else {
        Write-Host "✗ Software Installation: DISABLED" -ForegroundColor Red
    }
    
    Write-Host ""
    
    if ($RemoveBloatware) {
        Write-Host "✓ Bloatware Removal: ENABLED" -ForegroundColor Green
        Write-Host "  - Xbox apps, Games, Teams, Office Hub" -ForegroundColor Gray
    } else {
        Write-Host "✗ Bloatware Removal: DISABLED" -ForegroundColor Red
    }
    
    Write-Host ""
    
    if ($ConfigureSettings) {
        Write-Host "✓ Windows Configuration: ENABLED" -ForegroundColor Green
        Write-Host "  - Dark mode, disable transparency" -ForegroundColor Gray
        Write-Host "  - Show file extensions & hidden files" -ForegroundColor Gray
        Write-Host "  - Disable telemetry & Cortana" -ForegroundColor Gray
        Write-Host "  - Configure taskbar & audio" -ForegroundColor Gray
    } else {
        Write-Host "✗ Windows Configuration: DISABLED" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
}

# ============================================================================
# PROGRAM CATEGORIES
# ============================================================================

$allPrograms = @{
    Browsers = @(
        @{Name="Google Chrome"; ID="Google.Chrome"},
        @{Name="Mozilla Firefox"; ID="Mozilla.Firefox"},
        @{Name="Brave Browser"; ID="Brave.Brave"}
    )
    Utilities = @(
        @{Name="7-Zip"; ID="7zip.7zip"},
        @{Name="BCUninstaller"; ID="Klocman.BulkCrapUninstaller"},
        @{Name="Revo Uninstaller"; ID="RevoUninstaller.RevoUninstaller"},
        @{Name="EarTrumpet"; ID="File-New-Project.EarTrumpet"},
        @{Name="MicMute"; ID="CADbloke.MicMute"},
        @{Name="Notepad++"; ID="Notepad++.Notepad++"},
        @{Name="Rufus"; ID="Rufus.Rufus"},
        @{Name="WizTree"; ID="AntibodySoftware.WizTree"},
        @{Name="Sumatra PDF"; ID="SumatraPDF.SumatraPDF"},
        @{Name="Grub2Win"; ID="Grub2Win.Grub2Win"},
        @{Name="MiniTool Partition Wizard Free"; ID="MiniTool.PartitionWizard.Free"}
    )
    Media = @(
        @{Name="PotPlayer"; ID="Daum.PotPlayer"},
        @{Name="VLC Media Player"; ID="VideoLAN.VLC"},
        @{Name="YouTube Music Desktop App"; ID="th-ch.YouTubeMusic"},
        @{Name="HandBrake"; ID="HandBrake.HandBrake"}
    )
    Development = @(
        @{Name="Python 3.14"; ID="Python.Python.3.14"},
        @{Name="Scrcpy"; ID="Genymobile.scrcpy"},
        @{Name="Android SDK Platform Tools"; ID="Google.PlatformTools"}
    )
    RemoteAndVirtualization = @(
        @{Name="Chrome Remote Desktop"; ID="Google.ChromeRemoteDesktop"},
        @{Name="VMware Workstation Pro"; ID="VMware.WorkstationPro"}
    )
    Gaming = @(
        @{Name="GGPoker"; ID="GGPoker.GGPoker"}
    )
}

# ============================================================================
# MAIN MENU LOGIC
# ============================================================================

Show-Menu
$choice = Read-Host

switch ($choice) {
    "1" {
        # RUN EVERYTHING
        Show-Header
        Write-Host "🚀 RUN EVERYTHING MODE" -ForegroundColor Green
        Write-Host ""
        Write-Host "This will:" -ForegroundColor Yellow
        Write-Host "  ✓ Install ALL programs" -ForegroundColor White
        Write-Host "  ✓ Remove ALL bloatware" -ForegroundColor White
        Write-Host "  ✓ Apply ALL Windows configurations" -ForegroundColor White
        Write-Host ""
        Write-Host "Estimated time: 20-40 minutes" -ForegroundColor Gray
        
        if (Get-YesNo "Proceed with full installation?") {
            $installSoftware = $true
            $removeBloatware = $true
            $configureSettings = $true
            $selectedPrograms = @()
            foreach ($category in $allPrograms.Keys) {
                $selectedPrograms += $allPrograms[$category]
            }
        } else {
            Write-Host "Installation cancelled." -ForegroundColor Red
            exit
        }
    }
    
    "2" {
        # QUICK START WITH CONFIRMATION
        $installSoftware = $true
        $removeBloatware = $true
        $configureSettings = $true
        $selectedPrograms = @()
        foreach ($category in $allPrograms.Keys) {
            $selectedPrograms += $allPrograms[$category]
        }
        
        Show-Summary -InstallSoftware $installSoftware -RemoveBloatware $removeBloatware -ConfigureSettings $configureSettings
        
        if (-not (Get-YesNo "Do you want to proceed with this configuration?")) {
            Write-Host "Installation cancelled." -ForegroundColor Red
            exit
        }
    }
    
    "3" {
        # CUSTOM INSTALLATION
        Show-Header
        Write-Host "🎨 CUSTOM INSTALLATION MODE" -ForegroundColor Magenta
        Write-Host ""
        
        # Ask about each component
        $installSoftware = Get-YesNo "Install software?"
        
        if ($installSoftware) {
            Write-Host ""
            Write-Host "Select program categories to install:" -ForegroundColor Yellow
            Write-Host ""
            
            $selectedPrograms = @()
            
            foreach ($category in $allPrograms.Keys) {
                Write-Host "  Category: $category ($($allPrograms[$category].Count) programs)" -ForegroundColor Cyan
                if (Get-YesNo "    Install $category") {
                    $selectedPrograms += $allPrograms[$category]
                }
            }
        } else {
            $selectedPrograms = @()
        }
        
        $removeBloatware = Get-YesNo "Remove bloatware?"
        $configureSettings = Get-YesNo "Configure Windows settings?"
        
        # Show final summary
        Show-Summary -InstallSoftware $installSoftware -RemoveBloatware $removeBloatware -ConfigureSettings $configureSettings
        
        if (-not (Get-YesNo "Proceed with this configuration?")) {
            Write-Host "Installation cancelled." -ForegroundColor Red
            exit
        }
    }
    
    "4" {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit
    }
    
    default {
        Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
        exit
    }
}

# ============================================================================
# EXECUTION PHASE
# ============================================================================

Show-Header
Write-Host "Starting installation..." -ForegroundColor Green
Write-Host ""

# ============================================================================
# PART 1: SOFTWARE INSTALLATION
# ============================================================================

if ($installSoftware -and $selectedPrograms.Count -gt 0) {
    Write-Host "[1/3] Installing Software..." -ForegroundColor Yellow
    Write-Host "Total programs to install: $($selectedPrograms.Count)" -ForegroundColor Gray
    Write-Host ""
    
    $installed = 0
    foreach ($program in $selectedPrograms) {
        $installed++
        Write-Host "[$installed/$($selectedPrograms.Count)] Installing $($program.Name)..." -ForegroundColor Green
        try {
            winget install --id $program.ID --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
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
} else {
    Write-Host "[1/3] Software Installation: SKIPPED" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# PART 2: REMOVE BLOATWARE
# ============================================================================

if ($removeBloatware) {
    Write-Host "[2/3] Removing Bloatware..." -ForegroundColor Yellow
    Write-Host ""
    
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
} else {
    Write-Host "[2/3] Bloatware Removal: SKIPPED" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# PART 3: WINDOWS CONFIGURATION
# ============================================================================

if ($configureSettings) {
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
    Set-ItemProperty -Path "HKCU:\AppEvents\Schemes" -Name "(Default)" -Value ".None" -Type String -Force
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
    $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    if (Test-Path $chromePath) {
        Start-Process $chromePath -ArgumentList "--make-default-browser" -Wait -ErrorAction SilentlyContinue
    }
    
    Write-Host ""
    Write-Host "NOTE: Windows 11 requires manual confirmation to set default browser." -ForegroundColor Yellow
    Write-Host "Please open Settings > Apps > Default apps and set Chrome manually." -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "[3/3] Windows Configuration: SKIPPED" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# COMPLETION
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer for all changes to take effect" -ForegroundColor White
if ($installSoftware) {
    Write-Host "2. Manually install Office Tool Plus, UI.Vision XModule, Simp Music, SFWTool, and Universal ADB Driver" -ForegroundColor White
    Write-Host "3. Set Chrome as default browser in Settings > Apps > Default apps" -ForegroundColor White
    Write-Host "4. Check that all programs installed correctly" -ForegroundColor White
}
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
