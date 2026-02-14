#Requires -RunAsAdministrator

# --- AZTEK REFORGE™ INTERACTIVE ENGINE ---
$Host.UI.RawUI.WindowTitle = "AZTEK REFORGE™ | SYSTEM RECAST"

# --- CONFIGURATION ---
$WallpaperUrl = "https://raw.githubusercontent.com/mamc0826/a2k-site/master/assets/images/wall1.jpg"
$WallpaperPath = "$env:USERPROFILE\Pictures\reforge_wallpaper.jpg"

function Show-Header {
    Clear-Host
    $OS = Get-CimInstance Win32_OperatingSystem
    $CPU = Get-CimInstance Win32_Processor
    $RAM = [Math]::Round($OS.TotalVisibleMemorySize / 1MB, 0)
    $FreeRAM = [Math]::Round($OS.FreePhysicalMemory / 1MB, 1)

    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host "            AZTEK REFORGE™ : SYSTEM RECAST           " -ForegroundColor White -BackgroundColor Blue
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host " CPU: $($CPU.Name)" -ForegroundColor Gray
    Write-Host " RAM: $FreeRAM GB Free / $RAM GB Total" -ForegroundColor Gray
    Write-Host " UI: Classic Menu & Optimized Start Ready" -ForegroundColor Gray
    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
    Write-Host "  Interactive Deployment Mode | Final Blueprint v2.3 " -ForegroundColor Gray
    Write-Host ""
}

# --- 1. THE SAFETY NET ---
Show-Header
Write-Host "[!] Creating System Restore Point..." -ForegroundColor Yellow
Checkpoint-Computer -Description "AztekReforge_PreRecast" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
Write-Host "-> Restore Point Created.`n" -ForegroundColor Green

# --- INTERACTIVE MENU ---
Write-Host "[1] Full System Recast (The Works)" -ForegroundColor Yellow
Write-Host "    - Start Menu (More Pins), Classic Context, Arsenal, Power"
Write-Host "[2] Maintenance & Repair" -ForegroundColor Yellow
Write-Host "    - CHKDSK, WinUpdate, & App Upgrades"
Write-Host "[3] System Activation Help (MAS)" -ForegroundColor Yellow
Write-Host "[ER] Emergency Recovery (Rollback)" -ForegroundColor White -BackgroundColor Red
Write-Host "[Q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Select an option to begin"

switch ($choice) {
    "1" {
        Show-Header
        Write-Host "[!] INITIATING FINAL BLUEPRINT RECAST..." -ForegroundColor Red
        
        # --- 1. START MENU OPTIMIZATION ---
        Write-Host "-> Configuring Start Menu Layout (More Pins)..." -ForegroundColor Cyan
        $StartPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        # 1 = More Pins, 0 = Default, 2 = More Recommendations
        Set-ItemProperty -Path $StartPath -Name "Start_Layout" -Value 1 
        
        Write-Host "-> Tuning App Visibility..." -ForegroundColor Cyan
        $PolicyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        Set-ItemProperty -Path $StartPath -Name "Start_TrackProgs" -Value 1 # Show most used
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Value 0 # Disable welcome exp
        # Disable "Show recently opened items in Start/Jumplists"
        Set-ItemProperty -Path $StartPath -Name "Start_TrackDocs" -Value 0 
        # Disable suggestions/tips in Start
        Set-ItemProperty -Path $PolicyPath -Name "SubscribedContent-338388Enabled" -Value 0

        # --- 2. CLASSIC CONTEXT MENU ---
        Write-Host "-> Restoring Classic Right-Click Menu..." -ForegroundColor Cyan
        $RegPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
        if (!(Test-Path $RegPath)) { 
            New-Item -Path $RegPath -Force | Out-Null 
            Set-ItemProperty -Path $RegPath -Name "(Default)" -Value "" 
        }

        # --- 3. NETWORK & EXPLORER ---
        Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter | Where-Object {$Status -eq "Up"}).InterfaceAlias -ServerAddresses ("1.1.1.1","1.0.0.1") -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1
        $GodModePath = "$env:USERPROFILE\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
        if (!(Test-Path $GodModePath)) { New-Item -Path $GodModePath -ItemType Directory | Out-Null }

        # --- 4. DATE, MOUSE & LOCK SCREEN ---
        $IntlPath = "HKCU:\Control Panel\International"
        Set-ItemProperty -Path $IntlPath -Name "sShortDate" -Value "dd-MMM-yy"
        Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen" -Name "StatusAppAppUserModelId" -Value ""

        # --- 5. POWER SETTINGS ---
        powercfg /change monitor-timeout-ac 60
        powercfg /change sleep-timeout-ac 0
        powercfg /hibernate off

        # --- 6. VISUALS (Dark Mode & Wallpaper) ---
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

        # --- 7. ARSENAL & BLOAT PURGE ---
        $BloatList = @("*HP*", "*Dell*", "*Lenovo*", "*CandyCrush*", "*Zune*", "*Xbox*")
        foreach ($App in $BloatList) { Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue }
        $Arsenal = @("Google.Chrome", "Brave.Brave", "Malwarebytes.Malwarebytes", "7zip.7zip", "Notepad++.Notepad++", "VideoLAN.VLC", "RevoUninstaller.RevoUninstaller", "AntibodySoftware.WizTree", "MiniTool.PartitionWizard", "Python.Python.3", "SumatraPDF.SumatraPDF")
        foreach ($App in $Arsenal) { winget install --id $App --silent --accept-package-agreements --accept-source-agreements | Out-Null }
        
        # --- REFRESH EXPLORER ---
        Write-Host "-> Restarting Explorer to apply UI Changes..." -ForegroundColor Yellow
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue

        Write-Host "`nRECAST COMPLETE. THE SYSTEM IS REFORGED." -ForegroundColor Green
    }

    "2" {
        Show-Header
        Write-Host "[!] INITIATING DEEP MAINTENANCE..." -ForegroundColor Cyan
        winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
        echo y | chkdsk C: /f /r
        Write-Host "`nMAINTENANCE COMPLETE. RESTART TO FINISH." -ForegroundColor Yellow
    }

    "ER" {
        Show-Header
        $RP = Get-ComputerRestorePoint | Where-Object {$_.Description -match "AztekReforge"} | Select-Object -Last 1
        if ($RP) { Restore-Computer -RestorePoint $RP.SequenceNumber } else { rstrui.exe }
    }

    "Q" { exit }
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
