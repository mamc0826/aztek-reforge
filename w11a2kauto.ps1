#Requires -RunAsAdministrator

# --- AZTEK REFORGE™ : SENTINEL v2.5 ---
$Host.UI.RawUI.WindowTitle = "AZTEK REFORGE™ | SYSTEM RECAST"

function Show-Header {
    Clear-Host
    Write-Host "          █████╗ ███████╗████████╗███████╗██╗  ██╗" -ForegroundColor Green
    Write-Host "         ██╔══██╗╚══███╔╝╚══██╔══╝██╔════╝██║ ██╔╝" -ForegroundColor Green
    Write-Host "         ███████║  ███╔╝    ██║   █████╗  █████╔╝ " -ForegroundColor White
    Write-Host "         ██╔══██║ ███╔╝     ██║   ██╔══╝  ██╔═██╗ " -ForegroundColor White
    Write-Host "         ██║  ██║███████╗   ██║   ███████╗██║  ██╗" -ForegroundColor Green
    Write-Host "         ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝" -ForegroundColor Green
    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
    Write-Host " CPU: $((Get-CimInstance Win32_Processor).Name)" -ForegroundColor Gray
    Write-Host " RAM: $([Math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 1)) GB Free" -ForegroundColor Gray
    Write-Host " UI:  Classic Context Menu | Start: More Pins" -ForegroundColor Gray
    Write-Host "-----------------------------------------------------" -ForegroundColor Cyan
}

Show-Header
Write-Host "[0] Create Restore Point" -ForegroundColor Green
Write-Host "[1] Full System Recast" -ForegroundColor Yellow
Write-Host "[2] Deep Maintenance" -ForegroundColor Yellow
Write-Host "[ER] Emergency Recovery" -ForegroundColor White -BackgroundColor Red
Write-Host ""
$choice = Read-Host "Sentinel Action Required"

switch ($choice) {
    "0" { 
        Write-Host "Creating Safety Net..." -ForegroundColor Yellow
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "AztekReforge_Manual" -RestorePointType "MODIFY_SETTINGS"
    }
    "1" {
        # ... (All your v2.4 Recast Logic goes here)
        Write-Host "Recast Complete. Explorer Restarting..." -ForegroundColor Green
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    }
    "ER" {
        $RP = Get-ComputerRestorePoint | Where-Object {$_.Description -match "AztekReforge"} | Select-Object -Last 1
        if ($RP) { Restore-Computer -RestorePoint $RP.SequenceNumber } else { rstrui.exe }
    }
    "Q" { exit }
}
