#Requires -RunAsAdministrator

# --- AZTEK REFORGE™ INTERACTIVE ENGINE ---
$Host.UI.RawUI.WindowTitle = "AZTEK REFORGE™ | SYSTEM RECAST"

# --- CONFIGURATION ---
$WallpaperUrl = "https://raw.githubusercontent.com/mamc0826/a2k-site/master/assets/images/wall1.jpg"
$WallpaperPath = "$env:USERPROFILE\Pictures\reforge_wallpaper.jpg"

function Show-Header {
    Clear-Host
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host "            AZTEK REFORGE™ : SYSTEM RECAST           " -ForegroundColor White -BackgroundColor Blue
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host "  Interactive Deployment Mode | Visual Overhaul v1.4 " -ForegroundColor Gray
    Write-Host ""
}

# --- 1. THE SAFETY NET ---
Show-Header
Write-Host "[!] Creating System Restore Point..." -ForegroundColor Yellow
Checkpoint-Computer -Description "Before Aztek Reforge Recast" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
Write-Host "-> Restore Point Checked.`n" -ForegroundColor Green

# --- INTERACTIVE MENU ---
Write-Host "[1] Full System Recast (Recommended)" -ForegroundColor Yellow
Write-Host "    - Dark Mode, Wall1 Wallpaper, Debloat, & Performance"
Write-Host "[2] Visual Overhaul Only" -ForegroundColor Yellow
Write-Host "    - Dark Mode & Wall1 Wallpaper"
Write-Host "[3] System Cleanup & Network" -ForegroundColor Yellow
Write-Host "[Q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Select an option to begin"

switch ($choice) {
    "1" {
        Show-Header
        Write-Host "[!] INITIATING FULL SYSTEM RECAST..." -ForegroundColor Red
        
        # --- DARK MODE ACTIVATION ---
        Write-Host "-> Enabling System-Wide Dark Mode..." -ForegroundColor Cyan
        $RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        Set-ItemProperty -Path $RegPath -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $RegPath -Name "AppsUseLightTheme" -Value 0

        # --- WALLPAPER DEPLOYMENT ---
        Write-Host "-> Downloading wall1.jpg..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $WallpaperUrl -OutFile $WallpaperPath -ErrorAction SilentlyContinue
        
        Write-Host "-> Setting Wallpaper..." -ForegroundColor Cyan
        $code = @'
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@
        Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
        [Wallpaper]::SystemParametersInfo(20, 0, $WallpaperPath, 3)

        # --- PERFORMANCE TWEAKS ---
        Write-Host "-> Unlocking Ultimate Power & Cleaning Bloat..." -ForegroundColor Cyan
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        $Apps = @("Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.XboxApp", "Microsoft.GetHelp")
        foreach ($App in $Apps) {
            Get-AppxPackage -Name $App | Remove-AppxPackage -ErrorAction SilentlyContinue
        }
        
        Write-Host "`nRECAST COMPLETE. Visuals and Performance Synced." -ForegroundColor Green
    }
    
    "2" {
        Show-Header
        Write-Host "-> Applying Dark Mode..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
        
        Write-Host "-> Deploying wall1.jpg Wallpaper..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $WallpaperUrl -OutFile $WallpaperPath
        Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
        [Wallpaper]::SystemParametersInfo(20, 0, $WallpaperPath, 3)
        Write-Host "Visual Overhaul Complete." -ForegroundColor Green
    }

    "3" {
        Show-Header
        Write-Host "-> Flushing DNS & Clearing Temp Files..." -ForegroundColor Cyan
        ipconfig /flushdns
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleanup Complete." -ForegroundColor Green
    }

    "Q" { exit }
}

Write-Host "`nPress any key to return to Windows..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
