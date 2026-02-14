#Requires -RunAsAdministrator

# --- A2K REFORGE™ : INTERACTIVE ENGINE ---
$Host.UI.RawUI.WindowTitle = "A2K REFORGE™ | SYSTEM RECAST"

# --- CONFIGURATION ---
$WallpaperUrl = "https://raw.githubusercontent.com/mamc0826/a2k-site/master/assets/images/wall1.jpg"
$WallpaperPath = "$env:USERPROFILE\Pictures\reforge_wallpaper.jpg"
$WebUrl = "https://a2k.lat"

function Show-Header {
    Clear-Host
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host "                A2K REFORGE™ : SYSTEM RECAST         " -ForegroundColor White -BackgroundColor Blue
    Write-Host "=====================================================" -ForegroundColor Cyan
    $OS = Get-CimInstance Win32_OperatingSystem
    Write-Host " CPU: $((Get-CimInstance Win32_Processor).Name)" -ForegroundColor Gray
    Write-Host " RAM: $([Math]::Round($OS.FreePhysicalMemory / 1MB, 1)) GB Free / $([Math]::Round($OS.TotalVisibleMemorySize / 1MB, 0)) GB Total" -ForegroundColor Gray
    Write-Host " Status: A2K GUARD Active (Contest Integrity Mode)" -ForegroundColor Green
    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
    Write-Host ""
}

Show-Header
Write-Host "[0] Create Restore Point (Manual)" -ForegroundColor Green
Write-Host "[1] Full System Recast (The Works)" -ForegroundColor Yellow
Write-Host "[2] Deep Maintenance (Winget, CHKDSK, Updates)" -ForegroundColor Yellow
Write-Host "[3] System Activation Help (MAS)" -ForegroundColor Yellow
Write-Host "[W] Visit A2K Portal (Web)" -ForegroundColor Cyan
Write-Host "[ER] Emergency Recovery (Rollback)" -ForegroundColor White -BackgroundColor Red
Write-Host "[Q] Exit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Input System Command"

switch ($choice) {
    "W" {
        # --- THANK YOU MESSAGE POPUP ---
        $msg = "Thank you for using A2K Reforge!`n`nConnecting you to the A2K Portal for more tools and updates."
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup($msg, 0, "A2K REFORGE", 64) | Out-Null
        
        Write-Host "Launching A2K Portal..." -ForegroundColor Cyan
        Start-Process $WebUrl
    }
    "0" {
        Show-Header
        Write-Host "Creating Safety Net..." -ForegroundColor Yellow
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "A2KReforge_Manual" -RestorePointType "MODIFY_SETTINGS"
        Write-Host "Restore Point Created." -ForegroundColor Green
    }
    "1" {
        Show-Header
        Write-Host "[!] INITIATING FULL RECAST..." -ForegroundColor Red
        
        # --- START MENU (More Pins) ---
        $StartPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        Set-ItemProperty -Path $StartPath -Name "Start_Layout" -Value 1 
        Set-ItemProperty -Path $StartPath -Name "Start_TrackProgs" -Value 1
        Set-ItemProperty -Path $StartPath -Name "Start_TrackDocs" -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0

        # --- CLASSIC CONTEXT MENU ---
        $RegPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
        if (!(Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null; Set-ItemProperty -Path $RegPath -Name "(Default)" -Value "" }

        # --- POWER & LOCK SCREEN ---
        powercfg /change monitor-timeout-ac 60
        powercfg /change sleep-timeout-ac 0
        powercfg /hibernate off
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen" -Name "StatusAppAppUserModelId" -Value ""
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Value 0

        # --- DNS & MOUSE ---
        Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter | Where-Object {$Status -eq "Up"}).InterfaceAlias -ServerAddresses ("1.1.1.1","1.0.0.1") -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"

        # --- VISUALS ---
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
        Invoke-WebRequest -Uri $WallpaperUrl -OutFile $WallpaperPath -ErrorAction SilentlyContinue
        $code = @'
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@
        Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
        [Wallpaper]::SystemParametersInfo(20, 0, $WallpaperPath, 3)

        # --- A2K ARSENAL ---
        Write-Host "-> Deploying A2K Arsenal..." -ForegroundColor Cyan
        $Arsenal = @(
            @{ID="Google.Chrome"; Desc="Standard web browser for platform access"},
            @{ID="Brave.Brave"; Desc="Privacy browser to eliminate tracking interference"},
            @{ID="Malwarebytes.Malwarebytes"; Desc="A2K Guard partner for anti-cheat environment stability"},
            @{ID="7zip.7zip"; Desc="Archive management for contest file submissions"},
            @{ID="Notepad++.Notepad++"; Desc="Advanced editor for checking contest scripts/logs"},
            @{ID="VideoLAN.VLC"; Desc="Verify video-based contest entries and proof"},
            @{ID="RevoUninstaller.RevoUninstaller"; Desc="Deep cleaner for removing stubborn apps"},
            @{ID="AntibodySoftware.WizTree"; Desc="Fastest disk space analyzer"},
            @{ID="MiniTool.PartitionWizard"; Desc="Hard drive & partition manager"},
            @{ID="Python.Python.3"; Desc="Required for A2K Guard verification algorithms"},
            @{ID="SumatraPDF.SumatraPDF"; Desc="Lightweight viewer for contest rules and terms"}
        )

        foreach ($App in $Arsenal) { 
            Write-Host "   Installing $($App.ID): $($App.Desc)..." -ForegroundColor Gray
            winget install --id $App.ID --silent --accept-package-agreements --accept-source-agreements | Out-Null 
        }
        
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Write-Host "A2K System Reforged and Fair-Play Optimized." -ForegroundColor Green
    }
    "2" {
        Show-Header
        Write-Host "-> Running System Maintenance..." -ForegroundColor Cyan
        winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
        echo y | chkdsk C: /f /r
        Write-Host "Maintenance Scheduled. Restart required for Disk Repair." -ForegroundColor Yellow
    }
    "ER" {
        $RP = Get-ComputerRestorePoint | Where-Object {$_.Description -match "A2KReforge"} | Select-Object -Last 1
        if ($RP) { Restore-Computer -RestorePoint $RP.SequenceNumber } else { rstrui.exe }
    }
    "Q" { exit }
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
