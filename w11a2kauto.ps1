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
    Write-Host " Date: $(Get-Date -Format "dd-MMM-yy") | Time: $(Get-Date -Format "HH:mm tt")" -ForegroundColor Gray
    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
    Write-Host "  Interactive Deployment Mode | Sentinel's Choice v2.4" -ForegroundColor Gray
    Write-Host ""
}

# --- INITIAL HEADER ---
Show-Header

# --- INTERACTIVE MENU ---
Write-Host "[0] Create System Restore Point (Recommended First)" -ForegroundColor Green
Write-Host "[1] Full System Recast (The Works)" -ForegroundColor Yellow
Write-Host "    - Start Menu, Classic Context, Visuals, Arsenal, Power"
Write-Host "[2] Maintenance & Repair (CHKDSK, WinUpdate, Winget)" -ForegroundColor Yellow
Write-Host "[3] System Activation Help (MAS)" -ForegroundColor Yellow
Write-Host "[ER] Emergency Recovery (Rollback)" -ForegroundColor White -BackgroundColor Red
Write-Host "[Q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Select an option to begin"

switch ($choice) {
    "0" {
        Show-Header
        Write-Host "[!] INITIATING RESTORE POINT CREATION..." -ForegroundColor Yellow
        # Ensure System Restore is enabled on C:
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        # Create the checkpoint
        Checkpoint-Computer -Description "AztekReforge_Manual" -RestorePointType "MODIFY_SETTINGS"
        Write-Host "-> Restore Point 'AztekReforge_Manual' created successfully." -ForegroundColor Green
    }

    "1" {
        Show-Header
        Write-Host "[!] INITIATING FINAL BLUEPRINT RECAST..." -ForegroundColor Red
        
        # --- 1. START MENU & UI ---
        $StartPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        Set-ItemProperty -Path $StartPath -Name "Start_Layout" -Value 1 
        Set-ItemProperty -Path $StartPath -Name "Start_TrackProgs" -Value 1
        Set-ItemProperty -Path $StartPath -Name "Start_TrackDocs" -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0

        # --- 2. CLASSIC CONTEXT MENU ---
        $RegPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
        if (!(Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null; Set-ItemProperty -Path $RegPath -Name "(Default)" -Value "" }

        # --- 3. DATE, MOUSE & LOCK SCREEN ---
        Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value "dd-MMM-yy"
        Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen" -Name "StatusAppAppUserModelId" -Value ""

        # --- 4. NETWORK & POWER ---
        Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter | Where-Object {$Status -eq "Up"}).InterfaceAlias -ServerAddresses ("1.1.1.1","1.0.0.1") -ErrorAction SilentlyContinue
        powercfg /change monitor-timeout-ac 60
        powercfg /change sleep-timeout-ac 0
        powercfg /hibernate off

        # --- 5. VISUALS ---
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

        # --- 6. ARSENAL & BLOAT ---
        $BloatList = @("*HP*", "*Dell*", "*Lenovo*", "*CandyCrush*", "*Xbox*")
        foreach ($App in $BloatList) { Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue }
        $Arsenal = @("Google.Chrome", "Brave.Brave", "Malwarebytes.Malwarebytes", "7zip.7zip", "Notepad++.Notepad++", "VideoLAN.VLC", "RevoUninstaller.RevoUninstaller", "AntibodySoftware.WizTree")
        foreach ($App in $Arsenal) { winget install --id $App --silent --accept-package-agreements --accept-source-agreements | Out-Null }
        
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Write-Host "`nRECAST COMPLETE." -ForegroundColor Green
    }

    "2" {
        Show-Header
        Write-Host "[!] MAINTENANCE MODE..." -ForegroundColor Cyan
        winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
        echo y | chkdsk C: /f /r
        Write-Host "`nRESTART TO FINISH REPAIRS." -ForegroundColor Yellow
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
