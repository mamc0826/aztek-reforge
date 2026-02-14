#Requires -RunAsAdministrator

# --- AZTEK REFORGE™ INTERACTIVE ENGINE ---
$Host.UI.RawUI.WindowTitle = "AZTEK REFORGE™ | SYSTEM RECAST"

function Show-Header {
    Clear-Host
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host "            AZTEK REFORGE™ : SYSTEM RECAST           " -ForegroundColor White -BackgroundColor Blue
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host "  Interactive Deployment Mode | Peak Performance v1  " -ForegroundColor Gray
    Write-Host ""
}

Show-Header

# --- INTERACTIVE MENU ---
Write-Host "[1] Full System Recast (Recommended)" -ForegroundColor Yellow
Write-Host "[2] Selective Optimization (Debloat Only)" -ForegroundColor Yellow
Write-Host "[3] Network Performance Tuning" -ForegroundColor Yellow
Write-Host "[Q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Select an option to begin"

switch ($choice) {
    "1" {
        Write-Host "`nStarting Full System Recast..." -ForegroundColor Green
        # Add your install logic here
        Start-Sleep -Seconds 2
        Write-Host "Optimization Complete!" -ForegroundColor Green
    }
    "2" {
        Write-Host "`nRunning Selective Debloat..." -ForegroundColor Cyan
        # Add your debloat logic here
        Start-Sleep -Seconds 2
    }
    "3" {
        Write-Host "`nTuning Network for Low Latency..." -ForegroundColor Magenta
        # Add network logic here
        Start-Sleep -Seconds 2
    }
    "Q" {
        Write-Host "`nExiting Reforge..." -ForegroundColor Gray
        exit
    }
    Default {
        Write-Host "`nInvalid selection. Please run the command again." -ForegroundColor Red
    }
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
